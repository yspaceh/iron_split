import {onCall, HttpsError} from "firebase-functions/v2/https";
import {onSchedule} from "firebase-functions/v2/scheduler";
import {setGlobalOptions, logger} from "firebase-functions/v2";
import * as admin from "firebase-admin";
import {FieldPath} from "firebase-admin/firestore";

setGlobalOptions({region: "asia-northeast1"});

admin.initializeApp();
const db = admin.firestore();

interface TaskMember {
  isLinked?: boolean;
  displayName?: string;
  joinedAt?: admin.firestore.Timestamp; // 關鍵：讓 TS 知道這是一個 Timestamp
  role?: string;
  avatar?: string;
  [key: string]: any; // 允許其他動態欄位
}

interface TaskData {
  createdBy: string;
  members: Record<string, TaskMember>;
  [key: string]: any;
}

// 20 隻英國農場動物清單 (聖經定義)
const ALL_AVATARS = [
  "cow",
  "pig",
  "deer",
  "horse",
  "sheep",
  "goat",
  "duck",
  "stoat",
  "rabbit",
  "mouse",
  "cat",
  "dog",
  "otter",
  "owl",
  "fox",
  "hedgehog",
  "donkey",
  "squirrel",
  "badger",
  "robin",
];

// --- Helper: 寫入 Activity Log ---

/**
 * 寫入活動紀錄 (支援一般寫入與 Batch)
 * @param db Firestore 實例
 * @param taskId 任務 ID
 * @param operatorUid 操作者 UID
 * @param action 動作類型 (對應 Flutter 的 LogAction 字串)
 * @param details 詳細內容 Map
 * @param batch (選用) 如果有傳入，會併入該 Batch；否則直接寫入
 */
const writeActivityLog = async (
    db: admin.firestore.Firestore,
    taskId: string,
    operatorUid: string,
    action: string, // 'add_member', 'remove_member', etc.
    details: Record<string, any>,
    batch?: admin.firestore.WriteBatch
) => {
  const logRef = db.collection("tasks").doc(taskId).collection("activity_logs").doc();

  const logData = {
    operatorUid,
    actionType: action,
    details,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  if (batch) {
    batch.set(logRef, logData);
  } else {
    await logRef.set(logData);
  }
};

// 輔助：隨機產生 8 碼大寫英數 (排除易混淆字元 I, L, 1, O, 0)
const generateCode = (): string => {
  const chars = "ABCDEFGHJKMNPQRSTUVWXYZ23456789";
  let result = "";
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
};

// 輔助：從可用清單中隨機挑選一個 Avatar
const pickRandomAvatar = (usedAvatars: string[]): string => {
  // 過濾掉已使用的
  const available = ALL_AVATARS.filter((a) => !usedAvatars.includes(a));

  // 如果全部都被用光了 (理論上 maxMembers <= 20，不應發生)，就隨機挑一個
  if (available.length === 0) {
    return ALL_AVATARS[Math.floor(Math.random() * ALL_AVATARS.length)];
  }

  return available[Math.floor(Math.random() * available.length)];
};

/**
 * 判定是否為「空殼成員」
 * 1. 尚未連結 (isLinked != true)
 * 2. 預收與費用皆為 0
 * 3. 名字符合系統預設格式 (例如: 成員 2, Member 3)
 */
const isEmptyGhost = (m: any): boolean => {
  if (m.isLinked === true || m.uid != null) return false;
  const prepaid = m.prepaid || 0;
  const expense = m.expense || 0;
  const name = (m.displayName || "").trim();
  // 檢查名字是否為預設格式
  const isDefaultName = /^(成員|Member|メンバー)\s*\d*$/i.test(name);
  return prepaid === 0 && expense === 0 && isDefaultName;
};

/**
 * 建立邀請碼
 * 邏輯：檢查成員權限 -> 產生亂數代碼 (並檢查碰撞) -> 寫入 Firestore
 */
export const createInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const {taskId} = request.data;
  const uid = request.auth.uid;
  const taskRef = db.collection("tasks").doc(taskId);

  let code = "";
  let isUnique = false;
  let attempts = 0;
  const maxAttempts = 5;
  const expiresAt = admin.firestore.Timestamp.fromMillis(Date.now() + 900000);

  while (!isUnique && attempts < maxAttempts) {
    code = generateCode();
    const inviteRef = db.collection("invites").doc(code);

    try {
      await db.runTransaction(async (t) => {
        // 1. 將讀取與權限檢查移入 Transaction 內 (解決 TOCTOU)
        const taskDoc = await t.get(taskRef);
        if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");

        const members = taskDoc.data()?.members || {};
        // 2. 回應 Codex 的疑問：嚴格要求 isLinked === true
        if (!members[uid] || members[uid].isLinked !== true) {
          throw new HttpsError("permission-denied", "NOT_MEMBER");
        }

        // 3. 檢查碰撞
        const inviteSnap = await t.get(inviteRef);
        if (inviteSnap.exists) {
          throw new Error("COLLISION"); // 故意拋錯讓外層攔截重試
        }

        // 4. 執行寫入
        t.set(inviteRef, {
          taskId,
          expiresAt,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          createdByUid: uid,
        });

        t.update(taskRef, {
          activeInviteCode: code,
          activeInviteExpiresAt: expiresAt,
        });
      });

      isUnique = true; // Transaction 成功，確定唯一並跳出迴圈
    } catch (error: any) {
      if (error.message === "COLLISION") {
        attempts++;
      } else {
        throw error; // 將 HttpsError (如 NOT_MEMBER) 往外拋
      }
    }
  }

  if (!isUnique) {
    throw new HttpsError("aborted", "GENERATE_CODE_FAILED");
  }

  return {code, expiresAt: expiresAt.toMillis()};
});

/**
 * 預覽邀請碼
 * 邏輯：驗證代碼 -> 回傳任務資訊 + 未連結成員名單 (Ghost Members)
 */
export const previewInviteCode = onCall(async (request) => {
  // [檢查 1] 身份驗證
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");
  const {code} = request.data;

  // [檢查 2] 邀請碼存在性
  const inviteDoc = await db.collection("invites").doc(code).get();
  if (!inviteDoc.exists) throw new HttpsError("invalid-argument", "INVALID_CODE");
  const {taskId, expiresAt} = inviteDoc.data()!;

  // [檢查 3] 任務存在性
  const taskDoc = await db.collection("tasks").doc(taskId).get();
  if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
  const taskData = taskDoc.data()!;

  // [檢查 4] 邀請碼時效性
  if (expiresAt.toMillis() < Date.now()) throw new HttpsError("failed-precondition", "EXPIRED_CODE");

  // [檢查 5] 邀請碼匹配性 (防止舊碼遭誤用)
  if (taskData.activeInviteCode !== code) throw new HttpsError("invalid-argument", "INVALID_CODE");

  const members = taskData.members || {};
  if (taskData.createdBy === request.auth.uid) {
    return {taskId, action: "OPEN_TASK"};
  }
  const activeGhosts: any[] = []; // 需要顯示在前端的
  let emptySlotAvailable = false;
  let linkedCount = 0;

  for (const [id, m] of Object.entries(members)) {
    const memberData = m as any;
    if (memberData.uid === request.auth.uid) return {taskId, action: "OPEN_TASK"};

    if (memberData.isLinked) {
      linkedCount++;
      continue;
    }

    // 執行空殼過濾邏輯
    if (isEmptyGhost(memberData)) {
      emptySlotAvailable = true; // 發現空位，但不放進回傳清單
    } else {
      activeGhosts.push({
        id,
        displayName: memberData.displayName,
        prepaid: memberData.prepaid || 0,
        expense: memberData.expense || 0,
      });
    }
  }

  // [檢查 6] 人數上限檢查
  if (linkedCount >= taskData.maxMembers && activeGhosts.length === 0 && !emptySlotAvailable) {
    throw new HttpsError("failed-precondition", "TASK_FULL");
  }

  return {
    taskId,
    action: "NEED_JOIN",
    taskData: {
      taskName: taskData.name,
      baseCurrency: taskData.baseCurrency,
      startDate: taskData.startDate?.toMillis() || null, // 轉毫秒傳給前端
      endDate: taskData.endDate?.toMillis() || null,
    },
    ghosts: activeGhosts, // 僅回傳改過名字或有金額的成員
  };
});

/**
 * 加入任務
 * 邏輯：處理連結既有成員(Merge) 或 新增成員，並自動分配不重複的 Avatar
 */
export const joinByInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");
  const {code, displayName, targetMemberId} = request.data;
  const uid = request.auth.uid;

  const result = await db.runTransaction(async (transaction) => {
    // [1] 安全檢查：邀請碼驗證 (絕對不刪)
    const inviteRef = db.collection("invites").doc(code);
    const inviteDoc = await transaction.get(inviteRef);
    if (!inviteDoc.exists) throw new HttpsError("invalid-argument", "INVALID_CODE");
    const {taskId, expiresAt} = inviteDoc.data()!;

    if (expiresAt.toMillis() < Date.now()) throw new HttpsError("failed-precondition", "EXPIRED_CODE");

    const taskRef = db.collection("tasks").doc(taskId);
    const taskDoc = await transaction.get(taskRef);
    if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
    const taskData = taskDoc.data()!;

    if (taskData.activeInviteCode !== code) throw new HttpsError("invalid-argument", "INVALID_CODE");
    const currentMemberIds: string[] = taskData.memberIds || [];
    if (currentMemberIds.includes(uid)) {
      throw new HttpsError("already-exists", "User is already a member.");
    }

    const members = taskData.members || {};
    const emptySlots = Object.entries(members).filter(([_, m]) => !(m as TaskMember).isLinked);

    // [2] 頭像分配：確保不重複 (絕對不刪)
    const usedAvatars: string[] = Object.values(members).map((m: any) => m.avatar).filter(Boolean);
    const assignedAvatar = pickRandomAvatar(usedAvatars);

    // [3] 核心邏輯：決定補位目標
    let finalTargetId = targetMemberId;
    if (!finalTargetId) {
      if (emptySlots.length > 0) {
        // A. 有空位：優先遞補第一個 Ghost
        finalTargetId = emptySlots[0][0];
      } else {
        // B. [修正] 沒空位：禁止擴充，直接拋出錯誤
        // 前端 (S11) 收到這個錯誤後，應顯示「任務人數已滿」的訊息
        throw new HttpsError("failed-precondition", "TASK_FULL");
      }
    } else {
      // 如果前端有指定 targetMemberId，要確保該 ID 真的存在且是 Ghost
      // (雖然前端通常會擋，但後端再檢查一次比較安全)
      if (!members[finalTargetId]) throw new HttpsError("not-found", "MEMBER_NOT_FOUND");
      if ((members[finalTargetId] as TaskMember).isLinked) {
        throw new HttpsError("already-exists", "MEMBER_ALREADY_LINKED");
      }
    }

    const ghostData = members[finalTargetId];

    // [修正] 手動計算新的 memberIds 陣列，避免 arrayRemove/Union 衝突
    const newMemberIds = currentMemberIds.filter((id: string) => id !== finalTargetId);
    if (!newMemberIds.includes(uid)) {
      newMemberIds.push(uid);
    }

    // [4] 執行寫入 (合併成單次 update)
    transaction.update(taskRef, {
      // 1. Map 操作：刪除舊 Key，新增新 Key
      [`members.${finalTargetId}`]: admin.firestore.FieldValue.delete(),
      [`members.${uid}`]: {
        prepaid: ghostData.prepaid || 0,
        expense: ghostData.expense || 0,
        hasSeenRoleIntro: ghostData.hasSeenRoleIntro ?? false,
        createdAt: ghostData.createdAt,
        uid: uid,
        displayName: displayName,
        avatar: assignedAvatar,
        isLinked: true,
        role: "member",
        joinedAt: admin.firestore.FieldValue.serverTimestamp(),
      },

      // 2. Array 操作：直接寫入計算好的新陣列
      memberIds: newMemberIds,
      // 3. 其他欄位
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      taskId,
      action: "JOINED",
      avatar: assignedAvatar,
      canReroll: true,
    };
  });

  try {
    await writeActivityLog(db, result.taskId, uid, "add_member", {
      memberName: displayName,
      method: "invite_code",
    });
  } catch (error) {
    logger.error({
      error: error,
      taskId: result.taskId,
      uid: uid,
    });
  }

  return result;
});

/**
 * 刪除帳號 (危險操作)
 * 邏輯：
 * 1. 找出該用戶參與的所有 Task
 * 2. 若是普通成員 -> 變更為 Ghost (isLinked=false)
 * 3. 若是隊長 ->
 * a. 若群組內已無其他 Linked 成員 -> 刪除整個 Task
 * b. 若還有其他 Linked 成員 -> 自動移交給 joinedAt 最早的人，自己變 Ghost
 * 4. 刪除 User Document
 * 5. 刪除 Auth 帳號
 */
export const deleteUserAccount = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const uid = request.auth.uid;
  const db = admin.firestore();

  const tasksSnapshot = await db
      .collection("tasks")
      .where(new FieldPath("members", uid, "isLinked"), "==", true)
      .get();

  // --- 新增：Batch 分塊機制 ---
  const batches: admin.firestore.WriteBatch[] = [db.batch()];
  let opCount = 0;
  const getBatch = () => {
    if (opCount >= 400) { // Firestore 上限是 500，我們抓 400 確保安全
      batches.push(db.batch());
      opCount = 0;
    }
    opCount++;
    return batches[batches.length - 1]; // 回傳當前最新的 Batch
  };
  // --------------------------

  const tasksToDelete: FirebaseFirestore.DocumentReference[] = [];

  for (const doc of tasksSnapshot.docs) {
    const taskData = doc.data() as TaskData;
    const members = taskData.members || {};
    const isCaptain = taskData.createdBy === uid;

    if (!isCaptain) {
      // 💡 注意這裡從 db.batch() 變成了 getBatch()
      getBatch().update(doc.ref, {
        [`members.${uid}.isLinked`]: false,
        [`members.${uid}.role`]: "member",
        [`members.${uid}.displayName`]: `${members[uid].displayName}`,
        [`members.${uid}.avatar`]: null,
      });

      await writeActivityLog(db, doc.id, uid, "remove_member", {
        memberName: members[uid]?.displayName || "Unknown",
        reason: "account_deleted",
      }, getBatch());
    } else {
      const candidates = Object.entries(members)
          .filter(([id, m]: [string, any]) => id !== uid && m.isLinked === true)
          .sort((a: [string, any], b: [string, any]) => {
            const timeA = a[1].joinedAt?.toMillis() ?? 0;
            const timeB = b[1].joinedAt?.toMillis() ?? 0;
            return timeA - timeB;
          });

      if (candidates.length === 0) {
        tasksToDelete.push(doc.ref);
      } else {
        const newCaptainId = candidates[0][0];
        const newCaptainName = candidates[0][1].displayName;

        getBatch().update(doc.ref, {
          createdBy: newCaptainId,
          [`members.${newCaptainId}.role`]: "captain",
          [`members.${uid}.isLinked`]: false,
          [`members.${uid}.role`]: "member",
          [`members.${uid}.displayName`]: `${members[uid].displayName}`,
          [`members.${uid}.avatar`]: null,
        });

        await writeActivityLog(db, doc.id, uid, "update_settings", {
          settingType: "captain_transfer",
          oldCaptain: members[uid]?.displayName,
          newCaptain: newCaptainName,
          newValue: newCaptainName,
        }, getBatch());

        await writeActivityLog(db, doc.id, uid, "remove_member", {
          memberName: members[uid]?.displayName || "Unknown",
          reason: "account_deleted",
        }, getBatch());
      }
    }
  }

  try {
    // --- 執行所有收集好的 Batch ---
    for (const b of batches) {
      await b.commit();
    }

    if (tasksToDelete.length > 0) {
      const deletePromises = tasksToDelete.map((ref) => db.recursiveDelete(ref));
      await Promise.all(deletePromises);
    }
  } catch (error) {
    logger.error("刪除帳號時清理任務失敗，中斷流程", {uid, error});
    // 拋出錯誤，讓前端顯示失敗，且「絕對不會」往下執行刪除 Auth
    throw new HttpsError("internal", "帳號資料清理未完全，請再次點擊刪除重試");
  }

  // 只有上方所有 Batch 與群組刪除都 100% 成功，才真正刪除實體 User 與 Auth
  await db.collection("users").doc(uid).delete();
  await admin.auth().deleteUser(uid);

  return {success: true};
});

// index.ts 最下方

/**
 * 每日排程：刪除過期任務 (v2 寫法)
 */
export const deleteExpiredTasks = onSchedule("every 24 hours", async (_) => {
  const db = admin.firestore();

  // 計算 30 天前的時間點
  const now = Date.now();
  const thirtyDaysAgo = now - (30 * 24 * 60 * 60 * 1000);
  const cutoffDate = admin.firestore.Timestamp.fromMillis(thirtyDaysAgo);

  // 1. 查詢過期任務
  const snapshot = await db.collection("tasks")
      .where("status", "==", "closed")
      .where("finalizedAt", "<=", cutoffDate)
      .get();

  if (snapshot.empty) {
    logger.info("No expired tasks found.");
    return;
  }

  logger.info(`Found ${snapshot.size} expired tasks. Deleting...`);

  // 2. 執行遞迴刪除
  const deletePromises = snapshot.docs.map((doc) => db.recursiveDelete(doc.ref));

  await Promise.all(deletePromises);

  logger.info(`Successfully deleted ${snapshot.size} expired tasks.`);
});

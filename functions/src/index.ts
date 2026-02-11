import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

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
 * 邏輯：檢查隊長權限 -> 產生亂數代碼 -> 寫入 Firestore
 */
export const createInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const { taskId } = request.data;
  const uid = request.auth.uid;
  const taskRef = db.collection("tasks").doc(taskId);
  const taskDoc = await taskRef.get();

  if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");

  // 放寬權限為「只要是這個 Task 的成員就可以產生邀請碼」
  const members = taskDoc.data()?.members || {};
  if (!members[uid]) {
    throw new HttpsError("permission-denied", "NOT_MEMBER");
  }

  // 1. 這裡呼叫了 generateCode，警告就會消失
  const code = generateCode();

  // 設定 15 分鐘後過期
  const expiresAt = admin.firestore.Timestamp.fromMillis(Date.now() + 900000);

  const batch = db.batch();

  // 建立邀請碼對照表
  batch.set(db.collection("invites").doc(code), {
    taskId,
    expiresAt,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    createdByUid: uid,
  });

  // 更新任務狀態
  batch.update(taskRef, {
    activeInviteCode: code,
    activeInviteExpiresAt: expiresAt,
  });

  await batch.commit();

  return { code, expiresAt: expiresAt.toMillis() };
});

/**
 * 預覽邀請碼
 * 邏輯：驗證代碼 -> 回傳任務資訊 + 未連結成員名單 (Ghost Members)
 */
export const previewInviteCode = onCall(async (request) => {
  // [檢查 1] 身份驗證
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");
  const { code } = request.data;

  // [檢查 2] 邀請碼存在性
  const inviteDoc = await db.collection("invites").doc(code).get();
  if (!inviteDoc.exists) throw new HttpsError("invalid-argument", "INVALID_CODE");
  const { taskId, expiresAt } = inviteDoc.data()!;

  // [檢查 3] 任務存在性
  const taskDoc = await db.collection("tasks").doc(taskId).get();
  if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
  const taskData = taskDoc.data()!;

  // [檢查 4] 邀請碼時效性
  if (expiresAt.toMillis() < Date.now()) throw new HttpsError("failed-precondition", "EXPIRED_CODE");

  // [檢查 5] 邀請碼匹配性 (防止舊碼遭誤用)
  if (taskData.activeInviteCode !== code) throw new HttpsError("invalid-argument", "INVALID_CODE");

  const members = taskData.members || {};
  const activeGhosts: any[] = []; // 需要顯示在前端的
  let emptySlotAvailable = false;
  let linkedCount = 0;

  for (const [id, m] of Object.entries(members)) {
    const memberData = m as any;
    if (memberData.uid === request.auth.uid) return { taskId, action: "OPEN_TASK" };

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
  const { code, displayName, targetMemberId } = request.data;
  const uid = request.auth.uid;

  return db.runTransaction(async (transaction) => {
    // [1] 安全檢查：邀請碼驗證 (絕對不刪)
    const inviteRef = db.collection("invites").doc(code);
    const inviteDoc = await transaction.get(inviteRef);
    if (!inviteDoc.exists) throw new HttpsError("invalid-argument", "INVALID_CODE");
    const { taskId, expiresAt } = inviteDoc.data()!;

    if (expiresAt.toMillis() < Date.now()) throw new HttpsError("failed-precondition", "EXPIRED_CODE");

    const taskRef = db.collection("tasks").doc(taskId);
    const taskDoc = await transaction.get(taskRef);
    if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
    const taskData = taskDoc.data()!;

    if (taskData.activeInviteCode !== code) throw new HttpsError("invalid-argument", "INVALID_CODE");

    const members = taskData.members || {};
    if (Object.values(members).some((m: any) => m.uid === uid)) {
      throw new HttpsError("already-exists", "ALREADY_JOINED");
    }

    // [2] 頭像分配：確保不重複 (絕對不刪)
    const usedAvatars: string[] = Object.values(members).map((m: any) => m.avatar).filter(Boolean);
    const assignedAvatar = pickRandomAvatar(usedAvatars);

    // [3] 核心邏輯：決定補位目標
    let finalTargetId = targetMemberId;

    if (!finalTargetId) {
      // 如果前端沒指定，後端「自動補位」
      const emptySlots = Object.entries(members)
        .filter(([_, m]) => isEmptyGhost(m))
        .sort((a, b) => (a[1] as any).createdAt - (b[1] as any).createdAt);
        
      if (emptySlots.length === 0) {
        throw new HttpsError("failed-precondition", "TASK_FULL");
      }
      finalTargetId = emptySlots[0][0];
    }

    // [4] 執行寫入 (僅更新既有位子)
    if (!members[finalTargetId]) throw new HttpsError("not-found", "MEMBER_NOT_FOUND");
    const ghostData = members[finalTargetId];
    transaction.update(taskRef, {
      [`members.${finalTargetId}`]: admin.firestore.FieldValue.delete(),
      // 2. 建立新 UID Key 並精準繼承
      [`members.${uid}`]: {
        // [繼承資產]
        prepaid: ghostData.prepaid || 0,
        expense: ghostData.expense || 0,
        // [繼承 Service 定義的旗標]
        hasSeenRoleIntro: ghostData.hasSeenRoleIntro ?? false,
        createdAt: ghostData.createdAt,
        uid: uid,
        displayName: displayName,
        avatar: assignedAvatar,
        isLinked: true,
        role: "member",
        joinedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      memberIds: admin.firestore.FieldValue.arrayRemove(finalTargetId),
    });

    transaction.update(taskRef, {
      memberIds: admin.firestore.FieldValue.arrayUnion(uid),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      taskId,
      action: "JOINED",
      avatar: assignedAvatar,
      canReroll: true,
    };
  });
});

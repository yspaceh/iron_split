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

  // 檢查是否為隊長
  if (taskDoc.data()?.createdBy !== uid) {
    throw new HttpsError("permission-denied", "NOT_CAPTAIN");
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
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const { code } = request.data;
  const uid = request.auth.uid;

  // 1. 找邀請碼
  const inviteDoc = await db.collection("invites").doc(code).get();
  if (!inviteDoc.exists)
    throw new HttpsError("invalid-argument", "INVALID_CODE");

  const { taskId, expiresAt } = inviteDoc.data()!;
  const taskRef = db.collection("tasks").doc(taskId);

  // 2. 檢查是否已經是成員
  const mDoc = await taskRef.collection("members").doc(uid).get();
  if (mDoc.exists) return { taskId, action: "OPEN_TASK" }; // 已經加入過，直接開任務

  // 3. 讀取任務資料
  const taskDoc = await taskRef.get();
  if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
  const taskData = taskDoc.data()!;

  // 驗證有效性
  if (taskData.activeInviteCode !== code)
    throw new HttpsError("invalid-argument", "INVALID_CODE");
  if (expiresAt.toMillis() < Date.now())
    throw new HttpsError("failed-precondition", "EXPIRED_CODE");
  if (taskData.memberCount >= taskData.maxMembers)
    throw new HttpsError("failed-precondition", "TASK_FULL");

  // 4.  抓取未連結的成員 (Ghosts)
  // 定義：在 members collection 中，isLinked != true 的成員 (或 uid 為空)
  const membersSnapshot = await taskRef.collection("members").get();
  const unlinkedMembers: { id: string; displayName: string }[] = [];

  membersSnapshot.forEach((doc) => {
    const data = doc.data();
    // 判斷邏輯：沒有 uid 或者是明確標記尚未連結
    // 注意：captain 一定有 uid，所以不會被誤判
    if (!data.uid || data.isLinked === false) {
      unlinkedMembers.push({
        id: doc.id,
        displayName: data.displayName || "Unknown Member",
      });
    }
  });

  return {
    taskId,
    action: "NEED_JOIN",
    taskSummary: {
      name: taskData.name,
      memberCount: taskData.memberCount,
      maxMembers: taskData.maxMembers,
      baseCurrency: taskData.baseCurrency,
    },
    unlinkedMembers, // 回傳給前端 S04 畫面選
  };
});

/**
 * 加入任務
 * 邏輯：處理連結既有成員(Merge) 或 新增成員，並自動分配不重複的 Avatar
 */
export const joinByInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  // mergeMemberId: 如果使用者選了「我是成員A」，這裡會傳成員A的 docId
  const { code, displayName, mergeMemberId } = request.data;
  const uid = request.auth.uid;

  return db.runTransaction(async (transaction) => {
    const inviteRef = db.collection("invites").doc(code);
    const inviteDoc = await transaction.get(inviteRef);
    if (!inviteDoc.exists) throw new Error("INVALID_CODE");
    const { taskId } = inviteDoc.data()!;

    const taskRef = db.collection("tasks").doc(taskId);
    const taskDoc = await transaction.get(taskRef);
    if (!taskDoc.exists) throw new Error("TASK_NOT_FOUND");
    const taskData = taskDoc.data()!;

    // 1. 分配 Avatar
    // 先抓出所有成員的 avatar
    const allMembersSnap = await transaction.get(taskRef.collection("members"));
    const usedAvatars: string[] = [];
    allMembersSnap.forEach((doc) => {
      const d = doc.data();
      if (d.avatar) usedAvatars.push(d.avatar);
    });

    // 呼叫 pickRandomAvatar，這樣就不會跟現有成員重複
    const assignedAvatar = pickRandomAvatar(usedAvatars);

    // 2. 寫入成員資料
    if (mergeMemberId) {
      // 情境 A: 連結既有 Ghost Member
      const ghostRef = taskRef.collection("members").doc(mergeMemberId);
      const ghostDoc = await transaction.get(ghostRef);
      if (!ghostDoc.exists) throw new Error("MEMBER_NOT_FOUND");

      transaction.update(ghostRef, {
        uid: uid, // 綁定真實 User ID
        displayName: displayName, // 更新為使用者現在想要的名字
        avatar: assignedAvatar, // 賦予頭像 (Ghost 本來沒有)
        joinedAt: admin.firestore.FieldValue.serverTimestamp(),
        isLinked: true,
      });
    } else {
      // 情境 B: 新增全新成員
      if (taskData.memberCount >= taskData.maxMembers)
        throw new Error("TASK_FULL");

      const newMemberRef = taskRef.collection("members").doc(uid); // 用 uid 當 docId
      transaction.set(newMemberRef, {
        uid: uid,
        displayName,
        role: "member",
        avatar: assignedAvatar,
        joinedAt: admin.firestore.FieldValue.serverTimestamp(),
        isLinked: true,
      });

      // 只有新增成員才需要 +1 (連結舊成員總數不變)
      transaction.update(taskRef, {
        memberCount: admin.firestore.FieldValue.increment(1),
      });
    }

    return {
      taskId,
      action: "JOINED",
      avatar: assignedAvatar, // 回傳給前端 D01 顯示
      canReroll: true, // 標記還有一次重抽機會
    };
  });
});

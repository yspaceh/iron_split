import {onCall, HttpsError} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

const generateCode = (): string => {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let result = "";
  for (let i = 0; i < 8; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
};

export const createInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const {taskId} = request.data;
  const uid = request.auth.uid;
  const taskRef = db.collection("tasks").doc(taskId);
  const taskDoc = await taskRef.get();

  if (!taskDoc.exists) throw new HttpsError("not-found", "TASK_NOT_FOUND");
  if (taskDoc.data()?.captainUid !== uid) {
    throw new HttpsError("permission-denied", "NOT_CAPTAIN");
  }

  const code = generateCode();
  const expiresAt = admin.firestore.Timestamp.fromMillis(Date.now() + 900000);

  const batch = db.batch();
  batch.set(db.collection("invites").doc(code), {
    taskId,
    expiresAt,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    createdByUid: uid,
  });
  batch.update(taskRef, {
    activeInviteCode: code,
    activeInviteExpiresAt: expiresAt,
  });

  await batch.commit();
  return {code, expiresAt: expiresAt.toMillis()};
});

export const previewInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const {code} = request.data;
  const uid = request.auth.uid;
  const inviteDoc = await db.collection("invites").doc(code).get();

  if (!inviteDoc.exists) throw new HttpsError("invalid-argument", "INVALID_CODE");

  const inviteData = inviteDoc.data();
  if (!inviteData) throw new HttpsError("internal", "DATA_ERROR");

  const {taskId, expiresAt} = inviteData;
  const taskRef = db.collection("tasks").doc(taskId);
  const mDoc = await taskRef.collection("members").doc(uid).get();

  if (mDoc.exists) return {taskId, action: "OPEN_TASK"};

  const taskDoc = await taskRef.get();
  const taskData = taskDoc.data();
  if (!taskData) throw new HttpsError("not-found", "TASK_NOT_FOUND");

  if (taskData.activeInviteCode !== code) {
    throw new HttpsError("invalid-argument", "INVALID_CODE");
  }
  if (expiresAt.toMillis() < Date.now()) {
    throw new HttpsError("failed-precondition", "EXPIRED_CODE");
  }
  if (taskData.memberCount >= taskData.maxMembers) {
    throw new HttpsError("failed-precondition", "TASK_FULL");
  }

  return {
    taskId,
    action: "NEED_JOIN",
    taskSummary: {
      name: taskData.name,
      memberCount: taskData.memberCount,
      maxMembers: taskData.maxMembers,
      baseCurrency: taskData.baseCurrency,
    },
  };
});

export const joinByInviteCode = onCall(async (request) => {
  if (!request.auth) throw new HttpsError("unauthenticated", "AUTH_REQUIRED");

  const {code, displayName} = request.data;
  const uid = request.auth.uid;

  return db.runTransaction(async (transaction) => {
    const inviteRef = db.collection("invites").doc(code);
    const inviteDoc = await transaction.get(inviteRef);
    if (!inviteDoc.exists) throw new Error("INVALID_CODE");

    const inviteData = inviteDoc.data();
    if (!inviteData) throw new Error("DATA_ERROR");

    const {taskId, expiresAt} = inviteData;
    const taskRef = db.collection("tasks").doc(taskId);
    const taskDoc = await transaction.get(taskRef);
    const taskData = taskDoc.data();
    if (!taskData) throw new Error("TASK_NOT_FOUND");

    const mRef = taskRef.collection("members").doc(uid);
    const mDoc = await transaction.get(mRef);
    if (mDoc.exists) return {taskId, action: "OPEN_TASK"};

    if (taskData.activeInviteCode !== code) throw new Error("INVALID_CODE");
    if (expiresAt.toMillis() < Date.now()) throw new Error("EXPIRED_CODE");
    if (taskData.memberCount >= taskData.maxMembers) throw new Error("TASK_FULL");

    transaction.set(mRef, {
      displayName,
      role: "member",
      joinedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    transaction.update(taskRef, {
      memberCount: admin.firestore.FieldValue.increment(1),
    });

    return {taskId, action: "JOINED"};
  }).catch((err) => {
    throw new HttpsError("internal", err.message || "JOIN_FAILED");
  });
});

const {before, beforeEach, after, describe, it} = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require('@firebase/rules-unit-testing');

const {
  doc,
  setDoc,
  updateDoc,
  getDoc,
} = require('firebase/firestore');

const PROJECT_ID = 'demo-iron-split';
const RULES_PATH = path.resolve(__dirname, '../../firestore.rules');

let testEnv;

function taskPayload(memberIds, {member2Linked = true} = {}) {
  const now = new Date();
  return {
    id: 'task-a',
    name: 'Trip',
    baseCurrency: 'USD',
    memberIds,
    members: {
      u1: {
        uid: 'u1',
        displayName: 'Captain',
        isLinked: true,
        role: 'captain',
        joinedAt: now,
        createdAt: now,
      },
      u2: {
        uid: 'u2',
        displayName: 'Member',
        isLinked: member2Linked,
        role: 'member',
        joinedAt: now,
        createdAt: now,
      },
    },
    status: 'ongoing',
    createdBy: 'u1',
    remainderRule: 'member',
    createdAt: now,
    updatedAt: now,
  };
}

async function seedTask(taskId = 'task-a', memberIds = ['u1', 'u2'], options = {}) {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'tasks', taskId), taskPayload(memberIds, options));
  });
}

describe('Firestore Rules Contract', () => {
  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        rules: fs.readFileSync(RULES_PATH, 'utf8'),
      },
    });
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  after(async () => {
    await testEnv.cleanup();
  });

  it('task list read: member can read task doc, non-member is denied', async () => {
    await seedTask('task-read', ['u1', 'u2']);

    const memberDb = testEnv.authenticatedContext('u1').firestore();
    const nonMemberDb = testEnv.authenticatedContext('u3').firestore();

    await assertSucceeds(getDoc(doc(memberDb, 'tasks', 'task-read')));
    await assertFails(getDoc(doc(nonMemberDb, 'tasks', 'task-read')));
  });

  it('task update: member can update task, non-member is denied', async () => {
    await seedTask('task-update', ['u1', 'u2']);

    const memberDb = testEnv.authenticatedContext('u2').firestore();
    const nonMemberDb = testEnv.authenticatedContext('u3').firestore();

    await assertSucceeds(
      updateDoc(doc(memberDb, 'tasks', 'task-update'), {
        name: 'Trip Updated',
      }),
    );

    await assertFails(
      updateDoc(doc(nonMemberDb, 'tasks', 'task-update'), {
        name: 'Hacked',
      }),
    );

    const verifierDb = testEnv.authenticatedContext('u1').firestore();
    const snap = await getDoc(doc(verifierDb, 'tasks', 'task-update'));
    assert.equal(snap.data().name, 'Trip Updated');
  });

  it('left member: remains in members map but loses read and update access after memberIds removal', async () => {
    await seedTask('task-left', ['u1'], {member2Linked: false});

    const leftMemberDb = testEnv.authenticatedContext('u2').firestore();

    await assertFails(getDoc(doc(leftMemberDb, 'tasks', 'task-left')));
    await assertFails(
      updateDoc(doc(leftMemberDb, 'tasks', 'task-left'), {
        name: 'Should Fail',
      }),
    );
  });

  it('settlement write: member can write settlement data, non-member is denied', async () => {
    await seedTask('task-settle', ['u1', 'u2']);

    const memberDb = testEnv.authenticatedContext('u1').firestore();
    const nonMemberDb = testEnv.authenticatedContext('u3').firestore();

    await assertSucceeds(
      updateDoc(doc(memberDb, 'tasks', 'task-settle'), {
        status: 'settled',
        'settlement.receiverInfos': '{"bank":"abc"}',
      }),
    );

    await assertFails(
      updateDoc(doc(nonMemberDb, 'tasks', 'task-settle'), {
        status: 'settled',
        'settlement.receiverInfos': '{"bank":"hacked"}',
      }),
    );
  });
});

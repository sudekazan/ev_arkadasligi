// Runs against the emulators:
//   firebase emulators:exec --only firestore,storage "npm --prefix functions run test:rules"
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import {
  RulesTestEnvironment,
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  Timestamp,
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  updateDoc,
} from "firebase/firestore";
import { ref, uploadBytes } from "firebase/storage";
import { afterAll, beforeAll, beforeEach, describe, it } from "vitest";

const root = resolve(__dirname, "../../..");
let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-evkasa-rules",
    firestore: {
      rules: readFileSync(resolve(root, "firestore.rules"), "utf8"),
      host: "127.0.0.1",
      port: 8080,
    },
    storage: {
      rules: readFileSync(resolve(root, "storage.rules"), "utf8"),
      host: "127.0.0.1",
      port: 9199,
    },
  });
});

afterAll(async () => {
  await env.cleanup();
});

const now = Timestamp.now();

function expense(over: Record<string, unknown> = {}) {
  return {
    description: "Market",
    amountMinor: 10000,
    paidBy: "alice",
    date: now,
    category: "groceries",
    splitType: "equal",
    splitInput: { alice: 1, bob: 1 },
    shares: { alice: 5000, bob: 5000 },
    status: "final",
    note: "",
    receiptItems: [],
    createdBy: "alice",
    createdAt: now,
    updatedAt: now,
    ...over,
  };
}

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, "households/h1"), {
      name: "Ev",
      currency: "TRY",
      createdBy: "alice",
      adminIds: ["alice"],
      memberIds: ["alice", "bob"],
      inviteCode: "ABC234",
      proUntil: null,
      createdAt: now,
    });
    for (const uid of ["alice", "bob"]) {
      await setDoc(doc(db, `households/h1/members/${uid}`), {
        displayName: uid,
        avatarEmoji: "🙂",
        rentWeight: 1,
        joinedAt: now,
        active: true,
      });
    }
    await setDoc(doc(db, "households/h1/expenses/e1"), expense());
    await setDoc(doc(db, "households/h1/expenses/pending"), expense({
      amountMinor: 0, shares: {}, status: "pendingAmount", createdBy: "alice", paidBy: "bob",
    }));
    await setDoc(doc(db, "households/h1/expenses/pendingAlice"), expense({
      amountMinor: 0, shares: {}, status: "pendingAmount", createdBy: "alice",
    }));
    await setDoc(doc(db, "households/h1/settlements/s1"), {
      fromUid: "bob", toUid: "alice", amountMinor: 500, date: now, note: "", createdBy: "bob", createdAt: now,
    });
    await setDoc(doc(db, "inviteCodes/ABC234"), { householdId: "h1", createdAt: now });
    await setDoc(doc(db, "users/alice"), { displayName: "alice", householdIds: ["h1"] });
  });
});

const as = (uid: string) => env.authenticatedContext(uid).firestore();

describe("users", () => {
  it("only the owner reads and writes", async () => {
    await assertSucceeds(getDoc(doc(as("alice"), "users/alice")));
    await assertFails(getDoc(doc(as("bob"), "users/alice")));
  });

  it("cannot grant itself households or Pro", async () => {
    await assertFails(updateDoc(doc(as("alice"), "users/alice"), { householdIds: ["h1", "h2"] }));
    await assertFails(updateDoc(doc(as("alice"), "users/alice"), { proUntil: now }));
    await assertSucceeds(updateDoc(doc(as("alice"), "users/alice"), { displayName: "Alice" }));
    await assertFails(setDoc(doc(as("carol"), "users/carol"), { householdIds: ["h1"] }));
    await assertSucceeds(setDoc(doc(as("carol"), "users/carol"), { householdIds: [] }));
  });
});

describe("households", () => {
  it("members read, outsiders do not", async () => {
    await assertSucceeds(getDoc(doc(as("bob"), "households/h1")));
    await assertFails(getDoc(doc(as("mallory"), "households/h1")));
    await assertFails(getDoc(env.unauthenticatedContext().firestore().doc("households/h1")));
  });

  it("only admins rename; membership and Pro are server-only", async () => {
    await assertFails(updateDoc(doc(as("bob"), "households/h1"), { name: "X" }));
    await assertSucceeds(updateDoc(doc(as("alice"), "households/h1"), { name: "Yeni ad" }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1"), { memberIds: ["alice", "bob", "eve"] }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1"), { inviteCode: "ZZZZZZ" }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1"), { proUntil: now }));
  });

  it("members edit their own profile; admins edit rent weights", async () => {
    await assertSucceeds(updateDoc(doc(as("bob"), "households/h1/members/bob"), { displayName: "Bob", iban: "TR00" }));
    await assertFails(updateDoc(doc(as("bob"), "households/h1/members/alice"), { displayName: "x" }));
    await assertFails(updateDoc(doc(as("bob"), "households/h1/members/bob"), { rentWeight: 5 }));
    await assertSucceeds(updateDoc(doc(as("alice"), "households/h1/members/bob"), { rentWeight: 3 }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1/members/bob"), { rentWeight: 1.5 }));
  });
});

describe("expenses", () => {
  it("create requires own createdBy, member keys and a positive integer", async () => {
    const db = as("bob");
    await assertSucceeds(setDoc(doc(db, "households/h1/expenses/n1"), expense({ createdBy: "bob" })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n2"), expense({ createdBy: "alice" })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n3"),
      expense({ createdBy: "bob", shares: { bob: 5000, eve: 5000 } })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n4"), expense({ createdBy: "bob", paidBy: "eve" })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n5"), expense({ createdBy: "bob", amountMinor: 100.5 })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n6"), expense({ createdBy: "bob", amountMinor: 0 })));
    await assertFails(setDoc(doc(as("mallory"), "households/h1/expenses/n7"), expense({ createdBy: "mallory" })));
  });

  it("creator or admin edits and deletes", async () => {
    await assertFails(updateDoc(doc(as("bob"), "households/h1/expenses/e1"), { description: "x" }));
    await assertSucceeds(updateDoc(doc(as("alice"), "households/h1/expenses/e1"), { description: "x" }));
    await assertFails(deleteDoc(doc(as("bob"), "households/h1/expenses/e1")));
    await assertSucceeds(deleteDoc(doc(as("alice"), "households/h1/expenses/e1")));
  });

  it("the payer fills in a pending bill but cannot hand it to someone else", async () => {
    const filled = { amountMinor: 8000, shares: { alice: 4000, bob: 4000 }, createdBy: "alice" };
    await assertFails(setDoc(doc(as("bob"), "households/h1/expenses/pending"),
      expense({ ...filled, paidBy: "alice" })));
    await assertSucceeds(setDoc(doc(as("bob"), "households/h1/expenses/pending"),
      expense({ ...filled, paidBy: "bob" })));
  });

  it("other members cannot fill in someone else's pending bill", async () => {
    await assertFails(setDoc(doc(as("bob"), "households/h1/expenses/pendingAlice"),
      expense({ amountMinor: 8000, shares: { alice: 4000, bob: 4000 }, createdBy: "alice" })));
  });
});

describe("settlements", () => {
  it("parties or admin delete; outsiders cannot", async () => {
    await assertSucceeds(deleteDoc(doc(as("alice"), "households/h1/settlements/s1")));
  });

  it("must involve the creator and be positive", async () => {
    const base = { fromUid: "bob", toUid: "alice", amountMinor: 100, date: now, note: "", createdBy: "bob", createdAt: now };
    await assertSucceeds(setDoc(doc(as("bob"), "households/h1/settlements/n1"), base));
    await assertFails(setDoc(doc(as("bob"), "households/h1/settlements/n2"), { ...base, amountMinor: -1 }));
    await assertFails(setDoc(doc(as("bob"), "households/h1/settlements/n3"), { ...base, toUid: "bob" }));
    await assertFails(updateDoc(doc(as("bob"), "households/h1/settlements/s1"), { amountMinor: 1 }));
  });
});

describe("server-only collections", () => {
  it("inviteCodes and usage are closed", async () => {
    await assertFails(getDoc(doc(as("alice"), "inviteCodes/ABC234")));
    await assertFails(setDoc(doc(as("alice"), "usage/alice"), { receiptScans: {} }));
  });

  it("activity is append-only with own actor", async () => {
    const entry = { type: "expenseAdded", actorUid: "bob", refId: "e1", params: {}, createdAt: now };
    await assertSucceeds(setDoc(doc(as("bob"), "households/h1/activity/a1"), entry));
    await assertFails(setDoc(doc(as("bob"), "households/h1/activity/a2"), { ...entry, actorUid: "alice" }));
    await assertFails(updateDoc(doc(as("bob"), "households/h1/activity/a1"), { type: "x" }));
  });
});

describe("storage receipts", () => {
  it("members upload images up to 5 MB", async () => {
    const storage = env.authenticatedContext("bob").storage();
    const small = new Uint8Array(1024);
    await assertSucceeds(uploadBytes(ref(storage, "receipts/h1/a.jpg"), small, { contentType: "image/jpeg" }));
    await assertFails(uploadBytes(ref(storage, "receipts/h1/b.pdf"), small, { contentType: "application/pdf" }));
    await assertFails(uploadBytes(ref(storage, "receipts/h1/c.jpg"),
      new Uint8Array(5 * 1024 * 1024 + 1), { contentType: "image/jpeg" }));
    const outsider = env.authenticatedContext("mallory").storage();
    await assertFails(uploadBytes(ref(outsider, "receipts/h1/d.jpg"), small, { contentType: "image/jpeg" }));
  });
});

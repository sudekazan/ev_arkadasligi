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
    await setDoc(doc(db, "households/h1/shoppingItems/i1"), {
      name: "Süt", quantity: "2 litre", addedBy: "alice", done: false, createdAt: now,
    });
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

describe("member profile limits", () => {
  const bob = () => doc(as("bob"), "households/h1/members/bob");

  it("rejects an IBAN longer than 34 characters", async () => {
    await assertFails(updateDoc(bob(), { iban: "T".repeat(35) }));
    await assertSucceeds(updateDoc(bob(), { iban: "T".repeat(34) }));
    await assertSucceeds(updateDoc(bob(), { iban: null }));
  });

  it("rejects an avatar emoji field longer than 16 characters", async () => {
    await assertFails(updateDoc(bob(), { avatarEmoji: "a".repeat(17) }));
    await assertSucceeds(updateDoc(bob(), { avatarEmoji: "😀", iban: null }));
  });
});

describe("shopping items", () => {
  const item = (over: Record<string, unknown> = {}) => ({
    name: "Ekmek", quantity: null, addedBy: "bob", done: false, createdAt: now, ...over,
  });
  const items = (uid: string, id: string) => doc(as(uid), `households/h1/shoppingItems/${id}`);

  it("accepts a normal item, with or without quantity", async () => {
    await assertSucceeds(setDoc(items("bob", "n1"), item()));
    await assertSucceeds(setDoc(items("bob", "n2"), item({ quantity: "2 paket" })));
  });

  it("rejects a name over 100 characters, an empty name and a long quantity", async () => {
    await assertFails(setDoc(items("bob", "n3"), item({ name: "a".repeat(101) })));
    await assertSucceeds(setDoc(items("bob", "n4"), item({ name: "a".repeat(100) })));
    await assertFails(setDoc(items("bob", "n5"), item({ name: "" })));
    await assertFails(setDoc(items("bob", "n6"), item({ quantity: "a".repeat(41) })));
  });

  it("requires addedBy to be the caller and rejects unknown fields", async () => {
    await assertFails(setDoc(items("bob", "n7"), item({ addedBy: "alice" })));
    await assertFails(setDoc(items("bob", "n8"), item({ extra: "x" })));
    await assertFails(setDoc(items("mallory", "n9"), item({ addedBy: "mallory" })));
  });

  it("still lets members mark done, undo and delete", async () => {
    await assertSucceeds(updateDoc(items("bob", "i1"), { done: true, doneBy: "bob", doneAt: now }));
    await assertSucceeds(updateDoc(items("bob", "i1"), { done: false, doneBy: null, doneAt: null }));
    await assertFails(updateDoc(items("bob", "i1"), { name: "a".repeat(101) }));
    await assertFails(updateDoc(items("bob", "i1"), { addedBy: "bob" }));
    await assertSucceeds(deleteDoc(items("bob", "i1")));
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

// "gone" is no longer in households/h1.memberIds but still has a member
// document and an old expense: that is what account deletion and leaving
// leave behind.
describe("deleted members", () => {
  async function seedGone(member: Record<string, unknown>) {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "households/h1/members/gone"), {
        displayName: "", avatarEmoji: "🙂", rentWeight: 1, joinedAt: now, ...member,
      });
      await setDoc(doc(db, "households/h1/expenses/withGone"), expense({
        splitInput: { alice: 1, gone: 1 }, shares: { alice: 5000, gone: 5000 },
      }));
    });
  }

  const payment = { fromUid: "alice", toUid: "gone", amountMinor: 2500, date: now, note: "", createdBy: "alice", createdAt: now };

  it("settlement to a deleted member succeeds", async () => {
    await seedGone({ active: false, deleted: true });
    await assertSucceeds(setDoc(doc(as("alice"), "households/h1/settlements/d1"), payment));
    // The other direction (the deleted member owed the household) works too.
    await assertSucceeds(setDoc(doc(as("alice"), "households/h1/settlements/d2"),
      { ...payment, fromUid: "gone", toUid: "alice" }));
  });

  it("settlement to a departed member succeeds", async () => {
    // Left (not deleted): an edit of an old shared expense can still give
    // them a balance, so it must be settleable.
    await seedGone({ active: false });
    await assertSucceeds(setDoc(doc(as("alice"), "households/h1/settlements/d1"), payment));
    await assertSucceeds(setDoc(doc(as("alice"), "households/h1/settlements/d2"),
      { ...payment, fromUid: "gone", toUid: "alice" }));
  });

  it("settlement to a uid with no member doc fails", async () => {
    await seedGone({ active: false });
    await assertFails(setDoc(doc(as("alice"), "households/h1/settlements/d1"), { ...payment, toUid: "eve" }));
    await assertFails(setDoc(doc(as("alice"), "households/h1/settlements/d2"),
      { ...payment, fromUid: "eve", toUid: "alice" }));
  });

  it("settlement between two deleted members is only recorded by an admin", async () => {
    await seedGone({ active: false, deleted: true });
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "households/h1/members/gone2"), {
        displayName: "", active: false, deleted: true, joinedAt: now,
      });
    });
    const between = { ...payment, fromUid: "gone", toUid: "gone2" };
    await assertSucceeds(setDoc(doc(as("alice"), "households/h1/settlements/d1"), between));
    await assertFails(setDoc(doc(as("bob"), "households/h1/settlements/d2"), { ...between, createdBy: "bob" }));
  });

  it("editing an old expense that keeps a deleted participant succeeds", async () => {
    await seedGone({ active: false, deleted: true });
    await assertSucceeds(updateDoc(doc(as("alice"), "households/h1/expenses/withGone"), { description: "Düzeltildi" }));
    // Also when the deleted member paid it.
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), "households/h1/expenses/paidByGone"), expense({
        paidBy: "gone", splitInput: { alice: 1, gone: 1 }, shares: { alice: 5000, gone: 5000 },
      }));
    });
    await assertSucceeds(updateDoc(doc(as("alice"), "households/h1/expenses/paidByGone"), { description: "Düzeltildi" }));
  });

  it("an old expense cannot gain a participant who is not a current member", async () => {
    await seedGone({ active: false, deleted: true });
    // Was never on e1 (alice, bob): neither the deleted member nor a stranger can be added.
    await assertFails(updateDoc(doc(as("alice"), "households/h1/expenses/e1"),
      { shares: { alice: 3000, bob: 3000, gone: 4000 } }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1/expenses/e1"),
      { shares: { alice: 5000, eve: 5000 } }));
    await assertFails(updateDoc(doc(as("alice"), "households/h1/expenses/e1"), { paidBy: "gone" }));
    // A stranger cannot be made the payer of an old expense either.
    await assertFails(updateDoc(doc(as("alice"), "households/h1/expenses/withGone"), { paidBy: "eve" }));
  });

  it("adding a deleted member to a new expense fails", async () => {
    await seedGone({ active: false, deleted: true });
    const db = as("bob");
    await assertFails(setDoc(doc(db, "households/h1/expenses/n1"),
      expense({ createdBy: "bob", shares: { bob: 5000, gone: 5000 } })));
    await assertFails(setDoc(doc(db, "households/h1/expenses/n2"), expense({ createdBy: "bob", paidBy: "gone" })));
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

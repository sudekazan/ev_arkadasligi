import { randomInt } from "node:crypto";
import { initializeApp, getApps } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { HttpsError, CallableRequest } from "firebase-functions/v2/https";

if (getApps().length === 0) initializeApp();

export const db = getFirestore();

export const REGION = "europe-west1";
export const TIME_ZONE = "Europe/Istanbul";
export const MAX_MEMBERS = 12;
export const FREE_HOUSEHOLD_LIMIT = 1;
export const FREE_RECURRING_LIMIT = 3;
export const FREE_RECEIPT_SCANS = 5;
export const PRO_RECEIPT_SCANS = 200;

const CODE_ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

export function generateInviteCode(): string {
  let code = "";
  for (let i = 0; i < 6; i++) code += CODE_ALPHABET[randomInt(CODE_ALPHABET.length)];
  return code;
}

export function requireAuth(req: CallableRequest): string {
  const uid = req.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "auth-required");
  return uid;
}

export function requireString(value: unknown, name: string): string {
  if (typeof value !== "string" || value.trim() === "") {
    throw new HttpsError("invalid-argument", `${name}-required`);
  }
  return value.trim();
}

export interface HouseholdDoc {
  name: string;
  currency: string;
  createdBy: string;
  adminIds: string[];
  memberIds: string[];
  inviteCode: string;
  proUntil?: Timestamp | null;
}

export async function loadHousehold(hid: string) {
  const ref = db.collection("households").doc(hid);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError("not-found", "household-not-found");
  return { ref, data: snap.data() as HouseholdDoc };
}

export function requireMember(h: HouseholdDoc, uid: string) {
  if (!h.memberIds.includes(uid)) {
    throw new HttpsError("permission-denied", "not-a-member");
  }
}

export function requireAdmin(h: HouseholdDoc, uid: string) {
  if (!h.adminIds.includes(uid)) {
    throw new HttpsError("permission-denied", "admin-only");
  }
}

export function isActivePro(proUntil: Timestamp | null | undefined, now = new Date()): boolean {
  return !!proUntil && proUntil.toDate().getTime() > now.getTime();
}

/** Whether the user's own subscription is active (used for the household limit). */
export async function userIsPro(uid: string): Promise<boolean> {
  const snap = await db.collection("users").doc(uid).get();
  return isActivePro(snap.get("proUntil") as Timestamp | undefined);
}

export function activityDoc(
  type: string,
  actorUid: string,
  refId: string | null,
  params: Record<string, unknown> = {},
) {
  return { type, actorUid, refId, params, createdAt: Timestamp.now() };
}

/**
 * Recomputes a household's proUntil as the latest subscription among its
 * members, so Pro follows the household while any member pays.
 */
export async function recomputeHouseholdPro(hid: string): Promise<void> {
  const ref = db.collection("households").doc(hid);
  const snap = await ref.get();
  if (!snap.exists) return;
  const memberIds = (snap.get("memberIds") as string[]) ?? [];
  let best: Timestamp | null = null;
  for (const uid of memberIds) {
    const u = await db.collection("users").doc(uid).get();
    const p = u.get("proUntil") as Timestamp | undefined;
    if (p && (!best || p.toMillis() > best.toMillis())) best = p;
  }
  await ref.update({ proUntil: best });
}

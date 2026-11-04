import { Timestamp } from "firebase-admin/firestore";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions/v2";
import { db, recomputeHouseholdPro, userIsPro } from "./common.js";

/**
 * RevenueCat secret API key. Every function whose code can reach
 * [syncUserPro] must list it in its `secrets`, or `.value()` fails.
 */
export const revenueCatApiKey = defineSecret("REVENUECAT_API_KEY");

const ENTITLEMENT = "pro";
const ANONYMOUS_PREFIX = "$RCAnonymousID";

export interface RevenueCatEvent {
  type: string;
  app_user_id?: string;
  transferred_from?: string[];
  transferred_to?: string[];
}

/** users.proUntil from a GET /v1/subscribers response; null when not Pro. */
export function proUntilFromSubscriber(body: unknown, now = Date.now()): Date | null {
  const pro = (body as {
    subscriber?: {
      entitlements?: Record<string, {
        expires_date?: string | null;
        grace_period_expires_date?: string | null;
      }>;
    };
  })?.subscriber?.entitlements?.[ENTITLEMENT];
  if (!pro) return null;
  // Lifetime / non-expiring purchases have no expiration.
  if (pro.expires_date == null) return new Date(now + 100 * 365 * 864e5);
  const expires = new Date(pro.expires_date);
  // A failed renewal in a billing grace period keeps Pro until it ends.
  if (pro.grace_period_expires_date != null) {
    const grace = new Date(pro.grace_period_expires_date);
    if (grace.getTime() > expires.getTime()) return grace;
  }
  return expires;
}

/** Every real (non-anonymous) user an event touches, without duplicates. */
export function uidsFromEvent(event: RevenueCatEvent): string[] {
  const all = [
    event.app_user_id,
    ...(event.transferred_from ?? []),
    ...(event.transferred_to ?? []),
  ];
  const uids = all.filter(
    (id): id is string => typeof id === "string" && id !== "" && !id.startsWith(ANONYMOUS_PREFIX),
  );
  return [...new Set(uids)];
}

function subscriberUrl(uid: string): string {
  return `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(uid)}`;
}

function authHeaders() {
  return { Authorization: `Bearer ${revenueCatApiKey.value().trim()}` };
}

/**
 * Asks RevenueCat for the user's Pro status and stores it in users.proUntil
 * and in their households. Throws (before any write) when RevenueCat fails.
 */
export async function syncUserPro(uid: string): Promise<Date | null> {
  const res = await fetch(subscriberUrl(uid), { headers: authHeaders() });
  if (!res.ok) throw new Error(`revenuecat-${res.status}`);
  const proUntil = proUntilFromSubscriber(await res.json());

  const userRef = db.collection("users").doc(uid);
  const snap = await userRef.get();
  if (!snap.exists) return proUntil;
  await userRef.update({ proUntil: proUntil ? Timestamp.fromDate(proUntil) : null });
  for (const hid of (snap.get("householdIds") as string[]) ?? []) {
    await recomputeHouseholdPro(hid);
  }
  return proUntil;
}

/**
 * Firestore first; when it says free, asks RevenueCat in case a webhook is late.
 * If RevenueCat fails, keeps the Firestore answer so limits still give their
 * own error instead of `internal`.
 */
export async function userIsProFresh(uid: string): Promise<boolean> {
  if (await userIsPro(uid)) return true;
  try {
    const proUntil = await syncUserPro(uid);
    return !!proUntil && proUntil.getTime() > Date.now();
  } catch (err) {
    logger.warn("revenuecat check failed", { uid, err: String(err) });
    return false;
  }
}

/** Removes the user from RevenueCat; an already missing user is not an error. */
export async function deleteSubscriber(uid: string): Promise<void> {
  const res = await fetch(subscriberUrl(uid), { method: "DELETE", headers: authHeaders() });
  if (!res.ok && res.status !== 404) throw new Error(`revenuecat-delete-${res.status}`);
}

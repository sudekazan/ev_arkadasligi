import { timingSafeEqual } from "node:crypto";
import { Timestamp } from "firebase-admin/firestore";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions/v2";
import { onRequest } from "firebase-functions/v2/https";
import { REGION, db, recomputeHouseholdPro } from "./common.js";

const webhookSecret = defineSecret("REVENUECAT_WEBHOOK_SECRET");

const GRANTING = new Set([
  "INITIAL_PURCHASE",
  "RENEWAL",
  "PRODUCT_CHANGE",
  "UNCANCELLATION",
  "NON_RENEWING_PURCHASE",
  "SUBSCRIPTION_EXTENDED",
  "TEMPORARY_ENTITLEMENT_GRANT",
]);

export interface RevenueCatEvent {
  type: string;
  app_user_id: string;
  expiration_at_ms?: number | null;
}

/** New users.proUntil for an event, or undefined when it does not change it. */
export function proUntilFor(event: RevenueCatEvent, now = Date.now()): Date | null | undefined {
  if (GRANTING.has(event.type)) {
    // Lifetime / non-expiring purchases have no expiration.
    return event.expiration_at_ms ? new Date(event.expiration_at_ms) : new Date(now + 100 * 365 * 864e5);
  }
  if (event.type === "EXPIRATION") return null;
  // CANCELLATION, BILLING_ISSUE: access continues until expiration.
  return undefined;
}

function safeEqual(a: string, b: string): boolean {
  const ab = Buffer.from(a);
  const bb = Buffer.from(b);
  return ab.length === bb.length && timingSafeEqual(ab, bb);
}

export const revenueCatWebhook = onRequest(
  { region: REGION, secrets: [webhookSecret] },
  async (req, res) => {
    const expected = `Bearer ${webhookSecret.value()}`;
    if (req.method !== "POST" || !safeEqual(req.get("authorization") ?? "", expected)) {
      res.status(401).send("unauthorized");
      return;
    }
    const event = (req.body?.event ?? {}) as RevenueCatEvent;
    const uid = event.app_user_id;
    const next = proUntilFor(event);
    if (!uid || uid.startsWith("$RCAnonymousID") || next === undefined) {
      res.status(200).send("ignored");
      return;
    }
    const userRef = db.collection("users").doc(uid);
    const snap = await userRef.get();
    if (!snap.exists) {
      res.status(200).send("unknown-user");
      return;
    }
    await userRef.update({ proUntil: next ? Timestamp.fromDate(next) : null });
    for (const hid of (snap.get("householdIds") as string[]) ?? []) {
      await recomputeHouseholdPro(hid);
    }
    logger.info("revenuecat", { type: event.type, uid });
    res.status(200).send("ok");
  },
);

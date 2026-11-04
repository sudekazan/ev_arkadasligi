import { timingSafeEqual } from "node:crypto";
import { defineSecret } from "firebase-functions/params";
import { logger } from "firebase-functions/v2";
import { onCall, onRequest } from "firebase-functions/v2/https";
import { CALLABLE, REGION, requireAuth } from "./common.js";
import { RevenueCatEvent, revenueCatApiKey, syncUserPro, uidsFromEvent } from "./revenuecat.js";

const webhookSecret = defineSecret("REVENUECAT_WEBHOOK_SECRET");

function safeEqual(a: string, b: string): boolean {
  const ab = Buffer.from(a);
  const bb = Buffer.from(b);
  return ab.length === bb.length && timingSafeEqual(ab, bb);
}

/**
 * RevenueCat webhook. Event fields only say who changed; the Pro status
 * itself is always read back from RevenueCat, so late or out-of-order
 * events and TRANSFER (restore on another account) end up correct.
 */
export const revenueCatWebhook = onRequest(
  { region: REGION, secrets: [webhookSecret, revenueCatApiKey] },
  async (req, res) => {
    // Trim: a secret set from a pipe (openssl rand | secrets:set) keeps its trailing newline.
    const expected = `Bearer ${webhookSecret.value().trim()}`;
    if (req.method !== "POST" || !safeEqual((req.get("authorization") ?? "").trim(), expected)) {
      res.status(401).send("unauthorized");
      return;
    }
    const event = (req.body?.event ?? {}) as RevenueCatEvent;
    const uids = uidsFromEvent(event);
    if (uids.length === 0) {
      res.status(200).send("ignored");
      return;
    }
    try {
      for (const uid of uids) await syncUserPro(uid);
    } catch (err) {
      // 500 makes RevenueCat retry the event later.
      logger.error("revenuecat sync failed", { type: event.type, uids, err: String(err) });
      res.status(500).send("sync-failed");
      return;
    }
    logger.info("revenuecat", { type: event.type, uids });
    res.status(200).send("ok");
  },
);

/** Called by the app right after a purchase or restore. */
export const syncPro = onCall({ ...CALLABLE, secrets: [revenueCatApiKey] }, async (req) => {
  const uid = requireAuth(req);
  const date = await syncUserPro(uid);
  return { proUntil: date?.toISOString() ?? null };
});

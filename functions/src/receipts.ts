import { FieldValue } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { defineSecret, defineString } from "firebase-functions/params";
import { logger } from "firebase-functions/v2";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import {
  FREE_RECEIPT_SCANS,
  PRO_RECEIPT_SCANS,
  REGION,
  db,
  isActivePro,
  loadHousehold,
  requireAuth,
  requireMember,
  requireString,
} from "./common.js";
import { monthKey } from "./dates.js";
import { RECEIPT_PROMPT, parseReceiptJson } from "./receipt_parser.js";

const apiKey = defineSecret("RECEIPT_API_KEY");
const provider = defineString("RECEIPT_PROVIDER", { default: "gemini" });
const model = defineString("RECEIPT_MODEL", { default: "gemini-2.5-flash" });

async function callModel(mime: string, base64: string): Promise<string> {
  const key = apiKey.value();
  if (!key) throw new Error("missing-api-key");
  if (provider.value() === "openrouter") {
    const res = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${key}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: model.value(),
        response_format: { type: "json_object" },
        messages: [
          {
            role: "user",
            content: [
              { type: "text", text: RECEIPT_PROMPT },
              { type: "image_url", image_url: { url: `data:${mime};base64,${base64}` } },
            ],
          },
        ],
      }),
    });
    if (!res.ok) throw new Error(`openrouter-${res.status}`);
    const json = (await res.json()) as { choices?: { message?: { content?: string } }[] };
    return json.choices?.[0]?.message?.content ?? "";
  }
  const url = `https://generativelanguage.googleapis.com/v1beta/models/${model.value()}:generateContent`;
  const res = await fetch(url, {
    method: "POST",
    headers: { "x-goog-api-key": key, "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [
        { parts: [{ text: RECEIPT_PROMPT }, { inline_data: { mime_type: mime, data: base64 } }] },
      ],
      generationConfig: { responseMimeType: "application/json" },
    }),
  });
  if (!res.ok) throw new Error(`gemini-${res.status}`);
  const json = (await res.json()) as {
    candidates?: { content?: { parts?: { text?: string }[] } }[];
  };
  return json.candidates?.[0]?.content?.parts?.[0]?.text ?? "";
}

export const scanReceipt = onCall(
  {
    region: REGION,
    secrets: [apiKey],
    enforceAppCheck: process.env.FUNCTIONS_EMULATOR !== "true",
    timeoutSeconds: 60,
    memory: "512MiB",
  },
  async (req) => {
    const uid = requireAuth(req);
    const hid = requireString(req.data?.hid, "hid");
    const path = requireString(req.data?.path, "path");
    if (!path.startsWith(`receipts/${hid}/`) || path.includes("..")) {
      throw new HttpsError("invalid-argument", "path-invalid");
    }
    const { data: h } = await loadHousehold(hid);
    requireMember(h, uid);

    const limit = isActivePro(h.proUntil) ? PRO_RECEIPT_SCANS : FREE_RECEIPT_SCANS;
    const key = monthKey(new Date());
    const usageRef = db.collection("usage").doc(uid);
    await db.runTransaction(async (tx) => {
      const snap = await tx.get(usageRef);
      const used = (snap.get(`receiptScans.${key}`) as number) ?? 0;
      if (used >= limit) {
        throw new HttpsError("resource-exhausted", "receipt-quota", { limit, used });
      }
      tx.set(usageRef, { receiptScans: { [key]: used + 1 } }, { merge: true });
    });

    try {
      const file = getStorage().bucket().file(path);
      const [meta] = await file.getMetadata();
      const [bytes] = await file.download();
      const text = await callModel(String(meta.contentType ?? "image/jpeg"), bytes.toString("base64"));
      return parseReceiptJson(text);
    } catch (err) {
      logger.warn("scanReceipt failed", { err: String(err) });
      // Failed reads do not consume the monthly quota.
      await usageRef.set(
        { receiptScans: { [key]: FieldValue.increment(-1) } },
        { merge: true },
      );
      throw new HttpsError("unavailable", "receipt-unreadable");
    }
  },
);

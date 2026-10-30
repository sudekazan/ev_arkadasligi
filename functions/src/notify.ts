import { FieldValue } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions/v2";
import { db } from "./common.js";

export type NotificationKind = "newExpense" | "reminders" | "chores" | "bills";

type Lang = "tr" | "en" | "de";

type Template = (p: Record<string, string>) => { title: string; body: string };

const MESSAGES: Record<string, Record<Lang, Template>> = {
  newExpense: {
    tr: (p) => ({ title: p.household, body: `${p.actor} gider ekledi: ${p.description} (${p.amount})` }),
    en: (p) => ({ title: p.household, body: `${p.actor} added an expense: ${p.description} (${p.amount})` }),
    de: (p) => ({ title: p.household, body: `${p.actor} hat eine Ausgabe eingetragen: ${p.description} (${p.amount})` }),
  },
  settlement: {
    tr: (p) => ({ title: p.household, body: `${p.actor} sana ${p.amount} ödediğini kaydetti` }),
    en: (p) => ({ title: p.household, body: `${p.actor} recorded paying you ${p.amount}` }),
    de: (p) => ({ title: p.household, body: `${p.actor} hat eine Zahlung von ${p.amount} an dich eingetragen` }),
  },
  reminder: {
    tr: (p) => ({ title: p.household, body: `${p.actor} hatırlatıyor: ona ${p.amount} borcun var` }),
    en: (p) => ({ title: p.household, body: `${p.actor} reminds you that you owe them ${p.amount}` }),
    de: (p) => ({ title: p.household, body: `${p.actor} erinnert dich: Du schuldest ${p.amount}` }),
  },
  pendingBill: {
    tr: (p) => ({ title: p.household, body: `${p.description} faturasının tutarını girmen bekleniyor` }),
    en: (p) => ({ title: p.household, body: `Enter the amount for the ${p.description} bill` }),
    de: (p) => ({ title: p.household, body: `Gib den Betrag für die Rechnung ${p.description} ein` }),
  },
  chore: {
    tr: (p) => ({ title: p.household, body: `Bugün sıra sende: ${p.chore}` }),
    en: (p) => ({ title: p.household, body: `It's your turn today: ${p.chore}` }),
    de: (p) => ({ title: p.household, body: `Heute bist du dran: ${p.chore}` }),
  },
};

/** Formats integer minor units for a notification body. */
export function formatAmount(minor: number, currency: string, lang: Lang): string {
  const abs = Math.abs(minor);
  const major = Math.floor(abs / 100).toString();
  const cents = String(abs % 100).padStart(2, "0");
  const english = lang === "en";
  const grouped = major.replace(/\B(?=(\d{3})+(?!\d))/g, english ? "," : ".");
  const sign = minor < 0 ? "-" : "";
  const symbol = { TRY: "₺", EUR: "€", USD: "$", GBP: "£" }[currency] ?? currency;
  return english
    ? `${sign}${symbol}${grouped}.${cents}`
    : `${sign}${grouped},${cents} ${symbol}`;
}

/**
 * Sends a localized push to each user that has [kind] notifications enabled,
 * and prunes tokens FCM reports as invalid.
 */
export async function notifyUsers(
  uids: string[],
  kind: NotificationKind,
  messageKey: string,
  params: (lang: Lang) => Record<string, string>,
  data: Record<string, string> = {},
): Promise<void> {
  const messaging = getMessaging();
  await Promise.all(
    uids.map(async (uid) => {
      const snap = await db.collection("users").doc(uid).get();
      if (!snap.exists) return;
      const prefs = (snap.get("notificationPrefs") as Record<string, boolean>) ?? {};
      if (prefs[kind] === false) return;
      const tokens = (snap.get("fcmTokens") as string[]) ?? [];
      if (tokens.length === 0) return;
      const locale = snap.get("locale");
      const lang: Lang = locale === "en" || locale === "de" ? locale : "tr";
      const notification = MESSAGES[messageKey][lang](params(lang));
      try {
        const res = await messaging.sendEachForMulticast({ tokens, notification, data });
        const stale = tokens.filter((_, i) => {
          const code = res.responses[i].error?.code;
          return (
            code === "messaging/registration-token-not-registered" ||
            code === "messaging/invalid-registration-token"
          );
        });
        if (stale.length > 0) {
          await snap.ref.update({ fcmTokens: FieldValue.arrayRemove(...stale) });
        }
      } catch (err) {
        logger.warn("push failed", { uid, err });
      }
    }),
  );
}

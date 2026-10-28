// Validation of the model's receipt JSON. Pure, so it is unit-tested.

export interface ParsedReceipt {
  merchant: string | null;
  date: string | null; // YYYY-MM-DD
  totalMinor: number | null;
  category: ReceiptCategory | null;
  items: { name: string; amountMinor: number }[];
}

// ExpenseCategory names in lib/features/expenses/domain/expense.dart, minus
// rent (never on a shop receipt; picking it applies the rent shares).
export const RECEIPT_CATEGORIES = [
  "electricity",
  "water",
  "gas",
  "internet",
  "groceries",
  "cleaning",
  "homeGoods",
  "other",
] as const;

export type ReceiptCategory = (typeof RECEIPT_CATEGORIES)[number];

export const RECEIPT_PROMPT = `You read shop receipts. Reply with JSON only, no prose:
{"merchant": string|null, "date": "YYYY-MM-DD"|null, "total": string|null,
 "category": string|null, "items": [{"name": string, "amount": string}]}
Amounts are strings with the receipt's decimals, e.g. "1234.50". "total" is the
final amount paid. "category" is the one that fits the whole receipt best:
${RECEIPT_CATEGORIES.join(", ")}. Supermarkets, grocers, bakeries and markets
(e.g. Migros, BİM, A101, ŞOK, CarrefourSA) are "groceries"; detergents and
cleaning supplies are "cleaning"; furniture, kitchenware and home items are
"homeGoods"; utility bills are electricity, water, gas or internet. Use null
when a field is not readable. At most 50 items.`;

/** Parses "1.234,56", "1234.56", "₺ 12,5" etc. into integer minor units. */
export function decimalToMinor(value: unknown): number | null {
  if (typeof value !== "string" && typeof value !== "number") return null;
  let s = String(value).replace(/[^\d.,-]/g, "");
  if (s === "" || s.startsWith("-")) return null;
  const match = s.match(/[.,](\d{1,2})$/);
  let cents = 0;
  if (match) {
    cents = Number(match[1].padEnd(2, "0"));
    s = s.slice(0, s.length - match[0].length);
  }
  const whole = s.replace(/[.,]/g, "");
  if (whole !== "" && !/^\d+$/.test(whole)) return null;
  const minor = Number(whole || "0") * 100 + cents;
  return Number.isSafeInteger(minor) ? minor : null;
}

export function parseReceiptJson(text: string): ParsedReceipt {
  const cleaned = text.trim().replace(/^```(?:json)?\s*/i, "").replace(/```$/, "");
  const raw = JSON.parse(cleaned) as Record<string, unknown>;
  if (typeof raw !== "object" || raw === null) throw new Error("not-object");

  const merchant =
    typeof raw.merchant === "string" && raw.merchant.trim() !== ""
      ? raw.merchant.trim().slice(0, 80)
      : null;
  const date =
    typeof raw.date === "string" && /^\d{4}-\d{2}-\d{2}$/.test(raw.date) &&
    !Number.isNaN(Date.parse(raw.date))
      ? raw.date
      : null;
  const totalMinor = decimalToMinor(raw.total);
  const category = (RECEIPT_CATEGORIES as readonly string[]).includes(raw.category as string)
    ? (raw.category as ReceiptCategory)
    : null;
  const items: ParsedReceipt["items"] = [];
  if (Array.isArray(raw.items)) {
    for (const item of raw.items.slice(0, 50)) {
      if (typeof item !== "object" || item === null) continue;
      const name = (item as Record<string, unknown>).name;
      const amountMinor = decimalToMinor((item as Record<string, unknown>).amount);
      if (typeof name === "string" && name.trim() !== "" && amountMinor !== null) {
        items.push({ name: name.trim().slice(0, 80), amountMinor });
      }
    }
  }
  if (totalMinor === null && items.length === 0) throw new Error("empty-receipt");
  return {
    merchant,
    date,
    totalMinor: totalMinor && totalMinor > 0 ? totalMinor : null,
    category,
    items,
  };
}

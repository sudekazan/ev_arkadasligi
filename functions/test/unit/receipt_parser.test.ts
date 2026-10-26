import { describe, expect, it } from "vitest";
import { decimalToMinor, parseReceiptJson } from "../../src/receipt_parser.js";

describe("receipt parser", () => {
  it("parses amounts without floating point", () => {
    expect(decimalToMinor("1.234,56")).toBe(123456);
    expect(decimalToMinor("1234.5")).toBe(123450);
    expect(decimalToMinor("₺ 89,90")).toBe(8990);
    expect(decimalToMinor(12.3)).toBe(1230);
    expect(decimalToMinor("1.234")).toBe(123400);
    expect(decimalToMinor("-5")).toBeNull();
    expect(decimalToMinor(null)).toBeNull();
    expect(decimalToMinor("abc")).toBeNull();
  });

  it("validates the model JSON", () => {
    const r = parseReceiptJson(
      '```json\n{"merchant":" Migros ","date":"2026-10-20","total":"245,90","items":[{"name":"Süt","amount":"34,50"},{"name":"","amount":"1"},{"name":"Ekmek","amount":"x"}]}\n```',
    );
    expect(r).toEqual({
      merchant: "Migros",
      date: "2026-10-20",
      totalMinor: 24590,
      items: [{ name: "Süt", amountMinor: 3450 }],
    });
  });

  it("nulls unreadable fields and rejects empty receipts", () => {
    const r = parseReceiptJson('{"merchant":null,"date":"20.10.2026","total":"10"}');
    expect(r.date).toBeNull();
    expect(r.merchant).toBeNull();
    expect(r.totalMinor).toBe(1000);
    expect(() => parseReceiptJson('{"merchant":"X"}')).toThrow("empty-receipt");
    expect(() => parseReceiptJson("not json")).toThrow();
  });
});

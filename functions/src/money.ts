// Server-side mirror of lib/core/money. Amounts are integer minor units
// (kuruş); never use floating point here.

export type SplitType = "equal" | "exact" | "percent" | "shares";

export interface ExpenseLike {
  amountMinor: number;
  paidBy: string;
  shares: Record<string, number>;
  status?: string;
}

export interface SettlementLike {
  fromUid: string;
  toUid: string;
  amountMinor: number;
}

/** Largest-remainder allocation of [amount] by integer [weights]. */
export function allocateByWeights(
  amount: number,
  weights: Record<string, number>,
): Record<string, number> {
  const uids = Object.keys(weights)
    .filter((u) => weights[u] > 0)
    .sort();
  if (uids.length === 0) throw new Error("no-participants");
  const total = BigInt(uids.reduce((s, u) => s + weights[u], 0));
  const big = BigInt(amount);
  const rows = uids.map((uid) => {
    const product = big * BigInt(weights[uid]);
    return { uid, floor: product / total, rem: product % total };
  });
  let left = big - rows.reduce((s, r) => s + r.floor, 0n);
  const order = [...rows].sort((a, b) =>
    a.rem === b.rem ? (a.uid < b.uid ? -1 : 1) : a.rem > b.rem ? -1 : 1,
  );
  for (const row of order) {
    if (left === 0n) break;
    row.floor += 1n;
    left -= 1n;
  }
  const out: Record<string, number> = {};
  for (const r of rows) out[r.uid] = Number(r.floor);
  return out;
}

/** Computes exact shares for a template-generated expense. */
export function computeShares(
  type: SplitType,
  amount: number,
  input: Record<string, number>,
): Record<string, number> {
  switch (type) {
    case "equal": {
      const weights: Record<string, number> = {};
      for (const uid of Object.keys(input)) weights[uid] = 1;
      return allocateByWeights(amount, weights);
    }
    case "percent": {
      const sum = Object.values(input).reduce((s, v) => s + v, 0);
      if (sum !== 10000) throw new Error("percent-sum");
      return allocateByWeights(amount, input);
    }
    case "shares":
      return allocateByWeights(amount, input);
    case "exact": {
      const sum = Object.values(input).reduce((s, v) => s + v, 0);
      if (sum !== amount) throw new Error("exact-sum");
      return { ...input };
    }
  }
}

/** net = paid − owed + settlements sent − settlements received. */
export function computeNets(
  expenses: ExpenseLike[],
  settlements: SettlementLike[],
): Record<string, number> {
  const net: Record<string, number> = {};
  const add = (uid: string, v: number) => {
    net[uid] = (net[uid] ?? 0) + v;
  };
  for (const e of expenses) {
    if (e.status === "pendingAmount") continue;
    add(e.paidBy, e.amountMinor);
    for (const [uid, share] of Object.entries(e.shares ?? {})) add(uid, -share);
  }
  for (const s of settlements) {
    add(s.fromUid, s.amountMinor);
    add(s.toUid, -s.amountMinor);
  }
  return net;
}

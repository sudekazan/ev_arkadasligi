import { setGlobalOptions } from "firebase-functions/v2";
import { REGION } from "./common.js";

setGlobalOptions({ region: REGION, maxInstances: 10 });

export {
  createHousehold,
  joinHousehold,
  leaveHousehold,
  removeMember,
  regenerateInviteCode,
} from "./household.js";
export { onExpenseWritten, onSettlementWritten, sendReminder } from "./triggers.js";
export { runRecurring } from "./recurring.js";
export { choreReminders } from "./chores.js";
export { scanReceipt } from "./receipts.js";
export { revenueCatWebhook } from "./billing.js";
export { deleteAccount } from "./account.js";

// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ödeşelim';

  @override
  String get tabHome => 'Home';

  @override
  String get tabExpenses => 'Expenses';

  @override
  String get tabHouse => 'House';

  @override
  String get tabAccount => 'Account';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get close => 'Close';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Next';

  @override
  String get ok => 'OK';

  @override
  String get or => 'or';

  @override
  String get remove => 'Remove';

  @override
  String get retry => 'Try again';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get skip => 'Skip';

  @override
  String get seeAll => 'See all';

  @override
  String get requiredField => 'This field is required';

  @override
  String get you => 'You';

  @override
  String youSuffix(String name) {
    return '$name (you)';
  }

  @override
  String get unknownMember => 'Unknown member';

  @override
  String get deletedUser => 'Deleted user';

  @override
  String get admin => 'Admin';

  @override
  String get errorNetwork => 'Can\'t connect right now, please try again.';

  @override
  String get errorPermission => 'You don\'t have permission to do that.';

  @override
  String get errorNotFound => 'We couldn\'t find that.';

  @override
  String get errorInvalidCredentials => 'Wrong e-mail or password.';

  @override
  String get errorEmailInUse => 'An account with this e-mail already exists.';

  @override
  String get errorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get errorInvalidEmail => 'Enter a valid e-mail address.';

  @override
  String get errorTooManyRequests =>
      'Too many attempts, try again a bit later.';

  @override
  String get errorCancelled => 'Cancelled.';

  @override
  String get errorRequiresRecentLogin =>
      'For security, sign out and sign in again first.';

  @override
  String get errorHouseholdLimit =>
      'The free plan includes one household. Go Pro for more.';

  @override
  String get errorHouseholdFull => 'This household is full (12 members max).';

  @override
  String get errorInviteInvalid => 'Invalid invite code. Please check it.';

  @override
  String get errorBalanceNotZero => 'The balance is not zero. Settle up first.';

  @override
  String get errorReceiptQuota => 'You\'ve used this month\'s receipt scans.';

  @override
  String get errorReceiptUnreadable => 'The receipt couldn\'t be read.';

  @override
  String get errorReminderAlreadySent =>
      'You already sent this person a reminder today.';

  @override
  String get errorNothingOwed => 'This person doesn\'t owe anything.';

  @override
  String get errorUnknown => 'Something went wrong, please try again.';

  @override
  String get welcomeTitle1 => 'All shared costs in one place';

  @override
  String get welcomeBody1 =>
      'Add rent, bills and groceries so everyone knows who paid what.';

  @override
  String get welcomeTitle2 => 'Fair down to the last cent';

  @override
  String get welcomeBody2 =>
      'Split equally, by amount, percentage or room size; debts are simplified to the fewest transfers.';

  @override
  String get welcomeTitle3 => 'Chores live here too';

  @override
  String get welcomeBody3 =>
      'A shared shopping list and \"whose turn is it\" tracking. Adding expenses is always free and unlimited.';

  @override
  String get getStarted => 'Get started';

  @override
  String pageIndicator(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get authSubtitle => 'Split costs fairly with your housemates.';

  @override
  String get signIn => 'Sign in';

  @override
  String get register => 'Sign up';

  @override
  String get signOut => 'Sign out';

  @override
  String get yourName => 'Your name';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get enterEmailFirst => 'Enter your e-mail first.';

  @override
  String get passwordResetSent =>
      'A password reset link was sent to your e-mail.';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get onboardingTitle => 'Set up your household';

  @override
  String get onboardingBody =>
      'Create a new household or join with the 6-character code your housemate shared.';

  @override
  String get createHousehold => 'Create';

  @override
  String get joinWithCode => 'Join with code';

  @override
  String get join => 'Join';

  @override
  String get householdName => 'Household name';

  @override
  String get householdNameHint => 'e.g. Our flat';

  @override
  String get currency => 'Currency';

  @override
  String get inviteCode => 'Invite code';

  @override
  String get inviteCodeLength => 'The code has 6 characters';

  @override
  String inviteCodeSemantics(String code) {
    return 'Invite code: $code';
  }

  @override
  String get inviteTitle => 'Your household is ready!';

  @override
  String get inviteBody =>
      'Invite your housemates: share this code and they enter it under \"Join with code\".';

  @override
  String inviteShareText(String code) {
    return 'Join our household on Ödeşelim! Open the app, tap \"Join with code\" and enter: $code';
  }

  @override
  String get continueToHome => 'Go to home';

  @override
  String get regenerateCode => 'New code';

  @override
  String get regenerateCodeBody =>
      'The old code will stop working. You will need to share the new one again.';

  @override
  String get addHousehold => 'Add another household';

  @override
  String get myHouseholds => 'My households';

  @override
  String get switchHousehold => 'Switch household';

  @override
  String get houseSettings => 'Household settings';

  @override
  String get editHousehold => 'Edit household';

  @override
  String membersCount(int count, int max) {
    return 'Members ($count/$max)';
  }

  @override
  String get rentWeightHelp =>
      'Rent share: rent is split by these weights (e.g. big room 3, small room 2).';

  @override
  String rentWeightValue(int weight) {
    return 'Rent share: $weight';
  }

  @override
  String decreaseRentWeight(String name) {
    return 'Decrease rent share for $name';
  }

  @override
  String increaseRentWeight(String name) {
    return 'Increase rent share for $name';
  }

  @override
  String get removeMember => 'Remove member';

  @override
  String removeMemberBody(String name) {
    return 'Remove $name from the household?';
  }

  @override
  String get cannotRemoveTitle => 'Settle up first';

  @override
  String cannotRemoveBody(String name, String amount) {
    return '$name\'s balance is $amount. They can\'t be removed until it is zero.';
  }

  @override
  String get leaveHousehold => 'Leave household';

  @override
  String get leave => 'Leave';

  @override
  String leaveHouseholdBody(String household) {
    return 'Are you sure you want to leave \"$household\"?';
  }

  @override
  String get cannotLeaveTitle => 'Settle up first';

  @override
  String cannotLeaveBody(String amount) {
    return 'Your balance is $amount. It must be zero before you can leave.';
  }

  @override
  String get inviteHousemates => 'Invite housemates';

  @override
  String get allSettled => 'All square, nobody owes anything.';

  @override
  String youOweOne(String name, String amount) {
    return 'You owe $name $amount';
  }

  @override
  String youOweTotal(String amount) {
    return 'You owe $amount in total';
  }

  @override
  String owesYouOne(String name, String amount) {
    return '$name owes you $amount';
  }

  @override
  String theyOweYouTotal(String amount) {
    return 'You are owed $amount';
  }

  @override
  String get statusOwe => 'You owe';

  @override
  String get statusOwed => 'You are owed';

  @override
  String get statusSettled => 'Settled up';

  @override
  String get whoOwesWhom => 'Who owes whom';

  @override
  String transferLine(String from, String to) {
    return '$from → $to';
  }

  @override
  String get pay => 'Pay';

  @override
  String get remind => 'Remind';

  @override
  String get reminderSent => 'Reminder sent.';

  @override
  String get pendingBills => 'Bills awaiting an amount';

  @override
  String get enterAmount => 'Enter amount';

  @override
  String get recentPayments => 'Recent payments';

  @override
  String get disputePayment => 'Dispute payment';

  @override
  String disputePaymentBody(String amount) {
    return 'Delete this $amount payment record? Balances will update.';
  }

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get homeEmptyTitle => 'Add your first expense';

  @override
  String get homeEmptyBody =>
      'Once you add an expense, you\'ll see who owes whom here.';

  @override
  String get recordPayment => 'Record a payment';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get partialPaymentHint => 'You can pay all or part of it.';

  @override
  String recipientIban(String name) {
    return '$name\'s IBAN';
  }

  @override
  String get copyIban => 'Copy IBAN';

  @override
  String get ibanCopied => 'IBAN copied';

  @override
  String noIbanYet(String name) {
    return '$name hasn\'t added an IBAN yet.';
  }

  @override
  String get markAsPaid => 'Mark as paid';

  @override
  String get paymentRecorded => 'Payment recorded.';

  @override
  String get samePersonError => 'From and to can\'t be the same person';

  @override
  String get paymentMustInvolveYou =>
      'You can only record payments you are part of';

  @override
  String get addExpense => 'Add expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get enterBillAmount => 'Enter the bill amount';

  @override
  String get description => 'Description';

  @override
  String get amount => 'Amount';

  @override
  String get paidBy => 'Paid by';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get split => 'Split';

  @override
  String get note => 'Note';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get shares => 'Shares';

  @override
  String get enterValidAmount => 'Enter a valid amount';

  @override
  String get fixSplitFirst => 'The split doesn\'t add up';

  @override
  String paidByOn(String name, String date) {
    return '$name paid · $date';
  }

  @override
  String yourShare(String amount) {
    return 'Your share $amount';
  }

  @override
  String get pendingAmount => 'Amount pending';

  @override
  String splitTypeLabel(String type) {
    return 'Split: $type';
  }

  @override
  String get searchExpenses => 'Search expenses';

  @override
  String get allCategories => 'All categories';

  @override
  String get everyone => 'Everyone';

  @override
  String get noExpensesTitle => 'No expenses yet';

  @override
  String get noExpensesBody =>
      'Rent, bills or groceries: add your first shared expense.';

  @override
  String get noResultsTitle => 'No results';

  @override
  String get noResultsBody => 'No expenses match these filters.';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get deleteExpense => 'Delete expense';

  @override
  String deleteExpenseBody(String description) {
    return 'Permanently delete \"$description\"?';
  }

  @override
  String get expenseNotFound => 'Expense not found';

  @override
  String get expenseNotFoundBody => 'This expense may have been deleted.';

  @override
  String get categoryRent => 'Rent';

  @override
  String get categoryElectricity => 'Electricity';

  @override
  String get categoryWater => 'Water';

  @override
  String get categoryGas => 'Gas';

  @override
  String get categoryInternet => 'Internet';

  @override
  String get categoryGroceries => 'Groceries';

  @override
  String get categoryCleaning => 'Cleaning';

  @override
  String get categoryHomeGoods => 'Home goods';

  @override
  String get categoryOther => 'Other';

  @override
  String get splitEqual => 'Equally';

  @override
  String get splitExact => 'By amount';

  @override
  String get splitPercent => 'By percentage';

  @override
  String get splitShares => 'By shares';

  @override
  String get sharesSuffix => 'sh.';

  @override
  String get splitNoParticipants => 'Select at least one person';

  @override
  String get splitInvalidNumber => 'There is an invalid number';

  @override
  String splitMissing(String amount) {
    return '$amount missing';
  }

  @override
  String splitExcess(String amount) {
    return '$amount too much';
  }

  @override
  String percentTotal(String percent) {
    return 'Total $percent% (must be 100)';
  }

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get receiptScanning => 'Reading receipt…';

  @override
  String get receiptScanned => 'Receipt read, please check the details.';

  @override
  String get receiptScanFailed =>
      'Couldn\'t read the receipt; the photo is attached, enter the details by hand.';

  @override
  String get receiptTooLarge => 'The photo is too large (5 MB max).';

  @override
  String get receiptAttached => 'Receipt photo attached';

  @override
  String receiptItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items read',
      one: '1 item read',
    );
    return '$_temp0';
  }

  @override
  String get removeReceipt => 'Remove receipt';

  @override
  String get receipt => 'Receipt';

  @override
  String get receiptItems => 'Receipt items';

  @override
  String get shoppingList => 'Shopping';

  @override
  String get addShoppingItemHint => 'What do you need? e.g. milk, detergent';

  @override
  String get emptyShoppingTitle => 'The list is empty';

  @override
  String get emptyShoppingBody =>
      'Add what the house needs; whoever buys it ticks it off and everyone sees it instantly.';

  @override
  String get addFirstItem => 'Add the first item';

  @override
  String addedBy(String name) {
    return 'Added by $name';
  }

  @override
  String get boughtItems => 'Bought';

  @override
  String get boughtItemsHelp =>
      'You can add the selected items as one groceries expense.';

  @override
  String boughtBy(String name) {
    return 'Bought by $name';
  }

  @override
  String get markNotBought => 'Mark as not bought';

  @override
  String addAsExpense(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count items as expense',
      one: 'Add 1 item as expense',
    );
    return '$_temp0';
  }

  @override
  String get groceriesDescription => 'Groceries';

  @override
  String get chores => 'Chores';

  @override
  String get addChore => 'Add chore';

  @override
  String get editChore => 'Edit chore';

  @override
  String get deleteChore => 'Delete chore';

  @override
  String deleteChoreBody(String name) {
    return 'Delete the chore \"$name\"?';
  }

  @override
  String get choreName => 'Chore name';

  @override
  String get choreNameHint => 'e.g. Take out the trash';

  @override
  String get emptyChoresTitle => 'No chores';

  @override
  String get emptyChoresBody =>
      'Dishes, trash, cleaning… Set the rotation and the app reminds whoever is up.';

  @override
  String whoseTurn(String name) {
    return 'Turn: $name';
  }

  @override
  String choreDueToday(String date) {
    return 'Due now ($date)';
  }

  @override
  String choreDueOn(String date) {
    return 'Next: $date';
  }

  @override
  String get markDone => 'Done';

  @override
  String choreDoneNext(String name) {
    return 'Nice! It\'s $name\'s turn now.';
  }

  @override
  String get firstDueDate => 'First due date';

  @override
  String get rotationOrder => 'Rotation';

  @override
  String get rotationHelp => 'Tap people in order; that becomes the rotation.';

  @override
  String get frequencyDaily => 'Daily';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyBiweekly => 'Every 2 weeks';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get recurringExpenses => 'Recurring';

  @override
  String get addRecurring => 'Add recurring expense';

  @override
  String get editRecurring => 'Edit recurring expense';

  @override
  String get deleteRecurring => 'Delete template';

  @override
  String deleteRecurringBody(String description) {
    return 'Delete the \"$description\" template? Expenses already created stay.';
  }

  @override
  String get emptyRecurringTitle => 'No recurring expenses';

  @override
  String get emptyRecurringBody =>
      'Fixed costs like rent are added every month automatically; for bills you get a reminder to enter the amount.';

  @override
  String get recurringHint => 'e.g. Rent, Internet bill';

  @override
  String get fixedAmount => 'Fixed amount';

  @override
  String get fixedAmountHelp =>
      'The expense is created automatically on the day.';

  @override
  String get variableAmountHelp =>
      'An \"amount pending\" draft is created and the payer is notified.';

  @override
  String get variableAmount => 'Variable amount';

  @override
  String get variableNoExact =>
      '\"By amount\" split is not available for variable amounts';

  @override
  String get schedule => 'Schedule';

  @override
  String get dayOfMonth => 'Day of month';

  @override
  String get dayOfMonthHelp => 'Months without that day use their last day.';

  @override
  String get dayOfWeek => 'Day of week';

  @override
  String nextRun(String date) {
    return 'Next: $date';
  }

  @override
  String recurringFreeUsage(int used, int limit) {
    return '$used/$limit templates used on the free plan.';
  }

  @override
  String get activity => 'Activity';

  @override
  String get noActivityTitle => 'No activity yet';

  @override
  String get noActivityBody =>
      'Expenses, payments and completed chores show up here.';

  @override
  String activityHouseholdCreated(String actor) {
    return '$actor created the household';
  }

  @override
  String activityMemberJoined(String actor) {
    return '$actor joined';
  }

  @override
  String activityMemberLeft(String actor) {
    return '$actor left';
  }

  @override
  String activityMemberRemoved(String actor, String member) {
    return '$actor removed $member';
  }

  @override
  String activityExpenseAdded(String actor, String description, String amount) {
    return '$actor added $description ($amount)';
  }

  @override
  String activityExpenseEdited(String actor, String description) {
    return '$actor edited $description';
  }

  @override
  String activityExpenseDeleted(
    String actor,
    String description,
    String amount,
  ) {
    return '$actor deleted $description ($amount)';
  }

  @override
  String activitySettlementAdded(String from, String to, String amount) {
    return 'Payment: $from → $to ($amount)';
  }

  @override
  String activitySettlementDeleted(
    String actor,
    String from,
    String to,
    String amount,
  ) {
    return '$actor deleted a payment: $from → $to ($amount)';
  }

  @override
  String activityRecurringCreated(String description, String amount) {
    return 'Recurring expense added: $description ($amount)';
  }

  @override
  String activityBillPending(String description) {
    return '$description bill created, amount pending';
  }

  @override
  String activityChoreDone(String actor, String chore, String next) {
    return '$actor did $chore. Next: $next';
  }

  @override
  String activityShoppingConverted(String actor, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$actor turned $count shopping items into an expense',
      one: '$actor turned 1 shopping item into an expense',
    );
    return '$_temp0';
  }

  @override
  String get activityUnknown => 'Something changed in the household';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get avatar => 'Avatar';

  @override
  String get ibanOptional => 'IBAN (optional)';

  @override
  String get ibanHelp =>
      'Housemates can copy your IBAN with one tap when paying you.';

  @override
  String get ibanInvalid => 'Enter a valid IBAN';

  @override
  String get preferences => 'Preferences';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get systemDefault => 'System';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifyNewExpense => 'New expenses';

  @override
  String get notifyReminders => 'Payments and reminders';

  @override
  String get notifyBills => 'Bills awaiting an amount';

  @override
  String get notifyChores => 'Chore turns';

  @override
  String get data => 'Data';

  @override
  String get reports => 'Reports';

  @override
  String get exportCsv => 'Export as CSV';

  @override
  String csvSubject(String household) {
    return '$household expenses';
  }

  @override
  String get proFeature => 'Pro feature';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountBody =>
      'Your account and profile are permanently deleted and you leave all households. Past expenses will show \"Deleted user\". This cannot be undone.';

  @override
  String get goPro => 'Go Ödeşelim Pro';

  @override
  String get goProBody =>
      'Unlimited households and templates, 200 receipt scans a month, full reports.';

  @override
  String get proActive => 'Pro is active';

  @override
  String get proActiveBody => 'Everyone in the household gets Pro features.';

  @override
  String proActiveFor(String household) {
    return 'Everyone in \"$household\" has Pro.';
  }

  @override
  String get proBadge => 'Pro';

  @override
  String get proTitle => 'Ödeşelim Pro';

  @override
  String get proSubtitle =>
      'One person subscribes, the whole household benefits. Split that too!';

  @override
  String get proFreeForever =>
      'Adding expenses is unlimited and free on every plan.';

  @override
  String get proBenefitHouseholds => 'Unlimited households';

  @override
  String get proBenefitRecurring => 'Unlimited recurring templates';

  @override
  String proBenefitReceipts(int count) {
    return '$count receipt scans a month';
  }

  @override
  String get proBenefitReports =>
      'Category reports and monthly summaries for all history';

  @override
  String get proBenefitCsv => 'CSV export';

  @override
  String get proBenefitShared => 'Works for everyone in the household';

  @override
  String get planMonthly => 'Monthly';

  @override
  String get planAnnual => 'Yearly';

  @override
  String trialDays(int days) {
    return '$days-day free trial';
  }

  @override
  String savePercent(int percent) {
    return 'Save $percent%';
  }

  @override
  String get startTrial => 'Start free trial';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get restoreSuccess => 'Your Pro subscription was restored.';

  @override
  String get restoreNothing => 'No subscription found to restore.';

  @override
  String get storeUnavailable => 'Can\'t connect right now, try again';

  @override
  String get proWelcome => 'Welcome to Pro! 🎉';

  @override
  String get subscriptionTerms =>
      'Subscriptions renew automatically unless cancelled before the period ends. Cancel anytime in your store account settings.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get reportsFreeLimit =>
      'The free plan shows this month; past months are in Pro.';

  @override
  String get householdTotal => 'Household total';

  @override
  String get myShareTotal => 'Your share';

  @override
  String get noExpensesThisMonth => 'No expenses this month.';
}

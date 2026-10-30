// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Ödeşelim';

  @override
  String get tabHome => 'Start';

  @override
  String get tabExpenses => 'Ausgaben';

  @override
  String get tabHouse => 'WG';

  @override
  String get tabAccount => 'Konto';

  @override
  String get add => 'Hinzufügen';

  @override
  String get back => 'Zurück';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get clear => 'Leeren';

  @override
  String get close => 'Schließen';

  @override
  String get copy => 'Kopieren';

  @override
  String get copied => 'Kopiert';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get next => 'Weiter';

  @override
  String get ok => 'OK';

  @override
  String get or => 'oder';

  @override
  String get remove => 'Entfernen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get save => 'Speichern';

  @override
  String get share => 'Teilen';

  @override
  String get skip => 'Überspringen';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get requiredField => 'Dieses Feld ist erforderlich';

  @override
  String get you => 'Du';

  @override
  String youSuffix(String name) {
    return '$name (du)';
  }

  @override
  String get unknownMember => 'Unbekanntes Mitglied';

  @override
  String get deletedUser => 'Gelöschter Nutzer';

  @override
  String get admin => 'Admin';

  @override
  String get errorNetwork =>
      'Gerade keine Verbindung, bitte versuch es erneut.';

  @override
  String get errorPermission => 'Dafür hast du keine Berechtigung.';

  @override
  String get errorNotFound => 'Das haben wir nicht gefunden.';

  @override
  String get errorInvalidCredentials => 'E-Mail oder Passwort ist falsch.';

  @override
  String get errorEmailInUse => 'Mit dieser E-Mail gibt es bereits ein Konto.';

  @override
  String get errorWeakPassword =>
      'Das Passwort muss mindestens 6 Zeichen haben.';

  @override
  String get errorInvalidEmail => 'Gib eine gültige E-Mail-Adresse ein.';

  @override
  String get errorTooManyRequests =>
      'Zu viele Versuche, bitte versuch es gleich noch mal.';

  @override
  String get errorCancelled => 'Abgebrochen.';

  @override
  String get errorRequiresRecentLogin =>
      'Melde dich aus Sicherheitsgründen erst ab und wieder an.';

  @override
  String get errorHouseholdLimit =>
      'Der kostenlose Plan umfasst eine WG. Mit Pro bekommst du mehr.';

  @override
  String get errorHouseholdFull => 'Diese WG ist voll (max. 12 Mitglieder).';

  @override
  String get errorInviteInvalid =>
      'Ungültiger Einladungscode. Bitte überprüfe ihn.';

  @override
  String get errorBalanceNotZero =>
      'Der Saldo ist nicht null. Rechnet zuerst ab.';

  @override
  String get errorReceiptQuota =>
      'Du hast die Belegscans für diesen Monat aufgebraucht.';

  @override
  String get errorReceiptUnreadable => 'Der Beleg konnte nicht gelesen werden.';

  @override
  String get errorReminderAlreadySent =>
      'Du hast dieser Person heute schon eine Erinnerung geschickt.';

  @override
  String get errorNothingOwed => 'Diese Person schuldet nichts.';

  @override
  String get errorUnknown =>
      'Etwas ist schiefgelaufen, bitte versuch es erneut.';

  @override
  String get welcomeTitle1 => 'Alle gemeinsamen Kosten an einem Ort';

  @override
  String get welcomeBody1 =>
      'Trag Miete, Rechnungen und Einkäufe ein, damit alle wissen, wer was bezahlt hat.';

  @override
  String get welcomeTitle2 => 'Fair bis auf den Cent';

  @override
  String get welcomeBody2 =>
      'Teile gleichmäßig, nach Betrag, Prozent oder Zimmergröße; Schulden werden auf möglichst wenige Überweisungen reduziert.';

  @override
  String get welcomeTitle3 => 'Auch der Haushalt ist hier';

  @override
  String get welcomeBody3 =>
      'Eine gemeinsame Einkaufsliste und „Wer ist dran?“ beim Putzplan. Ausgaben eintragen ist immer kostenlos und unbegrenzt.';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String pageIndicator(int current, int total) {
    return 'Seite $current von $total';
  }

  @override
  String get authSubtitle => 'Teile Kosten fair mit deinen Mitbewohnern.';

  @override
  String get signIn => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get signOut => 'Abmelden';

  @override
  String get yourName => 'Dein Name';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get forgotPassword => 'Passwort vergessen';

  @override
  String get enterEmailFirst => 'Gib zuerst deine E-Mail ein.';

  @override
  String get passwordResetSent =>
      'Ein Link zum Zurücksetzen des Passworts wurde an deine E-Mail geschickt.';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String get continueWithApple => 'Weiter mit Apple';

  @override
  String get onboardingTitle => 'Richte deine WG ein';

  @override
  String get onboardingBody =>
      'Erstelle eine neue WG oder tritt mit dem 6-stelligen Code bei, den dir dein Mitbewohner geschickt hat.';

  @override
  String get createHousehold => 'Erstellen';

  @override
  String get joinWithCode => 'Mit Code beitreten';

  @override
  String get join => 'Beitreten';

  @override
  String get householdName => 'Name der WG';

  @override
  String get householdNameHint => 'z. B. Unsere WG';

  @override
  String get currency => 'Währung';

  @override
  String get inviteCode => 'Einladungscode';

  @override
  String get inviteCodeLength => 'Der Code hat 6 Zeichen';

  @override
  String inviteCodeSemantics(String code) {
    return 'Einladungscode: $code';
  }

  @override
  String get inviteTitle => 'Deine WG ist bereit!';

  @override
  String get inviteBody =>
      'Lade deine Mitbewohner ein: Teile diesen Code, sie geben ihn unter „Mit Code beitreten“ ein.';

  @override
  String inviteShareText(String code) {
    return 'Tritt unserer WG bei Ödeşelim bei! Öffne die App, tippe auf „Mit Code beitreten“ und gib ein: $code';
  }

  @override
  String get continueToHome => 'Zur Startseite';

  @override
  String get regenerateCode => 'Neuer Code';

  @override
  String get regenerateCodeBody =>
      'Der alte Code funktioniert dann nicht mehr. Du musst den neuen erneut teilen.';

  @override
  String get addHousehold => 'Weitere WG hinzufügen';

  @override
  String get myHouseholds => 'Meine WGs';

  @override
  String get switchHousehold => 'WG wechseln';

  @override
  String get houseSettings => 'WG-Einstellungen';

  @override
  String get editHousehold => 'WG bearbeiten';

  @override
  String membersCount(int count, int max) {
    return 'Mitglieder ($count/$max)';
  }

  @override
  String get rentWeightHelp =>
      'Mietanteil: Die Miete wird nach diesen Gewichten geteilt (z. B. großes Zimmer 3, kleines Zimmer 2).';

  @override
  String rentWeightValue(int weight) {
    return 'Mietanteil: $weight';
  }

  @override
  String decreaseRentWeight(String name) {
    return 'Mietanteil von $name verringern';
  }

  @override
  String increaseRentWeight(String name) {
    return 'Mietanteil von $name erhöhen';
  }

  @override
  String get removeMember => 'Mitglied entfernen';

  @override
  String removeMemberBody(String name) {
    return '$name aus der WG entfernen?';
  }

  @override
  String get cannotRemoveTitle => 'Erst abrechnen';

  @override
  String cannotRemoveBody(String name, String amount) {
    return 'Der Saldo von $name beträgt $amount. Erst bei null kann die Person entfernt werden.';
  }

  @override
  String get leaveHousehold => 'WG verlassen';

  @override
  String get leave => 'Verlassen';

  @override
  String leaveHouseholdBody(String household) {
    return 'Willst du „$household“ wirklich verlassen?';
  }

  @override
  String get cannotLeaveTitle => 'Erst abrechnen';

  @override
  String cannotLeaveBody(String amount) {
    return 'Dein Saldo beträgt $amount. Er muss null sein, bevor du gehen kannst.';
  }

  @override
  String get inviteHousemates => 'Mitbewohner einladen';

  @override
  String get allSettled => 'Alles ausgeglichen, niemand schuldet etwas.';

  @override
  String youOweOne(String name, String amount) {
    return 'Du schuldest $name $amount';
  }

  @override
  String youOweTotal(String amount) {
    return 'Du schuldest insgesamt $amount';
  }

  @override
  String owesYouOne(String name, String amount) {
    return '$name schuldet dir $amount';
  }

  @override
  String theyOweYouTotal(String amount) {
    return 'Dir werden $amount geschuldet';
  }

  @override
  String get statusOwe => 'Du schuldest';

  @override
  String get statusOwed => 'Dir wird geschuldet';

  @override
  String get statusSettled => 'Ausgeglichen';

  @override
  String get whoOwesWhom => 'Wer schuldet wem';

  @override
  String transferLine(String from, String to) {
    return '$from → $to';
  }

  @override
  String get pay => 'Bezahlen';

  @override
  String get remind => 'Erinnern';

  @override
  String get reminderSent => 'Erinnerung gesendet.';

  @override
  String get pendingBills => 'Rechnungen ohne Betrag';

  @override
  String get enterAmount => 'Betrag eingeben';

  @override
  String get recentPayments => 'Letzte Zahlungen';

  @override
  String get disputePayment => 'Zahlung anfechten';

  @override
  String disputePaymentBody(String amount) {
    return 'Diesen Zahlungseintrag über $amount löschen? Die Salden werden aktualisiert.';
  }

  @override
  String get recentActivity => 'Letzte Aktivität';

  @override
  String get homeEmptyTitle => 'Trag deine erste Ausgabe ein';

  @override
  String get homeEmptyBody =>
      'Sobald du eine Ausgabe einträgst, siehst du hier, wer wem etwas schuldet.';

  @override
  String get recordPayment => 'Zahlung erfassen';

  @override
  String get from => 'Von';

  @override
  String get to => 'An';

  @override
  String get partialPaymentHint => 'Du kannst alles oder einen Teil bezahlen.';

  @override
  String recipientIban(String name) {
    return 'IBAN von $name';
  }

  @override
  String get copyIban => 'IBAN kopieren';

  @override
  String get ibanCopied => 'IBAN kopiert';

  @override
  String noIbanYet(String name) {
    return '$name hat noch keine IBAN hinterlegt.';
  }

  @override
  String get markAsPaid => 'Als bezahlt markieren';

  @override
  String get paymentRecorded => 'Zahlung erfasst.';

  @override
  String get samePersonError => 'Von und An dürfen nicht dieselbe Person sein';

  @override
  String get paymentMustInvolveYou =>
      'Du kannst nur Zahlungen erfassen, an denen du beteiligt bist';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get editExpense => 'Ausgabe bearbeiten';

  @override
  String get enterBillAmount => 'Rechnungsbetrag eingeben';

  @override
  String get description => 'Beschreibung';

  @override
  String get amount => 'Betrag';

  @override
  String get paidBy => 'Bezahlt von';

  @override
  String get category => 'Kategorie';

  @override
  String get date => 'Datum';

  @override
  String get split => 'Aufteilung';

  @override
  String get note => 'Notiz';

  @override
  String get noteOptional => 'Notiz (optional)';

  @override
  String get shares => 'Anteile';

  @override
  String get enterValidAmount => 'Gib einen gültigen Betrag ein';

  @override
  String get fixSplitFirst => 'Die Aufteilung geht nicht auf';

  @override
  String paidByOn(String name, String date) {
    return '$name hat bezahlt · $date';
  }

  @override
  String yourShare(String amount) {
    return 'Dein Anteil $amount';
  }

  @override
  String get pendingAmount => 'Betrag ausstehend';

  @override
  String splitTypeLabel(String type) {
    return 'Aufteilung: $type';
  }

  @override
  String get searchExpenses => 'Ausgaben durchsuchen';

  @override
  String get allCategories => 'Alle Kategorien';

  @override
  String get everyone => 'Alle';

  @override
  String get noExpensesTitle => 'Noch keine Ausgaben';

  @override
  String get noExpensesBody =>
      'Miete, Rechnungen oder Einkäufe: Trag deine erste gemeinsame Ausgabe ein.';

  @override
  String get noResultsTitle => 'Keine Ergebnisse';

  @override
  String get noResultsBody => 'Keine Ausgaben passen zu diesen Filtern.';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get deleteExpense => 'Ausgabe löschen';

  @override
  String deleteExpenseBody(String description) {
    return '„$description“ endgültig löschen?';
  }

  @override
  String get expenseNotFound => 'Ausgabe nicht gefunden';

  @override
  String get expenseNotFoundBody =>
      'Diese Ausgabe wurde möglicherweise gelöscht.';

  @override
  String get categoryRent => 'Miete';

  @override
  String get categoryElectricity => 'Strom';

  @override
  String get categoryWater => 'Wasser';

  @override
  String get categoryGas => 'Gas';

  @override
  String get categoryInternet => 'Internet';

  @override
  String get categoryGroceries => 'Lebensmittel';

  @override
  String get categoryCleaning => 'Reinigung';

  @override
  String get categoryHomeGoods => 'Haushaltswaren';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get splitEqual => 'Gleichmäßig';

  @override
  String get splitExact => 'Nach Betrag';

  @override
  String get splitPercent => 'Nach Prozent';

  @override
  String get splitShares => 'Nach Anteilen';

  @override
  String get sharesSuffix => 'Ant.';

  @override
  String get splitNoParticipants => 'Wähle mindestens eine Person aus';

  @override
  String get splitInvalidNumber => 'Eine Zahl ist ungültig';

  @override
  String splitMissing(String amount) {
    return '$amount fehlen';
  }

  @override
  String splitExcess(String amount) {
    return '$amount zu viel';
  }

  @override
  String percentTotal(String percent) {
    return 'Gesamt $percent % (muss 100 sein)';
  }

  @override
  String get scanReceipt => 'Beleg scannen';

  @override
  String get receiptAiConsentTitle => 'Belege werden per KI gelesen';

  @override
  String get receiptAiConsentBody =>
      'Um Betrag, Datum und Geschäft auszufüllen, wird das Foto des Belegs über unseren Server an einen KI-Texterkennungsdienst gesendet. Das Foto wird nur zum Lesen verwendet und nicht zum Training von Modellen. Details findest du in der Datenschutzerklärung.';

  @override
  String get receiptAiConsentAccept => 'Zustimmen und weiter';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get receiptScanning => 'Beleg wird gelesen…';

  @override
  String get receiptScanned => 'Beleg gelesen, bitte prüfe die Angaben.';

  @override
  String get receiptScanFailed =>
      'Der Beleg konnte nicht gelesen werden; das Foto ist angehängt, gib die Angaben bitte von Hand ein.';

  @override
  String get receiptTooLarge => 'Das Foto ist zu groß (max. 5 MB).';

  @override
  String get receiptAttached => 'Belegfoto angehängt';

  @override
  String receiptItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Positionen gelesen',
      one: '1 Position gelesen',
    );
    return '$_temp0';
  }

  @override
  String get removeReceipt => 'Beleg entfernen';

  @override
  String get receipt => 'Beleg';

  @override
  String get receiptItems => 'Belegpositionen';

  @override
  String get shoppingList => 'Einkauf';

  @override
  String get addShoppingItemHint =>
      'Was wird gebraucht? z. B. Milch, Waschmittel';

  @override
  String get emptyShoppingTitle => 'Die Liste ist leer';

  @override
  String get emptyShoppingBody =>
      'Trag ein, was in der WG fehlt; wer es kauft, hakt es ab und alle sehen es sofort.';

  @override
  String get addFirstItem => 'Ersten Artikel hinzufügen';

  @override
  String addedBy(String name) {
    return 'Hinzugefügt von $name';
  }

  @override
  String get boughtItems => 'Gekauft';

  @override
  String get boughtItemsHelp =>
      'Du kannst die ausgewählten Artikel als eine Lebensmittel-Ausgabe eintragen.';

  @override
  String boughtBy(String name) {
    return 'Gekauft von $name';
  }

  @override
  String get markNotBought => 'Als nicht gekauft markieren';

  @override
  String addAsExpense(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel als Ausgabe eintragen',
      one: '1 Artikel als Ausgabe eintragen',
    );
    return '$_temp0';
  }

  @override
  String get groceriesDescription => 'Lebensmittel';

  @override
  String get chores => 'Putzplan';

  @override
  String get addChore => 'Aufgabe hinzufügen';

  @override
  String get editChore => 'Aufgabe bearbeiten';

  @override
  String get deleteChore => 'Aufgabe löschen';

  @override
  String deleteChoreBody(String name) {
    return 'Die Aufgabe „$name“ löschen?';
  }

  @override
  String get choreName => 'Name der Aufgabe';

  @override
  String get choreNameHint => 'z. B. Müll rausbringen';

  @override
  String get emptyChoresTitle => 'Keine Aufgaben';

  @override
  String get emptyChoresBody =>
      'Abwasch, Müll, Putzen… Leg die Reihenfolge fest und die App erinnert, wer dran ist.';

  @override
  String whoseTurn(String name) {
    return 'Dran: $name';
  }

  @override
  String choreDueToday(String date) {
    return 'Jetzt fällig ($date)';
  }

  @override
  String choreDueOn(String date) {
    return 'Nächstes Mal: $date';
  }

  @override
  String get markDone => 'Erledigt';

  @override
  String choreDoneNext(String name) {
    return 'Super! Jetzt ist $name dran.';
  }

  @override
  String get firstDueDate => 'Erstes Fälligkeitsdatum';

  @override
  String get rotationOrder => 'Reihenfolge';

  @override
  String get rotationHelp =>
      'Tippe die Personen der Reihe nach an; das wird die Reihenfolge.';

  @override
  String get frequencyDaily => 'Täglich';

  @override
  String get frequencyWeekly => 'Wöchentlich';

  @override
  String get frequencyBiweekly => 'Alle 2 Wochen';

  @override
  String get frequencyMonthly => 'Monatlich';

  @override
  String get recurringExpenses => 'Wiederkehrend';

  @override
  String get addRecurring => 'Wiederkehrende Ausgabe hinzufügen';

  @override
  String get editRecurring => 'Wiederkehrende Ausgabe bearbeiten';

  @override
  String get deleteRecurring => 'Vorlage löschen';

  @override
  String deleteRecurringBody(String description) {
    return 'Die Vorlage „$description“ löschen? Bereits erstellte Ausgaben bleiben erhalten.';
  }

  @override
  String get emptyRecurringTitle => 'Keine wiederkehrenden Ausgaben';

  @override
  String get emptyRecurringBody =>
      'Fixkosten wie die Miete werden jeden Monat automatisch eingetragen; bei Rechnungen wirst du erinnert, den Betrag einzugeben.';

  @override
  String get recurringHint => 'z. B. Miete, Internetrechnung';

  @override
  String get fixedAmount => 'Fester Betrag';

  @override
  String get fixedAmountHelp =>
      'Die Ausgabe wird am Stichtag automatisch erstellt.';

  @override
  String get variableAmountHelp =>
      'Ein Entwurf „Betrag ausstehend“ wird erstellt und der Zahler benachrichtigt.';

  @override
  String get variableAmount => 'Variabler Betrag';

  @override
  String get variableNoExact =>
      'Die Aufteilung „Nach Betrag“ ist bei variablen Beträgen nicht verfügbar';

  @override
  String get schedule => 'Zeitplan';

  @override
  String get dayOfMonth => 'Tag im Monat';

  @override
  String get dayOfMonthHelp =>
      'In Monaten ohne diesen Tag wird der letzte Tag verwendet.';

  @override
  String get dayOfWeek => 'Wochentag';

  @override
  String nextRun(String date) {
    return 'Nächstes Mal: $date';
  }

  @override
  String recurringFreeUsage(int used, int limit) {
    return '$used/$limit Vorlagen im kostenlosen Plan genutzt.';
  }

  @override
  String get activity => 'Aktivität';

  @override
  String get noActivityTitle => 'Noch keine Aktivität';

  @override
  String get noActivityBody =>
      'Ausgaben, Zahlungen und erledigte Aufgaben erscheinen hier.';

  @override
  String activityHouseholdCreated(String actor) {
    return '$actor hat die WG erstellt';
  }

  @override
  String activityMemberJoined(String actor) {
    return '$actor ist beigetreten';
  }

  @override
  String activityMemberLeft(String actor) {
    return '$actor hat die WG verlassen';
  }

  @override
  String activityMemberRemoved(String actor, String member) {
    return '$actor hat $member entfernt';
  }

  @override
  String activityExpenseAdded(String actor, String description, String amount) {
    return '$actor hat $description hinzugefügt ($amount)';
  }

  @override
  String activityExpenseEdited(String actor, String description) {
    return '$actor hat $description bearbeitet';
  }

  @override
  String activityExpenseDeleted(
    String actor,
    String description,
    String amount,
  ) {
    return '$actor hat $description gelöscht ($amount)';
  }

  @override
  String activitySettlementAdded(String from, String to, String amount) {
    return 'Zahlung: $from → $to ($amount)';
  }

  @override
  String activitySettlementDeleted(
    String actor,
    String from,
    String to,
    String amount,
  ) {
    return '$actor hat eine Zahlung gelöscht: $from → $to ($amount)';
  }

  @override
  String activityRecurringCreated(String description, String amount) {
    return 'Wiederkehrende Ausgabe hinzugefügt: $description ($amount)';
  }

  @override
  String activityBillPending(String description) {
    return 'Rechnung $description erstellt, Betrag ausstehend';
  }

  @override
  String activityChoreDone(String actor, String chore, String next) {
    return '$actor hat $chore erledigt. Als Nächstes: $next';
  }

  @override
  String activityShoppingConverted(String actor, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$actor hat $count Einkaufsartikel als Ausgabe eingetragen',
      one: '$actor hat 1 Einkaufsartikel als Ausgabe eingetragen',
    );
    return '$_temp0';
  }

  @override
  String get activityUnknown => 'In der WG hat sich etwas geändert';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get avatar => 'Avatar';

  @override
  String get ibanOptional => 'IBAN (optional)';

  @override
  String get ibanHelp =>
      'Mitbewohner können deine IBAN mit einem Tippen kopieren, wenn sie dich bezahlen.';

  @override
  String get ibanInvalid => 'Gib eine gültige IBAN ein';

  @override
  String get preferences => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get systemDefault => 'System';

  @override
  String get notifications => 'Mitteilungen';

  @override
  String get notifyNewExpense => 'Neue Ausgaben';

  @override
  String get notifyReminders => 'Zahlungen und Erinnerungen';

  @override
  String get notifyBills => 'Rechnungen ohne Betrag';

  @override
  String get notifyChores => 'Wer im Putzplan dran ist';

  @override
  String get data => 'Daten';

  @override
  String get reports => 'Berichte';

  @override
  String get exportCsv => 'Als CSV exportieren';

  @override
  String csvSubject(String household) {
    return 'Ausgaben von $household';
  }

  @override
  String get proFeature => 'Pro-Funktion';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountBody =>
      'Dein Konto und Profil werden endgültig gelöscht und du verlässt alle WGs. Frühere Ausgaben zeigen „Gelöschter Nutzer“. Das kann nicht rückgängig gemacht werden.';

  @override
  String get goPro => 'Ödeşelim Pro holen';

  @override
  String get goProBody =>
      'Unbegrenzt WGs und Vorlagen, 200 Belegscans im Monat, vollständige Berichte.';

  @override
  String get proActive => 'Pro ist aktiv';

  @override
  String get proActiveBody => 'Alle in der WG nutzen die Pro-Funktionen.';

  @override
  String proActiveFor(String household) {
    return 'Alle in „$household“ haben Pro.';
  }

  @override
  String get proBadge => 'Pro';

  @override
  String get proTitle => 'Ödeşelim Pro';

  @override
  String get proSubtitle =>
      'Eine Person abonniert, die ganze WG profitiert. Teilt euch auch das!';

  @override
  String get proFreeForever =>
      'Ausgaben eintragen ist in jedem Plan unbegrenzt und kostenlos.';

  @override
  String get proBenefitHouseholds => 'Unbegrenzt WGs';

  @override
  String get proBenefitRecurring => 'Unbegrenzt wiederkehrende Vorlagen';

  @override
  String proBenefitReceipts(int count) {
    return '$count Belegscans im Monat';
  }

  @override
  String get proBenefitReports =>
      'Kategorieberichte und Monatsübersichten für den gesamten Verlauf';

  @override
  String get proBenefitCsv => 'CSV-Export';

  @override
  String get proBenefitShared => 'Gilt für alle in der WG';

  @override
  String get planMonthly => 'Monatlich';

  @override
  String get planAnnual => 'Jährlich';

  @override
  String trialDays(int days) {
    return '$days Tage kostenlos testen';
  }

  @override
  String savePercent(int percent) {
    return 'Spare $percent %';
  }

  @override
  String get startTrial => 'Kostenlos testen';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restoreSuccess => 'Dein Pro-Abo wurde wiederhergestellt.';

  @override
  String get restoreNothing => 'Kein Abo zum Wiederherstellen gefunden.';

  @override
  String get storeUnavailable =>
      'Gerade keine Verbindung, bitte versuch es erneut';

  @override
  String get proWelcome => 'Willkommen bei Pro! 🎉';

  @override
  String get subscriptionTerms =>
      'Abos verlängern sich automatisch, wenn sie nicht vor Ende des Zeitraums gekündigt werden. Du kannst jederzeit in den Einstellungen deines Store-Kontos kündigen.';

  @override
  String get previousMonth => 'Vorheriger Monat';

  @override
  String get nextMonth => 'Nächster Monat';

  @override
  String get reportsFreeLimit =>
      'Der kostenlose Plan zeigt diesen Monat; frühere Monate gibt es mit Pro.';

  @override
  String get householdTotal => 'Gesamt der WG';

  @override
  String get myShareTotal => 'Dein Anteil';

  @override
  String get noExpensesThisMonth => 'Keine Ausgaben in diesem Monat.';
}

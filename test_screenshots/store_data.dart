import 'package:evarkadasligi/core/money/split_calculator.dart';
import 'package:evarkadasligi/features/activity/domain/activity_event.dart';
import 'package:evarkadasligi/features/chores/domain/chore.dart';
import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/household/domain/household.dart';
import 'package:evarkadasligi/features/shopping/domain/shopping_item.dart';

/// The moment every screenshot is taken at.
final shotNow = DateTime(2026, 11, 3, 9, 41);

const me = 'a';

/// Sample household for one store language. Amounts are in major units of
/// [currency]; equal splits are divisible by three so nothing is rounded.
class StoreData {
  const StoreData({
    required this.locale,
    required this.currency,
    required this.householdName,
    required this.names,
    required this.captions,
    required this.bannerTitle,
    required this.rent,
    required this.electricity,
    required this.internet,
    required this.groceries,
    required this.cleaning,
    required this.settlement,
    required this.texts,
    required this.receiptItems,
    required this.shopping,
    required this.boughtItem,
    required this.chores,
  });

  final String locale;
  final String currency;
  final String householdName;

  /// Display names for members a (the viewer), b and c.
  final List<String> names;

  /// One headline per screenshot, in order.
  final List<String> captions;

  /// Headline of the header and search results images.
  final String bannerTitle;

  final int rent;
  final int electricity;
  final int internet;
  final int groceries;
  final int cleaning;
  final int settlement;

  /// Expense descriptions: rent, electricity, internet, groceries, cleaning, water.
  final List<String> texts;

  /// Receipt lines as (name, amount in hundredths); they add up to [groceries].
  final List<(String, int)> receiptItems;
  final List<String> shopping;
  final String boughtItem;
  final List<String> chores;

  List<Member> get members => [
    for (final (i, id) in const ['a', 'b', 'c'].indexed)
      Member(
        id: id,
        displayName: names[i],
        // Initials instead of emoji: the test renderer has no emoji font.
        avatarEmoji: names[i][0],
        rentWeight: id == 'c' ? 1 : 2,
        joinedAt: shotNow.subtract(const Duration(days: 120)),
      ),
  ];

  Household get household => Household(
    id: 'h1',
    name: householdName,
    currency: currency,
    createdBy: me,
    adminIds: const [me],
    memberIds: const ['a', 'b', 'c'],
    inviteCode: 'K7Q2MX',
    createdAt: shotNow.subtract(const Duration(days: 120)),
  );

  List<Expense> get expenses {
    Map<String, int> equal(int major) {
      final each = major * 100 ~/ 3;
      return {'a': each, 'b': each, 'c': each};
    }

    final rentShares = {'a': rent * 40, 'b': rent * 40, 'c': rent * 20};
    Expense e(
      String id,
      int textIndex,
      int major,
      String paidBy,
      ExpenseCategory category,
      Map<String, int> shares,
      int daysAgo, {
      SplitType split = SplitType.equal,
      Map<String, int> input = const {},
    }) => Expense(
      id: id,
      description: texts[textIndex],
      amountMinor: major * 100,
      paidBy: paidBy,
      date: shotNow.subtract(Duration(days: daysAgo)),
      category: category,
      splitType: split,
      splitInput: input,
      shares: shares,
      createdBy: paidBy,
      createdAt: shotNow.subtract(Duration(days: daysAgo)),
      updatedAt: shotNow.subtract(Duration(days: daysAgo)),
    );

    return [
      e(
        'e1',
        0,
        rent,
        'b',
        ExpenseCategory.rent,
        rentShares,
        2,
        split: SplitType.shares,
        input: const {'a': 2, 'b': 2, 'c': 1},
      ),
      e('e2', 1, electricity, me, ExpenseCategory.electricity, equal(electricity), 4),
      e('e3', 2, internet, 'c', ExpenseCategory.internet, equal(internet), 6),
      e('e4', 3, groceries, me, ExpenseCategory.groceries, equal(groceries), 1).copyWith(
        receiptItems: [for (final (n, a) in receiptItems) ReceiptItem(name: n, amountMinor: a)],
      ),
      e('e5', 4, cleaning, 'c', ExpenseCategory.cleaning, equal(cleaning), 9),
      Expense(
        id: 'e6',
        description: texts[5],
        amountMinor: 0,
        paidBy: me,
        date: shotNow,
        category: ExpenseCategory.water,
        status: ExpenseStatus.pendingAmount,
        createdBy: me,
        createdAt: shotNow,
        updatedAt: shotNow,
      ),
    ];
  }

  List<Settlement> get settlements => [
    Settlement(
      id: 's1',
      fromUid: 'c',
      toUid: 'b',
      amountMinor: settlement * 100,
      date: shotNow.subtract(const Duration(days: 1)),
      createdBy: 'c',
      createdAt: shotNow.subtract(const Duration(days: 1)),
    ),
  ];

  List<ShoppingItem> get shoppingItems => [
    for (final (i, name) in shopping.indexed)
      ShoppingItem(
        id: 'i$i',
        name: name,
        addedBy: const ['a', 'b', 'c'][i % 3],
        createdAt: shotNow.subtract(Duration(hours: i + 1)),
      ),
    ShoppingItem(
      id: 'done',
      name: boughtItem,
      addedBy: 'c',
      done: true,
      doneBy: 'b',
      doneAt: shotNow.subtract(const Duration(hours: 2)),
      createdAt: shotNow.subtract(const Duration(days: 1)),
    ),
  ];

  List<Chore> get choreList => [
    Chore(
      id: 'c1',
      name: chores[0],
      frequency: ChoreFrequency.daily,
      rotation: const ['a', 'b', 'c'],
      nextDueAt: shotNow,
    ),
    Chore(
      id: 'c2',
      name: chores[1],
      rotation: const ['b', 'c', 'a'],
      nextDueAt: shotNow.add(const Duration(days: 2)),
    ),
    Chore(
      id: 'c3',
      name: chores[2],
      rotation: const ['c', 'a', 'b'],
      nextDueAt: shotNow.add(const Duration(days: 4)),
    ),
  ];

  List<ActivityEvent> get activity => [
    ActivityEvent(
      id: 'v1',
      type: ActivityType.expenseAdded,
      actorUid: me,
      params: {'description': texts[3], 'amountMinor': groceries * 100},
      createdAt: shotNow.subtract(const Duration(hours: 3)),
    ),
    ActivityEvent(
      id: 'v2',
      type: ActivityType.settlementAdded,
      actorUid: 'c',
      params: {'fromUid': 'c', 'toUid': 'b', 'amountMinor': settlement * 100},
      createdAt: shotNow.subtract(const Duration(hours: 20)),
    ),
    ActivityEvent(
      id: 'v3',
      type: ActivityType.choreDone,
      actorUid: 'c',
      params: {'name': chores[0], 'nextUid': me},
      createdAt: shotNow.subtract(const Duration(hours: 22)),
    ),
  ];
}

const storeData = [
  StoreData(
    locale: 'tr',
    currency: 'TRY',
    householdName: 'Moda\'daki Ev',
    names: ['Ayşe', 'Mehmet', 'Zeynep'],
    captions: [
      'Kim kime borçlu, tek bakışta',
      'Kirayı oda büyüklüğüne göre bölüş',
      'Fişi çek, form kendiliğinden dolsun',
      'Ortak alışveriş listesi',
      'Ev işlerinde sıra kimde?',
      'Gider ekleme her zaman sınırsız',
    ],
    bannerTitle: 'Ev masraflarını adil bölüş',
    rent: 30000,
    electricity: 1470,
    internet: 600,
    groceries: 2385,
    cleaning: 645,
    settlement: 5000,
    texts: [
      'Kasım kirası',
      'Elektrik faturası',
      'İnternet',
      'Haftalık market',
      'Temizlik malzemesi',
      'Su faturası',
    ],
    receiptItems: [
      ('Süt 2 L', 14500),
      ('Beyaz peynir', 32000),
      ('Zeytin', 26000),
      ('Domates', 9500),
      ('Tavuk göğsü', 41000),
      ('Bulaşık deterjanı', 28500),
      ('Ekmek', 3000),
      ('Türk kahvesi', 84000),
    ],
    shopping: ['Süt', 'Yumurta (30\'lu)', 'Tuvalet kağıdı', 'Bulaşık deterjanı', 'Ekmek'],
    boughtItem: 'Domates',
    chores: ['Bulaşık', 'Çöpü çıkar', 'Banyo temizliği'],
  ),
  StoreData(
    locale: 'en',
    currency: 'GBP',
    householdName: 'Our Flat',
    names: ['Emma', 'Jack', 'Sophie'],
    captions: [
      'Who owes whom, at a glance',
      'Split rent by room size',
      'Snap a receipt, the form fills itself',
      'A shared shopping list',
      'Whose turn is it?',
      'Adding expenses is always unlimited',
    ],
    bannerTitle: 'Split house bills fairly',
    rent: 2400,
    electricity: 147,
    internet: 45,
    groceries: 87,
    cleaning: 36,
    settlement: 400,
    texts: [
      'November rent',
      'Electricity bill',
      'Broadband',
      'Weekly shop',
      'Cleaning supplies',
      'Water bill',
    ],
    receiptItems: [
      ('Milk 2 pints', 210),
      ('Cheddar', 450),
      ('Chicken breast', 840),
      ('Tomatoes', 190),
      ('Pasta', 240),
      ('Coffee', 670),
      ('Washing-up liquid', 400),
      ('Bread', 140),
      ('Olive oil', 980),
      ('Salmon', 1250),
      ('Fruit & veg', 1830),
      ('Wine', 1500),
    ],
    shopping: ['Milk', 'Eggs (12)', 'Toilet roll', 'Washing-up liquid', 'Bread'],
    boughtItem: 'Tomatoes',
    chores: ['Dishes', 'Take out the bins', 'Clean the bathroom'],
  ),
  StoreData(
    locale: 'de',
    currency: 'EUR',
    householdName: 'WG Kreuzberg',
    names: ['Lena', 'Jonas', 'Mia'],
    captions: [
      'Wer schuldet wem, auf einen Blick',
      'Miete nach Zimmergröße teilen',
      'Beleg fotografieren, Formular füllt sich',
      'Eine gemeinsame Einkaufsliste',
      'Wer ist heute dran?',
      'Ausgaben eintragen ist immer unbegrenzt',
    ],
    bannerTitle: 'WG-Kosten fair teilen',
    rent: 1800,
    electricity: 129,
    internet: 39,
    groceries: 96,
    cleaning: 33,
    settlement: 300,
    texts: [
      'Miete November',
      'Stromrechnung',
      'Internet',
      'Wocheneinkauf',
      'Putzmittel',
      'Wasserrechnung',
    ],
    receiptItems: [
      ('Milch 1 L', 238),
      ('Käse', 499),
      ('Hähnchenbrust', 749),
      ('Tomaten', 219),
      ('Nudeln', 178),
      ('Kaffee', 799),
      ('Spülmittel', 195),
      ('Brot', 320),
      ('Olivenöl', 899),
      ('Lachs', 999),
      ('Obst & Gemüse', 2405),
      ('Wein', 2100),
    ],
    shopping: ['Milch', 'Eier (10er)', 'Klopapier', 'Spülmittel', 'Brot'],
    boughtItem: 'Tomaten',
    chores: ['Abwasch', 'Müll rausbringen', 'Bad putzen'],
  ),
];

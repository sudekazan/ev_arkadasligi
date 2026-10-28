import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../activity/domain/activity_event.dart';
import '../../household/data/household_repository.dart';
import '../domain/expense.dart';

/// Expenses and settlements. Every change writes its activity entry in the
/// same batch, so the feed always names the actor (also for deletes).
class ExpenseRepository {
  ExpenseRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _expenses(String hid) =>
      _db.collection('households/$hid/expenses');

  CollectionReference<Map<String, dynamic>> _settlements(String hid) =>
      _db.collection('households/$hid/settlements');

  CollectionReference<Map<String, dynamic>> _activity(String hid) =>
      _db.collection('households/$hid/activity');

  Map<String, dynamic> _activityDoc(
    String type,
    String actorUid,
    String? refId,
    Map<String, Object?> params,
  ) =>
      {
        'type': type,
        'actorUid': actorUid,
        'refId': refId,
        'params': params,
        'createdAt': Timestamp.now(),
      };

  String newExpenseId(String hid) => _expenses(hid).doc().id;

  Stream<List<Expense>> watchExpenses(String hid) => _expenses(hid)
      .orderBy('date', descending: true)
      .snapshots()
      .map((q) => parseDocs(q, Expense.fromJson));

  Stream<List<Settlement>> watchSettlements(String hid) => _settlements(hid)
      .orderBy('date', descending: true)
      .snapshots()
      .map((q) => parseDocs(q, Settlement.fromJson));

  /// Creates or updates [expense]; [existing] is the stored version when editing.
  Future<void> saveExpense(
    String hid,
    Expense expense, {
    required String actorUid,
    Expense? existing,
  }) async {
    final batch = _db.batch();
    final data = expense.toJson();
    if (existing != null) {
      data['createdAt'] = Timestamp.fromDate(existing.createdAt);
      data['createdBy'] = existing.createdBy;
    }
    batch.set(_expenses(hid).doc(expense.id), data);
    final type = existing == null ? ActivityType.expenseAdded : ActivityType.expenseEdited;
    batch.set(
      _activity(hid).doc(),
      _activityDoc(type, actorUid, expense.id, {
        'description': expense.description,
        'amountMinor': expense.amountMinor,
        if (existing != null && existing.amountMinor != expense.amountMinor)
          'previousAmountMinor': existing.amountMinor,
      }),
    );
    await batch.commit();
  }

  Future<void> deleteExpense(String hid, Expense expense, {required String actorUid}) async {
    final batch = _db.batch()
      ..delete(_expenses(hid).doc(expense.id))
      ..set(
        _activity(hid).doc(),
        _activityDoc(ActivityType.expenseDeleted, actorUid, expense.id, {
          'description': expense.description,
          'amountMinor': expense.amountMinor,
        }),
      );
    await batch.commit();
  }

  Future<void> addSettlement(String hid, Settlement settlement) async {
    final ref = _settlements(hid).doc();
    final batch = _db.batch()
      ..set(ref, settlement.toJson())
      ..set(
        _activity(hid).doc(),
        _activityDoc(ActivityType.settlementAdded, settlement.createdBy, ref.id, {
          'fromUid': settlement.fromUid,
          'toUid': settlement.toUid,
          'amountMinor': settlement.amountMinor,
        }),
      );
    await batch.commit();
  }

  Future<void> deleteSettlement(
    String hid,
    Settlement settlement, {
    required String actorUid,
  }) async {
    final batch = _db.batch()
      ..delete(_settlements(hid).doc(settlement.id))
      ..set(
        _activity(hid).doc(),
        _activityDoc(ActivityType.settlementDeleted, actorUid, settlement.id, {
          'fromUid': settlement.fromUid,
          'toUid': settlement.toUid,
          'amountMinor': settlement.amountMinor,
        }),
      );
    await batch.commit();
  }
}

final expenseRepositoryProvider =
    Provider<ExpenseRepository>((ref) => ExpenseRepository(ref.watch(firestoreProvider)));

final expensesProvider = StreamProvider<List<Expense>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(expenseRepositoryProvider).watchExpenses(hid);
});

final settlementsProvider = StreamProvider<List<Settlement>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(expenseRepositoryProvider).watchSettlements(hid);
});

final expenseByIdProvider = Provider.family<Expense?, String>((ref, id) {
  final list = ref.watch(expensesProvider).value ?? const [];
  for (final e in list) {
    if (e.id == id) return e;
  }
  return null;
});

final pendingBillsProvider = Provider<List<Expense>>((ref) {
  final list = ref.watch(expensesProvider).value ?? const [];
  return list.where((e) => e.isPending).toList();
});

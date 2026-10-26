import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../activity/domain/activity_event.dart';
import '../../household/data/household_repository.dart';
import '../domain/shopping_item.dart';

class ShoppingRepository {
  ShoppingRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String hid) =>
      _db.collection('households/$hid/shoppingItems');

  Stream<List<ShoppingItem>> watch(String hid) => _col(hid)
      .orderBy('createdAt')
      .snapshots()
      .map((q) => q.docs.map((d) => ShoppingItem.fromJson(docWithId(d))).toList());

  Future<void> add(String hid, {required String name, String? quantity, required String uid}) =>
      _col(hid).add({
        'name': name,
        'quantity': quantity,
        'addedBy': uid,
        'done': false,
        'createdAt': Timestamp.now(),
      });

  Future<void> setDone(String hid, String id, {required bool done, required String uid}) =>
      _col(hid).doc(id).update({
        'done': done,
        'doneBy': done ? uid : null,
        'doneAt': done ? Timestamp.now() : null,
      });

  Future<void> delete(String hid, String id) => _col(hid).doc(id).delete();

  /// Removes items that were turned into an expense and logs it.
  Future<void> markConverted(
    String hid,
    List<String> ids, {
    required String uid,
    required String expenseId,
  }) async {
    final batch = _db.batch();
    for (final id in ids) {
      batch.delete(_col(hid).doc(id));
    }
    batch.set(_db.collection('households/$hid/activity').doc(), {
      'type': ActivityType.shoppingConverted,
      'actorUid': uid,
      'refId': expenseId,
      'params': {'count': ids.length},
      'createdAt': Timestamp.now(),
    });
    await batch.commit();
  }
}

final shoppingRepositoryProvider =
    Provider<ShoppingRepository>((ref) => ShoppingRepository(ref.watch(firestoreProvider)));

final shoppingItemsProvider = StreamProvider<List<ShoppingItem>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(shoppingRepositoryProvider).watch(hid);
});

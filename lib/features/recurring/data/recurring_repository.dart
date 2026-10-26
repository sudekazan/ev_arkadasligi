import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../household/data/household_repository.dart';
import '../domain/recurring_template.dart';

class RecurringRepository {
  RecurringRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String hid) =>
      _db.collection('households/$hid/recurring');

  Stream<List<RecurringTemplate>> watch(String hid) => _col(hid)
      .orderBy('createdAt')
      .snapshots()
      .map((q) => q.docs.map((d) => RecurringTemplate.fromJson(docWithId(d))).toList());

  String newId(String hid) => _col(hid).doc().id;

  Future<void> save(String hid, RecurringTemplate t) => _col(hid).doc(t.id).set(t.toJson());

  Future<void> setActive(String hid, String id, bool active) =>
      _col(hid).doc(id).update({'active': active});

  Future<void> delete(String hid, String id) => _col(hid).doc(id).delete();
}

final recurringRepositoryProvider =
    Provider<RecurringRepository>((ref) => RecurringRepository(ref.watch(firestoreProvider)));

final recurringTemplatesProvider = StreamProvider<List<RecurringTemplate>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(recurringRepositoryProvider).watch(hid);
});

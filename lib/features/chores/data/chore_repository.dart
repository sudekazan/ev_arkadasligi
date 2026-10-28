import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../activity/domain/activity_event.dart';
import '../../household/data/household_repository.dart';
import '../domain/chore.dart';

class ChoreRepository {
  ChoreRepository(this._db);

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String hid) =>
      _db.collection('households/$hid/chores');

  Stream<List<Chore>> watch(String hid) => _col(hid)
      .orderBy('nextDueAt')
      .snapshots()
      .map((q) => parseDocs(q, Chore.fromJson));

  Stream<List<ChoreLog>> watchLogs(String hid, String choreId) => _db
      .collection('households/$hid/choreLogs')
      .where('choreId', isEqualTo: choreId)
      .snapshots()
      .map((q) => parseDocs(q, ChoreLog.fromJson)
        ..sort((a, b) => b.doneAt.compareTo(a.doneAt)));

  Future<void> save(String hid, Chore chore) {
    final ref = chore.id.isEmpty ? _col(hid).doc() : _col(hid).doc(chore.id);
    return ref.set(chore.toJson());
  }

  Future<void> delete(String hid, String id) => _col(hid).doc(id).delete();

  /// Marks the chore done by [uid], passes the turn on and logs it.
  Future<void> complete(String hid, Chore chore, {required String uid, required DateTime now}) {
    final next = chore.completed(now);
    final batch = _db.batch()
      ..update(_col(hid).doc(chore.id), {
        'currentIndex': next.currentIndex,
        'nextDueAt': Timestamp.fromDate(next.nextDueAt),
      })
      ..set(_db.collection('households/$hid/choreLogs').doc(), {
        'choreId': chore.id,
        'doneBy': uid,
        'doneAt': Timestamp.fromDate(now),
      })
      ..set(_db.collection('households/$hid/activity').doc(), {
        'type': ActivityType.choreDone,
        'actorUid': uid,
        'refId': chore.id,
        'params': {'name': chore.name, 'nextUid': next.currentUid},
        'createdAt': Timestamp.fromDate(now),
      });
    return batch.commit();
  }
}

final choreRepositoryProvider =
    Provider<ChoreRepository>((ref) => ChoreRepository(ref.watch(firestoreProvider)));

final choresProvider = StreamProvider<List<Chore>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(choreRepositoryProvider).watch(hid);
});

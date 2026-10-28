import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firebase/converters.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../household/data/household_repository.dart';
import '../domain/activity_event.dart';

class ActivityRepository {
  ActivityRepository(this._db);

  final FirebaseFirestore _db;

  Stream<List<ActivityEvent>> watch(String hid, {int? limit}) {
    Query<Map<String, dynamic>> q = _db
        .collection('households/$hid/activity')
        .orderBy('createdAt', descending: true);
    if (limit != null) q = q.limit(limit);
    return q
        .snapshots()
        .map((s) => parseDocs(s, ActivityEvent.fromJson));
  }
}

final activityRepositoryProvider =
    Provider<ActivityRepository>((ref) => ActivityRepository(ref.watch(firestoreProvider)));

final recentActivityProvider = StreamProvider<List<ActivityEvent>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(activityRepositoryProvider).watch(hid, limit: 5);
});

final allActivityProvider = StreamProvider<List<ActivityEvent>>((ref) {
  final hid = ref.watch(currentHouseholdIdProvider);
  if (hid == null) return Stream.value(const []);
  return ref.watch(activityRepositoryProvider).watch(hid, limit: 300);
});

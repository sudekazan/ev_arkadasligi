import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import 'app_error.dart';

/// Firestore [Timestamp] ⇄ [DateTime]. A missing value (e.g. a pending server
/// timestamp in a local snapshot) reads as "now".
class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) => _read(json) ?? DateTime.now();

  @override
  Object toJson(DateTime object) => Timestamp.fromDate(object);
}

class NullableTimestampConverter implements JsonConverter<DateTime?, Object?> {
  const NullableTimestampConverter();

  @override
  DateTime? fromJson(Object? json) => _read(json);

  @override
  Object? toJson(DateTime? object) => object == null ? null : Timestamp.fromDate(object);
}

DateTime? _read(Object? json) => switch (json) {
      final Timestamp t => t.toDate(),
      final DateTime d => d,
      final String s => DateTime.tryParse(s),
      final int ms => DateTime.fromMillisecondsSinceEpoch(ms),
      _ => null,
    };

/// Document data with its id merged in, for `Model.fromJson`.
Map<String, dynamic> docWithId(DocumentSnapshot<Map<String, dynamic>> doc) =>
    {...?doc.data(), 'id': doc.id};

/// Parses every document with [fromJson], skipping (and reporting) any that
/// does not match the model, so one bad write cannot break a whole list.
List<T> parseDocs<T>(
  QuerySnapshot<Map<String, dynamic>> query,
  T Function(Map<String, dynamic> json) fromJson,
) {
  final items = <T>[];
  for (final doc in query.docs) {
    try {
      items.add(fromJson(docWithId(doc)));
    } catch (error, stack) {
      reportError(error, stack);
    }
  }
  return items;
}

import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/firebase/firebase_providers.dart';
import '../../expenses/domain/expense.dart';

/// Result of `scanReceipt`; every field may be missing.
class ScannedReceipt {
  const ScannedReceipt({
    this.merchant,
    this.date,
    this.totalMinor,
    this.category,
    this.items = const [],
  });

  factory ScannedReceipt.fromMap(Map<String, dynamic> m) => ScannedReceipt(
        merchant: m['merchant'] as String?,
        date: m['date'] is String ? DateTime.tryParse(m['date'] as String) : null,
        totalMinor: (m['totalMinor'] as num?)?.toInt(),
        category: ExpenseCategory.values.asNameMap()[m['category']],
        items: [
          for (final raw in (m['items'] as List<Object?>? ?? const []))
            if (raw is Map)
              ReceiptItem(
                name: raw['name'] as String,
                amountMinor: (raw['amountMinor'] as num).toInt(),
              ),
        ],
      );

  final String? merchant;
  final DateTime? date;
  final int? totalMinor;
  final ExpenseCategory? category;
  final List<ReceiptItem> items;
}

class ReceiptRepository {
  ReceiptRepository(this._storage, this._functions);

  final FirebaseStorage _storage;
  final FirebaseFunctions _functions;

  static const maxBytes = 5 * 1024 * 1024;

  /// Uploads the photo to `receipts/{hid}/…` and returns its storage path.
  Future<String> upload(String hid, XFile file) async {
    final bytes = await file.readAsBytes();
    if (bytes.length > maxBytes) throw const ReceiptTooLargeException();
    final id = '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1 << 32)}';
    final path = 'receipts/$hid/$id.jpg';
    await _storage.ref(path).putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return path;
  }

  Future<ScannedReceipt> scan(String hid, String path) async {
    final result = await _functions
        .httpsCallable('scanReceipt', options: HttpsCallableOptions(timeout: const Duration(seconds: 70)))
        .call<Object?>({'hid': hid, 'path': path});
    return ScannedReceipt.fromMap(Map<String, dynamic>.from(result.data as Map));
  }

  Future<String> downloadUrl(String path) => _storage.ref(path).getDownloadURL();

  Future<void> delete(String path) => _storage.ref(path).delete();
}

class ReceiptTooLargeException implements Exception {
  const ReceiptTooLargeException();
}

final receiptRepositoryProvider = Provider<ReceiptRepository>(
  (ref) => ReceiptRepository(ref.watch(storageProvider), ref.watch(functionsProvider)),
);

final receiptUrlProvider = FutureProvider.family<String, String>(
  (ref, path) => ref.watch(receiptRepositoryProvider).downloadUrl(path),
);

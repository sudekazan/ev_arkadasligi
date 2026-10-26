import 'package:evarkadasligi/features/expenses/domain/expense.dart';
import 'package:evarkadasligi/features/household/domain/household.dart';
import 'package:evarkadasligi/features/reports/data/csv_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CSV escapes cells, skips pending bills and writes dot decimals', () {
    final t = DateTime(2026, 10, 1);
    Expense e(String id, int amount, {ExpenseStatus status = ExpenseStatus.finalized}) => Expense(
          id: id,
          description: 'Market, "büyük"',
          amountMinor: amount,
          paidBy: 'a',
          date: t,
          category: ExpenseCategory.groceries,
          shares: {'a': amount ~/ 2, 'b': amount - amount ~/ 2},
          status: status,
          createdBy: 'a',
          createdAt: t,
          updatedAt: t,
        );
    final csv = expensesToCsv(
      expenses: [e('1', 12345), e('2', 500, status: ExpenseStatus.pendingAmount)],
      members: {
        'a': Member(id: 'a', displayName: 'Ayşe', joinedAt: t),
        'b': Member(id: 'b', displayName: '', joinedAt: t, deleted: true),
      },
      header: ['Tarih', 'Açıklama', 'Kategori', 'Tutar', 'Ödeyen', 'Paylar', 'Not'],
      categoryLabel: (c) => c.name,
      deletedUserLabel: 'Silinmiş kullanıcı',
    );
    final lines = csv.trim().split('\n');
    expect(lines, hasLength(2));
    expect(
      lines[1],
      '2026-10-01,"Market, ""büyük""",groceries,123.45,Ayşe,"Ayşe: 61.72; Silinmiş kullanıcı: 61.73",',
    );
  });
}

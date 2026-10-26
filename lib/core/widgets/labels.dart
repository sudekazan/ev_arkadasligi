import '../../features/chores/domain/chore.dart';
import '../../features/expenses/domain/expense.dart';
import '../../features/recurring/domain/recurring_template.dart';
import '../../l10n/app_localizations.dart';
import '../money/split_calculator.dart';

extension EnumLabels on AppLocalizations {
  String categoryName(ExpenseCategory c) => switch (c) {
        ExpenseCategory.rent => categoryRent,
        ExpenseCategory.electricity => categoryElectricity,
        ExpenseCategory.water => categoryWater,
        ExpenseCategory.gas => categoryGas,
        ExpenseCategory.internet => categoryInternet,
        ExpenseCategory.groceries => categoryGroceries,
        ExpenseCategory.cleaning => categoryCleaning,
        ExpenseCategory.homeGoods => categoryHomeGoods,
        ExpenseCategory.other => categoryOther,
      };

  String splitTypeName(SplitType t) => switch (t) {
        SplitType.equal => splitEqual,
        SplitType.exact => splitExact,
        SplitType.percent => splitPercent,
        SplitType.shares => splitShares,
      };

  String choreFrequencyName(ChoreFrequency f) => switch (f) {
        ChoreFrequency.daily => frequencyDaily,
        ChoreFrequency.weekly => frequencyWeekly,
        ChoreFrequency.biweekly => frequencyBiweekly,
      };

  String recurrenceName(RecurrenceFrequency f) => switch (f) {
        RecurrenceFrequency.monthly => frequencyMonthly,
        RecurrenceFrequency.weekly => frequencyWeekly,
      };
}

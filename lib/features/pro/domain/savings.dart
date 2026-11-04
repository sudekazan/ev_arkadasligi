/// Percent saved by paying yearly instead of 12 monthly payments.
/// Both prices are integer minor units (kuruş). Returns 0 when the yearly
/// plan is not cheaper or the monthly price is not positive.
int savingsPercent({required int monthlyMinor, required int annualMinor}) {
  final yearOfMonthly = monthlyMinor * 12;
  if (yearOfMonthly <= 0) return 0;
  final saved = yearOfMonthly - annualMinor;
  if (saved <= 0) return 0;
  return (saved * 100) ~/ yearOfMonthly;
}

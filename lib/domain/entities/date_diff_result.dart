/// Clean Domain Entity representing difference between two calendar dates
class DateDiffResult {
  final DateTime startDate;
  final DateTime endDate;
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final int workingDays;
  final int weekendDays;
  final bool isNegative;

  const DateDiffResult({
    required this.startDate,
    required this.endDate,
    required this.years,
    required this.months,
    required this.days,
    required this.totalDays,
    required this.workingDays,
    required this.weekendDays,
    this.isNegative = false,
  });
}

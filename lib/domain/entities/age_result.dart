/// Clean Domain Entity representing exact calculated age breakdown
class AgeResult {
  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  // Micro-time totals
  final int totalMonths;
  final int totalWeeks;
  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;

  final NextBirthdayInfo nextBirthday;
  final String bornDayOfWeek;

  const AgeResult({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.totalMonths,
    required this.totalWeeks,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
    required this.nextBirthday,
    required this.bornDayOfWeek,
  });
}

class NextBirthdayInfo {
  final DateTime nextDate;
  final String dayOfWeek;
  final int remainingMonths;
  final int remainingDays;
  final int remainingHours;
  final int remainingMinutes;
  final int remainingSeconds;
  final int totalDaysRemaining;
  final int totalSecondsRemaining;
  final double cycleProgress; // 0.0 to 1.0

  const NextBirthdayInfo({
    required this.nextDate,
    required this.dayOfWeek,
    required this.remainingMonths,
    required this.remainingDays,
    required this.remainingHours,
    required this.remainingMinutes,
    required this.remainingSeconds,
    required this.totalDaysRemaining,
    required this.totalSecondsRemaining,
    required this.cycleProgress,
  });
}

class FutureAgeResult {
  final int targetYear;
  final int age;
  final String dayOfWeek;
  final DateTime targetDate;

  const FutureAgeResult({
    required this.targetYear,
    required this.age,
    required this.dayOfWeek,
    required this.targetDate,
  });
}

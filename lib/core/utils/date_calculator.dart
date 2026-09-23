import 'package:intl/intl.dart';
import '../../domain/entities/age_result.dart';
import '../../domain/entities/date_diff_result.dart';

/// Accurate Date Calculation Engine handling leap years,
/// calendar month boundaries, working days, and micro-time breakdowns.
class DateCalculator {
  DateCalculator._();

  /// Calculates exact age in years, months, and days from [dob] to [targetDate] (defaults to now).
  static AgeResult calculateAge(DateTime dob, [DateTime? targetDate]) {
    final now = targetDate ?? DateTime.now();

    if (dob.isAfter(now)) {
      return AgeResult(
        years: 0,
        months: 0,
        days: 0,
        hours: 0,
        minutes: 0,
        seconds: 0,
        totalMonths: 0,
        totalWeeks: 0,
        totalDays: 0,
        totalHours: 0,
        totalMinutes: 0,
        totalSeconds: 0,
        nextBirthday: _calculateNextBirthday(dob, now),
        bornDayOfWeek: DateFormat('EEEE').format(dob),
      );
    }

    int years = now.year - dob.year;
    int months = now.month - dob.month;
    int days = now.day - dob.day;
    int hours = now.hour - dob.hour;
    int minutes = now.minute - dob.minute;
    int seconds = now.second - dob.second;

    if (seconds < 0) {
      minutes--;
      seconds += 60;
    }

    if (minutes < 0) {
      hours--;
      minutes += 60;
    }

    if (hours < 0) {
      days--;
      hours += 24;
    }

    if (days < 0) {
      months--;
      // Days in previous month of 'now'
      final prevMonth = DateTime(now.year, now.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDuration = now.difference(dob);
    final totalSeconds = totalDuration.inSeconds;
    final totalMinutes = totalDuration.inMinutes;
    final totalHours = totalDuration.inHours;
    final totalDays = totalDuration.inDays;
    final totalWeeks = (totalDays / 7).floor();
    final totalMonths = (years * 12) + months;

    final nextBdayInfo = _calculateNextBirthday(dob, now);

    return AgeResult(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      totalMonths: totalMonths,
      totalWeeks: totalWeeks,
      totalDays: totalDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
      nextBirthday: nextBdayInfo,
      bornDayOfWeek: DateFormat('EEEE').format(dob),
    );
  }

  /// Calculates details about the upcoming next birthday
  static NextBirthdayInfo _calculateNextBirthday(DateTime dob, DateTime now) {
    DateTime nextBday = DateTime(now.year, dob.month, dob.day);

    // Handle Feb 29 leap year birthday
    if (dob.month == 2 && dob.day == 29 && !isLeapYear(now.year)) {
      nextBday = DateTime(now.year, 2, 28);
    }

    // If birthday already passed this year, it's next year
    if (nextBday.isBefore(now)) {
      final nextYear = now.year + 1;
      if (dob.month == 2 && dob.day == 29 && !isLeapYear(nextYear)) {
        nextBday = DateTime(nextYear, 2, 28);
      } else {
        nextBday = DateTime(nextYear, dob.month, dob.day);
      }
    }

    // Exact countdown duration
    final diff = nextBday.difference(now);
    final totalSecondsRemaining = diff.inSeconds;

    int remainingMonths = nextBday.month - now.month;
    int remainingDays = nextBday.day - now.day;
    int remainingHours = 23 - now.hour;
    int remainingMinutes = 59 - now.minute;
    int remainingSeconds = 59 - now.second;

    if (remainingDays < 0) {
      remainingMonths--;
      final prevMonthDays = DateTime(now.year, now.month + 1, 0).day;
      remainingDays += prevMonthDays;
    }
    if (remainingMonths < 0) {
      remainingMonths += 12;
    }

    // Calculate progress through current birthday cycle (0.0 to 1.0)
    final lastBday = DateTime(nextBday.year - 1, dob.month, dob.day);
    final totalCycleDays = nextBday.difference(lastBday).inDays;
    final daysPassed = now.difference(lastBday).inDays;
    final progress = (daysPassed / (totalCycleDays > 0 ? totalCycleDays : 365))
        .clamp(0.0, 1.0);

    return NextBirthdayInfo(
      nextDate: nextBday,
      dayOfWeek: DateFormat('EEEE').format(nextBday),
      remainingMonths: remainingMonths,
      remainingDays: remainingDays,
      remainingHours: remainingHours,
      remainingMinutes: remainingMinutes,
      remainingSeconds: remainingSeconds,
      totalDaysRemaining: diff.inDays,
      totalSecondsRemaining: totalSecondsRemaining > 0 ? totalSecondsRemaining : 0,
      cycleProgress: progress,
    );
  }

  /// Calculates age and weekday for a future year (Time Travel feature)
  static FutureAgeResult calculateFutureAge(DateTime dob, int targetYear) {
    var futureBirthday = DateTime(targetYear, dob.month, dob.day);
    if (dob.month == 2 && dob.day == 29 && !isLeapYear(targetYear)) {
      futureBirthday = DateTime(targetYear, 2, 28);
    }

    final age = targetYear - dob.year;
    final dayOfWeek = DateFormat('EEEE').format(futureBirthday);

    return FutureAgeResult(
      targetYear: targetYear,
      age: age >= 0 ? age : 0,
      dayOfWeek: dayOfWeek,
      targetDate: futureBirthday,
    );
  }

  /// Calculates difference between two arbitrary dates, including working days
  static DateDiffResult calculateDateDifference(
    DateTime startDate,
    DateTime endDate, {
    bool includeEndDay = false,
  }) {
    DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

    bool isNegative = false;
    if (start.isAfter(end)) {
      final temp = start;
      start = end;
      end = temp;
      isNegative = true;
    }

    int workingDays = 0;
    int weekendDays = 0;
    int totalDays = end.difference(start).inDays + (includeEndDay ? 1 : 0);

    DateTime cur = start;
    final last = includeEndDay ? end.add(const Duration(days: 1)) : end;

    while (cur.isBefore(last)) {
      // Monday = 1, Sunday = 7
      if (cur.weekday == DateTime.saturday || cur.weekday == DateTime.sunday) {
        weekendDays++;
      } else {
        workingDays++;
      }
      cur = cur.add(const Duration(days: 1));
    }

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    if (days < 0) {
      months--;
      final prevMonthDays = DateTime(end.year, end.month, 0).day;
      days += prevMonthDays;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return DateDiffResult(
      startDate: start,
      endDate: end,
      years: years,
      months: months,
      days: days,
      totalDays: totalDays,
      workingDays: workingDays,
      weekendDays: weekendDays,
      isNegative: isNegative,
    );
  }

  /// Determines whether given year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

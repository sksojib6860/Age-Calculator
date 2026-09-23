import 'package:flutter_test/flutter_test.dart';
import 'package:age_calculator/core/utils/date_calculator.dart';

void main() {
  group('DateCalculator - Precise Age Output', () {
    test('Calculates exact age in years, months, and days', () {
      final dob = DateTime(2000, 1, 15);
      final targetDate = DateTime(2025, 4, 20);

      final result = DateCalculator.calculateAge(dob, targetDate);

      expect(result.years, equals(25));
      expect(result.months, equals(3));
      expect(result.days, equals(5));
      expect(result.bornDayOfWeek, equals('Saturday'));
    });

    test('Handles leap year birthday calculation', () {
      // Born on leap year Feb 29
      final dob = DateTime(2000, 2, 29);
      final targetDate = DateTime(2024, 2, 29);

      final result = DateCalculator.calculateAge(dob, targetDate);
      expect(result.years, equals(24));
      expect(result.months, equals(0));
      expect(result.days, equals(0));
    });

    test('Future Age / Time Travel calculation', () {
      final dob = DateTime(1995, 6, 10);
      final futureResult = DateCalculator.calculateFutureAge(dob, 2050);

      expect(futureResult.targetYear, equals(2050));
      expect(futureResult.age, equals(55));
      expect(futureResult.dayOfWeek, equals('Friday'));
    });
  });

  group('DateCalculator - Date Difference Utility', () {
    test('Calculates total days, working days, and weekend days', () {
      // Monday to Friday of the same week (5 calendar days, 5 working days, 0 weekend days)
      final start = DateTime(2024, 1, 8); // Monday
      final end = DateTime(2024, 1, 12); // Friday

      final result = DateCalculator.calculateDateDifference(start, end, includeEndDay: true);

      expect(result.totalDays, equals(5));
      expect(result.workingDays, equals(5));
      expect(result.weekendDays, equals(0));
    });

    test('Calculates working days across weekends', () {
      final start = DateTime(2024, 1, 8); // Monday
      final end = DateTime(2024, 1, 14); // Sunday

      final result = DateCalculator.calculateDateDifference(start, end, includeEndDay: true);

      expect(result.totalDays, equals(7));
      expect(result.workingDays, equals(5));
      expect(result.weekendDays, equals(2));
    });
  });
}

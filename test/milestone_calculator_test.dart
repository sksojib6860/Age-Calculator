import 'package:flutter_test/flutter_test.dart';
import 'package:age_calculator/core/utils/milestone_calculator.dart';
import 'package:age_calculator/core/utils/zodiac_helper.dart';

void main() {
  group('MilestoneCalculator & Zodiac Tests', () {
    test('Calculates heartbeats, breaths, and sleep hours', () {
      final dob = DateTime(2020, 1, 1);
      final targetDate = DateTime(2021, 1, 1); // 366 days (2020 is leap year)

      final milestones = MilestoneCalculator.calculate(dob, targetDate);

      expect(milestones.totalSleepHours, equals(366 * 8));
      expect(milestones.totalHeartbeats > BigInt.zero, isTrue);
      expect(milestones.totalBreaths > BigInt.zero, isTrue);
    });

    test('Identifies Western Zodiac signs correctly', () {
      // Leo: Jul 23 - Aug 22
      final leo = ZodiacHelper.getWesternZodiac(DateTime(1995, 8, 10));
      expect(leo.name, equals('Leo'));
      expect(leo.element, equals('Fire'));

      // Pisces: Feb 19 - Mar 20
      final pisces = ZodiacHelper.getWesternZodiac(DateTime(2000, 3, 5));
      expect(pisces.name, equals('Pisces'));
      expect(pisces.element, equals('Water'));

      // Capricorn: Dec 22 - Jan 19
      final capricorn = ZodiacHelper.getWesternZodiac(DateTime(1999, 1, 5));
      expect(capricorn.name, equals('Capricorn'));
      expect(capricorn.element, equals('Earth'));
    });

    test('Identifies Chinese Zodiac animals correctly', () {
      // 2024 is the Year of the Wood Dragon
      final dragon = ZodiacHelper.getChineseZodiac(DateTime(2024, 5, 1));
      expect(dragon.animal, equals('Dragon'));

      // 2023 is the Year of the Water Rabbit
      final rabbit = ZodiacHelper.getChineseZodiac(DateTime(2023, 2, 1));
      expect(rabbit.animal, equals('Rabbit'));
    });
  });
}

import 'package:intl/intl.dart';
import '../../domain/entities/life_milestones.dart';
import 'zodiac_helper.dart';

/// Calculates lifestyle milestones: approximate heartbeats, breaths, and sleep hours
class MilestoneCalculator {
  MilestoneCalculator._();

  static LifeMilestones calculate(DateTime dob, [DateTime? targetDate]) {
    final now = targetDate ?? DateTime.now();
    final difference = now.difference(dob);
    final days = difference.inDays > 0 ? difference.inDays : 0;
    final minutes = difference.inMinutes > 0 ? difference.inMinutes : 0;

    // Heartbeats: ~80 beats per minute
    final totalHeartbeats = BigInt.from(minutes) * BigInt.from(80);

    // Breaths: ~16 breaths per minute
    final totalBreaths = BigInt.from(minutes) * BigInt.from(16);

    // Sleep: ~8 hours per day
    final totalSleepHours = days * 8;

    final dayOfWeekBorn = DateFormat('EEEE').format(dob);
    final westernZodiac = ZodiacHelper.getWesternZodiac(dob);
    final chineseZodiac = ZodiacHelper.getChineseZodiac(dob);

    return LifeMilestones(
      totalHeartbeats: totalHeartbeats,
      totalBreaths: totalBreaths,
      totalSleepHours: totalSleepHours,
      dayOfWeekBorn: dayOfWeekBorn,
      westernZodiac: westernZodiac,
      chineseZodiac: chineseZodiac,
    );
  }
}

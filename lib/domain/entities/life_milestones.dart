/// Clean Domain Entity representing Life Milestones and astrological data
class LifeMilestones {
  final BigInt totalHeartbeats;
  final BigInt totalBreaths;
  final int totalSleepHours;
  final String dayOfWeekBorn;
  final WesternZodiac westernZodiac;
  final ChineseZodiac chineseZodiac;

  const LifeMilestones({
    required this.totalHeartbeats,
    required this.totalBreaths,
    required this.totalSleepHours,
    required this.dayOfWeekBorn,
    required this.westernZodiac,
    required this.chineseZodiac,
  });
}

class WesternZodiac {
  final String name;
  final String symbol; // Emoji or unicode
  final String element; // Fire, Earth, Air, Water
  final String dateRange;
  final String traits;

  const WesternZodiac({
    required this.name,
    required this.symbol,
    required this.element,
    required this.dateRange,
    required this.traits,
  });
}

class ChineseZodiac {
  final String animal;
  final String symbol;
  final String element; // Wood, Fire, Earth, Metal, Water
  final String traits;

  const ChineseZodiac({
    required this.animal,
    required this.symbol,
    required this.element,
    required this.traits,
  });
}

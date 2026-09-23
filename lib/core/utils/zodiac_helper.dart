import '../../domain/entities/life_milestones.dart';

/// Helper to determine Western and Chinese Zodiac information
class ZodiacHelper {
  ZodiacHelper._();

  static WesternZodiac getWesternZodiac(DateTime date) {
    final m = date.month;
    final d = date.day;

    if ((m == 3 && d >= 21) || (m == 4 && d <= 19)) {
      return const WesternZodiac(
        name: 'Aries',
        symbol: '♈',
        element: 'Fire',
        dateRange: 'Mar 21 - Apr 19',
        traits: 'Courageous, Determined, Confident, Enthusiastic',
      );
    } else if ((m == 4 && d >= 20) || (m == 5 && d <= 20)) {
      return const WesternZodiac(
        name: 'Taurus',
        symbol: '♉',
        element: 'Earth',
        dateRange: 'Apr 20 - May 20',
        traits: 'Reliable, Patient, Practical, Devoted',
      );
    } else if ((m == 5 && d >= 21) || (m == 6 && d <= 20)) {
      return const WesternZodiac(
        name: 'Gemini',
        symbol: '♊',
        element: 'Air',
        dateRange: 'May 21 - Jun 20',
        traits: 'Gentle, Affectionate, Curious, Adaptable',
      );
    } else if ((m == 6 && d >= 21) || (m == 7 && d <= 22)) {
      return const WesternZodiac(
        name: 'Cancer',
        symbol: '♋',
        element: 'Water',
        dateRange: 'Jun 21 - Jul 22',
        traits: 'Tenacious, Highly Imaginative, Loyal, Empathetic',
      );
    } else if ((m == 7 && d >= 23) || (m == 8 && d <= 22)) {
      return const WesternZodiac(
        name: 'Leo',
        symbol: '♌',
        element: 'Fire',
        dateRange: 'Jul 23 - Aug 22',
        traits: 'Creative, Passionate, Generous, Warm-hearted',
      );
    } else if ((m == 8 && d >= 23) || (m == 9 && d <= 22)) {
      return const WesternZodiac(
        name: 'Virgo',
        symbol: '♍',
        element: 'Earth',
        dateRange: 'Aug 23 - Sep 22',
        traits: 'Loyal, Analytical, Kind, Hardworking',
      );
    } else if ((m == 9 && d >= 23) || (m == 10 && d <= 22)) {
      return const WesternZodiac(
        name: 'Libra',
        symbol: '♎',
        element: 'Air',
        dateRange: 'Sep 23 - Oct 22',
        traits: 'Cooperative, Diplomatic, Gracious, Fair-minded',
      );
    } else if ((m == 10 && d >= 23) || (m == 11 && d <= 21)) {
      return const WesternZodiac(
        name: 'Scorpio',
        symbol: '♏',
        element: 'Water',
        dateRange: 'Oct 23 - Nov 21',
        traits: 'Resourceful, Powerful, Brave, Passionate',
      );
    } else if ((m == 11 && d >= 22) || (m == 12 && d <= 21)) {
      return const WesternZodiac(
        name: 'Sagittarius',
        symbol: '♐',
        element: 'Fire',
        dateRange: 'Nov 22 - Dec 21',
        traits: 'Generous, Idealistic, Great sense of humor',
      );
    } else if ((m == 12 && d >= 22) || (m == 1 && d <= 19)) {
      return const WesternZodiac(
        name: 'Capricorn',
        symbol: '♑',
        element: 'Earth',
        dateRange: 'Dec 22 - Jan 19',
        traits: 'Responsible, Disciplined, Self-control, Good managers',
      );
    } else if ((m == 1 && d >= 20) || (m == 2 && d <= 18)) {
      return const WesternZodiac(
        name: 'Aquarius',
        symbol: '♒',
        element: 'Air',
        dateRange: 'Jan 20 - Feb 18',
        traits: 'Progressive, Original, Independent, Humanitarian',
      );
    } else {
      return const WesternZodiac(
        name: 'Pisces',
        symbol: '♓',
        element: 'Water',
        dateRange: 'Feb 19 - Mar 20',
        traits: 'Compassionate, Artistic, Intuitive, Gentle, Wise',
      );
    }
  }

  static ChineseZodiac getChineseZodiac(DateTime date) {
    final animals = [
      {'name': 'Rat', 'symbol': '🐀', 'traits': 'Quick-witted, Resourceful, Versatile'},
      {'name': 'Ox', 'symbol': '🐂', 'traits': 'Diligent, Dependable, Strong, Determined'},
      {'name': 'Tiger', 'symbol': '🐅', 'traits': 'Brave, Confident, Competitive'},
      {'name': 'Rabbit', 'symbol': '🐇', 'traits': 'Quiet, Elegant, Kind, Responsible'},
      {'name': 'Dragon', 'symbol': '🐉', 'traits': 'Confident, Intelligent, Enthusiastic'},
      {'name': 'Snake', 'symbol': '🐍', 'traits': 'Enigmatic, Intelligent, Wise'},
      {'name': 'Horse', 'symbol': '🐎', 'traits': 'Animated, Active, Energetic'},
      {'name': 'Goat', 'symbol': '🐐', 'traits': 'Calm, Gentle, Sympathetic'},
      {'name': 'Monkey', 'symbol': '🐒', 'traits': 'Sharp, Smart, Curious'},
      {'name': 'Rooster', 'symbol': '🐓', 'traits': 'Observant, Hardworking, Courageous'},
      {'name': 'Dog', 'symbol': '🐕', 'traits': 'Lovely, Honest, Prudent'},
      {'name': 'Pig', 'symbol': '🐖', 'traits': 'Compassionate, Generous, Diligent'},
    ];

    final elements = ['Wood', 'Fire', 'Earth', 'Metal', 'Water'];

    final year = date.year;
    final animalIndex = (year - 4) % 12;
    final safeAnimalIndex = animalIndex >= 0 ? animalIndex : animalIndex + 12;

    final elementIndex = ((year - 4) % 10) ~/ 2;
    final safeElementIndex = elementIndex >= 0 ? elementIndex : elementIndex + 5;

    final animal = animals[safeAnimalIndex];
    final element = elements[safeElementIndex];

    return ChineseZodiac(
      animal: animal['name']!,
      symbol: animal['symbol']!,
      element: element,
      traits: animal['traits']!,
    );
  }
}

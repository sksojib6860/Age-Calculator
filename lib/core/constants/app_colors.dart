import 'package:flutter/material.dart';

/// Centralized color system with Glassmorphic styles and
/// dynamic birth-month accent support as required by the PRD.
class AppColors {
  AppColors._();

  // Dark Theme Background Gradients
  static const List<Color> darkBackgroundGradient = [
    Color(0xFF0D1117),
    Color(0xFF161B22),
    Color(0xFF1E293B),
  ];

  // Light Theme Background Gradients
  static const List<Color> lightBackgroundGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFEEF2F6),
    Color(0xFFE2E8F0),
  ];

  // Glass Surface Defaults
  static const Color glassFillDark = Color(0x1AFFFFFF); // ~10% opacity white
  static const Color glassFillLight = Color(0x73FFFFFF); // ~45% opacity white
  static const Color glassBorderDark = Color(0x33FFFFFF); // ~20% opacity white
  static const Color glassBorderLight = Color(0x80FFFFFF); // ~50% opacity white

  // Default Primary Accent
  static const Color defaultAccent = Color(0xFF6366F1); // Indigo
  static const Color defaultAccentSecondary = Color(0xFF8B5CF6); // Purple

  // Dynamic Birth Month Accent Map (PRD: Dynamic Color Engine)
  // Accent colors dynamically shift based on user's birth month
  static final Map<int, MonthThemeColor> monthAccents = {
    1: const MonthThemeColor(
      monthName: 'January',
      season: 'Winter',
      primary: Color(0xFF38BDF8), // Ice Blue
      secondary: Color(0xFF0284C7),
      glowColor: Color(0x4D38BDF8),
    ),
    2: const MonthThemeColor(
      monthName: 'February',
      season: 'Winter',
      primary: Color(0xFFA855F7), // Amethyst Violet
      secondary: Color(0xFF7E22CE),
      glowColor: Color(0x4DA855F7),
    ),
    3: const MonthThemeColor(
      monthName: 'March',
      season: 'Spring',
      primary: Color(0xFF14B8A6), // Aquamarine
      secondary: Color(0xFF0F766E),
      glowColor: Color(0x4D14B8A6),
    ),
    4: const MonthThemeColor(
      monthName: 'April',
      season: 'Spring',
      primary: Color(0xFF3B82F6), // Diamond Sky Blue
      secondary: Color(0xFF1D4ED8),
      glowColor: Color(0x4D3B82F6),
    ),
    5: const MonthThemeColor(
      monthName: 'May',
      season: 'Spring',
      primary: Color(0xFF10B981), // Emerald Green
      secondary: Color(0xFF047857),
      glowColor: Color(0x4D10B981),
    ),
    6: const MonthThemeColor(
      monthName: 'June',
      season: 'Summer',
      primary: Color(0xFFEC4899), // Pearl Rose
      secondary: Color(0xFFBE185D),
      glowColor: Color(0x4DEC4899),
    ),
    7: const MonthThemeColor(
      monthName: 'July',
      season: 'Summer',
      primary: Color(0xFFEF4444), // Ruby Coral
      secondary: Color(0xFFB91C1C),
      glowColor: Color(0x4DEF4444),
    ),
    8: const MonthThemeColor(
      monthName: 'August',
      season: 'Summer',
      primary: Color(0xFF84CC16), // Peridot Lime
      secondary: Color(0xFF4D7C0F),
      glowColor: Color(0x4D84CC16),
    ),
    9: const MonthThemeColor(
      monthName: 'September',
      season: 'Autumn',
      primary: Color(0xFF6366F1), // Royal Sapphire
      secondary: Color(0xFF4338CA),
      glowColor: Color(0x4D6366F1),
    ),
    10: const MonthThemeColor(
      monthName: 'October',
      season: 'Autumn',
      primary: Color(0xFFF43F5E), // Tourmaline Rose
      secondary: Color(0xFFBE123C),
      glowColor: Color(0x4DF43F5E),
    ),
    11: const MonthThemeColor(
      monthName: 'November',
      season: 'Autumn',
      primary: Color(0xFFF59E0B), // Topaz Amber
      secondary: Color(0xFFB45309),
      glowColor: Color(0x4DF59E0B),
    ),
    12: const MonthThemeColor(
      monthName: 'December',
      season: 'Winter',
      primary: Color(0xFF06B6D4), // Deep Turquoise
      secondary: Color(0xFF0E7490),
      glowColor: Color(0x4D06B6D4),
    ),
  };

  static MonthThemeColor getMonthAccent(int? month) {
    if (month == null || month < 1 || month > 12) {
      return const MonthThemeColor(
        monthName: 'Default',
        season: 'All Seasons',
        primary: defaultAccent,
        secondary: defaultAccentSecondary,
        glowColor: Color(0x4D6366F1),
      );
    }
    return monthAccents[month]!;
  }
}

class MonthThemeColor {
  final String monthName;
  final String season;
  final Color primary;
  final Color secondary;
  final Color glowColor;

  const MonthThemeColor({
    required this.monthName,
    required this.season,
    required this.primary,
    required this.secondary,
    required this.glowColor,
  });

  LinearGradient get gradient => LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

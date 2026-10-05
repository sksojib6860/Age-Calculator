import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Manages app theme mode (Light/Dark) with smooth micro-transitions,
/// and dynamically updates accent colors based on user's birth month.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  int? _birthMonth;

  ThemeProvider({int? initialBirthMonth})
      : _birthMonth = initialBirthMonth ?? DateTime.now().month;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  int? get birthMonth => _birthMonth;

  MonthThemeColor get currentMonthColor {
    final safeMonth = _birthMonth;
    if (safeMonth == null || safeMonth < 1 || safeMonth > 12) {
      return AppColors.getMonthAccent(null);
    }
    return AppColors.getMonthAccent(safeMonth);
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void updateBirthMonth(int? month) {
    final normalizedMonth = (month == null || month < 1 || month > 12) ? null : month;
    if (_birthMonth == normalizedMonth) return;
    _birthMonth = normalizedMonth;
    notifyListeners();
  }
}

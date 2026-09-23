import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Manages app theme mode (Light/Dark) with smooth micro-transitions,
/// and dynamically updates accent colors based on user's birth month.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  int? _birthMonth;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  int? get birthMonth => _birthMonth;

  MonthThemeColor get currentMonthColor => AppColors.getMonthAccent(_birthMonth);

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
    if (_birthMonth == month) return;
    _birthMonth = month;
    notifyListeners();
  }
}

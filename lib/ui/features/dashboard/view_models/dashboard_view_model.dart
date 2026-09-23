import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/home_widget_service.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../domain/entities/age_result.dart';
import '../../../../domain/entities/life_milestones.dart';
import '../../../../domain/use_cases/calculate_age_use_case.dart';
import '../../../../domain/use_cases/calculate_milestones_use_case.dart';

/// ViewModel for the main dashboard managing age calculation,
/// real-time 1-second ticker engine, time travel slider, and dynamic theming.
class DashboardViewModel extends ChangeNotifier {
  final CalculateAgeUseCase calculateAgeUseCase;
  final CalculateMilestonesUseCase calculateMilestonesUseCase;
  ThemeProvider? _themeProvider;

  DateTime _dob = DateTime(1998, 5, 15);
  DateTime _currentTime = DateTime.now();
  AgeResult? _ageResult;
  LifeMilestones? _milestones;

  int _futureYear = DateTime.now().year + 10;
  FutureAgeResult? _futureAgeResult;

  Timer? _tickerTimer;
  bool _isTickerActive = true;
  int _counterAnimationKey = 0; // Incremented on calculate to trigger spin effect
  String? _selectedProfileName;

  DashboardViewModel({
    CalculateAgeUseCase? ageUseCase,
    CalculateMilestonesUseCase? milestonesUseCase,
  })  : calculateAgeUseCase = ageUseCase ?? CalculateAgeUseCase(),
        calculateMilestonesUseCase =
            milestonesUseCase ?? CalculateMilestonesUseCase() {
    _initCalculations();
    _startTicker();
  }

  void updateThemeProvider(ThemeProvider themeProvider) {
    _themeProvider = themeProvider;
    _themeProvider?.updateBirthMonth(_dob.month);
  }

  DateTime get dob => _dob;
  DateTime get currentTime => _currentTime;
  AgeResult? get ageResult => _ageResult;
  LifeMilestones? get milestones => _milestones;
  int get futureYear => _futureYear;
  FutureAgeResult? get futureAgeResult => _futureAgeResult;
  bool get isTickerActive => _isTickerActive;
  int get counterAnimationKey => _counterAnimationKey;
  String? get selectedProfileName => _selectedProfileName;

  void _initCalculations() {
    _ageResult = calculateAgeUseCase.execute(_dob, _currentTime);
    _milestones = calculateMilestonesUseCase.execute(_dob, _currentTime);
    _futureAgeResult = calculateAgeUseCase.executeTimeTravel(_dob, _futureYear);
  }

  void _startTicker() {
    _tickerTimer?.cancel();
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isTickerActive) return;
      _currentTime = DateTime.now();
      _ageResult = calculateAgeUseCase.execute(_dob, _currentTime);
      notifyListeners();
    });
  }

  /// Sets DOB and recalculates everything with count-up animation trigger
  void setDob(DateTime newDob, {String? profileName}) {
    _dob = newDob;
    _selectedProfileName = profileName;
    _counterAnimationKey++;
    _currentTime = DateTime.now();
    _ageResult = calculateAgeUseCase.execute(_dob, _currentTime);
    _milestones = calculateMilestonesUseCase.execute(_dob, _currentTime);
    _futureAgeResult = calculateAgeUseCase.executeTimeTravel(_dob, _futureYear);

    // Update dynamic birth-month theme
    _themeProvider?.updateBirthMonth(_dob.month);

    // Sync with Home Screen Widget
    if (_ageResult != null) {
      HomeWidgetService.updateAgeData(
        name: profileName ?? 'Me',
        ageResult: _ageResult!,
      );
    }

    notifyListeners();
  }

  /// Manual Calculate button action (PRD: triggers Count-up/Spin Effect)
  void triggerCalculate() {
    setDob(_dob, profileName: _selectedProfileName);
  }

  /// Time Travel slider adjustment
  void setFutureYear(int year) {
    _futureYear = year;
    _futureAgeResult = calculateAgeUseCase.executeTimeTravel(_dob, year);
    notifyListeners();
  }

  void toggleTicker() {
    _isTickerActive = !_isTickerActive;
    notifyListeners();
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    super.dispose();
  }
}

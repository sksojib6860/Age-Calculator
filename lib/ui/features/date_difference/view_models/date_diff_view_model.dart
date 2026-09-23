import 'package:flutter/material.dart';
import '../../../../domain/entities/date_diff_result.dart';
import '../../../../domain/use_cases/calculate_date_diff_use_case.dart';

/// ViewModel for Date Difference Utility
class DateDiffViewModel extends ChangeNotifier {
  final CalculateDateDiffUseCase calculateDateDiffUseCase;

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _includeEndDay = true;
  DateDiffResult? _result;

  DateDiffViewModel({CalculateDateDiffUseCase? useCase})
      : calculateDateDiffUseCase = useCase ?? CalculateDateDiffUseCase() {
    _calculate();
  }

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  bool get includeEndDay => _includeEndDay;
  DateDiffResult? get result => _result;

  void setStartDate(DateTime date) {
    _startDate = date;
    _calculate();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    _calculate();
  }

  void toggleIncludeEndDay(bool value) {
    _includeEndDay = value;
    _calculate();
  }

  void _calculate() {
    _result = calculateDateDiffUseCase.execute(
      _startDate,
      _endDate,
      includeEndDay: _includeEndDay,
    );
    notifyListeners();
  }

  void swapDates() {
    final temp = _startDate;
    _startDate = _endDate;
    _endDate = temp;
    _calculate();
  }
}

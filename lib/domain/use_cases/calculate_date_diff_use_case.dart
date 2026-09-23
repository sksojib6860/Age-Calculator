import '../../core/utils/date_calculator.dart';
import '../entities/date_diff_result.dart';

class CalculateDateDiffUseCase {
  DateDiffResult execute(
    DateTime startDate,
    DateTime endDate, {
    bool includeEndDay = false,
  }) {
    return DateCalculator.calculateDateDifference(
      startDate,
      endDate,
      includeEndDay: includeEndDay,
    );
  }
}

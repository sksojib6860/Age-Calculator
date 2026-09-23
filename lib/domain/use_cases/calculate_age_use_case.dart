import '../../core/utils/date_calculator.dart';
import '../entities/age_result.dart';

class CalculateAgeUseCase {
  AgeResult execute(DateTime dob, [DateTime? targetDate]) {
    return DateCalculator.calculateAge(dob, targetDate);
  }

  FutureAgeResult executeTimeTravel(DateTime dob, int targetYear) {
    return DateCalculator.calculateFutureAge(dob, targetYear);
  }
}

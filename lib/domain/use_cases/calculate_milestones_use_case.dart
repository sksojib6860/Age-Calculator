import '../../core/utils/milestone_calculator.dart';
import '../entities/life_milestones.dart';

class CalculateMilestonesUseCase {
  LifeMilestones execute(DateTime dob, [DateTime? targetDate]) {
    return MilestoneCalculator.calculate(dob, targetDate);
  }
}

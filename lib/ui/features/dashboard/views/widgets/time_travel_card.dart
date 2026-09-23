import 'package:flutter/material.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/domain/entities/age_result.dart';

/// Time Travel & Future Age Widget
/// Allows users to slide across future years to see their age and birthday weekday.
class TimeTravelCard extends StatelessWidget {
  final int futureYear;
  final FutureAgeResult? futureAgeResult;
  final ValueChanged<int> onYearChanged;
  final MonthThemeColor monthColor;

  const TimeTravelCard({
    super.key,
    required this.futureYear,
    required this.futureAgeResult,
    required this.onYearChanged,
    required this.monthColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentYear = DateTime.now().year;
    final maxYear = currentYear + 60;

    return GlassCard(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: monthColor.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: monthColor.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Time Travel & Future Age',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Slide into the future to see your age and birthday milestone:',
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),

          // Future Age Display Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  monthColor.primary.withOpacity(isDark ? 0.25 : 0.15),
                  monthColor.secondary.withOpacity(isDark ? 0.15 : 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: monthColor.primary.withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'In Year $futureYear',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      futureAgeResult != null
                          ? 'Birthday will be on a ${futureAgeResult!.dayOfWeek}'
                          : '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: monthColor.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    futureAgeResult != null
                        ? '${futureAgeResult!.age} yrs old'
                        : '--',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Year Slider
          Row(
            children: [
              Text(
                '$currentYear',
                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: monthColor.primary,
                    thumbColor: monthColor.primary,
                    overlayColor: monthColor.primary.withOpacity(0.2),
                    valueIndicatorColor: monthColor.primary,
                    valueIndicatorTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Slider(
                    value: futureYear.clamp(currentYear, maxYear).toDouble(),
                    min: currentYear.toDouble(),
                    max: maxYear.toDouble(),
                    divisions: maxYear - currentYear,
                    label: '$futureYear',
                    onChanged: (val) {
                      onYearChanged(val.round());
                    },
                  ),
                ),
              ),
              Text(
                '$maxYear',
                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          // Quick Preset Buttons
          Wrap(
            spacing: 8,
            children: [
              _buildPresetChip(currentYear + 5, '+5 Yrs'),
              _buildPresetChip(currentYear + 10, '+10 Yrs'),
              _buildPresetChip(currentYear + 25, '+25 Yrs'),
              _buildPresetChip(2050, '2050'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(int year, String label) {
    final isSelected = futureYear == year;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: monthColor.primary.withOpacity(0.25),
      onSelected: (_) => onYearChanged(year),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? monthColor.primary : null,
      ),
    );
  }
}

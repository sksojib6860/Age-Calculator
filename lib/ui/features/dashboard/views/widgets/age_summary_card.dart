import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/widgets/animated_counter.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/domain/entities/age_result.dart';

/// Card displaying precise age in Years, Months, and Days
/// with Count-Up/Spin animations on calculate.
class AgeSummaryCard extends StatelessWidget {
  final AgeResult ageResult;
  final int animationKey;
  final MonthThemeColor monthColor;

  const AgeSummaryCard({
    super.key,
    required this.ageResult,
    required this.animationKey,
    required this.monthColor,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat('#,###');

    return GlassCard(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Icons.cake_rounded,
                      color: monthColor.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Exact Age',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: monthColor.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: monthColor.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Born on ${ageResult.bornDayOfWeek}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: monthColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Primary Units: Years, Months, Days
          Row(
            children: [
              Expanded(
                child: _buildUnitTile(
                  context,
                  label: 'YEARS',
                  value: ageResult.years,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUnitTile(
                  context,
                  label: 'MONTHS',
                  value: ageResult.months,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUnitTile(
                  context,
                  label: 'DAYS',
                  value: ageResult.days,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),

          // Secondary Micro-time Breakdown
          Text(
            'LIFETIME BREAKDOWN',
            style: AppTextStyles.labelCaps.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _buildMicroBadge(
                context,
                icon: Icons.calendar_view_month,
                label: 'Months',
                value: numberFormatter.format(ageResult.totalMonths),
              ),
              _buildMicroBadge(
                context,
                icon: Icons.date_range,
                label: 'Weeks',
                value: numberFormatter.format(ageResult.totalWeeks),
              ),
              _buildMicroBadge(
                context,
                icon: Icons.today,
                label: 'Days',
                value: numberFormatter.format(ageResult.totalDays),
              ),
              _buildMicroBadge(
                context,
                icon: Icons.access_time,
                label: 'Hours',
                value: numberFormatter.format(ageResult.totalHours),
              ),
              _buildMicroBadge(
                context,
                icon: Icons.timer_outlined,
                label: 'Minutes',
                value: numberFormatter.format(ageResult.totalMinutes),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitTile(
    BuildContext context, {
    required String label,
    required int value,
    bool highlight = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: highlight
            ? monthColor.primary.withOpacity(isDark ? 0.22 : 0.15)
            : (isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.03)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? monthColor.primary.withOpacity(0.5)
              : (isDark ? Colors.white10 : Colors.black12),
          width: highlight ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        children: [
          AnimatedCounter(
            key: ValueKey('unit_${label}_$animationKey'),
            value: value,
            style: AppTextStyles.labelNumber.copyWith(
              color: highlight ? monthColor.primary : null,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: monthColor.primary),
          const SizedBox(width: 6),
          Text(
            '$value ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

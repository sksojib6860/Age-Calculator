import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/theme/theme_provider.dart';
import 'package:age_calculator/core/widgets/custom_date_picker_field.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/core/widgets/responsive_wrapper.dart';
import 'package:age_calculator/ui/features/date_difference/view_models/date_diff_view_model.dart';

/// Date Difference Utility Screen
/// Calculates duration, working days, and weekends between two custom dates.
class DateDifferenceView extends StatelessWidget {
  const DateDifferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DateDiffViewModel>();
    final themeProvider = context.watch<ThemeProvider>();
    final monthColor = themeProvider.currentMonthColor;
    final isDark = themeProvider.isDarkMode;
    final result = viewModel.result;
    final numberFormatter = NumberFormat('#,###');

    return ResponsiveWrapper(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            GlassCard(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: monthColor.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.compare_arrows_rounded,
                      color: monthColor.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date Difference Utility',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Compute duration and business days between dates',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Date Pickers with Swap
            CustomDatePickerField(
              selectedDate: viewModel.startDate,
              onDateChanged: viewModel.setStartDate,
              label: 'START DATE',
              monthColor: monthColor,
            ),
            const SizedBox(height: 8),

            Center(
              child: IconButton.filledTonal(
                icon: const Icon(Icons.swap_vert_rounded),
                onPressed: viewModel.swapDates,
                style: IconButton.styleFrom(
                  backgroundColor: monthColor.primary.withOpacity(0.2),
                  foregroundColor: monthColor.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),

            CustomDatePickerField(
              selectedDate: viewModel.endDate,
              onDateChanged: viewModel.setEndDate,
              label: 'END DATE',
              monthColor: monthColor,
            ),
            const SizedBox(height: 16),

            // Include End Date Toggle
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Include end day (+1 day)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Switch(
                    value: viewModel.includeEndDay,
                    activeColor: monthColor.primary,
                    onChanged: viewModel.toggleIncludeEndDay,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              GlassCard(
                padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL DURATION',
                      style: AppTextStyles.labelCaps.copyWith(
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Years, Months, Days Breakdown
                    Row(
                      children: [
                        _buildDurationPill(context, '${result.years}', 'Years', monthColor.primary),
                        const SizedBox(width: 8),
                        _buildDurationPill(context, '${result.months}', 'Months', monthColor.primary),
                        const SizedBox(width: 8),
                        _buildDurationPill(context, '${result.days}', 'Days', monthColor.primary),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 16),

                    // Detailed Metric Cards (Working Days vs Weekend Days)
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            context,
                            icon: Icons.work_outline_rounded,
                            iconColor: Colors.blueAccent,
                            label: 'Working Days',
                            value: numberFormatter.format(result.workingDays),
                            subtext: 'Mon - Fri',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            context,
                            icon: Icons.weekend_outlined,
                            iconColor: Colors.amberAccent,
                            label: 'Weekend Days',
                            value: numberFormatter.format(result.weekendDays),
                            subtext: 'Sat & Sun',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildMetricTile(
                      context,
                      icon: Icons.calendar_today_rounded,
                      iconColor: monthColor.primary,
                      label: 'Total Calendar Days',
                      value: numberFormatter.format(result.totalDays),
                      subtext: '${(result.totalDays / 7).floor()} full weeks & ${result.totalDays % 7} days',
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationPill(BuildContext context, String value, String unit, Color accent) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accent.withOpacity(0.4)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: accent,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              unit,
              style: AppTextStyles.labelCaps.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subtext,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtext,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

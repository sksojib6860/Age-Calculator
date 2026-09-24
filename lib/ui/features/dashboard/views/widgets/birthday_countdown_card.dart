import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/localization/app_localizations.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/domain/entities/age_result.dart';

/// Dynamic Countdown Visual Timer showing months, days, hours, and minutes
/// until the next birthday, with an annual cycle progress bar.
class BirthdayCountdownCard extends StatelessWidget {
  final NextBirthdayInfo countdown;
  final MonthThemeColor monthColor;

  const BirthdayCountdownCard({
    super.key,
    required this.countdown,
    required this.monthColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final isBirthdayToday = countdown.totalDaysRemaining == 0;
    final formattedDate =
        (l10n.isBangla ? DateFormat.yMMMMd('bn') : DateFormat.yMMMMd()).format(
          countdown.nextDate,
        );

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
                      Icons.celebration_rounded,
                      color: monthColor.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.text('nextBirthday'),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: monthColor.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: monthColor.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  countdown.dayOfWeek,
                  style: TextStyle(
                    color: monthColor.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isBirthdayToday
                ? l10n.text('happyBirthday')
                : l10n.comingUpOn(formattedDate),
            style: AppTextStyles.bodyMedium.copyWith(
              color: isBirthdayToday
                  ? Colors.amberAccent
                  : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
              fontWeight: isBirthdayToday ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCountUnit(
                  context,
                  label: l10n.text('months').toUpperCase(),
                  value: countdown.remainingMonths.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCountUnit(
                  context,
                  label: l10n.text('days').toUpperCase(),
                  value: countdown.remainingDays.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCountUnit(
                  context,
                  label: l10n.text('hours').toUpperCase(),
                  value: countdown.remainingHours.toString(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildCountUnit(
                  context,
                  label: l10n.text('minutes').toUpperCase(),
                  value: countdown.remainingMinutes.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.text('yearCycle'),
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              Text(
                '${(countdown.cycleProgress * 100).toStringAsFixed(1)}%',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: monthColor.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: countdown.cycleProgress,
              minHeight: 8,
              backgroundColor: isDark ? Colors.white10 : Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(monthColor.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountUnit(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(
              fontSize: 9,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

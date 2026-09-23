import 'package:flutter/material.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/domain/entities/age_result.dart';

/// Real-Time Life Ticker Widget
/// Shows user's exact age ticking in real-time down to hours, minutes, and seconds.
class LiveTickerCard extends StatelessWidget {
  final AgeResult ageResult;
  final bool isTickerActive;
  final VoidCallback onToggleTicker;
  final MonthThemeColor monthColor;

  const LiveTickerCard({
    super.key,
    required this.ageResult,
    required this.isTickerActive,
    required this.onToggleTicker,
    required this.monthColor,
  });

  @override
  Widget build(BuildContext context) {
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
                  // Pulsing Live Indicator
                  _buildPulseBadge(),
                  const SizedBox(width: 10),
                  Text(
                    'Real-Time Life Ticker',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  isTickerActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: monthColor.primary,
                  size: 26,
                ),
                tooltip: isTickerActive ? 'Pause Ticker' : 'Resume Ticker',
                onPressed: onToggleTicker,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your existence ticking in live precision:',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),

          // Micro-ticker row: Hours, Minutes, Seconds
          Row(
            children: [
              Expanded(
                child: _buildTimeBox(
                  context,
                  label: 'HOURS',
                  value: ageResult.hours.toString().padLeft(2, '0'),
                ),
              ),
              const SizedBox(width: 8),
              _buildColon(),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTimeBox(
                  context,
                  label: 'MINS',
                  value: ageResult.minutes.toString().padLeft(2, '0'),
                ),
              ),
              const SizedBox(width: 8),
              _buildColon(),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTimeBox(
                  context,
                  label: 'SECS',
                  value: ageResult.seconds.toString().padLeft(2, '0'),
                  highlight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPulseBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isTickerActive
            ? Colors.green.withOpacity(0.2)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTickerActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTickerActive ? Colors.greenAccent : Colors.grey,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isTickerActive ? 'LIVE' : 'PAUSED',
            style: TextStyle(
              color: isTickerActive ? Colors.greenAccent : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColon() {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: monthColor.primary.withOpacity(0.8),
      ),
    );
  }

  Widget _buildTimeBox(
    BuildContext context, {
    required String label,
    required String value,
    bool highlight = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? monthColor.primary.withOpacity(isDark ? 0.25 : 0.15)
            : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? monthColor.primary.withOpacity(0.6) : Colors.white12,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
              color: highlight ? monthColor.primary : null,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(
              fontSize: 10,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

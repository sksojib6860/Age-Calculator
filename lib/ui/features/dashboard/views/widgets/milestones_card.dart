import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/domain/entities/life_milestones.dart';

/// Life Milestones Infographics Card
/// Illustrates fun, calculated historical stats: Heartbeats, Breaths, Sleep,
/// and both Western & Chinese Zodiac signs.
class MilestonesCard extends StatelessWidget {
  final LifeMilestones milestones;
  final MonthThemeColor monthColor;

  const MilestonesCard({
    super.key,
    required this.milestones,
    required this.monthColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final numberFormatter = NumberFormat('#,###');

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
                  Icons.auto_graph_rounded,
                  color: monthColor.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Life Milestones & Infographics',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3 Infographic Stats: Heartbeats, Breaths, Sleep
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  context,
                  icon: Icons.favorite,
                  iconColor: Colors.redAccent,
                  label: 'Heartbeats',
                  value: _formatBigInt(milestones.totalHeartbeats),
                  subText: '~80 bpm avg',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatTile(
                  context,
                  icon: Icons.air,
                  iconColor: Colors.lightBlueAccent,
                  label: 'Breaths Taken',
                  value: _formatBigInt(milestones.totalBreaths),
                  subText: '~16 bpm avg',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildSleepTile(context, numberFormatter.format(milestones.totalSleepHours)),

          const SizedBox(height: 18),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),

          // Zodiac Infographics (Western & Chinese)
          Text(
            'ASTROLOGICAL PROFILE',
            style: AppTextStyles.labelCaps.copyWith(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Western Zodiac
              Expanded(
                child: _buildZodiacCard(
                  context,
                  title: 'Western Sign',
                  symbol: milestones.westernZodiac.symbol,
                  name: milestones.westernZodiac.name,
                  badge: milestones.westernZodiac.element,
                  dateRange: milestones.westernZodiac.dateRange,
                  traits: milestones.westernZodiac.traits,
                ),
              ),
              const SizedBox(width: 12),
              // Chinese Zodiac
              Expanded(
                child: _buildZodiacCard(
                  context,
                  title: 'Chinese Sign',
                  symbol: milestones.chineseZodiac.symbol,
                  name: milestones.chineseZodiac.animal,
                  badge: milestones.chineseZodiac.element,
                  dateRange: 'Lunar cycle',
                  traits: milestones.chineseZodiac.traits,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatBigInt(BigInt number) {
    final str = number.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  Widget _buildStatTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required String subText,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subText,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTile(BuildContext context, String hoursFormatted) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigoAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bedtime, color: Colors.indigoAccent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hours Spent Sleeping',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Based on ~8 hours of healthy rest per day',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$hoursFormatted hrs',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacCard(
    BuildContext context, {
    required String title,
    required String symbol,
    required String name,
    required String badge,
    required String dateRange,
    required String traits,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelCaps.copyWith(
              fontSize: 10,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(symbol, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: monthColor.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontSize: 10,
                color: monthColor.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            traits,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

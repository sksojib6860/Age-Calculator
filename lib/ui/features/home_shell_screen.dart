import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/glass_card.dart';
import 'dashboard/view_models/dashboard_view_model.dart';
import 'dashboard/views/dashboard_screen.dart';
import 'date_difference/views/date_difference_view.dart';
import 'family_friends/views/family_friends_view.dart';

/// Main Shell hosting the dynamic glassmorphic gradient background
/// and seamless navigation between Dashboard, Date Difference, and Friends Tracker.
class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Sync the dashboard's birth month into ThemeProvider AFTER the first
    // frame. Doing this directly in build() would call notifyListeners()
    // while the framework is still building and throw:
    // "setState() or markNeedsBuild() called during build."
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<DashboardViewModel>()
          .updateThemeProvider(context.read<ThemeProvider>());
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    final monthColor = themeProvider.currentMonthColor;
    final isDark = themeProvider.isDarkMode;
    final l10n = AppLocalizations.of(context);

    final screens = [
      const DashboardScreen(),
      const DateDifferenceView(),
      FamilyFriendsView(
        onNavigateToDashboard: () {
          setState(() => _currentIndex = 0);
        },
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Dynamic Radiant Gradient Ambient Background
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E1B4B),
                          monthColor.primary.withOpacity(0.18),
                        ]
                      : [
                          const Color(0xFFF8FAFC),
                          const Color(0xFFEFF6FF),
                          monthColor.primary.withOpacity(0.12),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Radiant Ambient Glow Orbs
          Positioned(
            top: -60,
            right: -60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    monthColor.primary.withOpacity(isDark ? 0.35 : 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 120,
            left: -80,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    monthColor.secondary.withOpacity(isDark ? 0.25 : 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main View Content
          SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),

      // Floating Glassmorphic Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingSmall,
          ),
          child: GlassCard(
            borderRadius: AppDimensions.radiusLarge,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.cake_outlined,
                  activeIcon: Icons.cake_rounded,
                  label: l10n.text('calculator'),
                  monthColor: monthColor,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.date_range_outlined,
                  activeIcon: Icons.date_range_rounded,
                  label: l10n.text('difference'),
                  monthColor: monthColor,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.people_outline_rounded,
                  activeIcon: Icons.people_rounded,
                  label: l10n.text('familyFriends'),
                  monthColor: monthColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required MonthThemeColor monthColor,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? monthColor.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? monthColor.primary : Colors.grey.shade400,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: monthColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

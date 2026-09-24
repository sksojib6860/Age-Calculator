import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/localization/app_localizations.dart';
import 'package:age_calculator/core/localization/locale_provider.dart';
import 'package:age_calculator/core/theme/theme_provider.dart';
import 'package:age_calculator/core/widgets/custom_date_picker_field.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/core/widgets/responsive_wrapper.dart';
import 'package:age_calculator/ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'widgets/age_summary_card.dart';
import 'widgets/birthday_countdown_card.dart';
import 'widgets/live_ticker_card.dart';
import 'widgets/milestones_card.dart';
import 'widgets/time_travel_card.dart';

/// Single-Page Glassmorphic Dashboard
/// Seamlessly integrates input, count-up animation, real-time life ticker,
/// birthday countdown, time travel slider, and lifestyle milestones.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();
    final themeProvider = context.watch<ThemeProvider>();
    final monthColor = themeProvider.currentMonthColor;
    final isDark = themeProvider.isDarkMode;
    final localeProvider = context.watch<LocaleProvider?>();
    final l10n = AppLocalizations.of(context);

    final ageResult = viewModel.ageResult;
    final milestones = viewModel.milestones;

    return ResponsiveWrapper(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar / Glass Header
            GlassCard(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMedium,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: monthColor.gradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: monthColor.glowColor,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.hourglass_top_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.text('appTitle'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                l10n.monthAccent(
                                  monthColor.monthName,
                                  monthColor.season,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: monthColor.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<Locale>(
                        tooltip: l10n.text('language'),
                        icon: Icon(
                          Icons.language_rounded,
                          color: monthColor.primary,
                        ),
                        onSelected: localeProvider?.setLocale,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: const Locale('en'),
                            child: Text(l10n.text('english')),
                          ),
                          PopupMenuItem(
                            value: const Locale('bn'),
                            child: Text(l10n.text('bangla')),
                          ),
                        ],
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: RotationTransition(turns: anim, child: child),
                        ),
                        child: IconButton(
                          key: ValueKey(isDark),
                          icon: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: monthColor.primary,
                          ),
                          onPressed: () => themeProvider.toggleTheme(),
                          tooltip: isDark
                              ? l10n.text('switchLight')
                              : l10n.text('switchDark'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile in focus tag (if loaded from Family & Friends)
            if (viewModel.selectedProfileName != null) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: monthColor.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: monthColor.primary.withOpacity(0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_pin_circle_rounded,
                      color: monthColor.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.viewingProfile(viewModel.selectedProfileName!),
                        style: TextStyle(
                          color: monthColor.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => viewModel.setDob(DateTime(1998, 5, 15)),
                      child: const Icon(Icons.close_rounded, size: 18),
                    ),
                  ],
                ),
              ),
            ],

            // Input Section: Date of Birth Picker
            CustomDatePickerField(
              selectedDate: viewModel.dob,
              onDateChanged: (newDob) => viewModel.setDob(newDob),
              label: l10n.text('dateOfBirth'),
              subtitle: l10n.text('tapToSelect'),
              monthColor: monthColor,
              lastDate: DateTime.now(),
            ),
            const SizedBox(height: 14),

            // Calculate Button with Glowing Gradient and Spin Effect Trigger
            SizedBox(
              width: double.infinity,
              height: 54,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: monthColor.gradient,
                  boxShadow: [
                    BoxShadow(
                      color: monthColor.glowColor,
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: viewModel.triggerCalculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(
                    Icons.flash_on_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  label: Text(
                    l10n.text('calculateAge'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Age Summary Card with Count-up/Spin Effect
            if (ageResult != null) ...[
              AgeSummaryCard(
                ageResult: ageResult,
                animationKey: viewModel.counterAnimationKey,
                monthColor: monthColor,
              ),
              const SizedBox(height: 16),

              // Real-Time Life Ticker (Live running clock down to seconds)
              LiveTickerCard(
                ageResult: ageResult,
                isTickerActive: viewModel.isTickerActive,
                onToggleTicker: viewModel.toggleTicker,
                monthColor: monthColor,
              ),
              const SizedBox(height: 16),

              // Next Birthday Countdown
              BirthdayCountdownCard(
                countdown: ageResult.nextBirthday,
                monthColor: monthColor,
              ),
              const SizedBox(height: 16),

              // Time Travel & Future Age Slider
              TimeTravelCard(
                futureYear: viewModel.futureYear,
                futureAgeResult: viewModel.futureAgeResult,
                onYearChanged: viewModel.setFutureYear,
                monthColor: monthColor,
              ),
              const SizedBox(height: 16),

              // Life Milestones Infographics (Heartbeats, Breaths, Sleep, Zodiacs)
              if (milestones != null) ...[
                MilestonesCard(milestones: milestones, monthColor: monthColor),
              ],
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

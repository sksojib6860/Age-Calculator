import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/core/localization/app_localizations.dart';
import 'package:age_calculator/core/theme/theme_provider.dart';
import 'package:age_calculator/core/utils/date_calculator.dart';
import 'package:age_calculator/core/widgets/glass_card.dart';
import 'package:age_calculator/core/widgets/responsive_wrapper.dart';
import 'package:age_calculator/domain/entities/friend_profile.dart';
import 'package:age_calculator/ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:age_calculator/ui/features/family_friends/view_models/family_friends_view_model.dart';
import 'add_edit_profile_sheet.dart';

/// Screen managing Family & Friends Profiles with SQLite CRUD,
/// one-tap calculation loading, and offline birthday reminders.
class FamilyFriendsView extends StatelessWidget {
  final VoidCallback onNavigateToDashboard;

  const FamilyFriendsView({super.key, required this.onNavigateToDashboard});

  final List<Color> _avatarColors = const [
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
  ];

  void _showAddEditSheet(BuildContext context, {FriendProfile? profile}) {
    final themeProvider = context.read<ThemeProvider>();
    final familyVm = context.read<FamilyFriendsViewModel>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddEditProfileSheet(
        initialProfile: profile,
        monthColor: themeProvider.currentMonthColor,
        onSave: (savedProfile) {
          if (profile != null) {
            familyVm.updateProfile(savedProfile);
          } else {
            familyVm.addProfile(savedProfile);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FamilyFriendsViewModel>();
    final themeProvider = context.watch<ThemeProvider>();
    final dashboardVm = context.read<DashboardViewModel>();
    final monthColor = themeProvider.currentMonthColor;
    final isDark = themeProvider.isDarkMode;
    final l10n = AppLocalizations.of(context);

    final categories = [
      ('All', l10n.text('all')),
      ('Family', l10n.text('family')),
      ('Friend', l10n.text('friend')),
      ('Partner', l10n.text('partner')),
      ('Colleague', l10n.text('colleague')),
    ];

    return ResponsiveWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Glass Card
          GlassCard(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: monthColor.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group_rounded,
                        color: monthColor.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.text('familyFriendsTitle'),
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.savedProfiles(viewModel.profiles.length),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddEditSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: monthColor.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.text('add')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected =
                    (viewModel.selectedCategory == null &&
                        category.$1 == 'All') ||
                    viewModel.selectedCategory == category.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.$2),
                    selected: isSelected,
                    selectedColor: monthColor.primary.withOpacity(0.25),
                    onSelected: (_) => viewModel.filterCategory(
                      category.$1 == 'All' ? null : category.$1,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Profiles List or Empty State
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.profiles.isEmpty
                ? _buildEmptyState(context, isDark, monthColor.primary)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: viewModel.profiles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final profile = viewModel.profiles[index];
                      return _buildProfileCard(
                        context,
                        profile: profile,
                        isDark: isDark,
                        accentColor: monthColor.primary,
                        onTap: () {
                          dashboardVm.setDob(
                            profile.dob,
                            profileName: profile.name,
                          );
                          onNavigateToDashboard();
                        },
                        onEdit: () =>
                            _showAddEditSheet(context, profile: profile),
                        onDelete: () => viewModel.deleteProfile(profile.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, Color accent) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 56,
              color: accent.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.text('noProfiles'),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.text('saveBirthdays'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddEditSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.person_add),
              label: Text(l10n.text('addFirstProfile')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required FriendProfile profile,
    required bool isDark,
    required Color accentColor,
    required VoidCallback onTap,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final avatarColor =
        _avatarColors[profile.avatarColorIndex % _avatarColors.length];
    final ageResult = DateCalculator.calculateAge(profile.dob);
    final daysToBday = ageResult.nextBirthday.totalDaysRemaining;
    final l10n = AppLocalizations.of(context);

    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Initials Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: avatarColor.withOpacity(0.25),
            child: Text(
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
              style: TextStyle(
                color: avatarColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        profile.relationship,
                        style: TextStyle(
                          fontSize: 10,
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  (l10n.isBangla
                          ? DateFormat.yMMMMd('bn')
                          : DateFormat.yMMMMd())
                      .format(profile.dob),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: [
                    // Age Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${ageResult.years}y ${ageResult.months}m old',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Birthday countdown chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: daysToBday == 0
                            ? Colors.amber.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        daysToBday == 0
                            ? '🎂 Birthday Today!'
                            : '🎂 in $daysToBday days',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: daysToBday == 0
                              ? Colors.amberAccent
                              : Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (val) {
              if (val == 'calc') onTap();
              if (val == 'edit') onEdit();
              if (val == 'delete') onDelete();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'calc',
                child: Row(
                  children: [
                    Icon(Icons.calculate_outlined, size: 18),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context).text('openCalculator')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context).text('edit')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).text('delete'),
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

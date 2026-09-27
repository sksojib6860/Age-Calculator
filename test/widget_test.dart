import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:age_calculator/core/theme/theme_provider.dart';
import 'package:age_calculator/domain/use_cases/calculate_age_use_case.dart';
import 'package:age_calculator/domain/use_cases/calculate_milestones_use_case.dart';
import 'package:age_calculator/domain/use_cases/calculate_date_diff_use_case.dart';
import 'package:age_calculator/domain/use_cases/profile_use_cases.dart';
import 'package:age_calculator/domain/repositories/profile_repository.dart';
import 'package:age_calculator/domain/entities/friend_profile.dart';
import 'package:age_calculator/ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:age_calculator/ui/features/date_difference/view_models/date_diff_view_model.dart';
import 'package:age_calculator/ui/features/family_friends/view_models/family_friends_view_model.dart';
import 'package:age_calculator/ui/features/home_shell_screen.dart';

class MockProfileRepository implements ProfileRepository {
  final List<FriendProfile> _profiles = [];

  @override
  Future<List<FriendProfile>> getAllProfiles() async => _profiles;

  @override
  Future<FriendProfile?> getProfileById(String id) async =>
      _profiles.cast<FriendProfile?>().firstWhere((p) => p?.id == id, orElse: () => null);

  @override
  Future<void> insertProfile(FriendProfile profile) async => _profiles.add(profile);

  @override
  Future<void> updateProfile(FriendProfile profile) async {
    final idx = _profiles.indexWhere((p) => p.id == profile.id);
    if (idx != -1) _profiles[idx] = profile;
  }

  @override
  Future<void> deleteProfile(String id) async =>
      _profiles.removeWhere((p) => p.id == id);
}

void main() {
  testWidgets('App renders HomeShellScreen and displays Exact Age', (WidgetTester tester) async {
    final mockRepo = MockProfileRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider<DashboardViewModel>(
            create: (_) => DashboardViewModel(
              ageUseCase: CalculateAgeUseCase(),
              milestonesUseCase: CalculateMilestonesUseCase(),
            ),
          ),
          ChangeNotifierProvider<DateDiffViewModel>(
            create: (_) => DateDiffViewModel(
              useCase: CalculateDateDiffUseCase(),
            ),
          ),
          ChangeNotifierProvider<FamilyFriendsViewModel>(
            create: (_) => FamilyFriendsViewModel(
              getProfilesUseCase: GetProfilesUseCase(mockRepo),
              saveProfileUseCase: SaveProfileUseCase(mockRepo),
              deleteProfileUseCase: DeleteProfileUseCase(mockRepo),
            ),
          ),
        ],
        child: const MaterialApp(
          home: HomeShellScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify key titles and elements exist
    expect(find.text('Age Calculator'), findsOneWidget);
    expect(find.text('Exact Age'), findsOneWidget);
    expect(find.text('Calculate Age'), findsOneWidget);
    expect(find.text('Real-Time Life Ticker'), findsOneWidget);
    expect(find.text('Next Birthday Countdown'), findsOneWidget);
    expect(find.text('Time Travel & Future Age'), findsOneWidget);
  });

  testWidgets('Syncs dashboard birth month into ThemeProvider after first frame',
      (WidgetTester tester) async {
    final mockRepo = MockProfileRepository();
    final themeProvider = ThemeProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
          ChangeNotifierProvider<DashboardViewModel>(
            create: (_) => DashboardViewModel(
              ageUseCase: CalculateAgeUseCase(),
              milestonesUseCase: CalculateMilestonesUseCase(),
            ),
          ),
          ChangeNotifierProvider<DateDiffViewModel>(
            create: (_) => DateDiffViewModel(
              useCase: CalculateDateDiffUseCase(),
            ),
          ),
          ChangeNotifierProvider<FamilyFriendsViewModel>(
            create: (_) => FamilyFriendsViewModel(
              getProfilesUseCase: GetProfilesUseCase(mockRepo),
              saveProfileUseCase: SaveProfileUseCase(mockRepo),
              deleteProfileUseCase: DeleteProfileUseCase(mockRepo),
            ),
          ),
        ],
        child: const MaterialApp(
          home: HomeShellScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Must not throw "setState() or markNeedsBuild() called during build".
    expect(tester.takeException(), isNull);

    // Default DOB is 1998-05-15, so the May accent must be applied.
    expect(themeProvider.birthMonth, 5);
    expect(themeProvider.currentMonthColor.monthName, 'May');
  });
}

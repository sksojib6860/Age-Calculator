import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'data/datasources/local/profile_dao.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/use_cases/calculate_age_use_case.dart';
import 'domain/use_cases/calculate_date_diff_use_case.dart';
import 'domain/use_cases/calculate_milestones_use_case.dart';
import 'domain/use_cases/profile_use_cases.dart';
import 'ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'ui/features/date_difference/view_models/date_diff_view_model.dart';
import 'ui/features/family_friends/view_models/family_friends_view_model.dart';
import 'ui/features/home_shell_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bn');

  // Transparent system navigation bar and status bar for immersive glassmorphism
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize offline notifications
  final notificationService = NotificationService.instance;
  await notificationService.init();
  await notificationService.requestPermissions();

  // Setup Repositories and Use Cases
  final profileDao = ProfileDao();
  final ProfileRepository profileRepository = ProfileRepositoryImpl(
    profileDao: profileDao,
  );

  final calculateAgeUseCase = CalculateAgeUseCase();
  final calculateMilestonesUseCase = CalculateMilestonesUseCase();
  final calculateDateDiffUseCase = CalculateDateDiffUseCase();

  final getProfilesUseCase = GetProfilesUseCase(profileRepository);
  final saveProfileUseCase = SaveProfileUseCase(profileRepository);
  final deleteProfileUseCase = DeleteProfileUseCase(profileRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<DashboardViewModel>(
          create: (_) => DashboardViewModel(
            ageUseCase: calculateAgeUseCase,
            milestonesUseCase: calculateMilestonesUseCase,
          ),
        ),
        ChangeNotifierProvider<DateDiffViewModel>(
          create: (_) => DateDiffViewModel(useCase: calculateDateDiffUseCase),
        ),
        ChangeNotifierProvider<FamilyFriendsViewModel>(
          create: (_) => FamilyFriendsViewModel(
            getProfilesUseCase: getProfilesUseCase,
            saveProfileUseCase: saveProfileUseCase,
            deleteProfileUseCase: deleteProfileUseCase,
            notifications: notificationService,
          ),
        ),
      ],
      child: const AgeCalculatorApp(),
    ),
  );
}

class AgeCalculatorApp extends StatelessWidget {
  const AgeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final currentMonthColor = themeProvider.currentMonthColor;

    return MaterialApp(
      title: 'Age Calculator',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('bn')],
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme(accentColor: currentMonthColor.primary),
      darkTheme: AppTheme.darkTheme(accentColor: currentMonthColor.primary),
      home: const HomeShellScreen(),
    );
  }
}

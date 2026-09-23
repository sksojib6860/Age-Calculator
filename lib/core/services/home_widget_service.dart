import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import '../../domain/entities/age_result.dart';

/// Service managing synchronization with Android and iOS Home Screen Widgets
class HomeWidgetService {
  HomeWidgetService._();

  static const String appGroupId = 'group.com.example.age_calculator';
  static const String androidWidgetName = 'AgeCountdownWidget';

  static Future<void> updateAgeData({
    required String name,
    required AgeResult ageResult,
  }) async {
    if (kIsWeb) return;
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      await HomeWidget.setAppGroupId(appGroupId);

      await HomeWidget.saveWidgetData<String>('user_name', name);
      await HomeWidget.saveWidgetData<int>('age_years', ageResult.years);
      await HomeWidget.saveWidgetData<int>('age_months', ageResult.months);
      await HomeWidget.saveWidgetData<int>('age_days', ageResult.days);
      await HomeWidget.saveWidgetData<int>(
        'days_until_bday',
        ageResult.nextBirthday.totalDaysRemaining,
      );

      await HomeWidget.updateWidget(
        androidName: androidWidgetName,
        iOSName: 'AgeCountdownWidget',
      );
    } catch (e) {
      debugPrint('HomeWidget sync error: $e');
    }
  }
}

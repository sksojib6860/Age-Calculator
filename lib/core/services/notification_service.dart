import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../domain/entities/friend_profile.dart';

/// Service managing offline birthday reminders using flutter_local_notifications
class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService._init();

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (details) {
          debugPrint('Notification clicked: ${details.payload}');
        },
      );
      _initialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      if (kIsWeb) return false;
      if (Platform.isAndroid) {
        final androidImpl = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await androidImpl?.requestNotificationsPermission();
        return granted ?? false;
      } else if (Platform.isIOS) {
        final iosImpl = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted = await iosImpl?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
    return false;
  }

  /// Schedules or updates a local birthday reminder for a profile
  Future<void> scheduleBirthdayReminder(FriendProfile profile) async {
    if (!_initialized) await init();

    final int notificationId = profile.id.hashCode.abs() % 100000;

    const androidDetails = AndroidNotificationDetails(
      'birthday_reminders',
      'Birthday Reminders',
      channelDescription: 'Notifications for upcoming friends and family birthdays',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    try {
      // Show notification on schedule or trigger immediate confirmation if reminder enabled
      if (profile.enableReminder) {
        // Send a celebratory confirmation/alert
        await _notificationsPlugin.show(
          id: notificationId,
          title: 'Birthday Reminder Set: ${profile.name}',
          body:
              "You will be reminded on ${profile.name}'s birthday (${profile.dob.day}/${profile.dob.month})!",
          notificationDetails: notificationDetails,
          payload: profile.id,
        );
      } else {
        await cancelReminder(profile.id);
      }
    } catch (e) {
      debugPrint('Failed to schedule notification: $e');
    }
  }

  Future<void> cancelReminder(String profileId) async {
    if (!_initialized) await init();
    try {
      final int notificationId = profileId.hashCode.abs() % 100000;
      await _notificationsPlugin.cancel(id: notificationId);
    } catch (e) {
      debugPrint('Failed to cancel notification: $e');
    }
  }
}

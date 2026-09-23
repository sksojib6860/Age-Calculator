import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../domain/entities/friend_profile.dart';
import '../../../../domain/use_cases/profile_use_cases.dart';

/// ViewModel managing Family & Friends local storage and notifications
class FamilyFriendsViewModel extends ChangeNotifier {
  final GetProfilesUseCase getProfilesUseCase;
  final SaveProfileUseCase saveProfileUseCase;
  final DeleteProfileUseCase deleteProfileUseCase;
  final NotificationService notificationService;

  List<FriendProfile> _allProfiles = [];
  String? _selectedCategory;
  bool _isLoading = false;

  FamilyFriendsViewModel({
    required this.getProfilesUseCase,
    required this.saveProfileUseCase,
    required this.deleteProfileUseCase,
    NotificationService? notifications,
  }) : notificationService = notifications ?? NotificationService.instance {
    loadProfiles();
  }

  List<FriendProfile> get profiles {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _allProfiles;
    }
    return _allProfiles
        .where((p) => p.relationship == _selectedCategory)
        .toList();
  }

  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  Future<void> loadProfiles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allProfiles = await getProfilesUseCase.execute();
    } catch (e) {
      debugPrint('Error loading profiles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProfile(FriendProfile profile) async {
    await saveProfileUseCase.execute(profile, isUpdate: false);
    if (profile.enableReminder) {
      await notificationService.scheduleBirthdayReminder(profile);
    }
    await loadProfiles();
  }

  Future<void> updateProfile(FriendProfile profile) async {
    await saveProfileUseCase.execute(profile, isUpdate: true);
    if (profile.enableReminder) {
      await notificationService.scheduleBirthdayReminder(profile);
    } else {
      await notificationService.cancelReminder(profile.id);
    }
    await loadProfiles();
  }

  Future<void> deleteProfile(String id) async {
    await deleteProfileUseCase.execute(id);
    await notificationService.cancelReminder(id);
    await loadProfiles();
  }
}

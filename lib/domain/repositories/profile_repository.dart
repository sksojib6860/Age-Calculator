import '../entities/friend_profile.dart';

/// Abstract contract for local profile storage
abstract class ProfileRepository {
  Future<List<FriendProfile>> getAllProfiles();
  Future<FriendProfile?> getProfileById(String id);
  Future<void> insertProfile(FriendProfile profile);
  Future<void> updateProfile(FriendProfile profile);
  Future<void> deleteProfile(String id);
}

import '../entities/friend_profile.dart';
import '../repositories/profile_repository.dart';

class GetProfilesUseCase {
  final ProfileRepository repository;
  GetProfilesUseCase(this.repository);

  Future<List<FriendProfile>> execute() {
    return repository.getAllProfiles();
  }
}

class SaveProfileUseCase {
  final ProfileRepository repository;
  SaveProfileUseCase(this.repository);

  Future<void> execute(FriendProfile profile, {bool isUpdate = false}) {
    if (isUpdate) {
      return repository.updateProfile(profile);
    } else {
      return repository.insertProfile(profile);
    }
  }
}

class DeleteProfileUseCase {
  final ProfileRepository repository;
  DeleteProfileUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteProfile(id);
  }
}

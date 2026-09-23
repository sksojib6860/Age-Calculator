import '../../domain/entities/friend_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local/profile_dao.dart';
import '../models/profile_model.dart';

/// Concrete implementation of ProfileRepository using SQLite ProfileDao
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDao dao;

  ProfileRepositoryImpl({ProfileDao? profileDao}) : dao = profileDao ?? ProfileDao();

  @override
  Future<List<FriendProfile>> getAllProfiles() async {
    final models = await dao.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<FriendProfile?> getProfileById(String id) async {
    final model = await dao.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> insertProfile(FriendProfile profile) async {
    await dao.insert(ProfileModel.fromEntity(profile));
  }

  @override
  Future<void> updateProfile(FriendProfile profile) async {
    await dao.update(ProfileModel.fromEntity(profile));
  }

  @override
  Future<void> deleteProfile(String id) async {
    await dao.delete(id);
  }
}

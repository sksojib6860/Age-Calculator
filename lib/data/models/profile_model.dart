import '../../domain/entities/friend_profile.dart';

/// SQLite DTO Model for FriendProfile
class ProfileModel {
  final String id;
  final String name;
  final String dob; // ISO-8601 format
  final String relationship;
  final int avatarColorIndex;
  final String? notes;
  final int enableReminder; // 1 for true, 0 for false

  ProfileModel({
    required this.id,
    required this.name,
    required this.dob,
    required this.relationship,
    required this.avatarColorIndex,
    this.notes,
    required this.enableReminder,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'relationship': relationship,
      'avatar_color_index': avatarColorIndex,
      'notes': notes,
      'enable_reminder': enableReminder,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dob: map['dob'] as String,
      relationship: (map['relationship'] as String?) ?? 'Friend',
      avatarColorIndex: (map['avatar_color_index'] as int?) ?? 0,
      notes: map['notes'] as String?,
      enableReminder: (map['enable_reminder'] as int?) ?? 1,
    );
  }

  FriendProfile toEntity() {
    return FriendProfile(
      id: id,
      name: name,
      dob: DateTime.parse(dob),
      relationship: relationship,
      avatarColorIndex: avatarColorIndex,
      notes: notes,
      enableReminder: enableReminder == 1,
    );
  }

  factory ProfileModel.fromEntity(FriendProfile entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      dob: entity.dob.toIso8601String(),
      relationship: entity.relationship,
      avatarColorIndex: entity.avatarColorIndex,
      notes: entity.notes,
      enableReminder: entity.enableReminder ? 1 : 0,
    );
  }
}

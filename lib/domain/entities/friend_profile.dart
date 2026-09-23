/// Clean Domain Entity representing a saved profile in the Family & Friends tracker
class FriendProfile {
  final String id;
  final String name;
  final DateTime dob;
  final String relationship;
  final int avatarColorIndex;
  final String? notes;
  final bool enableReminder;

  const FriendProfile({
    required this.id,
    required this.name,
    required this.dob,
    this.relationship = 'Friend',
    this.avatarColorIndex = 0,
    this.notes,
    this.enableReminder = true,
  });

  FriendProfile copyWith({
    String? id,
    String? name,
    DateTime? dob,
    String? relationship,
    int? avatarColorIndex,
    String? notes,
    bool? enableReminder,
  }) {
    return FriendProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      relationship: relationship ?? this.relationship,
      avatarColorIndex: avatarColorIndex ?? this.avatarColorIndex,
      notes: notes ?? this.notes,
      enableReminder: enableReminder ?? this.enableReminder,
    );
  }
}

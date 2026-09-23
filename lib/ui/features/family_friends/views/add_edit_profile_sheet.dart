import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:age_calculator/core/constants/app_colors.dart';
import 'package:age_calculator/core/constants/app_dimensions.dart';
import 'package:age_calculator/core/constants/app_text_styles.dart';
import 'package:age_calculator/domain/entities/friend_profile.dart';

class AddEditProfileSheet extends StatefulWidget {
  final FriendProfile? initialProfile;
  final MonthThemeColor monthColor;
  final Function(FriendProfile) onSave;

  const AddEditProfileSheet({
    super.key,
    this.initialProfile,
    required this.monthColor,
    required this.onSave,
  });

  @override
  State<AddEditProfileSheet> createState() => _AddEditProfileSheetState();
}

class _AddEditProfileSheetState extends State<AddEditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late DateTime _selectedDob;
  late String _relationship;
  late int _avatarColorIndex;
  late bool _enableReminder;

  final List<Color> _avatarColors = [
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.indigoAccent,
  ];

  final List<String> _relationships = [
    'Family',
    'Friend',
    'Partner',
    'Colleague',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final profile = widget.initialProfile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _notesController = TextEditingController(text: profile?.notes ?? '');
    _selectedDob = profile?.dob ?? DateTime(2000, 1, 1);
    _relationship = profile?.relationship ?? 'Friend';
    _avatarColorIndex = profile?.avatarColorIndex ?? 0;
    _enableReminder = profile?.enableReminder ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: widget.monthColor.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDob = picked);
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    final profile = FriendProfile(
      id: widget.initialProfile?.id ?? const Uuid().v4(),
      name: name,
      dob: _selectedDob,
      relationship: _relationship,
      avatarColorIndex: _avatarColorIndex,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      enableReminder: _enableReminder,
    );

    widget.onSave(profile);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.initialProfile != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEditing ? 'Edit Profile' : 'Add Family or Friend',
                style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // DOB Picker
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _pickDob,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cake_outlined, color: widget.monthColor.primary),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat.yMMMMd().format(_selectedDob),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        'Change',
                        style: TextStyle(
                          color: widget.monthColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Relationship Chips
              Text(
                'RELATIONSHIP',
                style: AppTextStyles.labelCaps.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _relationships.map((rel) {
                  final isSelected = _relationship == rel;
                  return ChoiceChip(
                    label: Text(rel),
                    selected: isSelected,
                    selectedColor: widget.monthColor.primary.withOpacity(0.25),
                    onSelected: (_) => setState(() => _relationship = rel),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Avatar Color Choice
              Text(
                'AVATAR ACCENT',
                style: AppTextStyles.labelCaps.copyWith(
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(_avatarColors.length, (idx) {
                  final color = _avatarColors[idx];
                  final isSelected = _avatarColorIndex == idx;
                  return GestureDetector(
                    onTap: () => setState(() => _avatarColorIndex = idx),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 8)]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),

              // Birthday Reminder Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Offline Birthday Reminder'),
                subtitle: const Text('Send notification when birthday arrives'),
                value: _enableReminder,
                activeColor: widget.monthColor.primary,
                onChanged: (val) => setState(() => _enableReminder = val),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.monthColor.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Save Changes' : 'Add Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

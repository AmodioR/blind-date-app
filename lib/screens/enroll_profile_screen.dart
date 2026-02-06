import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_colors.dart';
import 'enroll_draft.dart';
import 'enroll_preferences_screen.dart';

class EnrollProfileScreen extends StatefulWidget {
  const EnrollProfileScreen({super.key, required this.draft});

  final EnrollDraft draft;

  @override
  State<EnrollProfileScreen> createState() => _EnrollProfileScreenState();
}

class _EnrollProfileScreenState extends State<EnrollProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  String? _selectedGender;
  String? _avatarUrl;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.draft.name);
    _ageController = TextEditingController(
      text: widget.draft.age?.toString() ?? '',
    );
    _selectedGender = widget.draft.gender;
    _avatarUrl = widget.draft.avatarUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _isValid {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    return name.isNotEmpty && age != null && age >= 18 && _selectedGender != null;
  }

  Future<void> _uploadAvatar() async {
    if (_isUploadingAvatar) {
      return;
    }

    final client = Supabase.instance.client;
    final user = client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Du skal være logget ind for at uploade billede.')),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile == null) {
        return;
      }

      setState(() => _isUploadingAvatar = true);

      final bytes = await pickedFile.readAsBytes();
      final path = '${user.id}/avatar.jpg';
      await client.storage.from('avatars').uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: const FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );
      final publicUrl = client.storage.from('avatars').getPublicUrl(path);

      if (!mounted) {
        return;
      }

      setState(() {
        _avatarUrl = publicUrl;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kunne ikke uploade billede. Prøv igen.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploadingAvatar = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.premiumGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '2 af 3',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Personlige oplysninger',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vi skal bruge navn, alder og dit køn for at oprette din profil.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 24),
                  const _Field(
                    label: 'Profilbillede',
                    child: SizedBox.shrink(),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.white,
                      child: _avatarUrl == null || _avatarUrl!.isEmpty
                          ? const Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                              size: 64,
                            )
                          : Image.network(_avatarUrl!, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _avatarUrl == null || _avatarUrl!.isEmpty
                        ? 'Billede uploades senere'
                        : 'Billede valgt',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isUploadingAvatar ? null : _uploadAvatar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.white24,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      _isUploadingAvatar ? 'Uploader billede...' : 'Upload billede',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'Navn',
                    child: TextField(
                      controller: _nameController,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration('Indtast navn'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'Alder (18+)',
                    child: TextField(
                      controller: _ageController,
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration('Indtast alder'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Field(
                    label: 'Mit køn',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ['Mand', 'Kvinde', 'Andet / Vil ikke sige']
                          .map(
                            (option) => ChoiceChip(
                              label: Text(option),
                              selected: _selectedGender == option,
                              onSelected: (_) {
                                setState(() {
                                  _selectedGender = option;
                                });
                              },
                              selectedColor: AppColors.primary.withValues(alpha: 0.2),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _selectedGender == option
                                    ? AppColors.primaryDeep
                                    : AppColors.textSoft,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isValid
                        ? () {
                            final draft = widget.draft.copyWith(
                              name: _nameController.text.trim(),
                              age: int.parse(_ageController.text.trim()),
                              gender: _selectedGender,
                              avatarUrl: _avatarUrl,
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    EnrollPreferencesScreen(draft: draft),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.white24,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Næste',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

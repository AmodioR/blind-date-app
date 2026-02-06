import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.draft.name);
    _ageController = TextEditingController(
      text: widget.draft.age?.toString() ?? '',
    );
    _selectedGender = widget.draft.gender;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.premiumGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
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
                const Spacer(),
                ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          final draft = widget.draft.copyWith(
                            name: _nameController.text.trim(),
                            age: int.parse(_ageController.text.trim()),
                            gender: _selectedGender,
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

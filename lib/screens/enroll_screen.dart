import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/profile/profile_model.dart';
import '../data/profile/profile_repository_factory.dart';
import '../theme/app_colors.dart';
import 'main_tab_screen.dart';

class EnrollScreen extends StatefulWidget {
  const EnrollScreen({super.key});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  final _profileRepository = ProfileRepositoryFactory.create();

  int _currentStep = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedOwnGender;
  String _selectedGender = 'Alle';
  RangeValues _ageRange = const RangeValues(23, 35);
  double _distance = 25;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.premiumGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StepIndicator(currentStep: _currentStep),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: _currentStep == 1
                        ? _buildStepOne()
                        : _buildStepTwo(context),
                  ),
                ),
                const SizedBox(height: 16),
                _buildBottomCta(context),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Opret din profil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textSoft
,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Fortæl os lige det vigtigste for at komme i gang.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
        _LabeledField(
          label: 'Navn',
          controller: _nameController,
          hintText: 'Indtast navn',
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 16),
        _LabeledField(
          label: 'Alder',
          controller: _ageController,
          hintText: 'År',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        _LabeledField(
          label: 'Geografisk lokation',
          controller: _locationController,
          hintText: 'By eller område',
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildStepTwo(BuildContext context) {
    final genderOptions = ['Mand', 'Kvinde', 'Alle'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _currentStep = 1;
              });
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: AppColors.textMuted,
            ),
            icon: const Icon(Icons.chevron_left),
            label: const Text('Tilbage'),
          ),
        ),
        const Text(
          'Match-præferencer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textSoft
,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Indstil hvem du gerne vil matche med.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Dit køn',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: ['Mand', 'Kvinde']
              .map(
                (option) => ChoiceChip(
                  label: Text(option),
                  selected: _selectedOwnGender == option,
                  onSelected: (_) {
                    setState(() {
                      _selectedOwnGender = option;
                    });
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  backgroundColor: AppColors.surfaceTint,
                  labelStyle: TextStyle(
                    color: _selectedOwnGender == option
                        ? AppColors.primaryDeep
                        : AppColors.textSoft,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedOwnGender == option
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1),
        ),
        const Text(
          'Kønspræference',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: genderOptions
              .map(
                (option) => ChoiceChip(
                  label: Text(option),
                  selected: _selectedGender == option,
                  onSelected: (_) {
                    setState(() {
                      _selectedGender = option;
                    });
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  backgroundColor: AppColors.surfaceTint,
                  labelStyle: TextStyle(
                    color: _selectedGender == option
                        ? AppColors.primaryDeep
                        : AppColors.textSoft,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _selectedGender == option
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Aldersinterval',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_ageRange.start.round()}–${_ageRange.end.round()} år',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _ageRange,
          min: 18,
          max: 60,
          divisions: 42,
          onChanged: (value) {
            setState(() {
              _ageRange = value;
            });
          },
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(height: 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Maks. afstand',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_distance.round()} km',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
        Slider(
          value: _distance,
          min: 1,
          max: 100,
          divisions: 99,
          onChanged: (value) {
            setState(() {
              _distance = value;
            });
          },
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
        ),
      ],
    );
  }

  Widget _buildBottomCta(BuildContext context) {
    final label = _currentStep == 1 ? 'Næste' : 'Fortsæt';

    return ElevatedButton(
      onPressed: () async {
        if (_currentStep == 1) {
          setState(() {
            _currentStep = 2;
          });
          return;
        }
        final name = _nameController.text.trim();
        final age = int.tryParse(_ageController.text.trim()) ?? 0;
        final location = _locationController.text.trim();
        await _profileRepository.saveProfile(
          Profile(
            name: name,
            age: age,
            location: location,
            gender: _selectedOwnGender,
            genderPreference: _selectedGender,
            ageRangeMin: _ageRange.start.round(),
            ageRangeMax: _ageRange.end.round(),
            distanceKm: _distance.round(),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainTabScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 6,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$currentStep af 2',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: List.generate(2, (index) {
            final isActive = index + 1 == currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: index == 1 ? 0 : 6),
              height: 8,
              width: isActive ? 20 : 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            filled: true,
            fillColor: AppColors.surfaceTint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

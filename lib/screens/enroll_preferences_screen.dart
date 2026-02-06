import 'package:flutter/material.dart';

import '../data/profile/profile_model.dart';
import '../data/profile/profile_repository_factory.dart';
import '../theme/app_colors.dart';
import 'enroll_draft.dart';
import 'main_tab_screen.dart';

class EnrollPreferencesScreen extends StatefulWidget {
  const EnrollPreferencesScreen({super.key, required this.draft});

  final EnrollDraft draft;

  @override
  State<EnrollPreferencesScreen> createState() => _EnrollPreferencesScreenState();
}

class _EnrollPreferencesScreenState extends State<EnrollPreferencesScreen> {
  final _profileRepository = ProfileRepositoryFactory.create();

  late String _selectedGenderPreference;
  late RangeValues _ageRange;
  late double _distance;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedGenderPreference = widget.draft.genderPreference;
    _ageRange = RangeValues(
      widget.draft.ageRangeMin.toDouble(),
      widget.draft.ageRangeMax.toDouble(),
    );
    _distance = widget.draft.distanceKm.toDouble();
  }

  Future<void> _finish() async {
    setState(() {
      _isSaving = true;
    });

    await _profileRepository.saveProfile(
      Profile(
        name: widget.draft.name,
        age: widget.draft.age ?? 0,
        location: '',
        gender: widget.draft.gender,
        genderPreference: _selectedGenderPreference,
        ageRangeMin: _ageRange.start.round(),
        ageRangeMax: _ageRange.end.round(),
        distanceKm: _distance.round(),
        avatarUrl: widget.draft.avatarUrl,
      ),
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainTabScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const genderOptions = ['Mand', 'Kvinde', 'Alle'];

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
                  '3 af 3',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Præferencer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Kønspræference',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: genderOptions
                      .map(
                        (option) => ChoiceChip(
                          label: Text(option),
                          selected: _selectedGenderPreference == option,
                          onSelected: (_) {
                            setState(() {
                              _selectedGenderPreference = option;
                            });
                          },
                          selectedColor: AppColors.primary.withValues(alpha: 0.2),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: _selectedGenderPreference == option
                                ? AppColors.primaryDeep
                                : AppColors.textSoft,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aldersinterval',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_ageRange.start.round()}-${_ageRange.end.round()} år',
                      style: const TextStyle(color: Colors.white),
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
                  activeColor: Colors.white,
                  inactiveColor: Colors.white38,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Afstand',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${_distance.round()} km',
                      style: const TextStyle(color: Colors.white),
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
                  activeColor: Colors.white,
                  inactiveColor: Colors.white38,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isSaving ? null : _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.white24,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    _isSaving ? 'Gemmer...' : 'Færdig',
                    style: const TextStyle(
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
}

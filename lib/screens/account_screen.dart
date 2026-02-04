import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import 'landing_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  static const _nameKey = 'enroll_name';
  static const _ageKey = 'enroll_age';
  static const _genderPreferenceKey = 'enroll_gender_preference';
  static const _ageRangeMinKey = 'enroll_age_range_min';
  static const _ageRangeMaxKey = 'enroll_age_range_max';
  static const _distanceKmKey = 'enroll_distance_km';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Alle';
  RangeValues _ageRange = const RangeValues(24, 36);
  double _distance = 25;

  String _initialName = 'Sofia';
  String _initialAge = '28';
  String _initialGender = 'Alle';
  RangeValues _initialAgeRange = const RangeValues(24, 36);
  double _initialDistance = 25;

  @override
  void initState() {
    super.initState();
    _nameController.text = _initialName;
    _ageController.text = _initialAge;
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_nameKey);
    final age = prefs.getInt(_ageKey);
    final genderPreference = prefs.getString(_genderPreferenceKey);
    final ageRangeMin = prefs.getInt(_ageRangeMinKey);
    final ageRangeMax = prefs.getInt(_ageRangeMaxKey);
    final distance = prefs.getInt(_distanceKmKey);

    if (!mounted) {
      return;
    }

    setState(() {
      if (name != null && name.isNotEmpty) {
        _initialName = name;
        _nameController.text = name;
      }
      if (age != null) {
        _initialAge = age.toString();
        _ageController.text = _initialAge;
      }
      if (genderPreference != null && genderPreference.isNotEmpty) {
        _initialGender = genderPreference;
        _selectedGender = genderPreference;
      }
      if (ageRangeMin != null && ageRangeMax != null) {
        _initialAgeRange =
            RangeValues(ageRangeMin.toDouble(), ageRangeMax.toDouble());
        _ageRange = _initialAgeRange;
      }
      if (distance != null) {
        _initialDistance = distance.toDouble();
        _distance = _initialDistance;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool get _hasChanges {
    return _nameController.text.trim() != _initialName ||
        _ageController.text.trim() != _initialAge ||
        _selectedGender != _initialGender ||
        _ageRange.start != _initialAgeRange.start ||
        _ageRange.end != _initialAgeRange.end ||
        _distance != _initialDistance;
  }

  void _saveChanges() {
    if (!_hasChanges) {
      return;
    }
    setState(() {
      _initialName = _nameController.text.trim();
      _initialAge = _ageController.text.trim();
      _initialGender = _selectedGender;
      _initialAgeRange = _ageRange;
      _initialDistance = _distance;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dine ændringer er gemt')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom +
        kBottomNavigationBarHeight +
        12;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.premiumGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Account owner',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSoft,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 40,
                                offset: Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.surfaceTint,
                                    child: const Icon(
                                      Icons.person_outline,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Navn',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _nameController,
                                          onChanged: (_) => setState(() {}),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'Indtast navn',
                                            filled: true,
                                            fillColor: AppColors.surfaceTint,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Alder',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textMuted,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        TextField(
                                          controller: _ageController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (_) => setState(() {}),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: 'År',
                                            filled: true,
                                            fillColor: AppColors.surfaceTint,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 10,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceTint,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Status',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textMuted,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Beta-profil',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textSoft,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Match preferencer',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSoft,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 18,
                                offset: Offset(0, 10),
                              ),
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 40,
                                offset: Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Foretrukket køn',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: ['Mand', 'Kvinde', 'Alle']
                                    .map(
                                      (option) => ChoiceChip(
                                        label: Text(option),
                                        selected: _selectedGender == option,
                                        onSelected: (_) {
                                          setState(() {
                                            _selectedGender = option;
                                          });
                                        },
                                        selectedColor: AppColors.primary
                                            .withOpacity(0.15),
                                        backgroundColor: AppColors.surfaceTint,
                                        labelStyle: TextStyle(
                                          color: _selectedGender == option
                                              ? AppColors.primaryDeep
                                              : AppColors.textSoft,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Aldersinterval',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${_ageRange.start.round()}–${_ageRange.end.round()} år',
                                    style: TextStyle(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Maks. afstand',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${_distance.round()} km',
                                    style: TextStyle(
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
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LandingScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  foregroundColor: AppColors.textMuted,
                                  backgroundColor: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: const Text(
                                  'Log ud',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                onPressed: _hasChanges ? _saveChanges : null,
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 22),
                                  backgroundColor: AppColors.primary,
                                  disabledBackgroundColor: AppColors.border,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 8,
                                ),
                                child: Text(
                                  'Gem',
                                  style: TextStyle(
                                    color: _hasChanges
                                        ? Colors.white
                                        : AppColors.textMuted,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

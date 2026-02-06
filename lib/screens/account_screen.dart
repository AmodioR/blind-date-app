import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/profile/profile_model.dart';
import '../data/profile/profile_repository_factory.dart';
import '../theme/app_colors.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({
    super.key,
    required this.initialProfile,
    required this.onLogout,
  });

  final Profile initialProfile;
  final Future<void> Function() onLogout;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _profileRepository = ProfileRepositoryFactory.create();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedOwnGender;
  String _selectedGender = 'Alle';
  RangeValues _ageRange = const RangeValues(24, 36);
  double _distance = 25;

  String _initialName = 'Sofia';
  String _initialAge = '28';
  String _initialLocation = '';
  String? _initialOwnGender;
  String _initialGender = 'Alle';
  RangeValues _initialAgeRange = const RangeValues(24, 36);
  double _initialDistance = 25;

  @override
  void initState() {
    super.initState();
    _applyProfile(widget.initialProfile);
  }

  void _applyProfile(Profile profile) {
    if (profile.name.isNotEmpty) {
      _initialName = profile.name;
      _nameController.text = profile.name;
    } else {
      _nameController.text = _initialName;
    }
    if (profile.age > 0) {
      _initialAge = profile.age.toString();
      _ageController.text = _initialAge;
    } else {
      _ageController.text = _initialAge;
    }
    if (profile.location.isNotEmpty) {
      _initialLocation = profile.location;
    }
    _initialOwnGender = profile.gender;
    _selectedOwnGender = profile.gender;
    if (profile.genderPreference.isNotEmpty) {
      _initialGender = profile.genderPreference;
      _selectedGender = profile.genderPreference;
    }
    _initialAgeRange = RangeValues(
      profile.ageRangeMin.toDouble(),
      profile.ageRangeMax.toDouble(),
    );
    _ageRange = _initialAgeRange;
    _initialDistance = profile.distanceKm.toDouble();
    _distance = _initialDistance;
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
        _selectedOwnGender != _initialOwnGender ||
        _selectedGender != _initialGender ||
        _ageRange.start != _initialAgeRange.start ||
        _ageRange.end != _initialAgeRange.end ||
        _distance != _initialDistance;
  }

  Future<void> _saveChanges() async {
    if (!_hasChanges) {
      return;
    }
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    await _profileRepository.saveProfile(
      Profile(
        name: name,
        age: age,
        location: _initialLocation,
        gender: _selectedOwnGender,
        genderPreference: _selectedGender,
        ageRangeMin: _ageRange.start.round(),
        ageRangeMax: _ageRange.end.round(),
        distanceKm: _distance.round(),
      ),
    );
    setState(() {
      _initialName = name;
      _initialAge = age > 0 ? age.toString() : '';
      _initialOwnGender = _selectedOwnGender;
      _initialGender = _selectedGender;
      _initialAgeRange = _ageRange;
      _initialDistance = _distance;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gemt')),
    );
  }

  Future<void> _handleLogout() async {
    bool signOutFailed = false;
    try {
      await widget.onLogout();
    } catch (_) {
      signOutFailed = true;
    }

    await _profileRepository.clearProfile();

    if (!mounted) {
      return;
    }

    if (signOutFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kunne ikke logge ud')),
      );
    }
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
                              const SizedBox(height: 18),
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: 18),
                              Text(
                                'Dit køn',
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
                                        selectedColor: AppColors.primary
                                            .withOpacity(0.15),
                                        backgroundColor: AppColors.surfaceTint,
                                        labelStyle: TextStyle(
                                          color: _selectedOwnGender == option
                                              ? AppColors.primaryDeep
                                              : AppColors.textSoft,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                onPressed: _handleLogout,
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 22),
                                  side: const BorderSide(
                                    color: AppColors.border,
                                  ),
                                  foregroundColor: AppColors.textMuted,
                                  backgroundColor: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
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

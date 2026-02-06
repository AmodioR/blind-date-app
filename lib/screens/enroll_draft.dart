class EnrollDraft {
  const EnrollDraft({
    this.name = '',
    this.age,
    this.genderPreference = 'Alle',
    this.ageRangeMin = 23,
    this.ageRangeMax = 35,
    this.distanceKm = 25,
  });

  final String name;
  final int? age;
  final String genderPreference;
  final int ageRangeMin;
  final int ageRangeMax;
  final int distanceKm;

  EnrollDraft copyWith({
    String? name,
    int? age,
    bool clearAge = false,
    String? genderPreference,
    int? ageRangeMin,
    int? ageRangeMax,
    int? distanceKm,
  }) {
    return EnrollDraft(
      name: name ?? this.name,
      age: clearAge ? null : (age ?? this.age),
      genderPreference: genderPreference ?? this.genderPreference,
      ageRangeMin: ageRangeMin ?? this.ageRangeMin,
      ageRangeMax: ageRangeMax ?? this.ageRangeMax,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}

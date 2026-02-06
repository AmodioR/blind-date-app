class Profile {
  const Profile({
    required this.name,
    required this.age,
    required this.location,
    this.gender,
    required this.genderPreference,
    required this.ageRangeMin,
    required this.ageRangeMax,
    required this.distanceKm,
    this.avatarUrl,
  });

  final String name;
  final int age;
  final String location;
  final String? gender;
  final String genderPreference;
  final int ageRangeMin;
  final int ageRangeMax;
  final int distanceKm;
  final String? avatarUrl;

  Profile copyWith({
    String? name,
    int? age,
    String? location,
    String? gender,
    bool clearGender = false,
    String? genderPreference,
    int? ageRangeMin,
    int? ageRangeMax,
    int? distanceKm,
    String? avatarUrl,
    bool clearAvatarUrl = false,
  }) {
    return Profile(
      name: name ?? this.name,
      age: age ?? this.age,
      location: location ?? this.location,
      gender: clearGender ? null : (gender ?? this.gender),
      genderPreference: genderPreference ?? this.genderPreference,
      ageRangeMin: ageRangeMin ?? this.ageRangeMin,
      ageRangeMax: ageRangeMax ?? this.ageRangeMax,
      distanceKm: distanceKm ?? this.distanceKm,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'location': location,
      'gender': gender,
      'gender_preference': genderPreference,
      'age_range_min': ageRangeMin,
      'age_range_max': ageRangeMax,
      'distance_km': distanceKm,
      'avatar_url': avatarUrl,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] as String? ?? '',
      age: map['age'] as int? ?? 0,
      location: map['location'] as String? ?? '',
      gender: map['gender'] as String?,
      genderPreference: map['gender_preference'] as String? ?? 'Alle',
      ageRangeMin: map['age_range_min'] as int? ?? 24,
      ageRangeMax: map['age_range_max'] as int? ?? 36,
      distanceKm: map['distance_km'] as int? ?? 25,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory Profile.fromJson(Map<String, dynamic> json) => Profile.fromMap(json);
}

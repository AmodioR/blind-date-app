class Profile {
  const Profile({
    required this.name,
    required this.age,
    required this.location,
    required this.genderPreference,
    required this.ageRangeMin,
    required this.ageRangeMax,
    required this.distanceKm,
  });

  final String name;
  final int age;
  final String location;
  final String genderPreference;
  final int ageRangeMin;
  final int ageRangeMax;
  final int distanceKm;
}

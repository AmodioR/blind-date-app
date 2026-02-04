import 'package:shared_preferences/shared_preferences.dart';

import 'profile_model.dart';
import 'profile_repository.dart';

class LocalProfileRepository implements ProfileRepository {
  static const nameKey = 'enroll_name';
  static const ageKey = 'enroll_age';
  static const locationKey = 'enroll_location';
  static const genderPreferenceKey = 'enroll_gender_preference';
  static const ageRangeMinKey = 'enroll_age_range_min';
  static const ageRangeMaxKey = 'enroll_age_range_max';
  static const distanceKmKey = 'enroll_distance_km';

  @override
  Future<Profile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(nameKey);
    final age = prefs.getInt(ageKey);
    final location = prefs.getString(locationKey);
    final genderPreference = prefs.getString(genderPreferenceKey);
    final ageRangeMin = prefs.getInt(ageRangeMinKey);
    final ageRangeMax = prefs.getInt(ageRangeMaxKey);
    final distanceKm = prefs.getInt(distanceKmKey);

    if (name == null &&
        age == null &&
        location == null &&
        genderPreference == null &&
        ageRangeMin == null &&
        ageRangeMax == null &&
        distanceKm == null) {
      return null;
    }

    return Profile(
      name: name ?? '',
      age: age ?? 0,
      location: location ?? '',
      genderPreference: genderPreference ?? 'Alle',
      ageRangeMin: ageRangeMin ?? 24,
      ageRangeMax: ageRangeMax ?? 36,
      distanceKm: distanceKm ?? 25,
    );
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    final prefs = await SharedPreferences.getInstance();
    if (profile.name.trim().isEmpty) {
      await prefs.remove(nameKey);
    } else {
      await prefs.setString(nameKey, profile.name.trim());
    }
    if (profile.age <= 0) {
      await prefs.remove(ageKey);
    } else {
      await prefs.setInt(ageKey, profile.age);
    }
    if (profile.location.trim().isEmpty) {
      await prefs.remove(locationKey);
    } else {
      await prefs.setString(locationKey, profile.location.trim());
    }
    await prefs.setString(genderPreferenceKey, profile.genderPreference);
    await prefs.setInt(ageRangeMinKey, profile.ageRangeMin);
    await prefs.setInt(ageRangeMaxKey, profile.ageRangeMax);
    await prefs.setInt(distanceKmKey, profile.distanceKm);
  }

  @override
  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(nameKey);
    await prefs.remove(ageKey);
    await prefs.remove(locationKey);
    await prefs.remove(genderPreferenceKey);
    await prefs.remove(ageRangeMinKey);
    await prefs.remove(ageRangeMaxKey);
    await prefs.remove(distanceKmKey);
  }
}

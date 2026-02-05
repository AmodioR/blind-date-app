import 'package:supabase_flutter/supabase_flutter.dart';

import 'profile_model.dart';
import 'profile_repository.dart';

class RemoteProfileRepository implements ProfileRepository {
  static const _tableName = 'profiles';

  @override
  Future<Profile?> loadProfile() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return null;
    }

    final data = await client
        .from(_tableName)
        .select('name, age, location, gender, gender_preference, age_range_min, age_range_max, distance_km')
        .filter('id', 'eq', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return Profile(
      name: data['name'] as String? ?? '',
      age: data['age'] as int? ?? 0,
      location: data['location'] as String? ?? '',
      gender: data['gender'] as String?,
      genderPreference: data['gender_preference'] as String? ?? 'Alle',
      ageRangeMin: data['age_range_min'] as int? ?? 24,
      ageRangeMax: data['age_range_max'] as int? ?? 36,
      distanceKm: data['distance_km'] as int? ?? 25,
    );
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      throw StateError('Cannot save profile without an authenticated user.');
    }

    final trimmedGender = profile.gender?.trim();

    await client.from(_tableName).upsert({
      'id': user.id,
      'name': profile.name.trim(),
      'age': profile.age,
      'location': profile.location.trim(),
      'gender': (trimmedGender == null || trimmedGender.isEmpty) ? null : trimmedGender,
      'gender_preference': profile.genderPreference,
      'age_range_min': profile.ageRangeMin,
      'age_range_max': profile.ageRangeMax,
      'distance_km': profile.distanceKm,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> clearProfile() async {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final user = client.auth.currentUser;
    if (session == null || user == null) {
      return;
    }

    await client.from(_tableName).delete().filter('id', 'eq', user.id);
  }
}

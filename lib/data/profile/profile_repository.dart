import 'profile_model.dart';

abstract class ProfileRepository {
  Future<Profile?> loadProfile();
  Future<void> saveProfile(Profile profile);
  Future<void> clearProfile();
}

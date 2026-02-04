import '../../config/app_config.dart';
import 'local_profile_repository.dart';
import 'profile_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryFactory {
  const ProfileRepositoryFactory._();

  static ProfileRepository create() {
    if (AppConfig.useRemoteProfile) {
      return RemoteProfileRepository();
    }
    return LocalProfileRepository();
  }
}

class RemoteProfileRepository implements ProfileRepository {
  @override
  Future<Profile?> loadProfile() {
    throw UnimplementedError('RemoteProfileRepository is not implemented yet.');
  }

  @override
  Future<void> saveProfile(Profile profile) {
    throw UnimplementedError('RemoteProfileRepository is not implemented yet.');
  }

  @override
  Future<void> clearProfile() {
    throw UnimplementedError('RemoteProfileRepository is not implemented yet.');
  }
}

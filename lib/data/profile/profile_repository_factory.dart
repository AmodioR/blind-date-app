import '../../config/app_config.dart';
import 'local_profile_repository.dart';
import 'profile_repository.dart';
import 'remote_profile_repository.dart';

class ProfileRepositoryFactory {
  const ProfileRepositoryFactory._();

  static ProfileRepository create() {
    if (AppConfig.useRemoteProfile) {
      return RemoteProfileRepository();
    }
    return LocalProfileRepository();
  }
}

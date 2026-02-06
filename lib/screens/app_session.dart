import '../data/profile/profile_model.dart';

class AppSession {
  const AppSession({
    required this.userId,
    required this.profile,
  });

  final String userId;
  final Profile profile;
}

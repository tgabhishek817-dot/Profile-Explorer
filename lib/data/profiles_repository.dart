import '../domain/profile.dart';
import 'profiles_api.dart';

class ProfilesRepository {
  final ProfilesApi api;
  ProfilesRepository({required this.api});

  Future<List<Profile>> getProfiles() => api.fetchProfiles(results: 20);
}

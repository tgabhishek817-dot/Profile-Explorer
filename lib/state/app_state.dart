import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:profile_explorer_app/data/profiles_api.dart';
import 'package:profile_explorer_app/main.dart';
import '../domain/profile.dart';
import '../data/profiles_repository.dart';

class AppState {
  final List<Profile> profiles;
  final Set<String> likedIds;
  final bool isLoading;
  final String? error;
  final String? selectedCountry;

  AppState({
    required this.profiles,
    required this.likedIds,
    required this.isLoading,
    this.error,
    this.selectedCountry,
  });

  AppState.initial()
      : profiles = [],
        likedIds = {},
        isLoading = false,
        error = null,
        selectedCountry = null;

  AppState copyWith({
    List<Profile>? profiles,
    Set<String>? likedIds,
    bool? isLoading,
    String? error,
    String? selectedCountry,
  }) {
    return AppState(
      profiles: profiles ?? this.profiles,
      likedIds: likedIds ?? this.likedIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCountry: selectedCountry,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  final ProfilesRepository repo;
  AppNotifier({required this.repo}) : super(AppState.initial());

  Future<void> loadProfiles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final profiles = await repo.getProfiles();
      state = state.copyWith(profiles: profiles, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void toggleLike(String id) {
    final newLikes = Set<String>.from(state.likedIds);
    if (newLikes.contains(id)) newLikes.remove(id);
    else newLikes.add(id);
    state = state.copyWith(likedIds: newLikes);
  }

  void setCountryFilter(String? country) {
    state = state.copyWith(selectedCountry: country);
  }

  List<Profile> get visibleProfiles {
    final all = state.profiles;
    if (state.selectedCountry == null || state.selectedCountry == 'World') return all;
    return all.where((p) => p.country == state.selectedCountry).toList();
  }
}

final profilesApiProvider = Provider((ref) => ProfilesApi());
final profilesRepoProvider = Provider((ref) => ProfilesRepository(api: ref.read(profilesApiProvider)));
final appNotifierProvider = StateNotifierProvider<AppNotifier, AppState>(
    (ref) => AppNotifier(repo: ref.read(profilesRepoProvider)));

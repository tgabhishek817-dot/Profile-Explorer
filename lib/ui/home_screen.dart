import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profile_explorer_app/domain/profile.dart';
import '../state/app_state.dart';
import 'widgets/profile_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(appNotifierProvider.notifier).loadProfiles());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appNotifierProvider);
    final notifier = ref.read(appNotifierProvider.notifier);

    final countries = <String>{'World'};
    countries.addAll(
  state.profiles
      .whereType<Profile>() // removes null elements
      .map((e) => e.country)
);

    final countryList = countries.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Explorer', style: GoogleFonts.poppins(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(onPressed: () => notifier.loadProfiles(), icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: state.selectedCountry ?? 'World',
                            items: countryList.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) => notifier.setCountryFilter(val == 'World' ? null : val),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => await notifier.loadProfiles(),
                child: Builder(builder: (context) {
                  if (state.isLoading) return const Center(child: CircularProgressIndicator());
                  if (state.error != null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${state.error}'),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: () => notifier.loadProfiles(), child: const Text('Retry')),
                        ],
                      ),
                    );
                  }

                  final profiles = notifier.visibleProfiles;
                  if (profiles.isEmpty) return const Center(child: Text('No profiles found'));

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final p = profiles[index];
                      final liked = state.likedIds.contains(p.id);
                      return ProfileCard(profile: p, liked: liked, onLike: () => notifier.toggleLike(p.id));
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

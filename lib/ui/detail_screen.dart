import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/app_state.dart';
import '../domain/profile.dart';
import 'widgets/like_button.dart';

class DetailScreen extends ConsumerWidget {
  final String profileId;
  const DetailScreen({Key? key, required this.profileId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appNotifierProvider);
    final notifier = ref.read(appNotifierProvider.notifier);
   final profile = state.profiles
    .whereType<Profile>() // removes null elements, if any
    .firstWhere(
      (p) => p.id == profileId,
      orElse: () => Profile(id: '', firstName: '', lastName: '', age: 0, city: '', country: '', imageUrl: ''), // return an empty/default Profile if not found
    );

    final liked = state.likedIds.contains(profileId);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'profile_image_${profile.id}',
              child: CachedNetworkImage(
                imageUrl: profile.imageUrl,
                height: 600,
                fit: BoxFit.cover,
                placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.fullName,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('${profile.age} • ${profile.city}, ${profile.country}',
                            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 12),
                        Text(_generateMicroBio(profile as Profile),
                            style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      LikeButton(liked: liked, onTap: () => notifier.toggleLike(profile.id)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _generateMicroBio(Profile p) {
  final hobbies = ['coffee', 'photography', 'hiking', 'coding', 'cooking', 'reading', 'traveling'];
  final hobby = hobbies[Random(p.id.hashCode).nextInt(hobbies.length)];
  return '${p.firstName} is ${p.age} years old from ${p.city}. Loves $hobby and exploring new places.';
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/profile.dart';
import 'like_button.dart';
import '../detail_screen.dart';

class ProfileCard extends StatelessWidget {
  final Profile profile;
  final bool liked;
  final VoidCallback onLike;

  const ProfileCard({Key? key, required this.profile, required this.liked, required this.onLike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailScreen(profileId: profile.id))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Hero(
                tag: 'profile_image_${profile.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: profile.imageUrl,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    placeholder: (c, s) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (c, s, e) => const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text('${profile.age} • ${profile.city}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                  ),
                  LikeButton(liked: liked, onTap: onLike),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

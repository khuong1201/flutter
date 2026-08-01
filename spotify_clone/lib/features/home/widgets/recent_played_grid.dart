import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class RecentPlayedGrid extends StatelessWidget {
  final List<dynamic> items;
  final List<Track> allTracks;

  const RecentPlayedGrid({Key? key, required this.items, required this.allTracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayItems = items.length > 4 ? items.sublist(0, 4) : items;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: displayItems.length,
      itemBuilder: (context, index) {
        final item = displayItems[index];
        return GestureDetector(
          onTap: () {
            if (allTracks.isNotEmpty) {
              context.read<AudioProvider>().playTrack(allTracks[index % allTracks.length]);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                  child: CachedNetworkImage(
                    imageUrl: item['coverUrl'] ?? '',
                    width: 56, height: 56, fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(width: 56, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item['title'] ?? '',
                    style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
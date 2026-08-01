import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class SearchResultsList extends StatelessWidget {
  final List<Track> tracks;

  const SearchResultsList({Key? key, required this.tracks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: track.coverUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(width: 50, color: Colors.grey),
            ),
          ),
          title: Text(track.title, style: const TextStyle(color: kText, fontWeight: FontWeight.bold)),
          subtitle: Text(track.artistName, style: const TextStyle(color: kSubtitle)),
          onTap: () => context.read<AudioProvider>().playTrack(track),
        );
      },
    );
  }
}
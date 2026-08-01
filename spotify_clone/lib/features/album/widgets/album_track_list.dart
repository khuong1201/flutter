import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/features/player/screens/full_player_screen.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class AlbumTrackList extends StatelessWidget {
  final List<Track> tracks;
  final List<Track> allAlbumTracks;

  const AlbumTrackList({
    Key? key,
    required this.tracks,
    required this.allAlbumTracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final track = tracks[index];
          return ListTile(
            leading: Text(
              '${index + 1}',
              style: const TextStyle(color: kSubtitle, fontSize: 16),
            ),
            title: Text(track.title, style: const TextStyle(color: kText)),
            subtitle: Text(track.artistName, style: const TextStyle(color: kSubtitle)),
            trailing: const Icon(Icons.more_vert, color: kSubtitle),
            onTap: () {
              context.read<AudioProvider>().playPlaylist(allAlbumTracks, startIndex: index);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FullPlayerScreen()),
              );
            },
          );
        },
        childCount: tracks.length,
      ),
    );
  }
}
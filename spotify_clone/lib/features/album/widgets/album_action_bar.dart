import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/features/player/screens/full_player_screen.dart';
import 'package:spotify_clone/shared/models/album_model.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class AlbumActionBar extends StatelessWidget {
  final Album album;
  final List<Track> albumTracks;

  const AlbumActionBar({
    Key? key,
    required this.album,
    required this.albumTracks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            album.artistName,
            style: const TextStyle(color: kSubtitle, fontSize: 16),
          ),
          const Spacer(),
          Container(
            decoration: const BoxDecoration(
              color: kPrimary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 32,
              icon: const Icon(Icons.play_arrow, color: Colors.black),
              onPressed: () {
                if (albumTracks.isNotEmpty) {
                  context.read<AudioProvider>().playPlaylist(albumTracks, startIndex: 0);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FullPlayerScreen()),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
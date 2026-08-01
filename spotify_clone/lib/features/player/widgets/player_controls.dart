import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';


class PlayerControls extends StatelessWidget {
  final AudioProvider audioProvider;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;

  const PlayerControls({
    Key? key,
    required this.audioProvider,
    required this.isPlaying,
    required this.isShuffle,
    required this.isRepeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle, color: isShuffle ? kPrimary : kSubtitle),
          onPressed: () => audioProvider.toggleShuffle(),
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous, color: kText, size: 36),
          onPressed: () => audioProvider.previousTrack(),
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: kPrimary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: IconButton(
            iconSize: 42,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () => audioProvider.togglePlayPause(),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next, color: kText, size: 36),
          onPressed: () => audioProvider.nextTrack(),
        ),
        IconButton(
          icon: Icon(Icons.repeat, color: isRepeat ? kPrimary : kSubtitle),
          onPressed: () => audioProvider.toggleRepeat(),
        ),
      ],
    );
  }
}
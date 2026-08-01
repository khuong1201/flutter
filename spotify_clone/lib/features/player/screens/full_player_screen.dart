import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/features/player/widgets/player_artwork.dart';
import 'package:spotify_clone/features/player/widgets/player_controls.dart';
import 'package:spotify_clone/features/player/widgets/player_header.dart';
import 'package:spotify_clone/features/player/widgets/player_track_info.dart';
import 'package:spotify_clone/shared/widgets/audio_progress_bar.dart';


class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentTrack = context.select((AudioProvider p) => p.currentTrack);
    if (currentTrack == null) return const SizedBox.shrink();

    final isPlaying = context.select((AudioProvider p) => p.isPlaying);
    final isShuffle = context.select((AudioProvider p) => p.isShuffle);
    final isRepeat = context.select((AudioProvider p) => p.isRepeat);
    final duration = context.select((AudioProvider p) => p.duration);
    final position = context.select((AudioProvider p) => p.position);
    
    final audioProvider = context.read<AudioProvider>();

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const PlayerHeader(),
              const SizedBox(height: 32),
              
              // Ảnh bìa
              PlayerArtwork(coverUrl: currentTrack.coverUrl),
              const SizedBox(height: 48),
              
              // Tên bài hát & Thả tim
              PlayerTrackInfo(track: currentTrack),
              const SizedBox(height: 24),
              
              // Thanh tiến trình
              const AudioProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position), style: const TextStyle(color: kSubtitle, fontSize: 12)),
                  Text(_formatDuration(duration), style: const TextStyle(color: kSubtitle, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 16),
              
              // Nút điều khiển
              PlayerControls(
                audioProvider: audioProvider,
                isPlaying: isPlaying,
                isShuffle: isShuffle,
                isRepeat: isRepeat,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
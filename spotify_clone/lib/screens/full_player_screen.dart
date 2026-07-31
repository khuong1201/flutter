import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/audio_progress_bar.dart';
import '../providers/favorite_provider.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({Key? key}) : super(key: key);

  String _formatDuration(Duration duration) {
    String minutes = duration.inMinutes.toString();
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU HIỆU SUẤT: Lấy ra 5 biến cần thiết, từ chối vẽ lại khi thời gian trôi
    final currentTrack = context.select((AudioProvider p) => p.currentTrack);
    final isPlaying = context.select((AudioProvider p) => p.isPlaying);
    final isShuffle = context.select((AudioProvider p) => p.isShuffle);
    final isRepeat = context.select((AudioProvider p) => p.isRepeat);
    final duration = context.select((AudioProvider p) => p.duration);
    final isFavorite = context.select((FavoriteProvider p) => p.isFavorite(currentTrack?.id ?? ''));
    if (currentTrack == null) return const SizedBox.shrink();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A4A4A), Color(0xFF121212)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context), 
                    ),
                    const Text('ĐANG PHÁT TỪ ALBUM', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 32),

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: currentTrack.coverUrl,
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTrack.title,
                            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            currentTrack.artist,
                            style: const TextStyle(color: Colors.grey, fontSize: 16),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? const Color(0xFF1DB954) : Colors.white, 
                        size: 32
                      ),
                      onPressed: () {
                        context.read<FavoriteProvider>().toggleFavorite(currentTrack.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Thanh trượt
                const AudioProgressBar(isMini: false),

                // TỐI ƯU TEXT THỜI GIAN: Bọc vào StreamBuilder để nó tự nháy chữ số
                StreamBuilder<Duration>(
                  stream: context.read<AudioProvider>().positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        Text(_formatDuration(duration), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    );
                  }
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle, color: isShuffle ? const Color(0xFF1DB954) : Colors.white),
                      onPressed: () => context.read<AudioProvider>().toggleShuffle(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                      onPressed: () => context.read<AudioProvider>().previousTrack(),
                    ),
                    Container(
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: IconButton(
                        iconSize: 48,
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.black),
                        onPressed: () => context.read<AudioProvider>().togglePlayPause(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                      onPressed: () => context.read<AudioProvider>().nextTrack(),
                    ),
                    IconButton(
                      icon: Icon(Icons.repeat, color: isRepeat ? const Color(0xFF1DB954) : Colors.white),
                      onPressed: () => context.read<AudioProvider>().toggleRepeat(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
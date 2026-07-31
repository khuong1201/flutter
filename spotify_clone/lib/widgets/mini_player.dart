import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../screens/full_player_screen.dart';
import 'audio_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU HIỆU SUẤT: Chỉ vẽ lại khi đổi bài hát hoặc đổi nút Play/Pause
    final currentTrack = context.select((AudioProvider p) => p.currentTrack);
    final isPlaying = context.select((AudioProvider p) => p.isPlaying);

    if (currentTrack == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, 
          backgroundColor: Colors.transparent, 
          builder: (context) => const FullPlayerScreen(),
        );
      },
      child: Container(
        height: 64, 
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: currentTrack.coverUrl,
                      width: 60, fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 60, color: Colors.grey,
                        child: const Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentTrack.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          currentTrack.artist,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: 28,
                    ),
                    // Gọi hàm thì phải dùng context.read()
                    onPressed: () => context.read<AudioProvider>().togglePlayPause(),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            
            // Thanh trượt giờ đây TỰ LO logic thời gian của nó
            const SizedBox(
              height: 12, 
              child: AudioProgressBar(isMini: true),
            ),
          ],
        ),
      ),
    );
  }
}
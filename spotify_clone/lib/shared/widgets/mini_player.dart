import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/library/providers/favorite_provider.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/features/player/screens/full_player_screen.dart';

import 'audio_progress_bar.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final currentTrack = context.select((AudioProvider p) => p.currentTrack);
    final isPlaying = context.select((AudioProvider p) => p.isPlaying);
    
    if (currentTrack == null) return const SizedBox.shrink();
    
    final isFavorite = context.select((FavoriteProvider p) => p.isFavorite(currentTrack.id.toString()));

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, 
          backgroundColor: kBackground, 
          builder: (context) => const FullPlayerScreen(),
        );
      },
      child: Container(
        height: 64, 
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: kSurface, // Sử dụng màu surface chuẩn từ constants
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  // 1. Ảnh bìa
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: currentTrack.coverUrl,
                      width: 60, height: 60, fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        width: 60, color: kSurface,
                        child: const Icon(Icons.music_note, color: kText),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 2. Tên bài hát và nghệ sĩ
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentTrack.title,
                          style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          currentTrack.artistName,
                          style: const TextStyle(color: kSubtitle, fontSize: 12),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // 3. Nút Thích (Favorite)
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? kPrimary : kText,
                      size: 24,
                    ),
                    onPressed: () {
                      context.read<FavoriteProvider>().toggleFavorite(currentTrack.id.toString());
                    },
                  ),
                  
                  // 4. Nút Play / Pause
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: kText, size: 28,
                    ),
                    onPressed: () => context.read<AudioProvider>().togglePlayPause(),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            
            // 5. Thanh tiến trình thời gian nhỏ bên dưới
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/utils/constants.dart';
import 'package:spotify_clone/widgets/audio_progress_bar.dart';
import '../providers/audio_provider.dart';
import '../providers/favorite_provider.dart';

class FullPlayerScreen extends StatelessWidget {
  const FullPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Kiểm tra null trước tiên để đảm bảo an toàn tuyệt đối
    final currentTrack = context.select((AudioProvider p) => p.currentTrack);
    if (currentTrack == null) return const SizedBox.shrink();

    // 2. Lấy các thông số trạng thái tối ưu bằng context.select
    final isPlaying = context.select((AudioProvider p) => p.isPlaying);
    final isShuffle = context.select((AudioProvider p) => p.isShuffle);
    final isRepeat = context.select((AudioProvider p) => p.isRepeat);
    final duration = context.select((AudioProvider p) => p.duration);
    final position = context.select((AudioProvider p) => p.position);
    final isFavorite = context.select((FavoriteProvider p) => p.isFavorite(currentTrack.id));
    
    final audioProvider = context.read<AudioProvider>();

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: kText,
                      size: 34,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
        
                  const Column(
                    children: [
                      Text(
                        "PLAYING FROM PLAYLIST",
                        style: TextStyle(
                          color: kSubtitle,
                          fontSize: 10,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Techno Essentials",
                        style: TextStyle(
                          color: kText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
        
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: kText),
                    onPressed: () {},
                  ),
                ],
              ),
        
              const SizedBox(height: 64),
              // Ảnh bìa lớn
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: currentTrack.coverUrl,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: kCard),
                    errorWidget: (context, url, error) => const Icon(Icons.music_note, color: kText, size: 50),
                  ),
                ),
              ),
              const SizedBox(height: 64,),
              // Tên bài hát & Nút tim (Hive)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentTrack.title, style: const TextStyle(color: kText, fontSize: 32, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(currentTrack.artist, style: const TextStyle(color: kSubtitle, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? kPrimary : kText,
                      size: 28,
                    ),
                    onPressed: () {
                      context.read<FavoriteProvider>().toggleFavorite(currentTrack.id);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Thanh tiến trình (Slider)
              const AudioProgressBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(position), style: const TextStyle(color: kSubtitle, fontSize: 12)),
                  Text(_formatDuration(duration), style: const TextStyle(color: kSubtitle, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 10),
              // Các nút điều khiển phát nhạc
              Row(
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
                    decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(20),),
                    child: IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: kText, size: 48),
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
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.devices, color: kSubtitle, size: 20),
                  Icon(Icons.share_outlined, color: kSubtitle),
                ],
              ),
              const SizedBox(height: 20),
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
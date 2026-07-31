import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/screens/full_player_screen.dart';
import '../providers/favorite_provider.dart';
import '../providers/audio_provider.dart';
import '../models/track_model.dart';
import '../repositories/music_repository.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Lấy danh sách ID đã thả tim từ Hive
    final favoriteIds = context.watch<FavoriteProvider>().favoriteIds;
    final MusicRepository repository = MusicRepository();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Thư viện của bạn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: favoriteIds.isEmpty
          ? const Center(
              child: Text(
                'Chưa có bài hát yêu thích nào!\nHãy bấm nút trái tim ở màn hình phát nhạc.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          : FutureBuilder<List<Track>>(
              // 2. Kéo dữ liệu bài hát từ file JSON thông qua Repository
              future: repository.getTracksByIds(favoriteIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không tìm thấy bài hát!', style: TextStyle(color: Colors.grey)));
                }

                final tracks = snapshot.data!;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: track.coverUrl, 
                          width: 50, 
                          height: 50, 
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(track.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
                      trailing: const Icon(Icons.favorite, color: Color(0xFF1DB954)),
                      onTap: () {
                        // Bấm vào phát nhạc luôn
                        context.read<AudioProvider>().playTrack(track);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FullPlayerScreen(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
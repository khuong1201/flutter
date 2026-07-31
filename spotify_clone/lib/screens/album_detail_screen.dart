import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/utils/constants.dart';
import '../models/album_model.dart';
import '../models/track_model.dart';
import '../repositories/music_repository.dart';
import '../providers/audio_provider.dart';
import 'full_player_screen.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album; // Màn hình này cần nhận vào 1 Album để hiển thị

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final MusicRepository _repository = MusicRepository();
  late Future<List<Track>> _tracksFuture;
  List<Track> _albumTracks = [];

  @override
  void initState() {
    super.initState();
    // Tải danh sách bài hát thuộc về Album này
    _tracksFuture = _repository.getTracksByIds(widget.album.trackIds);
    // Đổ dữ liệu vào biến _albumTracks ngay khi Future hoàn thành
    _tracksFuture.then((tracks) {
      if (mounted) {
        setState(() => _albumTracks = tracks);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      // KHÔNG dùng AppBar thông thường, chúng ta dùng CustomScrollView
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar: Trái tim của hiệu ứng cuộn mờ dần
          SliverAppBar(
            expandedHeight: 300.0, // Chiều cao tối đa khi kéo giãn
            pinned: true, // Ghim thanh tiêu đề lại khi cuộn lên trên cùng
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.album.title,
                style: const TextStyle(fontWeight: FontWeight.bold, color: kText),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Ảnh bìa Album
                  CachedNetworkImage(
                    imageUrl:widget.album.coverUrl,
                    fit: BoxFit.cover,
                  ),
                  // Lớp phủ Gradient đen mờ dần lên trên để chữ dễ đọc
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF121212),
                          const Color(0xFF121212).withOpacity(0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. SliverToBoxAdapter: Dành cho các thành phần không phải danh sách (Nút Play)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    widget.album.artist,
                    style: const TextStyle(color: kSubtitle, fontSize: 16),
                  ),
                  const Spacer(),
                  // Nút Play to màu xanh đặc trưng của Spotify
                  Container(
                    decoration: const BoxDecoration(
                      color: kPrimary, // Spotify Green
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 32,
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      onPressed: () {
                        if (_albumTracks.isNotEmpty) {
                          context.read<AudioProvider>().playPlaylist(_albumTracks, startIndex: 0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FullPlayerScreen(),
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),

          // 3. SliverList: Danh sách các bài hát trong Album
          FutureBuilder<List<Track>>(
            future: _tracksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator(color: kPrimary)),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('Không có bài hát', style: TextStyle(color: kSubtitle))),
                );
              }

              final tracks = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final track = tracks[index];
                    return ListTile(
                      leading: Text(
                        '${index + 1}', // Số thứ tự bài hát
                        style: const TextStyle(color: kSubtitle, fontSize: 16),
                      ),
                      title: Text(track.title, style: const TextStyle(color: kText)),
                      subtitle: Text(track.artist, style: const TextStyle(color: kSubtitle)),
                      trailing: const Icon(Icons.more_vert, color: kSubtitle),
                      onTap: () {
                        // Phát nhạc và cập nhật Mini-player
                        context.read<AudioProvider>().playPlaylist(_albumTracks, startIndex: index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FullPlayerScreen(),
                          ),
                        );
                      },
                    );
                  },
                  childCount: tracks.length, // Số lượng bài hát
                ),
              );
            },
          ),
          
          // Thêm một khoảng trống ở dưới cùng để danh sách không bị che bởi Mini-player
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
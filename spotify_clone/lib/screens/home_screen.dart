import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../repositories/music_repository.dart';
import '../models/album_model.dart';
import '../models/track_model.dart';
import 'album_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicRepository _repository = MusicRepository();
  
  late Future<List<Album>> _albumsFuture;
  late Future<List<Track>> _tracksFuture;

  @override
  void initState() {
    super.initState();
    _albumsFuture = _repository.getAllAlbums();
    _tracksFuture = _repository.getTracksByIds(['track_01', 'track_02']); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      // 1. CHUYỂN SANG CUSTOM SCROLL VIEW
      body: CustomScrollView(
        slivers: [
          // 2. AppBar chuyển thành SliverAppBar
          SliverAppBar(
            backgroundColor: const Color(0xFF121212),
            pinned: true,
            elevation: 0,
            title: const Text(
              'Chào buổi sáng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
            ],
          ),
          
          // 3. Các khối tĩnh bọc bằng SliverToBoxAdapter
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Album Nổi Bật',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: _buildAlbumSection(),
          ),
          
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Gợi Ý Cho Bạn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          
          // 4. Gọi hàm render danh sách bài hát dạng Sliver
          _buildTrackSectionSliver(),
          
          // 5. Lớp đệm dưới cùng để không bị Mini-player che mất bài hát cuối
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  // Khối vẽ danh sách Album (Cuộn ngang - Giữ nguyên như cũ)
  Widget _buildAlbumSection() {
    return FutureBuilder<List<Album>>(
      future: _albumsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Không có dữ liệu Album', style: TextStyle(color: Colors.grey)),
          );
        }

        final albums = snapshot.data!;
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AlbumDetailScreen(album: album)),
                  );
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Bo góc cho ảnh đẹp hơn
                        child: CachedNetworkImage(imageUrl: album.coverUrl,width: 140, height: 140, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 8),
                      Text(album.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(album.artist, style: const TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // KHỐI MỚI: Vẽ danh sách Bài hát bằng SliverList (Tối ưu render)
  Widget _buildTrackSectionSliver() {
    return FutureBuilder<List<Track>>(
      future: _tracksFuture,
      builder: (context, snapshot) {
        // Mọi return bên trong FutureBuilder này đều phải bọc bằng Sliver
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator(color: Colors.green)),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Không có bài hát nào', style: TextStyle(color: Colors.grey)),
            ),
          );
        }

        final tracks = snapshot.data!;
        
        // SỬ DỤNG SLIVERLIST THAY CHO LISTVIEW.BUILDER
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final track = tracks[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(imageUrl:track.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                ),
                title: Text(track.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(track.artist, style: const TextStyle(color: Colors.grey)),
                trailing: const Icon(Icons.more_vert, color: Colors.grey),
                onTap: () {
                  // Phát nhạc lẻ (1 bài)
                  context.read<AudioProvider>().playTrack(track);
                },
              );
            },
            childCount: tracks.length, // Cung cấp số lượng bài hát
          ),
        );
      },
    );
  }
}
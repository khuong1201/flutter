import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/album/screens/album_detail_screen.dart';
import 'package:spotify_clone/features/player/providers/audio_provider.dart';
import 'package:spotify_clone/shared/models/album_model.dart';
import 'package:spotify_clone/shared/models/track_model.dart';
import 'package:spotify_clone/shared/repositories/album_repository.dart';
import 'package:spotify_clone/shared/repositories/music_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicRepository _musicRepository = MusicRepository();
  final AlbumRepository _albumRepository = AlbumRepository();

  List<Track> _topTracks = [];
  List<Album> _topAlbums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      // Song song gọi API lấy Top Tracks và danh sách Album nổi bật
      final tracksFuture = _musicRepository.getTopTracks();
      final albumsFuture = _albumRepository.searchAlbums('hit'); // Hoặc từ khóa bất kỳ

      final results = await Future.wait([tracksFuture, albumsFuture]);

      if (mounted) {
        setState(() {
          _topTracks = results[0] as List<Track>;
          _topAlbums = results[1] as List<Album>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBackground,
        body: Center(child: CircularProgressIndicator(color: kPrimary)),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: kBackground,
            floating: true,
            pinned: false,
            toolbarHeight: 60,

            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: Row(
                  children: [
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        color: kText,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= CHƯƠNG 1: HIỂN THỊ ALBUM TRƯỢT NGANG =================
                  if (_topAlbums.isNotEmpty) ...[
                    const Text(
                      'Featured Albums',
                      style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _topAlbums.length,
                        itemBuilder: (context, index) {
                          final album = _topAlbums[index];
                          return GestureDetector(
                            onTap: () {
                              // Chuyển sang màn hình AlbumDetailScreen khi bấm vào Album
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumDetailScreen(album: album),
                                ),
                              );
                            },
                            child: Container(
                              width: 120,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: album.coverMedium,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Container(width: 120, height: 120, color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    album.title,
                                    style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    album.artistName,
                                    style: const TextStyle(color: kSubtitle, fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // ================= CHƯƠNG 2: DANH SÁCH BÀI HÁT (TOP TRACKS) =================
                  const Text(
                    'Today\'s Top Tracks',
                    style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  _topTracks.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('Không thể tải dữ liệu từ server.', style: TextStyle(color: kSubtitle)),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _topTracks.length,
                          itemBuilder: (context, index) {
                            final track = _topTracks[index];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: CachedNetworkImage(
                                  imageUrl: track.coverUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      Container(width: 50, height: 50, color: Colors.grey),
                                ),
                              ),
                              title: Text(
                                track.title,
                                style: const TextStyle(color: kText, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                track.artistName,
                                style: const TextStyle(color: kSubtitle),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                context.read<AudioProvider>().playPlaylist(_topTracks, startIndex: index);
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
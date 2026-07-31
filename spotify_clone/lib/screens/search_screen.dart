import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/audio_provider.dart';
import '../models/track_model.dart';
import '../repositories/music_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MusicRepository _repository = MusicRepository();
  List<Track> _allTracks = [];
  List<Track> _filteredTracks = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTracks();
  }

  // Tải toàn bộ danh sách bài hát từ file JSON mock data
  Future<void> _loadTracks() async {
    final tracks = await _repository.getAllTracks();
    setState(() {
      _allTracks = tracks;
      _filteredTracks = tracks;
      _isLoading = false;
    });
  }

  // Lọc danh sách bài hát theo từ khóa người dùng nhập (Tên bài hoặc Tên ca sĩ)
  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTracks = _allTracks;
      } else {
        _filteredTracks = _allTracks
            .where((t) => 
                t.title.toLowerCase().contains(query.toLowerCase()) || 
                t.artist.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Tìm kiếm', 
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 16),
              
              // Thanh nhập từ khóa tìm kiếm (Search Bar) phong cách Spotify
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Bạn muốn nghe bài hát hoặc nghệ sĩ nào?',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), 
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              const Text(
                'Kết quả tìm kiếm',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Hiển thị danh sách kết quả hoặc trạng thái tải
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF1DB954)))
                    : _filteredTracks.isEmpty
                        ? const Center(
                            child: Text(
                              'Không tìm thấy bài hát phù hợp!',
                              style: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _filteredTracks.length,
                            itemBuilder: (context, index) {
                              final track = _filteredTracks[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: track.coverUrl, 
                                    width: 50, 
                                    height: 50, 
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(color: Colors.grey[850]),
                                    errorWidget: (context, url, error) => const Icon(Icons.music_note, color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  track.title, 
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  track.artist, 
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                                onTap: () {
                                  // Bấm vào là phát bài hát đó ngay lập tức
                                  context.read<AudioProvider>().playTrack(track);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
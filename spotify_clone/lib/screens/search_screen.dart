import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/utils/constants.dart';
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
  List<dynamic> _categories = [];
  bool _isSearching = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tracks = await _repository.getAllTracks();
    final String jsonString = await rootBundle.loadString('assets/data/mock_data.json');
    final data = jsonDecode(jsonString);
    setState(() {
      _allTracks = tracks;
      _filteredTracks = tracks;
      _categories = data['categories'] ?? [];
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredTracks = _allTracks
          .where((t) => t.title.toLowerCase().contains(query.toLowerCase()) || t.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Search', style: TextStyle(color: kText, fontSize: 26, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.settings_outlined, color: kText), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 12),
              // Search Input Box
              TextField(
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'What do you want to listen to?',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: kPrimary))
                    : _isSearching
                        ? ListView.builder(
                            itemCount: _filteredTracks.length,
                            itemBuilder: (context, index) {
                              final track = _filteredTracks[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(imageUrl: track.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                                ),
                                title: Text(track.title, style: const TextStyle(color: kText, fontWeight: FontWeight.bold)),
                                subtitle: Text(track.artist, style: const TextStyle(color: kSubtitle)),
                                onTap: () => context.read<AudioProvider>().playTrack(track),
                              );
                            },
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Browse all', style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Expanded(
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1.8,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                                  itemCount: _categories.length,
                                  itemBuilder: (context, index) {
                                    final cat = _categories[index];
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(cat['color'].replaceAll('#', '0xFF'))),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        cat['title'],
                                        style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
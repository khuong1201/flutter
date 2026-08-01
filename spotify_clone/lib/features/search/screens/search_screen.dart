import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/search/widgets/browse_categories_grid.dart';
import 'package:spotify_clone/features/search/widgets/search_bar_widget.dart';
import 'package:spotify_clone/features/search/widgets/search_results_list.dart';
import 'package:spotify_clone/shared/models/track_model.dart';
import 'package:spotify_clone/shared/repositories/music_repository.dart';

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
    _loadDataFromApi();
  }

  // Gọi hoàn toàn bằng Deezer API thật, không dùng rootBundle / mock_data.json nữa
  Future<void> _loadDataFromApi() async {
    try {
      final tracksFuture = _repository.getTopTracks();
      final categoriesFuture = _repository.getCategories();

      final results = await Future.wait([tracksFuture, categoriesFuture]);

      if (mounted) {
        setState(() {
          _allTracks = results[0] as List<Track>;
          _filteredTracks = _allTracks;
          _categories = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredTracks = _allTracks
          .where((t) => t.title.toLowerCase().contains(query.toLowerCase()) || 
                        t.artistName.toLowerCase().contains(query.toLowerCase()))
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
              
              // Ô nhập từ khóa tìm kiếm
              SearchBarWidget(onChanged: _onSearchChanged),
              const SizedBox(height: 16),
              
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: kPrimary))
                    : _isSearching
                        ? SearchResultsList(tracks: _filteredTracks)
                        : BrowseCategoriesGrid(categories: _categories),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
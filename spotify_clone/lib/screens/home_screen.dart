import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/utils/constants.dart';
import '../providers/audio_provider.dart';
import '../models/track_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _homeData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mock_data.json');
      final data = jsonDecode(jsonString);
      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: kPrimary)));
    }

    final sections = _homeData['sections'] as List<dynamic>? ?? [];
    final tracksData = _homeData['tracks'] as List<dynamic>? ?? [];
    List<Track> allTracks = tracksData.map((e) => Track.fromJson(e)).toList();

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar với lời chào Good evening
          SliverAppBar(
            backgroundColor: kBackground,
            floating: true,
            pinned: false,
            title: const Text('Good evening', style: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: const Icon(Icons.notifications_none, color: kText), onPressed: () {}),
              IconButton(icon: const Icon(Icons.history, color: kText), onPressed: () {}),
              IconButton(icon: const Icon(Icons.settings_outlined, color: kText), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Recently Played (Lưới 2x2)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final item = sections[0]['items'][index];
                      return GestureDetector(
                        onTap: () {
                          if (allTracks.isNotEmpty) {
                            context.read<AudioProvider>().playTrack(allTracks[index % allTracks.length]);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                                child: CachedNetworkImage(imageUrl: item['coverUrl'], width: 56, height: 56, fit: BoxFit.cover),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['title'],
                                  style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // 2. Jump back in (Trượt ngang)
                  const Text('Jump back in', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: sections[1]['items'].length,
                      itemBuilder: (context, index) {
                        final item = sections[1]['items'][index];
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(imageUrl: item['coverUrl'], width: 120, height: 120, fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 6),
                              Text(item['title'], style: const TextStyle(color: kText, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(item['subtitle'], style: const TextStyle(color: kSubtitle, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Made For You (Banner lớn)
                  const Text('Made For You', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                          child: CachedNetworkImage(imageUrl: sections[2]['items'][0]['coverUrl'], width: 160, height: 160, fit: BoxFit.cover),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('WEEKLY WRAP', style: TextStyle(color: kPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(sections[2]['items'][0]['title'], style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(sections[2]['items'][0]['subtitle'], style: const TextStyle(color: kSubtitle, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/utils/constants.dart';
import '../providers/favorite_provider.dart';
import '../providers/audio_provider.dart';
import '../models/track_model.dart';
import '../repositories/music_repository.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoriteProvider>().favoriteIds;
    final MusicRepository repository = MusicRepository();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        title: Row(
          children: [
            const CircleAvatar(backgroundColor: Colors.purple, radius: 16, child: Text('S', style: TextStyle(color: kText))),
            const SizedBox(width: 12),
            const Text('Your Library', style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: kText), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add, color: kText), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs (Playlists, Artists, Albums)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildChip('Playlists', true),
                const SizedBox(width: 8),
                _buildChip('Artists', false),
                const SizedBox(width: 8),
                _buildChip('Albums', false),
              ],
            ),
          ),
          const Divider(color: kSurface),
          
          // List Liked Songs & Recents
          Expanded(
            child: FutureBuilder<List<Track>>(
              future: repository.getTracksByIds(favoriteIds),
              builder: (context, snapshot) {
                final tracks = snapshot.data ?? [];
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Colors.indigo, Colors.blueGrey]),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.favorite, color: kText),
                      ),
                      title: const Text('Liked Songs', style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
                      subtitle: Text('Playlist • ${tracks.length} songs', style: const TextStyle(color: kSubtitle)),
                    ),
                    const SizedBox(height: 10),
                    ...tracks.map((track) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(imageUrl: track.coverUrl, width: 50, height: 50, fit: BoxFit.cover),
                          ),
                          title: Text(track.title, style: const TextStyle(color: kText, fontWeight: FontWeight.bold)),
                          subtitle: Text(track.artist, style: const TextStyle(color: kSubtitle)),
                          onTap: () => context.read<AudioProvider>().playTrack(track),
                        )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget SystemChip(String label, bool isSelected) {
    return _buildChip(label, isSelected);
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? kPrimary : kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.black : kText, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
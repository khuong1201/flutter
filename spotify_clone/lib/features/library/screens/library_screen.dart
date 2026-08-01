import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/library/providers/favorite_provider.dart';
import 'package:spotify_clone/features/library/widgets/library_app_bar.dart';
import 'package:spotify_clone/features/library/widgets/library_filter_chips.dart';
import 'package:spotify_clone/features/library/widgets/library_track_list.dart';
import 'package:spotify_clone/shared/models/track_model.dart';
import 'package:spotify_clone/shared/repositories/music_repository.dart';


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteIds = context.watch<FavoriteProvider>().favoriteIds;
    final MusicRepository repository = MusicRepository();

    return Scaffold(
      backgroundColor: kBackground,
      appBar: const LibraryAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Tabs (Playlists, Artists, Albums)
          const LibraryFilterChips(),
          const Divider(color: kSurface),
          
          // List Liked Songs & Recents
          Expanded(
            child: FutureBuilder<List<Track>>(
              future: repository.getTracksByIds(favoriteIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: kPrimary));
                }
                final tracks = snapshot.data ?? [];
                return LibraryTrackList(tracks: tracks);
              },
            ),
          ),
        ],
      ),
    );
  }
}
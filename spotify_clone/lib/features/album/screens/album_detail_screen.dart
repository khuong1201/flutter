import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/album/widgets/album_action_bar.dart';
import 'package:spotify_clone/features/album/widgets/album_header_sliver.dart';
import 'package:spotify_clone/features/album/widgets/album_track_list.dart';
import 'package:spotify_clone/shared/models/album_model.dart';
import 'package:spotify_clone/shared/models/track_model.dart';
import 'package:spotify_clone/shared/repositories/album_repository.dart';


class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final AlbumRepository _albumRepository = AlbumRepository();
  late Future<List<Track>> _tracksFuture;
  List<Track> _albumTracks = [];

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách bài hát thật theo ID của Album từ Deezer
    _tracksFuture = _albumRepository.getAlbumTracks(widget.album.id);
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
      body: CustomScrollView(
        slivers: [
          // 1. Header ảnh và tiêu đề
          AlbumHeaderSliver(album: widget.album),

          // 2. Tên ca sĩ và nút Play
          SliverToBoxAdapter(
            child: AlbumActionBar(
              album: widget.album,
              albumTracks: _albumTracks,
            ),
          ),

          // 3. Danh sách bài hát
          FutureBuilder<List<Track>>(
            future: _tracksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator(color: kPrimary)),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('Không có bài hát trong album này', style: TextStyle(color: kSubtitle))),
                  ),
                );
              }

              final tracks = snapshot.data!;
              return AlbumTrackList(
                tracks: tracks,
                allAlbumTracks: _albumTracks,
              );
            },
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
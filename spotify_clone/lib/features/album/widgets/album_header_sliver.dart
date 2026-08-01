import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/shared/models/album_model.dart';


class AlbumHeaderSliver extends StatelessWidget {
  final Album album;

  const AlbumHeaderSliver({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      backgroundColor: const Color(0xFF121212),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          album.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: kText),
        ),
        centerTitle: true,
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: album.coverMedium,
              fit: BoxFit.cover,
            ),
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
    );
  }
}
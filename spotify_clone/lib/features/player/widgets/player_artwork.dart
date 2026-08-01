import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/app/constants.dart';


class PlayerArtwork extends StatelessWidget {
  final String coverUrl;

  const PlayerArtwork({Key? key, required this.coverUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.8;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: coverUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: kSurface),
          errorWidget: (context, url, error) => const Icon(Icons.music_note, color: kText, size: 50),
        ),
      ),
    );
  }
}
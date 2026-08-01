import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/library/providers/favorite_provider.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class PlayerTrackInfo extends StatelessWidget {
  final Track track;

  const PlayerTrackInfo({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isFavorite = context.select((FavoriteProvider p) => p.isFavorite(track.id.toString()));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track.title,
                style: const TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                track.artistName,
                style: const TextStyle(color: kSubtitle, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? kPrimary : kText,
            size: 28,
          ),
          onPressed: () {
            context.read<FavoriteProvider>().toggleFavorite(track.id.toString());
          },
        ),
      ],
    );
  }
}
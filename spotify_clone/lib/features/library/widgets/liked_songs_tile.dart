import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class LikedSongsTile extends StatelessWidget {
  final int songCount;

  const LikedSongsTile({Key? key, required this.songCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.indigo, Colors.blueGrey]),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.favorite, color: kText),
      ),
      title: const Text('Liked Songs', style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
      subtitle: Text('Playlist • $songCount songs', style: const TextStyle(color: kSubtitle)),
    );
  }
}
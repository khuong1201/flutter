import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LibraryAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kBackground,
      title: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.purple,
            radius: 16,
            child: Text('S', style: TextStyle(color: kText)),
          ),
          const SizedBox(width: 12),
          const Text('Your Library', style: TextStyle(color: kText, fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search, color: kText), onPressed: () {}),
        IconButton(icon: const Icon(Icons.add, color: kText), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
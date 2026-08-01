import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class PlayerHeader extends StatelessWidget {
  const PlayerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: kText, size: 34),
          onPressed: () => Navigator.pop(context),
        ),
        const Column(
          children: [
            Text(
              "PLAYING FROM PLAYLIST",
              style: TextStyle(color: kSubtitle, fontSize: 10, letterSpacing: 1.5),
            ),
            SizedBox(height: 2),
            Text(
              "Techno Essentials",
              style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: kText),
          onPressed: () {},
        ),
      ],
    );
  }
}
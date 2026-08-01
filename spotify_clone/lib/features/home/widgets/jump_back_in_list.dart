import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/app/constants.dart';


class JumpBackInList extends StatelessWidget {
  final List<dynamic> items;

  const JumpBackInList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jump back in', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: item['coverUrl'] ?? '',
                        width: 120, height: 120, fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(width: 120, height: 120, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(item['title'] ?? '', style: const TextStyle(color: kText, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(item['subtitle'] ?? '', style: const TextStyle(color: kSubtitle, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotify_clone/app/constants.dart';


class MadeForYouBanner extends StatelessWidget {
  final Map<String, dynamic> item;

  const MadeForYouBanner({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Made For You', style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: item['coverUrl'] ?? '',
                  width: 160, height: 160, fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(width: 160, height: 160, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('WEEKLY WRAP', style: TextStyle(color: kPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item['title'] ?? '', style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item['subtitle'] ?? '', style: const TextStyle(color: kSubtitle, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
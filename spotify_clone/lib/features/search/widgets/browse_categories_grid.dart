import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class BrowseCategoriesGrid extends StatelessWidget {
  final List<dynamic> categories;

  const BrowseCategoriesGrid({Key? key, required this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Browse all', style: TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final colorString = (cat['color'] as String? ?? '#333333').replaceAll('#', '0xFF');
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(int.parse(colorString)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  cat['title'] ?? '',
                  style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
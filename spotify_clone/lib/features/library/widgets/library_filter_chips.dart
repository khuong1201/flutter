import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class LibraryFilterChips extends StatelessWidget {
  const LibraryFilterChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildChip('Playlists', true),
          const SizedBox(width: 8),
          _buildChip('Artists', false),
          const SizedBox(width: 8),
          _buildChip('Albums', false),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? kPrimary : kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : kText,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
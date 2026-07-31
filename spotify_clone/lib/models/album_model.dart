class Album {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String description;
  final List<String> trackIds;

  Album({
    required this.id, required this.title, required this.artist,
    required this.coverUrl, required this.description, required this.trackIds,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      description: json['description'] ?? '',
      trackIds: List<String>.from(json['trackIds'] ?? []), 
    );
  }
}
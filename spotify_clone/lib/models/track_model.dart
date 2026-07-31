class Track {
  final String id;
  final String title;
  final String artist;
  final String albumId;
  final int duration;
  final String audioUrl;
  final String coverUrl;

  Track({
    required this.id, required this.title, required this.artist,
    required this.albumId, required this.duration, 
    required this.audioUrl, required this.coverUrl,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      albumId: json['albumId'] ?? '',
      duration: json['duration'] ?? 0,
      audioUrl: json['audioUrl'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
    );
  }
}
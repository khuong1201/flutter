class Album {
  final int id;
  final String title;
  final Map<String, dynamic> artist;
  final String coverMedium;
  final int nbTracks; 

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverMedium,
    required this.nbTracks,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      // Xử lý an toàn: Chuyển đổi linh hoạt nếu API trả về String hoặc int
      id: json['id'] is int 
          ? json['id'] 
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      artist: json['artist'] is Map<String, dynamic> ? json['artist'] : {},
      coverMedium: json['cover_medium'] ?? json['cover'] ?? json['cover_big'] ?? '',
      nbTracks: json['nb_tracks'] is int 
          ? json['nb_tracks'] 
          : int.tryParse(json['nb_tracks']?.toString() ?? '0') ?? 0,
    );
  }

  // Getter hỗ trợ lấy tên nghệ sĩ an toàn
  String get artistName {
    if (artist.containsKey('name')) {
      return artist['name'] ?? 'Unknown Artist';
    }
    return 'Unknown Artist';
  }
}
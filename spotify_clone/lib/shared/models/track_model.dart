class Track {
  final int id;
  final String title;
  final int duration;
  final String preview; 
  final Map<String, dynamic> artist;
  final Map<String, dynamic> album;

  Track({
    required this.id,
    required this.title,
    required this.duration,
    required this.preview,
    required this.artist,
    required this.album,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id'] is int 
          ? json['id'] 
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? json['name'] ?? '',
      duration: json['duration'] is int 
          ? json['duration'] 
          : int.tryParse(json['duration']?.toString() ?? '0') ?? 0,
      preview: json['preview'] ?? '',
      artist: json['artist'] is Map<String, dynamic> ? json['artist'] : {},
      album: json['album'] is Map<String, dynamic> ? json['album'] : {},
    );
  }

  // Xử lý lấy tên nghệ sĩ linh hoạt từ API track đơn hoặc search/chart
  String get artistName {
    if (artist.containsKey('name')) {
      return artist['name'] ?? 'Unknown Artist';
    }
    return 'Unknown Artist';
  }

  // Xử lý lấy ảnh bìa album linh hoạt từ nhiều định dạng khác nhau của Deezer
  String get coverUrl {
    if (album.isNotEmpty) {
      return album['cover_medium'] ?? 
             album['cover'] ?? 
             album['cover_big'] ?? 
             album['cover_small'] ?? '';
    }
    return '';
  }
}
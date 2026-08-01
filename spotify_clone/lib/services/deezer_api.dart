class DeezerApi {
  static const String baseUrl = "https://api.deezer.com";

  // =========================
  // TRACK
  // =========================
  static String searchTrack(String keyword) => "$baseUrl/search/track?q=$keyword";
  static String topTracks() => "$baseUrl/chart/0/tracks";
  static String track(int id) => "$baseUrl/track/$id";

  // =========================
  // ALBUM
  // =========================
  static String album(int id) => "$baseUrl/album/$id";
  static String albumTracks(int id) => "$baseUrl/album/$id/tracks";
  static String searchAlbum(String keyword) => "$baseUrl/search/album?q=$keyword";

  // =========================
  // ARTIST
  // =========================
  static String artistAlbums(int artistId) => "$baseUrl/artist/$artistId/albums";


  static String genres() => "$baseUrl/genre";
}
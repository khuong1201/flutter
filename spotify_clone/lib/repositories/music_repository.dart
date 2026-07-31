import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/album_model.dart';
import '../models/track_model.dart';

class MusicRepository {
  static const String _dataPath = 'assets/data/mock_data.json';

  List<Album>? _cachedAlbums;
  List<Track>? _cachedTracks;

  Future<void> _loadDataIfNeeded() async {
    if (_cachedAlbums != null && _cachedTracks != null) return;
    try {
      final String jsonString = await rootBundle.loadString(_dataPath);
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      final List<dynamic> albumList = jsonData['albums'] ?? [];
      _cachedAlbums = albumList.map((e) => Album.fromJson(e)).toList();

      final List<dynamic> trackList = jsonData['tracks'] ?? [];
      _cachedTracks = trackList.map((e) => Track.fromJson(e)).toList();
    } catch (e) {
      print('Lỗi đọc JSON: $e');
      _cachedAlbums = [];
      _cachedTracks = [];
    }
  }

  Future<List<Album>> getAllAlbums() async {
    await _loadDataIfNeeded();
    return _cachedAlbums ?? [];
  }

  Future<List<Track>> getTracksByIds(List<String> ids) async {
    await _loadDataIfNeeded();
    if (_cachedTracks == null) return [];
    return _cachedTracks!.where((track) => ids.contains(track.id)).toList();
  }

  // --- THÊM HÀM NÀY VÀO ---
  Future<List<Track>> getAllTracks() async {
    await _loadDataIfNeeded();
    return _cachedTracks ?? [];
  }
}
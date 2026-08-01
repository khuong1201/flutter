import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify_clone/shared/models/track_model.dart';


class AudioProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Track? _currentTrack;
  bool _isPlaying = false;
  
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Quản lý danh sách phát
  List<Track> _playlist = [];
  int _currentIndex = -1;
  
  // Trạng thái Shuffle/Repeat
  bool isShuffle = false;
  bool isRepeat = false;

  Track? get currentTrack => _currentTrack;
  bool get isPlaying => _isPlaying;
  Duration get duration => _duration;
  Duration get position => _position;

  AudioProvider() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      
      if (processingState == ProcessingState.completed) {
        // Tự động chuyển bài khi hết nhạc
        if (isRepeat) {
          seek(Duration.zero);
          _audioPlayer.play();
        } else {
          nextTrack(); // Gọi hàm Next
        }
      } else {
        _isPlaying = isPlaying;
      }
      notifyListeners();
    });

    _audioPlayer.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });

    // Lắng nghe position stream để UI cập nhật thanh progress nếu muốn
    _audioPlayer.positionStream.listen((pos) {
      _position = pos;
      // Dùng notifyListeners cẩn thận ở đây vì có thể gây render liên tục toàn app nếu không tối ưu, 
      // thay vào đó bạn có thể dùng StreamBuilder trực tiếp ở UI cho thanh Progress bar.
    });
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  // Phát cả một danh sách (dùng cho Nút Play ở Album hoặc Playlist)
  Future<void> playPlaylist(List<Track> tracks, {int startIndex = 0}) async {
    if (tracks.isEmpty) return;
    _playlist = tracks;
    _currentIndex = startIndex;
    await playTrack(_playlist[_currentIndex]);
  }

  // Hàm phát 1 bài hát
  Future<void> playTrack(Track track) async {
    if (_currentTrack?.id == track.id) {
      if (!_isPlaying) _audioPlayer.play();
      return;
    }
    _currentTrack = track;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners(); 

    try {
      // Đảm bảo trong Track model của bạn trường link preview 30s tên là preview (hoặc audioUrl)
      // Chuyển ID sang String vì MediaItem yêu cầu id kiểu String
      final audioSource = AudioSource.uri(
        Uri.parse(track.preview), 
        tag: MediaItem(
          id: track.id.toString(), 
          title: track.title, 
          artist: track.artistName, // Dùng getter artistName từ Track model đã định nghĩa
          artUri: track.coverUrl.isNotEmpty ? Uri.parse(track.coverUrl) : null, 
        ),
      );

      // Nạp gói dữ liệu vào Player và phát
      await _audioPlayer.setAudioSource(audioSource);
      _audioPlayer.play();
    } catch (e) {
      print("Lỗi tải nhạc: $e");
    }
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  // Chuyển bài tiếp theo
  void nextTrack() {
    if (_playlist.isEmpty || _currentIndex < 0) return;
    
    if (isShuffle) {
      // Nếu bật trộn bài, chọn ngẫu nhiên một index khác index hiện tại
      _currentIndex = (DateTime.now().millisecondsSinceEpoch % _playlist.length);
    } else if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0; // Quay lại bài đầu tiên nếu hết danh sách
    }
    playTrack(_playlist[_currentIndex]);
  }

  // Quay lại bài trước
  void previousTrack() {
    if (_playlist.isEmpty || _currentIndex < 0) return;
    
    // Nếu nhạc đang chạy được hơn 3 giây, nút Prev sẽ tua lại từ đầu bài hát
    if (_position.inSeconds > 3) {
      seek(Duration.zero);
    } else if (_currentIndex > 0) {
      _currentIndex--;
    } else {
      _currentIndex = _playlist.length - 1; // Quay về bài cuối nếu đang ở bài đầu
    }
    playTrack(_playlist[_currentIndex]);
  }

  // Bật/tắt Trộn bài và Lặp lại
  void toggleShuffle() {
    isShuffle = !isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    isRepeat = !isRepeat;
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
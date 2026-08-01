import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:spotify_clone/app/constants.dart';
import 'package:spotify_clone/features/home/screens/home_screen.dart';
import 'package:spotify_clone/features/library/screens/library_screen.dart';
import 'package:spotify_clone/features/search/screens/search_screen.dart';
import 'package:spotify_clone/shared/widgets/mini_player.dart';

// Import các cấu hình và tính năng đã xây dựng
import 'app/theme.dart';
import 'features/player/providers/audio_provider.dart';
import 'features/library/providers/favorite_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Khởi tạo Hive
  await Hive.initFlutter();
  await Hive.openBox<String>('favorites_box');

  // 2. Khởi tạo phát nhạc nền (Lock screen / Notification)
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.spotifyclone.channel.audio',
    androidNotificationChannelName: 'Audio Playback',
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/ic_launcher',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AudioProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()), 
      ],
      child: const SpotifyCloneApp(),
    ),
  );
}

// Lớp này giúp tắt hiệu ứng kéo giãn cao su của Android (tạo cảm giác cuộn mượt mà kiểu iOS)
class NoStretchScrollBehavior extends ScrollBehavior {
  const NoStretchScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); 
  }
}

class SpotifyCloneApp extends StatelessWidget {
  const SpotifyCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify Clone',
      scrollBehavior: const NoStretchScrollBehavior(),
      theme: AppTheme.darkTheme, // Sử dụng trực tiếp Theme đã viết chuẩn ở thư mục app/theme.dart
      home: const RootScreen(),
    );
  }
}

// Màn hình Root chứa Bottom Navigation Bar kết hợp Mini Player
class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(), // Luôn gíữ thanh phát nhạc mini ở đáy trên mọi tab
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: kPrimary,
            unselectedItemColor: Colors.grey,     
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
            ],
          ),
        ],
      ),
    );
  }
}
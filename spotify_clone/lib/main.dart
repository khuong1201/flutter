import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/favorite_provider.dart';
import 'package:spotify_clone/screens/library_screen.dart';
import 'package:spotify_clone/screens/search_screen.dart';
import 'providers/audio_provider.dart';
import 'widgets/mini_player.dart';
import 'screens/home_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>('favorites_box');
  // Khởi tạo Background Service trước khi chạy App
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
        // 3. Khai báo FavoriteProvider (Không cần truyền isar vào nữa)
        ChangeNotifierProvider(create: (context) => FavoriteProvider()), 
      ],
      child: const SpotifyCloneApp(),
    ),
  );
}

// Lớp này giúp tắt hiệu ứng kéo giãn cao su của Android
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
      scrollBehavior: NoStretchScrollBehavior(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const RootScreen(),
    );
  }
}

// Màn hình Root chứa Bottom Navigation Bar
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
          const MiniPlayer(),
          
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tìm kiếm'),
              BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Thư viện'),
            ],
          ),
        ],
      ),
    );
  }
}
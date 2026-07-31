import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/favorite_provider.dart';
import 'package:spotify_clone/screens/library_screen.dart';
import 'package:spotify_clone/screens/search_screen.dart';
import 'package:spotify_clone/utils/constants.dart';
import 'providers/audio_provider.dart';
import 'widgets/mini_player.dart';
import 'screens/home_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>('favorites_box');

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
      scrollBehavior: const NoStretchScrollBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        // Tự động gán màu nền mặc định cho toàn app
        scaffoldBackgroundColor: kBackground,
        primaryColor: kPrimary,
        colorScheme: const ColorScheme.dark(
          primary: kPrimary,
          surface: kSurface,
        ),
        // Cấu hình màu cho BottomNavigationBar mặc định
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: kSurface,
          selectedItemColor: kPrimary,
          unselectedItemColor: kSubtitle,
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
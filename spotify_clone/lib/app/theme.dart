import 'package:flutter/material.dart';
import 'package:spotify_clone/app/constants.dart';


class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kBackground,
      primaryColor: kPrimary,
      canvasColor: kBackground,
      
      // Cấu hình AppBar chung cho toàn app
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: kText,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: kText),
      ),

      // Cấu hình Bottom Navigation Bar (nếu app dùng thanh điều hướng dưới)
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kSurface,
        selectedItemColor: kText,
        unselectedItemColor: kSubtitle,
        type: BottomNavigationBarType.fixed,
      ),

      // Cấu hình màu sắc cho Slider (Thanh tiến trình nhạc)
      sliderTheme: const SliderThemeData(
        activeTrackColor: kText,
        inactiveTrackColor: kCard,
        thumbColor: kText,
        trackHeight: 3,
      ),

      // Cấu hình kiểu chữ mặc định (Text Theme)
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kText, fontSize: 16),
        bodyMedium: TextStyle(color: kSubtitle, fontSize: 14),
        titleLarge: TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
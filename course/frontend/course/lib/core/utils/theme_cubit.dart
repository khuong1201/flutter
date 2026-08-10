import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._storage) : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  final SecureStorageHelper _storage;

  Future<void> _loadSavedTheme() async {
    final themeString = await _storage.getTheme();

    if (themeString != null) {
      if (themeString == 'light') {
        emit(ThemeMode.light);
      } else if (themeString == 'dark') {
        emit(ThemeMode.dark);
      } else {
        emit(ThemeMode.system);
      }
    }
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    String themeString = 'system';
    if (themeMode == ThemeMode.light) {
      themeString = 'light';
    } else if (themeMode == ThemeMode.dark) {
      themeString = 'dark';
    }
    
    await _storage.saveTheme(themeString);
    emit(themeMode);
  }
}

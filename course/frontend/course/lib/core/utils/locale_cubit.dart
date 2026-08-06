import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._storage) : super(WidgetsBinding.instance.platformDispatcher.locale) {
    _loadSavedLocale();
  }

  final SecureStorageHelper _storage;

  Future<void> _loadSavedLocale() async {
    final languageCode = await _storage.getLanguage();

    if (languageCode != null) {
      emit(Locale(languageCode));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    await _storage.saveLanguage(languageCode);
    emit(Locale(languageCode));
  }
}
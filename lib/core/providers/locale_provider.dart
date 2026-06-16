import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi')); // Default to Vietnamese

  void setLocale(Locale locale) {
    state = locale;
  }

  void toggleLocale() {
    if (state.languageCode == 'vi') {
      state = const Locale('en');
    } else {
      state = const Locale('vi');
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

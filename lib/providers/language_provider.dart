import 'package:flutter/material.dart';
import '../core/utils/local_storage.dart';

class LanguageItem {
  final String code;
  final String name;
  final String greeting;

  const LanguageItem({
    required this.code,
    required this.name,
    required this.greeting,
  });
}

class LanguageProvider with ChangeNotifier {
  String _selectedLanguageCode = 'en';

  String get selectedLanguageCode => _selectedLanguageCode;

  final List<LanguageItem> languages = const [
    LanguageItem(code: 'en', name: 'English', greeting: 'Hi'),
    LanguageItem(code: 'hi', name: 'Hindi', greeting: 'नमस्ते'),
    LanguageItem(code: 'bn', name: 'Bengali', greeting: 'হ্যালো'),
    LanguageItem(code: 'kn', name: 'Kannada', greeting: 'ನಮಸ್ಕಾರ'),
    LanguageItem(code: 'pa', name: 'Punjabi', greeting: 'ਸਤ ਸ੍ਰੀ ਅਕਾਲ'),
    LanguageItem(code: 'ta', name: 'Tamil', greeting: 'வணக்கம்'),
    LanguageItem(code: 'te', name: 'Telugu', greeting: 'హలో'),
    LanguageItem(code: 'fr', name: 'French', greeting: 'Bonjour'),
    LanguageItem(code: 'es', name: 'Spanish', greeting: 'Hola'),
  ];

  LanguageItem get currentLanguage =>
      languages.firstWhere((l) => l.code == _selectedLanguageCode,
          orElse: () => languages.first);

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final saved = await LocalStorage.getLanguage();
    if (saved != null) {
      _selectedLanguageCode = saved;
      notifyListeners();
    }
  }

  void selectLanguage(String code) {
    if (_selectedLanguageCode != code) {
      _selectedLanguageCode = code;
      LocalStorage.saveLanguage(code);
      notifyListeners();
    }
  }
}


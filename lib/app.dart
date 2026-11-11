import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/calling_list_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash/splash_screen.dart';

class CalleyApp extends StatelessWidget {
  const CalleyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CallingListProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MaterialApp(
        title: 'Get Calley',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}


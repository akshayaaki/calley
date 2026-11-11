import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/constants/app_colors.dart';
import 'core/network/http_overrides.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure HTTP overrides for dev/mock host SSL certificates
  HttpOverrides.global = CalleyHttpOverrides();

  // Set system UI styling for clean white theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CalleyApp());
}

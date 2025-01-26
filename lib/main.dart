import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primaryColor: const Color(0xFF1D539F),
        colorScheme: ColorScheme(
          primary: const Color(0xFF1D539F),
          secondary: const Color(0xFFD4E4F4),
          surface: const Color(0xFFFFFFFF),
          error: Colors.red,
          onPrimary: const Color(0xFFFFFFFF),
          onSecondary: const Color(0xFF1D539F),
          onSurface: const Color(0xFF333333),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'RussoOne', color: Color(0xFF333333)),
          titleLarge: TextStyle(fontFamily: 'ChakraPetch', fontWeight: FontWeight.bold, color: Color(0xFF1D539F)),
          bodyLarge: TextStyle(fontFamily: 'ChakraPetch', color: Color(0xFF333333)),
          bodyMedium: TextStyle(fontFamily: 'ChakraPetch', color: Color(0xFF1D539F)),
        ),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
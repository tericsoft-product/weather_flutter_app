import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/screens/home_screen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.production");
  } else {
    await dotenv.load(fileName: ".env.development");
  }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const ProviderScope(
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent, // Used for bottom navigation background
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // AppBar background
          foregroundColor: Colors.white, // Text and icon color
        ),
      ),
      home: const HomeScreen(),
    );
  }
}





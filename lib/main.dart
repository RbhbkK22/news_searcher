import 'package:flutter/material.dart';
import 'package:news_app/core/config/config.dart';
import 'package:news_app/feutures/news_list/presentations/news_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await config.load();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        primaryColor: Color(0xff538AE4),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 2, color: Color(0xff538AE4)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: NewsListScreen(),
    );
  }
}

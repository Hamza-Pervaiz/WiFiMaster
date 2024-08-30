import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masterwifi/splashscreen.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => UserProvider()), // Add your provider here
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

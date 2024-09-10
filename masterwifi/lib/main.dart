import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masterwifi/splashscreen.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    // If Firebase initialization is successful, continue with running the app
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(), // Add your provider here
          ),
          // Add other providers here if needed
        ],
        child:
            const MainApp(), // Replace with the correct widget for your main app
      ),
    );
  } catch (e) {
    // Handle initialization errors here
    print("Error initializing Firebase: $e");
  }
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

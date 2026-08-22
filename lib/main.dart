import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/login_screen.dart';
import 'services/fcm_service.dart';

// Global key untuk navigasi deep-link tanpa context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inisialisasi Firebase dengan timeout agar tidak nyangkut selamanya
    await Firebase.initializeApp().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        debugPrint('Firebase initialization timed out, continuing...');
        throw 'Timeout Firebase';
      },
    );

    // Inisialisasi layanan FCM dengan proteksi try-catch
    await FcmService.initialize(navigatorKey);
  } catch (e) {
    debugPrint('Initialization Error (Ignored to bypass splash): $e');
  }

  runApp(const AkuRelawanApp());
}

class AkuRelawanApp extends StatelessWidget {
  const AkuRelawanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AkuRelawan',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

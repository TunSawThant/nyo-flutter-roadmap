import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

// ============================================================
// MAIN.DART - App Entry Point
// ────────────────────────────────────────────────────────────
// Named Routes Setup:
//   ✅ initialRoute - app start point
//   ✅ onGenerateRoute - dynamic route generation
//   ✅ RouteGenerator.generateRoute - centralized route management
// ============================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ── APP CONFIG ─────────────────────────────────────────
      title: 'Named Routes Demo',
      debugShowCheckedModeBanner: false,

      // ── THEME ──────────────────────────────────────────────
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'sans-serif',
      ),

      // ── NAMED ROUTES SETUP ─────────────────────────────────
      //
      // Option 1: routes (simple, static)
      //   routes: {
      //     '/': (context) => LoginScreen(),
      //     '/home': (context) => HomeScreen(),
      //   }
      //   ❌ arguments pass မလုပ်နိုင်
      //
      // Option 2: onGenerateRoute (recommended, dynamic) ✅
      //   - arguments pass လုပ်နိုင်သည်
      //   - route validation လုပ်နိုင်သည်
      //   - unknown route handle လုပ်နိုင်သည်

      // Initial route - app ဖွင့်သောအခါ ပထမဆုံး route
      initialRoute: AppRoutes.login, // '/'

      // Route generator - onGenerateRoute ✅
      onGenerateRoute: RouteGenerator.generateRoute,

      // Unknown route fallback (onGenerateRoute မတွေ့သောအခါ)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: const Color(0xFF0A0E27),
            appBar: AppBar(
              title: const Text('404 - Route Not Found'),
              backgroundColor: Colors.red,
            ),
            body: Center(
              child: Text(
                'Route "${settings.name}" မတွေ့ပါ',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

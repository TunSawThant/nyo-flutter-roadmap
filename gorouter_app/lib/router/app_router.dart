import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/navigation_demo_screen.dart';
import '../screens/data_passing_screen.dart';
import '../screens/error_screen.dart';
import '../widgets/main_scaffold.dart';

// =====================================================
// ROUTE CONSTANTS - Path strings ကို constant ဖြင့်သိမ်းသည်
// Typo မဖြစ်စေရန် ဤနည်းသည် Best Practice ဖြစ်သည်
// =====================================================
abstract class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const productDetail = '/home/product/:productId';
  static const profile = '/profile';
  static const settings = '/settings';
  static const navigationDemo = '/navigation-demo';
  static const dataPassing = '/data-passing';

  // =====================================================
  // Path Parameters ထည့်ရန် Helper Methods
  // =====================================================
  static String productDetailPath(String productId) =>
      '/home/product/$productId';
}

// =====================================================
// GOROUTER CONFIGURATION
// listenable: authService ကို ထည့်ခြင်းဖြင့် Auth State
// ပြောင်းသည်နှင့် Router က Auto-Redirect လုပ်မည်
// =====================================================
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    // Initial Location - App ဖွင့်သည်နှင့် ဤ Route မှ စမည်
    initialLocation: AppRoutes.login,

    // Debug Logging - Development ကာလတွင် Route Changes ကိုကြည့်ရန်
    debugLogDiagnostics: true,

    // =====================================================
    // REDIRECT (Auth Guard)
    // ဤ Function သည် Route Change တိုင်း Run မည်
    // Login မဝင်ဘဲ Protected Routes သို့ မရောက်နိုင်
    // =====================================================
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authService.isLoggedIn;
      final isOnLoginPage = state.matchedLocation == AppRoutes.login;

      // Case 1: Login မဝင်ဘဲ Protected Route သွားလျှင် -> Login ပြသ
      if (!isLoggedIn && !isOnLoginPage) {
        return AppRoutes.login;
      }

      // Case 2: Login ဝင်ပြီး Login Page သွားလျှင် -> Home ပြသ
      if (isLoggedIn && isOnLoginPage) {
        return AppRoutes.home;
      }

      // Case 3: Normal navigation - Redirect မလိုပါ
      return null;
    },

    // Redirect ကို Reactive ဖြစ်စေရန် - AuthService State ပြောင်းသည်နှင့်
    // GoRouter က redirect() ကို Re-run မည်
    refreshListenable: authService,

    // =====================================================
    // ERROR PAGE
    // =====================================================
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // =====================================================
    // ROUTES DEFINITION
    // =====================================================
    routes: [
      // =====================================================
      // LOGIN ROUTE - Shell မပါသော Standalone Route
      // =====================================================
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // =====================================================
      // SHELL ROUTE - Bottom Navigation Bar ပါသော Routes
      // ShellRoute သည် Child Routes တွေကို Persistent Shell
      // (Bottom Nav Bar) ဖြင့် ထုပ်ပိုးပေးသည်
      // =====================================================
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // HOME TAB
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
            routes: [
              // PRODUCT DETAIL - Nested Route (Home > Product Detail)
              GoRoute(
                path: 'product/:productId',
                name: 'product-detail',
                builder: (context, state) {
                  // Path Parameter ထုတ်ယူနည်း
                  final productId = state.pathParameters['productId']!;

                  // Extra Data ထုတ်ယူနည်း (Optional - Type Safe)
                  final extraData = state.extra as Map<String, dynamic>?;
                  final fromSource = extraData?['from'] as String?;

                  return ProductDetailScreen(
                    productId: productId,
                    fromSource: fromSource,
                  );
                },
              ),
            ],
          ),

          // PROFILE TAB
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // NAVIGATION DEMO TAB
          GoRoute(
            path: AppRoutes.navigationDemo,
            name: 'navigation-demo',
            builder: (context, state) => const NavigationDemoScreen(),
          ),

          // DATA PASSING TAB
          GoRoute(
            path: AppRoutes.dataPassing,
            name: 'data-passing',
            builder: (context, state) {
              // Query Parameters ထုတ်ယူနည်း
              final tab = state.uri.queryParameters['tab'] ?? 'query';
              return DataPassingScreen(initialTab: tab);
            },
          ),

          // SETTINGS TAB
          GoRoute(
            path: AppRoutes.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

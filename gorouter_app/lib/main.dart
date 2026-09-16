import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'router/app_router.dart';

/// =====================================================
/// GoRouter Learning App - Main Entry Point
/// =====================================================
/// 
/// ဤ App တွင် သင်ကြားနိုင်သောအကြောင်းအရာများ:
/// 
/// 1. GoRouter Setup & Configuration
/// 2. Route Declaration (GoRoute, ShellRoute)
/// 3. Auth Guard (redirect + refreshListenable)
/// 4. Navigation Methods:
///    - context.push()     : Stack ထဲ ထပ်ထည့်သည်
///    - context.pop()      : Stack မှ ဖယ်ထုတ်သည်
///    - context.go()       : Stack ကို Replace လုပ်သည်
///    - context.replace()  : Current Page ကို Replace လုပ်သည်
///    - context.pushNamed(): Named Route ဖြင့် push()
///    - context.goNamed()  : Named Route ဖြင့် go()
/// 5. Data Passing:
///    - Path Parameters (:id)
///    - Query Parameters (?key=value)
///    - Extra Data (state.extra)
///    - Return Data (pop(data) + push() await)
/// 6. Error Handling (errorBuilder)
/// 7. GoRouterState (Current Route Info)
/// 
/// =====================================================

void main() {
  runApp(
    // ChangeNotifierProvider ဖြင့် AuthService ကို App ထဲတွင် Provide လုပ်သည်
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const GoRouterLearnApp(),
    ),
  );
}

class GoRouterLearnApp extends StatefulWidget {
  const GoRouterLearnApp({super.key});

  @override
  State<GoRouterLearnApp> createState() => _GoRouterLearnAppState();
}

class _GoRouterLearnAppState extends State<GoRouterLearnApp> {
  // GoRouter Instance - AuthService ကို depend လုပ်သည်
  // AuthService State ပြောင်းသည်နှင့် Router က redirect() Re-run မည်
  late final _router = createRouter(context.read<AuthService>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Learn',
      debugShowCheckedModeBanner: false,

      // =====================================================
      // Theme Configuration
      // =====================================================
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: const CardThemeData(
          elevation: 0,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: const CardThemeData(elevation: 0),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          scrolledUnderElevation: 0,
        ),
      ),

      // =====================================================
      // GoRouter ကို MaterialApp.router တွင် ထည့်သည်
      // routerConfig ဖြင့် GoRouter Instance ကို Pass လုပ်သည်
      // =====================================================
      routerConfig: _router,
    );
  }
}

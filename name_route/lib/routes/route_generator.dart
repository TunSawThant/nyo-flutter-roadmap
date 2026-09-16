import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/logout_screen.dart';

// ============================================================
// ROUTE GENERATOR  (ပြင်ဆင်ထားသော version - Type-safe Arguments)
// ════════════════════════════════════════════════════════════
//
// ❌ မူလ code ၏ ပြဿနာများ
// ─────────────────────────────────────────────────────────
//  Problem 1: args == null စစ်ရုံမျှသာ
//    → null မဟုတ်လျှင် ဘာ type မဆိုဖြတ်သွားနိုင်သည်
//    → ဥပမာ: home route ကို String "hello" ဖြင့် ခေါ်ပေမည့်
//             error မဖြစ်ဘဲ HomeScreen ထဲ String ရောက်သွားသည်
//
//  Problem 2: Argument cast လုပ်ခြင်းကို Screen ထဲမှာ လုပ်သည်
//    → route_generator က စစ်ဆေးမပေးဘဲ
//      HomeScreen, DetailScreen တွင် ထပ်စစ်ရသည်
//    → Code ၂ နေရာပြန်ရေးရသည် (duplication)
//
//  Problem 3: Screen ၏ constructor argument type → Object?
//    → Type safety မရှိ၊ IDE autocomplete မကူ
//
// ✅ ပြင်ဆင်ချက်များ
// ─────────────────────────────────────────────────────────
//  Fix 1: "is" keyword ဖြင့် type စစ်ဆေးခြင်း (Type Check)
//    → null check + type check ကို တစ်ပြိုင်နက်လုပ်သည်
//    → မှားသောအခါ ရှင်းလင်းသော error message ပြသည်
//
//  Fix 2: Route generator ထဲမှာသာ cast လုပ်ပြီး
//          typed argument (UserModel, ProductModel) ကို
//          Screen constructor သို့ တိုက်ရိုက် pass လုပ်သည်
//
//  Fix 3: Screen constructor argument → concrete type
//    → HomeScreen(user: UserModel)  ← type-safe ✅
//    → DetailScreen(product: ProductModel)  ← type-safe ✅
//
// ============================================================

class RouteGenerator {
  RouteGenerator._(); // Private constructor — instantiate မလုပ်ရ

  // ══════════════════════════════════════════════════════════
  // MAIN ROUTE GENERATOR
  // MaterialApp(onGenerateRoute: RouteGenerator.generateRoute)
  // ══════════════════════════════════════════════════════════
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //
    // RouteSettings object တွင် ပါဝင်သည်
    // ┌─────────────────────────────────────────┐
    // │ settings.name       → route string      │
    // │                        e.g. '/detail'   │
    // │ settings.arguments  → pass လာသော data  │
    // │                        type: Object?    │
    // └─────────────────────────────────────────┘
    //

    switch (settings.name) {

      // ══════════════════════════════════════════════════════
      // STEP 1 ─ LOGIN ROUTE  '/'
      // Arguments: မလိုအပ် (initial route)
      // ══════════════════════════════════════════════════════
      //
      //  Navigator.pushReplacementNamed(context, AppRoutes.login)
      //  ─ ဤ route မှာ arguments မပါဘဲ ခေါ်သောကြောင့်
      //    check မလုပ်ဘဲ တိုက်ရိုက် return ပြန်သည်
      //
      case AppRoutes.login:
        return _buildRoute(
          settings: settings,
          child: const LoginScreen(),
        );

      // ══════════════════════════════════════════════════════
      // STEP 2 ─ HOME ROUTE  '/home'
      // Expected Argument: UserModel (login မှ pass လာသည်)
      // ══════════════════════════════════════════════════════
      //
      //  Login page မှ ဤပုံစံဖြင့် ခေါ်သည်:
      //  Navigator.pushReplacementNamed(
      //    context,
      //    AppRoutes.home,
      //    arguments: userModel,   ← UserModel object
      //  );
      //
      //  စစ်ဆေးပုံ (3 ဆင့်):
      //  ┌──────────────────────────────────────────────┐
      //  │ ①  settings.arguments ကို local variable သိမ်း│
      //  │ ②  "is UserModel" ဖြင့် type check လုပ်သည်  │
      //  │ ③  မှန်ကန်လျှင် cast ပြီး Screen သို့ pass   │
      //  └──────────────────────────────────────────────┘
      //
      case AppRoutes.home:
        // ① arguments ကို raw form ဖြင့် ယူသည် (type: Object?)
        final args = settings.arguments;

        // ② Type check — "is" keyword
        //    args is UserModel
        //    ↓
        //    true  → args သည် UserModel instance ဖြစ်သည်
        //            Dart compiler ၎င်းကို UserModel အဖြစ် smart cast လုပ်ပေးသည်
        //    false → UserModel မဟုတ် (null / wrong type)
        //            _typeErrorRoute() ကိုသွားသည်
        if (args is! UserModel) {
          // ❌ Fail: null ဖြစ်ပါက သို့မဟုတ် UserModel မဟုတ်ပါက
          return _typeErrorRoute(
            routeName: AppRoutes.home,
            expected: 'UserModel',
            received: args, // debug: ဘာ type ရောက်လာသည် ကိုပြသည်
          );
        }

        // ③ ဤနေရာမှာ args ၏ type သည် UserModel အဖြစ်
        //    Dart က automatically smart-cast လုပ်ထားသည်
        //    (explicit "(args as UserModel)" မလုပ်ရတော့)
        //    args.username, args.email etc. တိုက်ရိုက်သုံးနိုင်
        return _buildRoute(
          settings: settings,
          child: HomeScreen(user: args), // ← typed! Object? မဟုတ်
        );

      // ══════════════════════════════════════════════════════
      // STEP 3 ─ DETAIL ROUTE  '/detail'
      // Expected Argument: ProductModel (home မှ pass လာသည်)
      // ══════════════════════════════════════════════════════
      //
      //  Home page မှ ဤပုံစံဖြင့် ခေါ်သည်:
      //  final result = await Navigator.pushNamed(
      //    context,
      //    AppRoutes.detail,
      //    arguments: product,   ← ProductModel object
      //  );
      //
      case AppRoutes.detail:
        final args = settings.arguments;

        if (args is! ProductModel) {
          return _typeErrorRoute(
            routeName: AppRoutes.detail,
            expected: 'ProductModel',
            received: args,
          );
        }

        // Smart cast → args is ProductModel ✅
        return _buildRoute(
          settings: settings,
          child: DetailScreen(product: args), // ← typed!
        );

      // ══════════════════════════════════════════════════════
      // STEP 4 ─ LOGOUT ROUTE  '/logout'
      // Expected Argument: UserModel (optional — null ခွင့်ပြု)
      // ══════════════════════════════════════════════════════
      //
      //  Logout page မှာ user info ပြသရန် UserModel လိုသည်
      //  သို့သော် null ဖြစ်ပါကလည် fallback ဖြင့် ဆက်သွားနိုင်သည်
      //
      //  ① null ဖြစ်နိုင်ကြောင်း လက်ခံသည်  (UserModel?)
      //  ② null မဟုတ်လျှင်သာ type check လုပ်သည်
      //  ③ မှားသော type လျှင် warning error ပြသည်
      //
      case AppRoutes.logout:
        final args = settings.arguments;

        // Logout ကို null arguments ဖြင့်လည်းခေါ်ခွင့်ပြုသည်
        // သို့သော် null မဟုတ်ဘဲ UserModel လည်းမဟုတ်ပါက error
        if (args != null && args is! UserModel) {
          return _typeErrorRoute(
            routeName: AppRoutes.logout,
            expected: 'UserModel (or null)',
            received: args,
          );
        }

        // args is UserModel? → UserModel သို့မဟုတ် null
        // as UserModel? ဖြင့် safe cast
        return _buildRoute(
          settings: settings,
          child: LogoutScreen(user: args as UserModel?), // nullable ✅
        );

      // ══════════════════════════════════════════════════════
      // STEP 5 ─ UNKNOWN ROUTE (404)
      // settings.name မည်သည့် case နှင့်မှ မကိုက်ညီသောအခါ
      // ══════════════════════════════════════════════════════
      default:
        return _notFoundRoute(settings.name);
    }
  }

  // ══════════════════════════════════════════════════════════
  // HELPER METHODS
  // ══════════════════════════════════════════════════════════

  /// Route တည်ဆောက်ခြင်း — transition animation standard
  /// ─────────────────────────────────────────────────────
  /// [settings] → HistoryEntry / deeplink tracking အတွက်
  /// [child]    → ပြသမည့် Screen widget
  static MaterialPageRoute<dynamic> _buildRoute({
    required RouteSettings settings,
    required Widget child,
  }) {
    return MaterialPageRoute(
      settings: settings, // ← route name & args မှတ်တမ်းတင်ထားသည်
      builder: (_) => child,
    );
  }

  // ──────────────────────────────────────────────────────────
  // TYPE ERROR ROUTE
  // Argument type မှားသောအခါ ပြသသည်
  // Developer ကို မည်သည့် type လိုအပ်ကြောင်း ရှင်းပြသည်
  // ──────────────────────────────────────────────────────────
  //
  //  ဤ route ကို ပြသသောအခါ —
  //  • routeName  → မည်သည့် route သို့ navigate လုပ်ခဲ့သည်
  //  • expected   → မည်သည့် type လိုအပ်သည်
  //  • received   → မည်သည့် type ရောက်လာသည်
  //
  static Route<dynamic> _typeErrorRoute({
    required String routeName,
    required String expected,
    required Object? received,
  }) {
    // received type ကို string အဖြစ် ဖော်ပြသည်
    final receivedType = received == null ? 'null' : received.runtimeType.toString();

    return MaterialPageRoute(
      builder: (_) => _ErrorScreen(
        title: 'Argument Type Error',
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        lines: [
          _ErrorLine(label: 'Route', value: routeName),
          _ErrorLine(label: 'Expected Type', value: expected),
          _ErrorLine(label: 'Received Type', value: receivedType),
          _ErrorLine(
            label: 'Fix',
            value: 'Navigator.pushNamed(\n'
                '  context, "$routeName",\n'
                '  arguments: $expected(),\n'
                ');',
            isCode: true,
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────
  // NOT FOUND ROUTE (404)
  // Route name မတွေ့သောအခါ
  // ──────────────────────────────────────────────────────────
  static Route<dynamic> _notFoundRoute(String? name) {
    return MaterialPageRoute(
      builder: (_) => _ErrorScreen(
        title: '404 - Route Not Found',
        icon: Icons.route_outlined,
        iconColor: Colors.red,
        lines: [
          _ErrorLine(label: 'Requested', value: name ?? '(null)'),
          const _ErrorLine(label: 'Available Routes', value:
            '/ → Login\n'
            '/home → Home\n'
            '/detail → Detail\n'
            '/logout → Logout',
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ERROR SCREEN WIDGET
// Type error နှင့် 404 အတွက် ပြသသည်
// Developer-friendly error message
// ══════════════════════════════════════════════════════════════

class _ErrorScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<_ErrorLine> lines;

  const _ErrorScreen({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1235),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Center(
              child: Icon(icon, size: 64, color: iconColor),
            ),
            const SizedBox(height: 24),

            // Error details
            ...lines.map((line) => _buildLine(line)),
          ],
        ),
      ),
    );
  }

  Widget _buildLine(_ErrorLine line) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: line.isCode
            ? Colors.black45
            : Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: line.isCode
              ? Colors.white24
              : Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.label,
            style: TextStyle(
              color: iconColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            line.value,
            style: TextStyle(
              color: line.isCode
                  ? const Color(0xFF3ECFCF)
                  : Colors.white,
              fontSize: 13,
              fontFamily: line.isCode ? 'monospace' : null,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Error line data class
class _ErrorLine {
  final String label;
  final String value;
  final bool isCode;

  const _ErrorLine({
    required this.label,
    required this.value,
    this.isCode = false,
  });
}

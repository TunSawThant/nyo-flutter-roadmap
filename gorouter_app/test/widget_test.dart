// =====================================================
// GoRouter Learning App - Widget / Integration Tests
// =====================================================
//
// ဤ File သည် မူလ Flutter Template ၏ Counter Test ကို အစားထိုးထားခြင်း ဖြစ်သည်။
// (မူလ Template Test သည် ဤ App တွင် မရှိသော `MyApp` ကို ရည်ညွှန်းထားသောကြောင့်
//  `flutter test` ကို Compile Error ဖြင့် ကျရှုံးစေခဲ့သည်)
//
// Run: flutter test
//
// စစ်ဆေးသော GoRouter Behaviour များ:
//   1. App စတင်လျှင် /login တွင် ရောက်ခြင်း
//   2. Auth Guard - Login မဝင်ဘဲ Protected Route သွားလျှင် /login သို့ Redirect
//   3. Login အောင်မြင်လျှင် /home သို့ Auto-Redirect (refreshListenable)
//   4. Login မှားလျှင် Error Message ပြခြင်း
//   5. Logout လုပ်လျှင် /login သို့ Auto-Redirect
//   6. မရှိသော Route အတွက် 404 ErrorScreen ပြခြင်း (errorBuilder)
//   7. Path Parameter + Extra Data ရရှိခြင်း
//   8. Return Data (push() await + pop(data))
//   9. Query Parameter (?tab=...) က Tab ကို ရွှေ့ခြင်း
//  10. AuthService Unit Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gorouter_app/main.dart';
import 'package:gorouter_app/router/app_router.dart';
import 'package:gorouter_app/services/auth_service.dart';

/// AuthService ၏ Mock Delay (1500ms / 800ms) ထက် အနည်းငယ် ပိုရှည်သော အချိန်
const _afterLogin = Duration(milliseconds: 1600);
const _afterLogout = Duration(milliseconds: 900);

/// Router ကို Test ထဲမှ တိုက်ရိုက်ထိန်းချုပ်နိုင်သော Test Harness
class _Harness {
  final AuthService auth = AuthService();
  late final GoRouter router = createRouter(auth);

  Widget get app => ChangeNotifierProvider<AuthService>.value(
    value: auth,
    child: MaterialApp.router(routerConfig: router),
  );
}

/// App ကို Start လုပ်ပြီး Animation များ ပြီးဆုံးသည်အထိ စောင့်သည်
Future<_Harness> _pumpApp(WidgetTester tester) async {
  final harness = _Harness();
  await tester.pumpWidget(harness.app);
  await tester.pumpAndSettle();
  return harness;
}

/// Login ဝင်ပြီးသား (Home ရောက်ပြီးသား) အခြေအနေအထိ ယူသည်
Future<_Harness> _pumpLoggedInApp(WidgetTester tester) async {
  final harness = await _pumpApp(tester);
  harness.auth.quickLoginAsAdmin();
  await tester.pumpAndSettle();
  expect(find.text('GoRouter Courses'), findsOneWidget);
  return harness;
}

void main() {
  group('App Startup & Auth Guard', () {
    testWidgets('app boots into the login screen', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
          child: const GoRouterLearnApp(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GoRouter Learn'), findsOneWidget);
      expect(find.text('Login ဝင်ရောက်ပါ'), findsOneWidget);
    });

    testWidgets('protected route redirects to /login when logged out', (
      tester,
    ) async {
      final harness = await _pumpApp(tester);

      harness.router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      expect(find.text('Login ဝင်ရောက်ပါ'), findsOneWidget);
      expect(find.text('GoRouter Courses'), findsNothing);
    });
  });

  group('Login', () {
    testWidgets('valid credentials navigate to home', (tester) async {
      final harness = await _pumpApp(tester);

      await tester.tap(find.text('Login ဝင်ရောက်ပါ'));
      await tester.pump();

      // Loading အခြေအနေတွင် Progress Indicator ပြရမည်
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(_afterLogin);
      await tester.pumpAndSettle();

      expect(harness.auth.isLoggedIn, isTrue);
      expect(find.text('GoRouter Courses'), findsOneWidget);
    });

    testWidgets('wrong password shows an error message', (tester) async {
      final harness = await _pumpApp(tester);

      await tester.enterText(find.byType(TextFormField).last, 'wrong-password');
      await tester.tap(find.text('Login ဝင်ရောက်ပါ'));
      await tester.pump();
      await tester.pump(_afterLogin);
      await tester.pumpAndSettle();

      expect(find.text('Email သို့ Password မှားနေသည်။'), findsOneWidget);
      expect(harness.auth.isLoggedIn, isFalse);
      // မူလက Error ဖြစ်လျှင် Loading State ကျန်နေနိုင်သည် - ယခု အမြဲ Reset ဖြစ်သည်
      expect(harness.auth.isLoading, isFalse);
    });
  });

  group('Navigation', () {
    testWidgets('logout redirects back to /login', (tester) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go(AppRoutes.profile);
      await tester.pumpAndSettle();

      final logoutButton = find.text('Logout');
      await tester.ensureVisible(logoutButton);
      await tester.pumpAndSettle();
      await tester.tap(logoutButton);
      await tester.pump();
      await tester.pump(_afterLogout);
      await tester.pumpAndSettle();

      expect(harness.auth.isLoggedIn, isFalse);
      expect(find.text('Login ဝင်ရောက်ပါ'), findsOneWidget);
    });

    testWidgets('unknown route shows the 404 error screen', (tester) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go('/this-route-does-not-exist');
      await tester.pumpAndSettle();

      expect(find.text('404'), findsOneWidget);
      expect(find.text('Page မတွေ့ပါ'), findsOneWidget);
    });

    testWidgets('path parameter and extra data reach the detail screen', (
      tester,
    ) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go(
        AppRoutes.productDetailPath('p002'),
        extra: {'from': 'widget_test'},
      );
      await tester.pumpAndSettle();

      // Path Parameter က Product ကို ရွေးချယ်ပြီး Extra Data က Badge တွင် ပြသည်
      expect(find.text('Dart Programming Mastery'), findsWidgets);
      expect(find.text('Extra Data: from = "widget_test"'), findsOneWidget);
    });

    testWidgets('pop(data) returns data to the caller', (tester) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go('${AppRoutes.dataPassing}?tab=return');
      await tester.pumpAndSettle();

      final openButton = find.text('Product Detail ဖွင့်ပြီး Data ပြန်ရမည်');
      await tester.ensureVisible(openButton);
      await tester.pumpAndSettle();
      await tester.tap(openButton);
      await tester.pumpAndSettle();

      expect(find.text('Flutter UI Design Kit'), findsWidgets);

      await tester.tap(find.text('pop(data)'));
      await tester.pumpAndSettle();

      // pop(data) ဖြင့် ပြန်ပို့သော Map ကို Caller တွင် ပြရမည်
      // (`action: purchased` ဟု Quote မပါဘဲ ရှာသည် - Code Block ထဲရှိ
      //  `'action': 'purchased'` နှင့် မတူစေရန်)
      expect(find.textContaining('action: purchased'), findsOneWidget);
    });
  });

  group('Query Parameters', () {
    testWidgets('?tab= selects the matching tab', (tester) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go('${AppRoutes.dataPassing}?tab=path');
      await tester.pumpAndSettle();
      expect(find.text('Path Parameters (:paramName)'), findsOneWidget);
    });

    testWidgets('changing ?tab= on the same route switches the tab', (
      tester,
    ) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go('${AppRoutes.dataPassing}?tab=path');
      await tester.pumpAndSettle();
      expect(find.text('Path Parameters (:paramName)'), findsOneWidget);

      // BUG FIX REGRESSION: Route သည် တူညီသော်လည်း Query Param ပြောင်းလျှင်
      // State ကို ပြန်မဖန်တီးသောကြောင့် မူလက Tab မပြောင်းခဲ့ပါ။
      harness.router.go('${AppRoutes.dataPassing}?tab=extra');
      await tester.pumpAndSettle();
      expect(find.text('Extra Data (state.extra)'), findsOneWidget);
    });

    testWidgets('in-page query buttons switch the visible tab', (tester) async {
      final harness = await _pumpLoggedInApp(tester);

      harness.router.go('${AppRoutes.dataPassing}?tab=query');
      await tester.pumpAndSettle();

      final button = find.text('/data-passing?tab=extra');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Extra Data (state.extra)'), findsOneWidget);
    });
  });

  group('Layout on a narrow phone screen', () {
    /// ကျဉ်းသော Phone မျက်နှာပြင် (360x640 logical) ကို အသုံးပြုသည်
    void useNarrowScreen(WidgetTester tester, Size logicalSize) {
      tester.view.physicalSize = logicalSize * 3;
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    // ကျဉ်းသော Device နှစ်မျိုးဖြင့် စမ်းသပ်သည်
    // 360x640 = အသုံးများသော Android Phone
    // 320x568 = အသေးဆုံး ပံ့ပိုးမည့် မျက်နှာပြင် (iPhone SE ကဲ့သို့)
    for (final size in const [Size(360, 640), Size(320, 568)]) {
      final label = '${size.width.toInt()}x${size.height.toInt()}';

      testWidgets('$label - every screen renders without an overflow', (
        tester,
      ) async {
        useNarrowScreen(tester, size);

        final harness = await _pumpApp(tester);
        expect(
          tester.takeException(),
          isNull,
          reason: 'Login screen overflow at $label',
        );

        harness.auth.quickLoginAsAdmin();
        await tester.pumpAndSettle();

        // Screen တစ်ခုချင်းစီကို ကျဉ်းသော မျက်နှာပြင်တွင် Render လုပ်ပြီး
        // Overflow Error မတက်ကြောင်း စစ်သည် (RenderFlex Overflow သည်
        // Test တွင် Exception အဖြစ် အလိုအလျောက် ပေါ်လာသည်)
        final failures = <String>[];

        for (final location in [
          AppRoutes.home,
          AppRoutes.profile,
          AppRoutes.settings,
          AppRoutes.navigationDemo,
          AppRoutes.productDetailPath('p001'),
          '${AppRoutes.dataPassing}?tab=query',
          '${AppRoutes.dataPassing}?tab=extra',
          '${AppRoutes.dataPassing}?tab=path',
          '${AppRoutes.dataPassing}?tab=return',
        ]) {
          harness.router.go(location);
          await tester.pumpAndSettle();

          final exception = tester.takeException();
          if (exception != null) {
            failures.add('$location → $exception');
          }
        }

        // Screen အားလုံး အောင်မြင်ရမည် (မအောင်မြင်လျှင် မည်သည့် Route မှာ
        // ဖြစ်သည်ကို မြင်နိုင်ရန် စာရင်းအားလုံးကို ပြသည်)
        expect(failures, isEmpty, reason: failures.join('\n'));
      });
    }
  });

  group('AuthService', () {
    test('login succeeds with the demo credentials', () async {
      final auth = AuthService();

      expect(
        await auth.login(AuthService.demoEmail, AuthService.demoPassword),
        isTrue,
      );
      expect(auth.isLoggedIn, isTrue);
      expect(auth.currentUser?.name, 'Ko Aung');
      expect(auth.isLoading, isFalse);
    });

    test('login ignores case and surrounding spaces in the email', () async {
      final auth = AuthService();

      expect(
        await auth.login('  MATHIDA@Example.com ', AuthService.demoPassword),
        isTrue,
      );
      expect(auth.currentUser?.name, 'Ma Thida');
    });

    test('login fails with a wrong password', () async {
      final auth = AuthService();

      expect(
        await auth.login(AuthService.demoEmail, 'wrong-password'),
        isFalse,
      );
      expect(auth.isLoggedIn, isFalse);
      expect(auth.isLoading, isFalse);
    });

    test('logout clears the current user', () async {
      final auth = AuthService()..quickLoginAsAdmin();
      expect(auth.isLoggedIn, isTrue);

      await auth.logout();

      expect(auth.isLoggedIn, isFalse);
      expect(auth.currentUser, isNull);
      expect(auth.isLoading, isFalse);
    });
  });
}

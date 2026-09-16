# 🗺️ GoRouter Setup & Route Declaration

> ဖိုင်: `lib/router/app_router.dart`
> GoRouter ၏ Setup မှ Route Tree ဆောက်ပုံကို အဆင့်ဆင့် ဖော်ပြသည်

---

## 1. Route Constants (AppRoutes class)

```dart
// lib/router/app_router.dart

abstract class AppRoutes {
  // ─── Static Route Paths ───────────────────────────────────
  static const login           = '/login';
  static const home            = '/home';
  static const profile         = '/profile';
  static const navigationDemo  = '/navigation-demo';
  static const dataPassing     = '/data-passing';
  static const settings        = '/settings';

  // ─── Dynamic Route Path Builder ──────────────────────────
  //  :productId ပါသော Path ကို ဤ Method ဖြင့် တည်ဆောက်သည်
  static String productDetailPath(String productId) =>
      '/home/product/$productId';

  // Usage:
  // context.push(AppRoutes.productDetailPath('p001'));
  // → '/home/product/p001'
}
```

**ဘာကြောင့် `abstract class` သုံးသနည်း?**

```dart
// abstract class ဆိုသောကြောင့် Instance Create လုပ်မရ
// AppRoutes() ← Error! ဤနည်းဖြင့် create မရ

// static members ကိုသာ Access လုပ်နိုင်
AppRoutes.login          // '/login'  ✅
AppRoutes.home           // '/home'   ✅
```

---

## 2. GoRouter Factory Function

```dart
// Function Signature — AuthService ကို Parameter ဖြင့်ယူသည်
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    // ─── Basic Config ──────────────────────────────────────

    // App ဖွင့်သည်နှင့် ဤ URL မှ စမည်
    initialLocation: AppRoutes.login,

    // Development တွင် Route Changes ကို Console Log တွင်ကြည့်ရန်
    // Production Build တွင် false ထားသင့်သည်
    debugLogDiagnostics: true,

    // ─── Auth Guard ────────────────────────────────────────
    redirect: (BuildContext context, GoRouterState state) { ... },

    // Auth State ပြောင်းသည်နှင့် redirect() ကို Auto Re-run
    refreshListenable: authService,

    // ─── Error Handling ────────────────────────────────────
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // ─── Route Tree ────────────────────────────────────────
    routes: [ ... ],
  );
}
```

---

## 3. redirect() — Auth Guard

```dart
redirect: (BuildContext context, GoRouterState state) {

  final isLoggedIn  = authService.isLoggedIn;
  final isOnLogin   = state.matchedLocation == AppRoutes.login;

  // ──────────────────────────────────────────────────────────
  // Case 1: Login မဝင်ဘဲ Protected Route သွားလျှင်
  //   /home, /profile, /settings, ... → /login redirect
  // ──────────────────────────────────────────────────────────
  if (!isLoggedIn && !isOnLogin) {
    return AppRoutes.login;   // String ပြန်ပေး = Redirect Target
  }

  // ──────────────────────────────────────────────────────────
  // Case 2: Login ဝင်ပြီးပြီ ဆိုပြီး /login ကိုသွားမိသောအခါ
  //   /login → /home redirect (Unnecessary double login ကာကွယ်)
  // ──────────────────────────────────────────────────────────
  if (isLoggedIn && isOnLogin) {
    return AppRoutes.home;    // /home သို့ Redirect
  }

  // ──────────────────────────────────────────────────────────
  // Case 3: Normal Navigation — Redirect မလို
  // ──────────────────────────────────────────────────────────
  return null;  // null ပြန်ပေး = Navigate ကို Allow
},

// ─── refreshListenable ─────────────────────────────────────
// AuthService.notifyListeners() ခေါ်တိုင်း redirect() Re-run မည်
// Logout → notifyListeners() → redirect() → /login
refreshListenable: authService,
```

**redirect() Logic ဇယား:**

| isLoggedIn | isOnLogin | redirect() Result |
|-----------|-----------|------------------|
| `false` | `false` | `'/login'` — Protected page → Login |
| `false` | `true`  | `null` — Stay on Login (OK) |
| `true`  | `true`  | `'/home'` — Already logged, skip Login |
| `true`  | `false` | `null` — Normal navigation (OK) |

---

## 4. Route Tree

### 4a. Standalone Route (Shell မပါ)

```dart
routes: [
  // ─── Login Route ───────────────────────────────────────
  // Shell မပါ (Bottom Nav မပြ)
  GoRoute(
    path: AppRoutes.login,   // '/login'
    name: 'login',
    builder: (context, state) => const LoginScreen(),
  ),

  // ─── Shell Route ───────────────────────────────────────
  // Bottom Nav Bar ပါသော Routes Group
  ShellRoute(
    builder: (context, state, child) {
      // child = Active Tab ၏ Screen Widget
      return MainScaffold(child: child);
    },
    routes: [ ... ],  // Tab Routes ဤနေရာတွင်
  ),
],
```

### 4b. ShellRoute ထဲ Routes

```dart
ShellRoute(
  builder: (context, state, child) => MainScaffold(child: child),
  routes: [

    // ─── Home Tab ────────────────────────────────────────
    GoRoute(
      path: AppRoutes.home,   // '/home'
      name: 'home',
      builder: (context, state) => const HomeScreen(),

      // Nested Child Route
      routes: [
        GoRoute(
          path: 'product/:productId',
          // Full path: /home/product/:productId
          name: 'product-detail',
          builder: (context, state) {
            // Path Parameter ရယူနည်း
            final productId = state.pathParameters['productId']!;

            // Extra Data ရယူနည်း (Type Cast လုပ်ရ)
            final extra = state.extra as Map<String, dynamic>?;
            final fromSource = extra?['from'] as String?;

            return ProductDetailScreen(
              productId: productId,
              fromSource: fromSource,
            );
          },
        ),
      ],
    ),

    // ─── Profile Tab ─────────────────────────────────────
    GoRoute(
      path: AppRoutes.profile,   // '/profile'
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // ─── Navigation Demo Tab ─────────────────────────────
    GoRoute(
      path: AppRoutes.navigationDemo,  // '/navigation-demo'
      name: 'navigation-demo',
      builder: (context, state) => const NavigationDemoScreen(),
    ),

    // ─── Data Passing Tab ────────────────────────────────
    GoRoute(
      path: AppRoutes.dataPassing,   // '/data-passing'
      name: 'data-passing',
      builder: (context, state) {
        // Query Parameter ရယူနည်း
        final tab = state.uri.queryParameters['tab'] ?? 'query';
        return DataPassingScreen(initialTab: tab);
      },
    ),

    // ─── Settings Tab ────────────────────────────────────
    GoRoute(
      path: AppRoutes.settings,   // '/settings'
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
),
```

---

## 5. Route Matching ဘယ်လို အလုပ်လုပ်သနည်း?

URL တစ်ခု Navigate လုပ်သောအခါ GoRouter ဤ Sequence ဖြင့် Route ကို ရှာသည်:

```
URL: /home/product/p001

Step 1: Top-level Routes ကြည့်သည်
  /login          ← မကိုက်
  ShellRoute      ← Child Routes စစ်မည်

Step 2: ShellRoute ၏ Child Routes ကြည့်သည်
  /home           ← ကိုက်! Child Routes စစ်မည်

Step 3: /home ၏ Child Routes ကြည့်သည်
  product/:productId ← /home/product/p001 နှင့် ကိုက်!
  pathParameters['productId'] = 'p001'

Step 4: ProductDetailScreen Build ✅
```

---

## 6. GoRoute Parameters တစ်ခုချင်းစီ ရှင်းလင်းချက်

```dart
GoRoute(
  // ─── Required ────────────────────────────────────────────
  path: 'product/:productId',
  // URL pattern. ':productId' သည် Variable segment ဖြစ်သည်
  // /home/ ထဲ ဤ Route ရှိသောကြောင့် full path = /home/product/:productId

  // ─── Optional ────────────────────────────────────────────
  name: 'product-detail',
  // Named Route alias. goNamed('product-detail') ဖြင့် Navigate နိုင်

  // ─── Required ────────────────────────────────────────────
  builder: (BuildContext context, GoRouterState state) {
    // state.pathParameters   → Path Params
    // state.uri.queryParameters → Query Params
    // state.extra            → Extra Object
    // state.uri              → Full URI
    // state.matchedLocation  → Matched Path String
    // state.name             → Route Name
    return ProductDetailScreen(...);
  },

  // ─── Optional ────────────────────────────────────────────
  routes: [
    // Child/Nested Routes ထည့်နိုင်သည်
  ],

  // ─── Optional ────────────────────────────────────────────
  redirect: (context, state) {
    // Route-specific redirect (Global redirect မဟုတ်)
    return null;
  },
)
```

---

## 7. GoRouterState Properties

```dart
builder: (context, state) {
  // URL: /home/product/p001?ref=home

  state.uri                    // Uri object: /home/product/p001?ref=home
  state.uri.path               // '/home/product/p001'
  state.uri.queryParameters    // {'ref': 'home'}
  state.matchedLocation        // '/home/product/p001'
  state.pathParameters         // {'productId': 'p001'}
  state.name                   // 'product-detail'
  state.extra                  // extra object (or null)
  state.error                  // Exception (errorBuilder တွင်)
  state.pageKey                // Unique Page Key
}
```

---

> **Next:** `04_navigation_methods.md` တွင် push/pop/go/replace ကို ကြည့်ပါ

# 🗺️ GoRouter Complete Learning Guide
### Flutter Navigation ကို အဆင့်ဆင့် နားလည်မည်

> **ဤ Guide သည် `gorouter_app` Project ကို Base ထားပြီး GoRouter ကို A မှ Z အထိ သင်ကြားပေးသည်**
> 
> **App Run နည်း:** `flutter run` → Email: `koaung@example.com` / Password: `password123`

---

## 📚 သင်ကြားမည့် အကြောင်းအရာများ (ကြာချိန်: ~2 နာရီ)

| Step | Topic | ဘယ် File တွင်ကြည့်မလဲ |
|------|-------|----------------------|
| 1 | Navigator 1.0 vs GoRouter | ဤ Guide ပဲ |
| 2 | Setup & pubspec.yaml | `lib/main.dart` |
| 3 | Route Declaration (GoRoute) | `lib/router/app_router.dart` |
| 4 | ShellRoute & Bottom Nav | `lib/widgets/main_scaffold.dart` |
| 5 | Auth Guard (redirect) | `lib/services/auth_service.dart` |
| 6 | push() / pop() / go() / replace() | `lib/screens/navigation_demo_screen.dart` |
| 7 | Data Passing Methods | `lib/screens/data_passing_screen.dart` |
| 8 | Named Routes | `lib/screens/navigation_demo_screen.dart` |
| 9 | Return Data from Routes | `lib/screens/data_passing_screen.dart` |
| 10 | Error Handling | `lib/screens/error_screen.dart` |
| 11 | GoRouterState | `lib/screens/settings_screen.dart` |
| 12 | Best Practices | ဤ Guide ပဲ |

---

## 🎯 Step 1: Navigator 1.0 vs GoRouter

### ❌ Navigator 1.0 ၏ ပြဿနာများ

Flutter ၏ မူလ Navigation System ဖြစ်သော Navigator 1.0 ကို အရင်ကြည့်ကြည့်ပါ:

```dart
// Navigator 1.0 — Push
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => DetailScreen(id: id)),
);

// Navigator 1.0 — Pop
Navigator.of(context).pop();

// Named Route ဖြင့် Navigate
Navigator.of(context).pushNamed('/detail', arguments: id);
```

**ပြဿနာ 1: Deep Link မအလုပ်လုပ်**
```
URL: myapp.com/product/123 ကို App ဖွင့်သည်နှင့်
→ Product Detail Page တိုက်ရိုက် မပွင့်လာ
→ App ၏ Home Page သာ ပွင့်လာမည်
```

**ပြဿနာ 2: Web URL Bar ကို မအသုံးပြုနိုင်**
```
Web Browser တွင် Back Button နှိပ်သည်နှင့် URL မပြောင်း
URL Bar တွင် /profile Type ကြည့်သောအခါ Page မပွင့်
```

**ပြဿနာ 3: Auth Guard ရေးရခက်**
```dart
// Login မဝင်ဘဲ Protected Page သွားတာ ကာကွယ်ရန်
// → နေရာတိုင်းတွင် ဤ Code ထည့်ရမည်! (Code Duplication ဆိုးသည်)
if (!isLoggedIn) {
  Navigator.of(context).pushReplacementNamed('/login');
  return;
}
```

**ပြဿနာ 4: URL ကို မသိနိုင်**
```dart
// "User ဘယ် Page တွင် ရှိသနည်း?" ကို URL မသုံးဘဲ သိရန် ခက်သည်
// Analytics, Deep Linking မလုပ်နိုင်
```

### ✅ GoRouter ဖြင့် ဖြေရှင်းနည်း

```dart
// GoRouter — URL-based Navigation
context.go('/product/123');    // URL ပါပြောင်းသည် ✅
context.push('/product/123');  // Stack ထဲ ထပ်ထည့်သည် ✅

// Auth Guard — တစ်နေရာတည်းသာ ရေးရသည် ✅
redirect: (context, state) {
  if (!isLoggedIn) return '/login'; // Auto-Redirect
  return null;                       // Allow Navigation
},
```

**GoRouter ကောင်းသောအချက်များ:**
- 🔗 Deep Link — URL ဖြင့် တိုက်ရိုက် Page သို့ ရောက်နိုင်သည်
- 🌐 Web URL Bar — Browser ၏ Back/Forward အလုပ်လုပ်သည်
- 🛡️ Auth Guard — တစ်နေရာတည်းသာ ရေးရသည်
- 🏷️ Named Routes — Path String မမှတ်ရ
- 📦 ShellRoute — Bottom Nav Persistent ဖြစ်သည်
- ✅ Google Official Package

---

## 🎯 Step 2: GoRouter Setup

### pubspec.yaml တွင် ထည့်ရသောအကြောင်း

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^17.5.0   # ← GoRouter Package
  provider: ^6.1.5     # ← State Management (Auth State Share ရန်)
```

> **Why go_router Package ထည့်ရသနည်း?**
>
> Flutter SDK ထဲတွင် GoRouter မပါဝင်ပါ။ Google ၏ Official Package ဖြစ်သော
> `go_router` ကို သီးသန့် Install လုပ်ရမည်။ `flutter pub add go_router`
> ဖြင့် ထည့်နိုင်သည်။

### main.dart — App Entry Point

ဖိုင်: `lib/main.dart`

```dart
void main() {
  runApp(
    // [1] Provider ဖြင့် AuthService ကို Wrap လုပ်သည်
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const GoRouterLearnApp(),
    ),
  );
}
```

> **Why ChangeNotifierProvider ဖြင့် Wrap လုပ်သနည်း?**
>
> AuthService သည် Login/Logout State ကို ထိန်းသည်။ App ၏ မည်သည့် Widget
> မှမဆို `context.read<AuthService>()` ဖြင့် Access လုပ်နိုင်ရန်
> Provider ဖြင့် App Level တွင် Wrap လုပ်ရသည်။
> GoRouter ၏ `refreshListenable` ကလည်း ဤ AuthService Instance ကိုသုံးသောကြောင့်
> App Level တွင် Create လုပ်ထားရသည်။

```dart
class _GoRouterLearnAppState extends State<GoRouterLearnApp> {
  // [2] GoRouter Instance — AuthService ဖြင့် Create
  late final _router = createRouter(context.read<AuthService>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // [3] MaterialApp.router ကိုသုံးရမည် (MaterialApp မဟုတ်)
      routerConfig: _router,
    );
  }
}
```

> **Why MaterialApp.router ကိုသုံးသနည်း?**
>
> Regular `MaterialApp` သည် Navigator 1.0 ကိုသုံးသောကြောင့် GoRouter နှင့်
> Compatible မဟုတ်ပါ။ `MaterialApp.router` သည် `routerConfig` parameter ကို
> လက်ခံပြီး GoRouter ကို Navigation System အဖြစ် Register လုပ်ပေးသည်။
> `routerConfig` ထည့်မပေးလျှင် GoRouter က Route ကို Control မလုပ်နိုင်ပါ။

---

## 🎯 Step 3: Route Declaration

ဖိုင်: `lib/router/app_router.dart`

### Route Constants — Typo ကာကွယ်ရန်

```dart
abstract class AppRoutes {
  static const login            = '/login';
  static const home             = '/home';
  static const profile          = '/profile';
  static const navigationDemo   = '/navigation-demo';
  static const dataPassing      = '/data-passing';
  static const settings         = '/settings';

  // Path Parameter ပါ URL တည်ဆောက်ရန် Helper Method
  static String productDetailPath(String productId) =>
      '/home/product/$productId';
}
```

> **Why Constant ဖြင့် Path ကို သိမ်းသနည်း?**
>
> ```dart
> context.go('/hme');     // ❌ Typo! Runtime Error
> context.go(AppRoutes.home); // ✅ Compile-time Check
> ```
>
> Path String ကို Code တစ်နေရာတည်းတွင် သတ်မှတ်ထားလျှင်
> Path ပြောင်းလဲသည့်အခါ တစ်နေရာတည်းသာ ပြင်ရသည်။
> IDE Autocomplete ပါ အလုပ်လုပ်သောကြောင့် Productivity မြင့်သည်။

### GoRouter Instance Create

```dart
GoRouter createRouter(AuthService authService) {
  return GoRouter(
    // App ဖွင့်သည်နှင့် ဤ Route မှ စမည်
    initialLocation: AppRoutes.login,

    // Development Log — Route Changes ကို Console တွင် ကြည့်နိုင်
    debugLogDiagnostics: true,

    // Auth Guard (Step 5 တွင် အသေးစိတ်)
    redirect: (context, state) { ... },
    refreshListenable: authService,

    // 404 Error Page
    errorBuilder: (context, state) => ErrorScreen(error: state.error),

    // Routes List
    routes: [ ... ],
  );
}
```

### Basic GoRoute

```dart
GoRoute(
  path: '/login',          // URL Path — /login ဆိုသော URL
  name: 'login',           // Named Route (Optional) — goNamed('login') ဖြင့်ခေါ်ရန်
  builder: (context, state) => const LoginScreen(),
),
```

**GoRoute ၏ Parameters:**

| Parameter | Purpose | ဥပမာ |
|-----------|---------|------|
| `path` | URL Path | `'/login'` → Login Page |
| `name` | Route Name | `goNamed('login')` ဖြင့်ခေါ်ရန် |
| `builder` | Page Widget ပြန်ပေး | `LoginScreen()` |
| `routes` | Sub-pages (Nested) | Detail > Sub-detail |

### Nested Routes

```dart
GoRoute(
  path: '/home',
  builder: (context, state) => const HomeScreen(),

  // Child Routes — URL: /home/product/:productId
  routes: [
    GoRoute(
      // '/home/' မထည့်ဘဲ child segment ကိုသာ ထည့်ရသည်
      path: 'product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
  ],
),
```

> **Why Nested Routes သုံးသနည်း?**
>
> Product Detail Page သည် Home Page ၏ Sub-page ဖြစ်သောကြောင့်
> `/home/product/123` ဟု URL ဖွဲ့ပြီး Hierarchy ကို ဖော်ပြသည်။
> Code Structure ကိုကြည့်ရုံဖြင့် Page Hierarchy ကို ချက်ချင်းသိနိုင်သည်။
>
> ```
> /home                  → HomeScreen
> /home/product/p001     → ProductDetailScreen (Home ၏ Child)
> /home/product/p002     → ProductDetailScreen (Home ၏ Child)
> ```

---

## 🎯 Step 4: ShellRoute (Bottom Navigation Bar)

ဖိုင်: `lib/router/app_router.dart` + `lib/widgets/main_scaffold.dart`

### ShellRoute ဆိုသည်မှာ

```dart
ShellRoute(
  // [1] Shell (Frame) = Bottom Nav Bar ပါသော Wrapper
  builder: (context, state, child) {
    // child = လက်ရှိ Active Tab ၏ Page Widget
    return MainScaffold(child: child);
  },

  // [2] Shell ထဲတွင် ပြသမည့် Route များ
  routes: [
    GoRoute(path: '/home',             builder: ...),
    GoRoute(path: '/profile',          builder: ...),
    GoRoute(path: '/navigation-demo',  builder: ...),
    GoRoute(path: '/data-passing',     builder: ...),
    GoRoute(path: '/settings',         builder: ...),
  ],
),
```

> **Why ShellRoute သုံးသနည်း?**
>
> Bottom Navigation Bar ပါသော App တွင် Tab ပြောင်းသည်နှင့် Bottom Nav Bar
> ပျောက်မသွားဘဲ (`Persistent`) ဆက်ရှိနေစေရန် ShellRoute ကိုသုံးသည်။
>
> ShellRoute မသုံးဘဲ Regular GoRoute သာ သုံးလျှင်:
> - Tab ပြောင်းတိုင်း Bottom Nav Bar ကို Re-build လုပ်ရမည်
> - Animation ထိခိုက်နိုင်သည်
> - Persistent State မထိန်းနိုင်

```
ShellRoute (MainScaffold = Bottom Nav Frame)
├── /home             → HomeScreen
├── /profile          → ProfileScreen
├── /navigation-demo  → NavigationDemoScreen
├── /data-passing     → DataPassingScreen
└── /settings         → SettingsScreen
```

### MainScaffold — Active Tab ရှာနည်း

ဖိုင်: `lib/widgets/main_scaffold.dart`

```dart
int _currentIndex(BuildContext context) {
  // GoRouterState.of(context) → Current URL ကိုသိသည်
  final location = GoRouterState.of(context).matchedLocation;

  for (int i = 0; i < _navItems.length; i++) {
    if (location.startsWith(_navItems[i].path)) {
      return i; // Active Tab Index
    }
  }
  return 0;
}
```

> **Why GoRouterState.of(context) ကိုသုံးသနည်း?**
>
> URL မှ Active Tab ကို Auto-detect လုပ်ရန် GoRouterState ကိုသုံးသည်။
> URL `/profile` ဆိုလျှင် Profile Tab ကို Auto-highlight လုပ်မည်။
> Deep Link ဖြင့် `/data-passing?tab=query` ဖြင့် App ဖွင့်သည့်အခါ
> Data Passing Tab ကို Auto-select လုပ်မည်။

```dart
NavigationBar(
  selectedIndex: currentIndex,
  onDestinationSelected: (index) {
    // Tab ပြောင်းသည်နှင့် go() ဖြင့် Navigate
    context.go(_navItems[index].path);
    // push() မသုံးရ — Stack Reset လိုသောကြောင့်
  },
),
```

---

## 🎯 Step 5: Auth Guard (redirect + refreshListenable)

ဖိုင်: `lib/router/app_router.dart` + `lib/services/auth_service.dart`

### redirect Function

```dart
GoRouter(
  redirect: (BuildContext context, GoRouterState state) {
    final isLoggedIn = authService.isLoggedIn;
    final isOnLogin  = state.matchedLocation == AppRoutes.login;

    // Case 1: Login မဝင်ဘဲ Protected Route သွားလျှင်
    if (!isLoggedIn && !isOnLogin) {
      return AppRoutes.login; // /login သို့ Redirect
    }

    // Case 2: Login ဝင်ပြီး Login Page သွားလျှင် (Unnecessary)
    if (isLoggedIn && isOnLogin) {
      return AppRoutes.home; // /home သို့ Redirect
    }

    // Case 3: Normal Navigation — Redirect မလို
    return null;
  },

  // [핵심] Auth State ပြောင်းသည်နှင့် redirect() ကို Auto Re-run
  refreshListenable: authService,
)
```

> **Why `refreshListenable: authService` ထည့်ရသနည်း?**
>
> GoRouter ၏ `redirect()` သည် Default အနေဖြင့် Route Navigation ဖြစ်သည့်အချိန်တွင်သာ
> Run သည်။ Login / Logout လုပ်သည်နှင့် Auth State ပြောင်းသော်လည်း Navigation
> မဖြစ်သောကြောင့် `redirect()` Auto-run မဖြစ်ပါ။
>
> `refreshListenable: authService` ထည့်ခြင်းဖြင့်:
> ```
> auth.logout() ခေါ်မည်
>       ↓
> notifyListeners() Run မည်
>       ↓
> GoRouter က refreshListenable ပြောင်းသည်ကို သိမည်
>       ↓
> redirect() ကို Auto Re-run မည်
>       ↓
> isLoggedIn = false → return '/login'
>       ↓
> App Auto-Navigate to Login Page ✅
> ```

### AuthService — ChangeNotifier

ဖိုင်: `lib/services/auth_service.dart`

```dart
class AuthService extends ChangeNotifier {
  // ChangeNotifier ကိုသုံးသောကြောင့် notifyListeners() ခေါ်နိုင်
  UserModel? _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500)); // API Delay Simulate
    _currentUser = foundUser;
    notifyListeners(); // ← GoRouter ကို "State ပြောင်းပြီ" သတိပေး
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _currentUser = null;
    notifyListeners(); // ← GoRouter က redirect() Re-run မည်
  }
}
```

> **Why ChangeNotifier ကိုသုံးသနည်း?**
>
> GoRouter ၏ `refreshListenable` သည် `Listenable` Interface ကို Implement လုပ်သည့်
> Object ကိုသာ Accept လုပ်သည်။ `ChangeNotifier` သည် `Listenable` ကို Implement
> လုပ်ထားသောကြောင့် GoRouter နှင့် Perfectly Integration ဖြစ်သည်။

---

## 🎯 Step 6: Navigation Methods — push, pop, go, replace

ဖိုင်: `lib/screens/navigation_demo_screen.dart`

### context.push() — Stack ထဲ ထပ်ထည့်သည်

```dart
// Home Screen တွင် Product Detail ကိုဖွင့်ချင်သောအခါ
context.push('/home/product/p001');

// push() မတိုင်မီ Stack:  [Home]
// push() ပြီးနောက် Stack: [Home, Detail]  ← Detail ကို Top တွင်ထည့်
```

**Back Button နှိပ်သောအခါ:**
```
Stack: [Home, Detail]
Back Button ↓
Stack: [Home]  ← Detail ပျောက်ပြီး Home ပြန်မြင်ရမည်
```

**push() ကို When to use:**
- Product / Article Detail ကြည့်ချင်သောအခါ
- Sub-form ဖွင့်ချင်သောအခါ
- Modal-like Page ဖွင့်ချင်သောအခါ

### context.pop() — Stack မှ ဖျက်သည်

```dart
// Detail Page မှ Back ပြန်ချင်သောအခါ
context.pop();

// pop() မတိုင်မီ Stack:  [Home, Detail]
// pop() ပြီးနောက် Stack: [Home]
```

```dart
// pop() မလုပ်မီ စစ်ဆေးနည်း — Exception ကာကွယ်ရန်
if (context.canPop()) {
  context.pop();
} else {
  // Root Route — Pop မနိုင်တော့
  // App Exit လုပ်ချင်ရင်: SystemNavigator.pop()
}
```

> **Why canPop() စစ်ရသနည်း?**
>
> Stack တွင် Page တစ်ခုသာ ကျန်နေသောအခါ `pop()` ကိုခေါ်လျှင်
> Exception ဖြစ်နိုင်သည် (ဖြစ်မဖြစ်သည် Platform အလိုက် ကွဲပြားသည်)။
> `canPop()` ဖြင့် Safe pop လုပ်နိုင်သည်။

### context.go() — Stack Reset လုပ်ပြီး Navigate

```dart
// Bottom Nav Tab ပြောင်းသောအခါ
context.go('/profile');

// go() မတိုင်မီ Stack:  [Home, Detail, SubPage]
// go() ပြီးနောက် Stack: [Profile]  ← Stack ကို Reset လုပ်ပြီး Profile တင်
```

**Back Button နှိပ်သောအခါ:**
```
Stack: [Profile]
Back Button ↓
App မှ ထွက် (သို့) System Home
```

**go() ကို When to use:**
- Bottom Navigation Tab ပြောင်းသောအခါ
- Login → Home Navigate (Login Page ကို Back မပြန်ချင်)
- Root Level Pages Navigate

### context.replace() — Current Page ကိုသာ Replace

```dart
// Stack = [A, B] ဆိုပါ
context.replace('/c');
// Stack = [A, C]  ← B ကို C ဖြင့် Replace ← Stack Size မပြောင်း
```

**replace() ကို When to use:**
- OTP Page မှ Verify ပြီးနောက် OTP Page ကို Success Page ဖြင့် Replace
- Login Page မှ Login ပြီးနောက် Login Page ကို Home ဖြင့် Replace

### Comparison Table

| Method | Stack Change | Back Button | Use Case |
|--------|-------------|-------------|----------|
| `push('/b')` | `[A]` → `[A, B]` | B → A | Detail / Sub-pages |
| `pop()` | `[A, B]` → `[A]` | - | ပြန်သွားချင်သောအခါ |
| `go('/b')` | `[A, B, C]` → `[B]` | B → Exit | Tab Navigation |
| `replace('/b')` | `[A, C]` → `[A, B]` | B → A | Page Swap |

**App တွင် ကြည့်ပါ:** Navigation Demo Tab → Tab 1, Tab 2, Tab 3

---

## 🎯 Step 7: Data Passing Methods

ဖိုင်: `lib/screens/data_passing_screen.dart` + `lib/screens/product_detail_screen.dart`

GoRouter တွင် Data ကို Routes ကြား **၃ မျိုး** ပေးပို့နိုင်သည်:

### Method 1: Path Parameters (:paramName)

**Best For:** Product ID, User ID, Article Slug — Unique Identifier

```dart
// [1] Router တွင် Route သတ်မှတ်ချိန်
GoRoute(
  path: 'product/:productId',  // :productId = URL Variable Segment
  builder: (context, state) {
    // [2] Path Parameter ရယူနည်း
    final id = state.pathParameters['productId']!;
    return ProductDetailScreen(productId: id);
  },
),

// [3] Navigate သည်နှင့်
context.push('/home/product/p001');  // productId = "p001"
context.push('/home/product/p002');  // productId = "p002"
```

**Path Parameters ၏ ကောင်းသောအချက်:**
- ✅ Deep Link ဖြင့်လည်း Data ပါလာမည်: `myapp.com/home/product/p001`
- ✅ URL ကိုကြည့်ရုံဖြင့် Data ကို မြင်နိုင်သည်
- ✅ Web / Mobile နှစ်မျိုးလုံး အလုပ်လုပ်သည်
- ✅ Bookmark / Share URL ဖြင့်လည်း အသုံးပြုနိုင်သည်

### Method 2: Query Parameters (?key=value)

**Best For:** Filter, Sort, Tab Selection — Optional Data

```dart
// [1] Navigate သည်နှင့်
context.go('/data-passing?tab=query&sort=asc&page=2');

// [2] Router တွင် ရယူနည်း
builder: (context, state) {
  final tab  = state.uri.queryParameters['tab'];  // "query"
  final sort = state.uri.queryParameters['sort']; // "asc"
  final page = state.uri.queryParameters['page']; // "2"
  return DataPassingScreen(initialTab: tab ?? 'query');
},
```

**Query Parameters ၏ ကောင်းသောအချက်:**
- ✅ Optional Data — ထည့်မထည့် ရွေးနိုင်သည်
- ✅ Deep Link ဖြင့် Data ပါလာနိုင်သည်
- ✅ Multiple Parameters တစ်ပြိုင်နက် ပို့နိုင်သည်
- ✅ Filter State ကို URL တွင် Share လုပ်နိုင်သည်

### Method 3: Extra Data (state.extra)

**Best For:** Complex Object, In-App Navigation Only (Deep Link မပါ)

```dart
// [1] Navigate သည်နှင့် — Any Dart Object ပေးနိုင်
context.push(
  '/home/product/p001',
  extra: {
    'from': 'home_screen',
    'category': 'Education',
    'isRecommended': true,
    'timestamp': DateTime.now(), // DateTime, List, Object — ဘာမဆို
  },
);

// [2] Router တွင် ရယူနည်း
builder: (context, state) {
  // Cast ရမည် — Type-safe မဟုတ်
  final extra   = state.extra as Map<String, dynamic>?;
  final from    = extra?['from'] as String?;
  return ProductDetailScreen(fromSource: from);
},
```

**⚠️ Extra Data ၏ အားနည်းချက်:**
```
❌ Deep Link ဖြင့် App ဖွင့်သောအခါ    → Extra Data ပျောက်သည်
❌ Web Browser Refresh လုပ်သောအခါ   → Extra Data ပျောက်သည်
❌ Type-safe မဟုတ်                  → Runtime Error ဖြစ်နိုင်သည်
```

> **Extra ကို When to use:**
> In-App Navigation တွင်သာ သုံးသင့်သည်။ Web App တည်ဆောက်လျှင်
> Extra မသုံးဘဲ Path/Query Parameters ကိုသာ သုံးသင့်သည်။

### Data Passing Summary

| Method | Syntax | Deep Link | Type-safe | Best For |
|--------|--------|-----------|-----------|----------|
| Path Param | `/product/:id` | ✅ | ✅ | Unique ID (Product, User) |
| Query Param | `?key=val` | ✅ | ❌ | Optional (Filter, Tab) |
| Extra | `extra: obj` | ❌ | ❌ | Complex in-app Object |

**App တွင် ကြည့်ပါ:** Data Passing Tab → Query, Extra, Path, Return Tabs

---

## 🎯 Step 8: Named Routes (goNamed / pushNamed)

ဖိုင်: `lib/screens/navigation_demo_screen.dart`

### Route Name သတ်မှတ်နည်း

```dart
GoRoute(
  path: 'product/:productId',
  name: 'product-detail',  // ← Route Name
  builder: ...
),
```

### goNamed() ဖြင့် Navigate

```dart
// Regular go() — Path String ကိုမှတ်ရမည်
context.go('/home/product/p001');

// goNamed() — Name ဖြင့် Navigate (Path String မမှတ်ရ)
context.goNamed(
  'product-detail',                      // Route Name
  pathParameters: {'productId': 'p001'}, // Path Params
  queryParameters: {'ref': 'home'},      // Query Params (Optional)
  extra: {'from': 'named'},              // Extra (Optional)
);
```

```dart
// pushNamed() — push() + Named Routes
context.pushNamed(
  'product-detail',
  pathParameters: {'productId': 'p004'},
  extra: {'from': 'push_named'},
);
```

> **Why Named Routes ကောင်းသနည်း?**
>
> Path `/home/product/:productId` ကို `/courses/:courseId` ဟု ပြောင်းလဲသောအခါ:
> ```dart
> // Named Routes မသုံးလျှင် — ဘေ့ Code ကို ပြင်ရမည်
> context.go('/home/product/p001'); // ← ဤ Code အားလုံး ပြင်ရမည်
>
> // Named Routes သုံးလျှင် — Router Definition တစ်နေရာသာ ပြင်ရ
> context.goNamed('product-detail', ...); // ← ပြင်စရာမလို
> ```
>
> Large App တွင် Routes ဆယ်ပေါင်းများစွာ ရှိသောအခါ Named Routes ကိုသုံးလျှင်
> Refactoring ကိုလွယ်ကူစေသည်။

---

## 🎯 Step 9: Return Data from Routes

ဖိုင်: `lib/screens/data_passing_screen.dart` + `lib/screens/product_detail_screen.dart`

### push() သည် Future ပြန်ပေးသည်

```dart
// Page A (Caller) — Data ရလိုသော Page
Future<void> openDetailAndGetResult() async {
  // push() ကို await ဖြင့်စောင့်သည်
  final result = await context.push<Map<String, dynamic>>(
    '/home/product/p001',
    extra: {'from': 'return_demo'},
  );

  // pop(data) ကိုခေါ်ပြီးနောက် ဤနေရာမှ Resume ဖြစ်မည်
  if (result != null) {
    print('Action:   ${result['action']}');     // 'purchased'
    print('Quantity: ${result['quantity']}');   // 2
    print('ID:       ${result['productId']}'); // 'p001'
  }
}
```

```dart
// Page B (Callee) — Data ပြန်ပို့မည့် Page
void onBackPressed() {
  // pop() ဖြင့် Data ပါ ပြန်ပို့သည်
  context.pop({
    'action': 'purchased',
    'productId': 'p001',
    'quantity': 2,
  });
  // Page A ၏ await push() မှ Resume ဖြစ်ပြီး result = ဤ Data
}
```

**Data Flow:**
```
Page A: final result = await context.push('/detail')
                                    ↓
              Page B Open ဖြစ်သည်
                                    ↓
              User ဘာတွေလုပ်လုပ်
                                    ↓
              context.pop({'action': 'purchased', ...})
                                    ↓
Page A: result = {'action': 'purchased', ...}  ← Resume
```

> **Why Return Data ကောင်းသနည်း?**
>
> Dialog, BottomSheet မှ Data ပြန်ရသကဲ့သို့ Page မှလည်း Data ပြန်ရနိုင်သည်။
> Global State (Provider/Riverpod) ကို ဆွဲမသုံးဘဲ Local Communication ဖြင့်
> Pages ကြားတွင် Data Exchange လုပ်နိုင်သောကြောင့် Code ရှင်းလင်းသည်။

**App တွင် ကြည့်ပါ:** Data Passing Tab → "Return" Tab → Button နှိပ်ပါ → Detail ၏ pop(data) Button

---

## 🎯 Step 10: Error Handling (404 Page)

ဖိုင်: `lib/screens/error_screen.dart`

```dart
GoRouter(
  // Route မတွေ့သောအခါ ဤ Widget ကိုပြသမည်
  errorBuilder: (context, state) {
    return ErrorScreen(error: state.error);
  },
)
```

```dart
// ErrorScreen တွင်
class ErrorScreen extends StatelessWidget {
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('404 — Page မတွေ့ပါ'),
          Text(error?.toString() ?? 'Unknown route'),

          // Home သို့ ပြန်သွားသည်
          FilledButton(
            onPressed: () => context.go('/home'),
            child: Text('Home သို့ ပြန်သွားမည်'),
          ),
        ],
      ),
    );
  }
}
```

**Test နည်း:**
```dart
// Settings Tab → Quick Nav တွင်
context.go('/this-route-does-not-exist'); // → 404 Error Screen
```

---

## 🎯 Step 11: GoRouterState

ဖိုင်: `lib/screens/settings_screen.dart`

```dart
// Widget ၏ build() Method တွင် Current Route Info ကိုရနိုင်
@override
Widget build(BuildContext context) {
  final state = GoRouterState.of(context);

  print(state.uri);                     // /settings
  print(state.matchedLocation);         // /settings (matched pattern)
  print(state.name);                    // 'settings' (named route)
  print(state.pathParameters);          // {} or {'productId': 'p001'}
  print(state.uri.queryParameters);     // {} or {'tab': 'query'}
  print(state.uri.toString());          // Full URL with query
}
```

> **Why GoRouterState.of(context) ကိုသုံးသနည်း?**
>
> **Case 1 — Active Tab Auto-detect:**
> Bottom Nav Bar တွင် URL `/profile` ဆိုလျှင် Profile Tab ကို Auto-highlight
> လုပ်ရန် `matchedLocation` ကိုသုံးသည်။
>
> **Case 2 — Analytics:**
> User ဘယ် Page တွင် ရှိသနည်း ကို Tracking လုပ်ရန်
>
> **Case 3 — Breadcrumbs:**
> Page Header တွင် "Home > Products > Detail" ကဲ့သို့ ပြရန်
>
> **Case 4 — Conditional UI:**
> Route အလိုက် ကွဲပြားသော UI ပြသရန်

**App တွင် ကြည့်ပါ:** Settings Tab → Top Card တွင် Current Route Info မြင်ရမည်

---

## 🎯 Step 12: Real Project Best Practices

### ✅ DO — ဤနည်းများ သုံးပါ

```dart
// 1. Route Path Constant ဖြင့် သိမ်းပါ
abstract class AppRoutes {
  static const home = '/home';
  static String productDetail(String id) => '/home/product/$id';
}

// 2. Tab Navigation တွင် go() ကိုသာ သုံးပါ
onDestinationSelected: (i) => context.go(_navItems[i].path),

// 3. Detail Pages တွင် push() ကိုသုံးပါ
onTap: () => context.push(AppRoutes.productDetail(product.id)),

// 4. pop() မတိုင်မီ canPop() စစ်ပါ
onBack: () {
  if (context.canPop()) context.pop();
},

// 5. Web/Deep Link App တွင် Path/Query Parameters သုံးပါ
context.push('/product/$id?ref=home'); // ✅ Deep Link Safe

// 6. Large App တွင် Named Routes သုံးပါ
context.goNamed('product-detail', pathParameters: {'productId': id});

// 7. Auth Guard ကို redirect() တစ်နေရာတည်းတွင်သာ သတ်မှတ်ပါ
redirect: (context, state) {
  if (!auth.isLoggedIn) return '/login';
  return null;
},
```

### ❌ DON'T — ဤနည်းများ မသုံးပါနှင့်

```dart
// ❌ GoRouter App တွင် Navigator 1.0 မသုံးပါနှင့်
Navigator.of(context).push(MaterialPageRoute(builder: ...));
// ✅ context.push('/path') ကိုသုံးပါ

// ❌ Route Path ကို Hard-code မလုပ်ပါနှင့်
context.go('/hme'); // Typo Error!
// ✅ context.go(AppRoutes.home) ကိုသုံးပါ

// ❌ Tab Navigation တွင် push() မသုံးပါနှင့်
context.push('/profile'); // Back Stack ထပ်ပါမည်
// ✅ context.go('/profile') ကိုသုံးပါ

// ❌ Web App တွင် Extra တစ်ခုတည်းကို မမှီသနည်း
context.push('/product', extra: id); // Refresh/Deep Link တွင် ပျောက်မည်
// ✅ context.push('/product/$id') Path Param ကိုသုံးပါ

// ❌ pop() မတိုင်မီ canPop() မစစ်ဘဲ မသုံးပါနှင့်
context.pop(); // Root Route တွင် Exception ဖြစ်နိုင်
// ✅ if (context.canPop()) context.pop();
```

### GoRouter + Provider Integration Pattern

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class _MyAppState extends State<MyApp> {
  // AuthService ကို context.read ဖြင့် ရယူပြီး Router Create
  late final _router = createRouter(context.read<AuthService>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}

GoRouter createRouter(AuthService auth) {
  return GoRouter(
    redirect: (ctx, state) {
      if (!auth.isLoggedIn) return '/login';
      return null;
    },
    refreshListenable: auth, // Same Instance — Important!
    routes: [ ... ],
  );
}
```

---

## 🔍 Quick Reference Cheatsheet

```dart
// ═══════════════════════════════════
//  NAVIGATION METHODS
// ═══════════════════════════════════
context.push('/path')           // Stack ထဲ ထပ်ထည့် (Back နိုင်)
context.pop()                   // Stack မှ ဖျက် (Back)
context.pop(myData)             // Data ဖြင့် Back
context.go('/path')             // Stack Reset လုပ်ပြီး Navigate
context.replace('/path')        // Current Page ကို Replace
context.canPop()                // Pop နိုင်/မနိုင် → bool

// ═══════════════════════════════════
//  NAMED ROUTES
// ═══════════════════════════════════
context.pushNamed('route-name')
context.goNamed('route-name')
context.goNamed(
  'route-name',
  pathParameters: {'id': 'value'},
  queryParameters: {'key': 'value'},
  extra: anyDartObject,
)

// ═══════════════════════════════════
//  READING DATA (in GoRoute builder)
// ═══════════════════════════════════
state.pathParameters['id']          // :id → 'p001'
state.uri.queryParameters['key']    // ?key=val → 'val'
state.extra as MyType?              // extra Object
state.uri                           // Full URI
state.matchedLocation               // Matched path string

// ═══════════════════════════════════
//  CURRENT ROUTE (in any Widget)
// ═══════════════════════════════════
GoRouterState.of(context).uri
GoRouterState.of(context).matchedLocation
GoRouterState.of(context).pathParameters
GoRouterState.of(context).name

// ═══════════════════════════════════
//  ROUTER INSTANCE
// ═══════════════════════════════════
GoRouter.of(context).go('/path')
GoRouter.of(context).push('/path')
```

---

## 📱 Exercises — App ဖွင့်ပြီး ဤ Exercises များ လုပ်ကြည့်ပါ

**Exercise 1: push() vs go() ကြားခြားနားချက်**
1. Home Tab → Product Card Tap ပါ (push ဖြစ်မည်)
2. Back Button ဖိပါ → Home ပြန်လာမည်
3. Navigation Demo → Tab 2 → go(Home) Button ဖိပါ
4. Back Button ဖိပါ → App ထွက်မည် (Stack Reset ဖြစ်သောကြောင့်)

**Exercise 2: Auth Guard ကြည့်ပါ**
1. Profile Tab → Logout Button ဖိပါ
2. Login Page သို့ Auto-Redirect မြင်ရမည်
3. Login ဝင်ပါ → Home သို့ Auto-Redirect မြင်ရမည်

**Exercise 3: Stack Visualizer**
1. Navigation Demo → "Stack ကြည့်" Tab
2. push/pop/go/replace Buttons နှိပ်ကြည့်ပါ
3. Stack ပြောင်းလဲသည်ကို Visual ဖြင့် မြင်ရမည်

**Exercise 4: Data Passing**
1. Data Passing Tab → Path Tab → Product ID Tap ပါ
2. Detail Page တွင် Path Parameter Value မြင်ရမည်
3. Return Tab → Button ဖိပါ → Detail ၏ "pop(data)" ဖိပါ
4. Return Data ပြန်ရသည်ကို မြင်ရမည်

**Exercise 5: Error Page**
1. Settings Tab → Quick Nav → "go(/not-found)" Chip ဖိပါ
2. 404 Error Page မြင်ရမည်
3. Home Button ဖိပြီး ပြန်လာပါ

---

## 🔗 References

- **go_router Package:** https://pub.dev/packages/go_router
- **Flutter Navigation Docs:** https://docs.flutter.dev/ui/navigation
- **GoRouter Migration Guide:** https://docs.flutter.dev/release/breaking-changes/go-router-v7

---

*ဤ Guide ကို `gorouter_app` Project ဖြင့် တွဲဖက်လေ့လာပါ။*
*Code ကြည့်ရင်း → App Run ကြည့်ရင်း → Exercise လုပ်ရင်း သင်ကြားလျှင် ပိုမိုနားလည်မည်ဖြစ်သည်။ 🎓*

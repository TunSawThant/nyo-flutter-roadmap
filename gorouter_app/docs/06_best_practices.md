# ✅ Best Practices, Cheatsheet & Common Mistakes

> GoRouter ကို Real Project တွင် Professional အဆင့်ဖြင့် သုံးရန် လမ်းညွှန်

---

## DO's — ဤနည်းများ လိုက်နာပါ

### 1. Route Paths ကို Constants ဖြင့် သတ်မှတ်ပါ

```dart
// ✅ GOOD
abstract class AppRoutes {
  static const home = '/home';
  static const login = '/login';
  static String productDetail(String id) => '/home/product/$id';
}

context.go(AppRoutes.home);
context.push(AppRoutes.productDetail('p001'));
```

```dart
// ❌ BAD — Typo ဖြစ်နိုင်; Path ပြောင်းလဲသောအခါ နေရာများစွာ ပြင်ရ
context.go('/hme');                  // Typo!
context.push('/home/prodcut/p001');  // Typo!
```

---

### 2. Tab Navigation တွင် go() ကိုသာ သုံးပါ

```dart
// ✅ GOOD — Tab Stack ကို Reset လုပ်သည်
NavigationBar(
  onDestinationSelected: (index) {
    context.go(_tabs[index].path);
  },
)
```

```dart
// ❌ BAD — Tab ပြောင်းတိုင်း Stack ထဲ ထည့်မည်
//  Back နှိပ်သောအခါ ကြားမှ Tab Pages ပွင့်လာမည်
NavigationBar(
  onDestinationSelected: (index) {
    context.push(_tabs[index].path);  // push() မသုံးပါနှင့်!
  },
)
```

---

### 3. pop() မတိုင်မီ canPop() စစ်ပါ

```dart
// ✅ GOOD — Safe pop
void onBackPressed() {
  if (context.canPop()) {
    context.pop();
  }
  // Root route တွင် ဘာမှ မလုပ်ရ (သို့) SystemNavigator.pop()
}
```

```dart
// ❌ BAD — Root route တွင် Exception ဖြစ်နိုင်
void onBackPressed() {
  context.pop(); // Stack ၏ ထိပ်ဆုံး Page တစ်ခုသာ ကျန်လျှင် Error
}
```

---

### 4. Auth Guard ကို redirect() တစ်နေရာတည်းတွင် ထားပါ

```dart
// ✅ GOOD — Router တွင် တစ်နေရာတည်း
GoRouter(
  redirect: (context, state) {
    if (!authService.isLoggedIn) return '/login';
    return null;
  },
  refreshListenable: authService,
)
```

```dart
// ❌ BAD — Screen တိုင်းတွင် Auth Check လုပ်ရ (Code Duplication)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    if (!auth.isLoggedIn) {
      // initState တွင် Navigate မရ! WidgetsBinding နှင့် ချိတ်ရမည်
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
    }
    return ...;
  }
}
```

---

### 5. Deep Link Data တွင် Path/Query Params သုံးပါ

```dart
// ✅ GOOD — Deep Link Safe
context.push('/product/${product.id}');
context.go('/products?category=education&sort=price');
```

```dart
// ❌ BAD (Web App / Deep Link ဆိုလျှင်) — Refresh တွင် Data ပျောက်
context.push(
  '/product/${product.id}',
  extra: {'productData': product}, // Deep Link တွင် ပျောက်မည်!
);
```

---

### 6. Extra Data တွင် Null-safe Handle လုပ်ပါ

```dart
// ✅ GOOD — Deep Link (extra = null) ကို Handle လုပ်သည်
class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String? fromSource; // Nullable!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        if (fromSource != null)
          Chip(label: Text('From: $fromSource')),
        // fromSource မပါလည်း UI ကောင်းနေသင့်သည်
      ]),
    );
  }
}
```

```dart
// ❌ BAD — Deep Link တွင် Crash ဖြစ်မည်
class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> extra; // Null မဟုတ်ဟု ယူဆ

  @override
  Widget build(BuildContext context) {
    return Text(extra['from']!); // Deep Link တွင် extra = null → Crash!
  }
}
```

---

### 7. debugLogDiagnostics ကို Development မှသာ ဖွင့်ပါ

```dart
// ✅ GOOD
GoRouter(
  debugLogDiagnostics: kDebugMode, // Debug build တွင်သာ Log
)
```

```dart
// ❌ BAD — Production တွင် Console Spam ဖြစ်မည်
GoRouter(
  debugLogDiagnostics: true, // Always on
)
```

---

## DON'Ts — ဤနည်းများ မလုပ်ပါနှင့်

### ❌ GoRouter App တွင် Navigator 1.0 မသုံးပါနှင့်

```dart
// ❌ WRONG — GoRouter App တွင် Navigator.of() မသုံးပါ
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => DetailScreen()),
);

// ✅ CORRECT
context.push('/detail');
```

> **ဘာကြောင့်?**
> Navigator 1.0 ဖြင့် Navigate လုပ်သောအခါ GoRouter ၏ URL Sync ပျက်သည်။
> Auth Guard / redirect() ကို Bypass လုပ်ပြီး Login မဝင်ဘဲ Protected Pages ဝင်နိုင်သည်။

---

### ❌ GoRouter StatefulWidget ထဲတွင် initState မှ Navigate မလုပ်ပါနှင့်

```dart
// ❌ WRONG — initState တွင် context.go() မရ
@override
void initState() {
  super.initState();
  context.go('/login'); // Error! Context not fully mounted
}

// ✅ CORRECT — addPostFrameCallback ဖြင့် လုပ်ရ
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;
    context.go('/login');
  });
}

// ✅ Better — redirect() ကိုသုံးပါ (GoRouter pattern)
// Auth state ပြောင်းသောအခါ GoRouter ၏ redirect() သည် Auto-handle လုပ်သည်
```

---

### ❌ GoRouter ကို Provider ၏ create: တွင် Create မလုပ်ပါနှင့်

```dart
// ❌ WRONG
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // build() တွင် GoRouter Create မလုပ်ပါ — Rebuild တိုင်း Router ပြောင်းမည်
    final router = GoRouter(routes: [...]);
    return MaterialApp.router(routerConfig: router);
  }
}

// ✅ CORRECT — StatefulWidget ဖြင့် Once Create
class _MyAppState extends State<MyApp> {
  late final _router = createRouter(context.read<AuthService>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router);
  }
}
```

---

## 🔍 Complete Cheatsheet

```dart
// ══════════════════════════════════════════════════════════
//  NAVIGATION METHODS
// ══════════════════════════════════════════════════════════
context.push('/path')               // Stack ထဲ ထည့် (Back ပြန်နိုင်)
context.push('/path', extra: obj)   // Extra Data ဖြင့် push
final r = await context.push<T>(p)  // Return Data ဖြင့် push

context.pop()                       // Back (Stack မှ ဖျက်)
context.pop(data)                   // Data ဖြင့် Back
if (context.canPop()) context.pop() // Safe pop

context.go('/path')                 // Stack Reset ပြီး Navigate
context.replace('/path')            // Current Page Swap

// ══════════════════════════════════════════════════════════
//  NAMED ROUTE VARIANTS
// ══════════════════════════════════════════════════════════
context.pushNamed('route-name')
context.goNamed('route-name')
context.replaceNamed('route-name')

context.goNamed(
  'route-name',
  pathParameters: {'id': 'value'},         // :id
  queryParameters: {'key': 'value'},        // ?key=value
  extra: anyObject,
)

// ══════════════════════════════════════════════════════════
//  READING DATA IN ROUTE BUILDER
// ══════════════════════════════════════════════════════════
state.pathParameters['id']              // :id → String
state.uri.queryParameters['key']        // ?key=val → String?
state.extra as MyType?                  // Extra (cast required)
state.uri                               // Full Uri object
state.uri.path                          // Path only
state.matchedLocation                   // Matched route pattern
state.name                              // Named route name
state.error                             // In errorBuilder

// ══════════════════════════════════════════════════════════
//  CURRENT ROUTE INFO IN WIDGETS
// ══════════════════════════════════════════════════════════
final s = GoRouterState.of(context);
s.uri                                   // Current URI
s.matchedLocation                       // Current matched path
s.pathParameters                        // Path params map
s.name                                  // Current route name

// ══════════════════════════════════════════════════════════
//  ROUTER INSTANCE
// ══════════════════════════════════════════════════════════
GoRouter.of(context).go('/path')
GoRouter.of(context).push('/path')
GoRouter.of(context).pop()

// ══════════════════════════════════════════════════════════
//  ROUTE DEFINITION
// ══════════════════════════════════════════════════════════
GoRoute(
  path: '/path',          // URL Pattern
  name: 'route-name',     // Named Route (optional)
  builder: (ctx, state) => MyScreen(),
  routes: [ ... ],        // Nested child routes (optional)
  redirect: (ctx, state) { return null; }, // Local guard (optional)
)

ShellRoute(
  builder: (ctx, state, child) => ScaffoldWithNav(child: child),
  routes: [ ... ],        // Tab routes here
)

// ══════════════════════════════════════════════════════════
//  ROUTER CONFIG
// ══════════════════════════════════════════════════════════
GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: kDebugMode,
  redirect: (ctx, state) { ... },       // Global auth guard
  refreshListenable: authService,       // Re-run redirect on change
  errorBuilder: (ctx, state) => Error(), // 404 page
  routes: [ ... ],
)
```

---

## 📋 Common Patterns

### Pattern 1: Login Required Route

```dart
// Router Level
redirect: (ctx, state) {
  if (!auth.isLoggedIn && !state.matchedLocation.startsWith('/public')) {
    return '/login?from=${state.uri.toString()}'; // Return URL ပါ Store
  }
  return null;
},

// Login Screen — Redirect back after login
Future<void> onLoginSuccess() async {
  final from = GoRouterState.of(context).uri.queryParameters['from'];
  if (from != null && from.isNotEmpty) {
    context.go(from); // Original destination သို့ go
  } else {
    context.go('/home');
  }
}
```

### Pattern 2: Role-based Redirect

```dart
redirect: (ctx, state) {
  final user = authService.currentUser;
  if (user == null) return '/login';

  // Admin only routes
  if (state.matchedLocation.startsWith('/admin') && user.role != 'admin') {
    return '/home'; // Non-admin → Home
  }

  return null;
},
```

### Pattern 3: Tab Persistence

```dart
// Tab Navigate သောအခါ Go မသုံးဘဲ State ကို Restore လုပ်ချင်ရင်
// StatefulShellRoute ကိုသုံးနိုင်သည် (go_router v7+)
StatefulShellRoute.indexedStack(
  builder: (ctx, state, shell) => ScaffoldWithNav(shell: shell),
  branches: [
    StatefulShellBranch(routes: [GoRoute(path: '/home', ...)]),
    StatefulShellBranch(routes: [GoRoute(path: '/profile', ...)]),
  ],
)
// ← Tab ပြောင်းပြီး ပြန်လာသောအခါ Scroll Position ကဲ့သို့ State ဆက်ရှိမည်
```

---

## 🎓 Learning Checklist

Project App ကို Run ပြီး ဤ Items များ Check လုပ်ပါ:

- [ ] Login မဝင်ဘဲ `/home` ကိုသွားကြည့်ပြီး `/login` Redirect မြင်ရသည်
- [ ] Login ဝင်ပြီး Bottom Nav Tab ပြောင်းပြီး push() vs go() ကွဲပြားသည်ကို မြင်ရသည်
- [ ] Product Detail ဖွင့်ပြီး Back Button ဖိကြည့်သည် (pop() အလုပ်လုပ်သည်)
- [ ] Logout ပြီး `/login` Auto-Redirect မြင်ရသည် (refreshListenable)
- [ ] Navigation Demo → Stack Visualizer ဖြင့် Stack Change မြင်ရသည်
- [ ] Data Passing → Path/Query/Extra/Return 4 Methods ကြည့်ရသည်
- [ ] Settings → `/this-does-not-exist` သွားပြီး Error Page မြင်ရသည်
- [ ] Settings → GoRouterState ဖြင့် Current Route Info မြင်ရသည်

---

*GoRouter ကို Master လုပ်ပြီ! Real Project တွင် ယခု Apply လုပ်နိုင်ပြီ 🚀*

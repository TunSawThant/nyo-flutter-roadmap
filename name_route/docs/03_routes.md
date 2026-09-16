# 03 — Routes (app_routes.dart & route_generator.dart)

> **ဤ file ဖြင့် သင်ယူမည့်အရာ:** Named Routes ကို ဘယ်လို setup လုပ်သည်၊ Route arguments ကို type-safe ဖြင့် စစ်ဆေးပုံ

---

## 📂 Routes Folder Structure

```
lib/routes/
├── app_routes.dart       ← Route name constants (String)
└── route_generator.dart  ← Route builder + Argument validator
```

---

## 1️⃣ app_routes.dart — Route Name Constants

**File:** `lib/routes/app_routes.dart`

```dart
class AppRoutes {
  AppRoutes._();  // Private constructor — new AppRoutes() မလုပ်နိုင်

  static const String login  = '/';        // initial route
  static const String home   = '/home';
  static const String detail = '/detail';
  static const String logout = '/logout';
}
```

### ဘာကြောင့် Constants Class ဖြစ်သင့်သည်?

```dart
// ❌ Hardcoded string — Typo ဖြစ်နိုင်
Navigator.pushNamed(context, '/hoem');  // typo! '/home' ဖြစ်ရမည်
// → Error: no route found (runtime မှသာ သိနိုင်)

// ✅ Constants — Typo ဖြစ်လျှင် compile error
Navigator.pushNamed(context, AppRoutes.hoem);  // compile error ✅
// → IDE က ချက်ချင်းပြပေးမည်
```

### Static Const ၏ အကျိုးကျေးဇူး

| | String | AppRoutes.home |
|-|--------|----------------|
| Typo | ❌ runtime error | ✅ compile error |
| Rename | ❌ ၂ နေရာပြင်ရ | ✅ တစ်နေရာသာ |
| IDE help | ❌ autocomplete မရ | ✅ autocomplete ရ |

---

## 2️⃣ main.dart — Route Setup

**File:** `lib/main.dart`

```dart
MaterialApp(
  initialRoute: AppRoutes.login,          // ① app ဖွင့်သောအခါ ပထမ route
  onGenerateRoute: RouteGenerator.generateRoute,  // ② route builder
  onUnknownRoute: (settings) { ... },     // ③ 404 fallback
)
```

### ① `initialRoute`

```dart
initialRoute: AppRoutes.login,  // '/'
// App run လျှင် LoginScreen ပထမဆုံး ပြသသည်
```

### ② `onGenerateRoute` — Dynamic Route Builder

```dart
// Option A: static routes map (simple)
routes: {
  '/': (context) => LoginScreen(),
  '/home': (context) => HomeScreen(),
  // ❌ Arguments pass မလုပ်နိုင်
}

// Option B: onGenerateRoute (recommended) ✅
onGenerateRoute: RouteGenerator.generateRoute,
// ✅ Arguments type check လုပ်နိုင်
// ✅ Dynamic logic ထည့်နိုင်
// ✅ Error handling ထည့်နိုင်
```

### ③ `onUnknownRoute` — 404 Fallback

```dart
onUnknownRoute: (settings) {
  // onGenerateRoute မှာပါ မတွေ့သောအခါ ဤနေရာ ရောက်သည်
  return MaterialPageRoute(builder: (_) => NotFoundPage());
}
```

---

## 3️⃣ route_generator.dart — Route Builder

**File:** `lib/routes/route_generator.dart`

### Class Structure

```dart
class RouteGenerator {
  RouteGenerator._();  // instantiate မလုပ်ရ

  // Main method — MaterialApp မှ ခေါ်သည်
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:   return ...;
      case AppRoutes.home:    return ...;
      case AppRoutes.detail:  return ...;
      case AppRoutes.logout:  return ...;
      default:                return ...;  // 404
    }
  }

  // Helper methods
  static MaterialPageRoute _buildRoute({...}) { ... }
  static Route _typeErrorRoute({...}) { ... }
  static Route _notFoundRoute(String? name) { ... }
}
```

### RouteSettings Object

```dart
// Navigator.pushNamed() ကိုခေါ်သောအခါ Flutter က
// RouteSettings object ဖန်တီးပြီး generateRoute() သို့ pass လုပ်သည်

RouteSettings {
  name: '/detail',          // route name
  arguments: productObject, // pass လာသော data
}
```

---

## 4️⃣ Type-Safe Argument Checking — Step by Step

### Login Route (arguments မလို)

```dart
case AppRoutes.login:
  // Arguments check မလိုအပ်
  // LoginScreen constructor တွင် parameter မရှိ
  return _buildRoute(
    settings: settings,
    child: const LoginScreen(),
  );
```

### Home Route (UserModel လိုသည်)

```dart
case AppRoutes.home:

  // ① Raw argument ယူသည်
  final args = settings.arguments;  // type: Object?

  // ② Type check — is! (NOT instance of)
  if (args is! UserModel) {
    // args = null       → ❌ error
    // args = "string"   → ❌ error
    // args = UserModel  → ✅ pass (ဤ block skip)
    return _typeErrorRoute(
      routeName: AppRoutes.home,
      expected: 'UserModel',
      received: args,
    );
  }

  // ③ Smart Cast ✅
  // "is!" check ဖြတ်ပြီးသောကြောင့်
  // Dart compiler က args = UserModel ဟု သိသည်
  // (args as UserModel) ဟု ထပ်ရေးရန် မလို
  return _buildRoute(
    settings: settings,
    child: HomeScreen(user: args),  // args = UserModel ✅
  );
```

### Detail Route (ProductModel လိုသည်)

```dart
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
    child: DetailScreen(product: args),
  );
```

### Logout Route (UserModel? — optional)

```dart
case AppRoutes.logout:
  final args = settings.arguments;

  // null ကိုလက်ခံသည် (optional UserModel)
  // null မဟုတ်ဘဲ UserModel မဟုတ်ပါကသာ error
  if (args != null && args is! UserModel) {
    return _typeErrorRoute(
      routeName: AppRoutes.logout,
      expected: 'UserModel (or null)',
      received: args,
    );
  }

  return _buildRoute(
    settings: settings,
    child: LogoutScreen(user: args as UserModel?),
    //                            ↑ nullable cast
  );
```

---

## 5️⃣ `_buildRoute()` Helper

```dart
static MaterialPageRoute<dynamic> _buildRoute({
  required RouteSettings settings,
  required Widget child,
}) {
  return MaterialPageRoute(
    settings: settings,  // ← route history tracking
    builder: (_) => child,
  );
}
```

**`settings` ကို pass လုပ်ရသောကြောင့်:**
- Route history (back stack) ကို Flutter မှတ်သည်
- Deep link support
- `ModalRoute.of(context)` ဖြင့် current route ကြည့်နိုင်

---

## 6️⃣ Error Routes

### Type Error — Wrong argument type

```
┌─────────────────────────────────────┐
│   ⚠️ Argument Type Error            │
│                                     │
│  Route:         /home               │
│  Expected Type: UserModel           │
│  Received Type: String              │
│  Fix:                               │
│  Navigator.pushNamed(               │
│    context, "/home",                │
│    arguments: UserModel(...),       │
│  );                                 │
└─────────────────────────────────────┘
```

### Not Found — Unknown route name

```
┌─────────────────────────────────────┐
│   🔴 404 - Route Not Found          │
│                                     │
│  Requested: /settings               │
│  Available Routes:                  │
│    /       → Login                  │
│    /home   → Home                   │
│    /detail → Detail                 │
│    /logout → Logout                 │
└─────────────────────────────────────┘
```

---

## 7️⃣ Before vs After — Type Safety

```dart
// ─── BEFORE (မူလ) ─────────────────────────────────────────

// route_generator.dart
case AppRoutes.home:
  final args = settings.arguments;
  if (args == null) {           // null ချည်းစစ်
    return _errorRoute('...');
  }
  return MaterialPageRoute(
    builder: (_) => HomeScreen(arguments: args),  // Object? pass
  );

// home_screen.dart (Screen ထဲ ထပ်စစ်ရ)
void initState() {
  if (widget.arguments is UserModel) {          // ဒုတိယ စစ်
    _currentUser = widget.arguments as UserModel; // manual cast
  }
}

// ─── AFTER (ပြင်ဆင်) ─────────────────────────────────────

// route_generator.dart
case AppRoutes.home:
  final args = settings.arguments;
  if (args is! UserModel) {     // null + type check တစ်ပြိုင်နက်
    return _typeErrorRoute(...);
  }
  return _buildRoute(
    child: HomeScreen(user: args),  // UserModel typed ✅
  );

// home_screen.dart (Screen ထဲ စစ်ရန် မလိုတော့)
UserModel get _currentUser => widget.user;  // တိုက်ရိုက်သုံး ✅
```

---

## 8️⃣ Calling Routes — Quick Cheatsheet

```dart
// Login → Home (pushReplacement)
Navigator.pushReplacementNamed(
  context,
  AppRoutes.home,
  arguments: userModel,    // UserModel required
);

// Home → Detail (push + await)
final result = await Navigator.pushNamed(
  context,
  AppRoutes.detail,
  arguments: product,      // ProductModel required
);
// result: String? (review) or null

// Home → Logout (push)
Navigator.pushNamed(
  context,
  AppRoutes.logout,
  arguments: currentUser,  // UserModel? (optional)
);

// Logout → Login (stack clear)
Navigator.pushNamedAndRemoveUntil(
  context,
  AppRoutes.login,
  (route) => false,
);

// Any Screen → Back (pop)
Navigator.pop(context);           // data မပါ
Navigator.pop(context, someData); // data ပါ
```

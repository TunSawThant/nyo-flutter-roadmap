# 📁 Project Structure — Folder & File Guide

> **gorouter_app** Project ၏ တည်ဆောက်ပုံကို File တစ်ခုချင်းစီ ရှင်းလင်းဖော်ပြသည်

---

## 🌳 Full Project Tree

```
gorouter_app/
│
├── lib/                          ← Dart Source Code အားလုံး ဤနေရာတွင်
│   │
│   ├── main.dart                 ← [Entry Point] App ဖွင့်သည်နှင့် ဤ File မှ စသည်
│   │
│   ├── models/                   ← Data Models (Plain Dart Classes)
│   │   ├── user_model.dart       ← UserModel (id, name, email, avatar, role)
│   │   └── product_model.dart    ← ProductModel (id, name, price, ...)
│   │
│   ├── data/                     ← Mock Data (Real API မရှိသေးသောကြောင့်)
│   │   └── mock_data.dart        ← MockData class (6 Sample Products)
│   │
│   ├── services/                 ← Business Logic (API calls, State)
│   │   └── auth_service.dart     ← AuthService: Login/Logout State Management
│   │
│   ├── router/                   ← GoRouter Configuration
│   │   └── app_router.dart       ← Route Tree + Auth Guard + AppRoutes constants
│   │
│   ├── widgets/                  ← Reusable Widgets
│   │   └── main_scaffold.dart    ← Bottom Navigation Bar (ShellRoute wrapper)
│   │
│   └── screens/                  ← Page-level Widgets
│       ├── login_screen.dart     ← Login Form + Auth
│       ├── home_screen.dart      ← Product Grid + push() demo
│       ├── product_detail_screen.dart ← Path Param + Extra + pop(data)
│       ├── navigation_demo_screen.dart ← push/pop/go/replace Interactive Demo
│       ├── data_passing_screen.dart  ← 4 Data Passing Methods
│       ├── profile_screen.dart   ← User Info + Logout + Redirect Explanation
│       ├── settings_screen.dart  ← GoRouterState + Quick Nav + Deep Links
│       └── error_screen.dart     ← 404 Not Found Page
│
├── docs/                         ← ဤ Documentation Folder
│   ├── README.md
│   ├── 01_project_structure.md   ← ဤ File
│   ├── 02_code_flow.md
│   ├── 03_router_guide.md
│   ├── 04_navigation_methods.md
│   ├── 05_data_passing.md
│   └── 06_best_practices.md
│
├── GOROUTER_GUIDE.md             ← Original Full Guide
├── pubspec.yaml                  ← Dependencies (go_router, provider)
└── README.md                     ← Flutter Default README
```

---

## 📋 File တစ်ခုချင်းစီ ရှင်းလင်းချက်

### `lib/main.dart` — App Entry Point

```dart
void main() {
  runApp(
    ChangeNotifierProvider(    // AuthService ကို App Level တွင် Provide
      create: (_) => AuthService(),
      child: const GoRouterLearnApp(),
    ),
  );
}
```

**ဤ File ၏ တာဝန်:**
- App ကို Start ပေးသည်
- Provider ဖြင့် AuthService ကို Global Scope တွင် ထားသည်
- GoRouter Instance ကို Create လုပ်ပြီး MaterialApp.router တွင် ထည့်သည်

---

### `lib/models/` — Data Models

#### `user_model.dart`
```dart
class UserModel {
  final String id;       // 'u001'
  final String name;     // 'Ko Aung'
  final String email;    // 'koaung@example.com'
  final String avatar;   // '👨‍💻'
  final String role;     // 'admin' / 'student'
}
```

#### `product_model.dart`
```dart
class ProductModel {
  final String id;           // 'p001'
  final String name;         // 'Flutter Pro Course'
  final String description;  // Long text
  final double price;        // 49.99
  final String category;     // 'Education'
  final String imageEmoji;   // '📱'
  final double rating;       // 4.8
  final int reviewCount;     // 1250
  final bool isInStock;      // true/false
}
```

**Why Plain Dart Classes?**
> Model Classes သည် Data Structure ကိုသာ သတ်မှတ်သည်။
> Business Logic မပါဝင်ပါ။ Type-safe ဖြင့် Data ကို Handle လုပ်နိုင်သည်။

---

### `lib/data/mock_data.dart` — Sample Data

```dart
class MockData {
  // 6 Sample Products
  static final List<ProductModel> products = [ ... ];

  // Helper Methods
  static ProductModel? findById(String id) { ... }
  static List<ProductModel> findByCategory(String category) { ... }
  static List<String> get categories { ... }
}
```

**Why Mock Data?**
> Real API (Firebase, REST) မရှိသေးသောကြောင့် Mock Data ဖြင့်
> App ၏ UI နှင့် Navigation ကို Test လုပ်နိုင်သည်။
> API ချိတ်ဆက်ချင်သောအခါ MockData ကို API Call ဖြင့် Replace လုပ်ရုံသာ ရသည်။

---

### `lib/services/auth_service.dart` — Authentication

```dart
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  UserModel? get currentUser => _currentUser;

  Future<bool> login(String email, String password) async { ... }
  Future<void> logout() async { ... }
}
```

**ChangeNotifier ကိုသုံးရသောအကြောင်း:**
- `notifyListeners()` ဖြင့် GoRouter ၏ `refreshListenable` ကို Trigger လုပ်နိုင်သည်
- Provider ဖြင့် UI Widgets များကို Auth State ပြောင်းသည်နှင့် Rebuild လုပ်စေနိုင်သည်

---

### `lib/router/app_router.dart` — Navigation Brain

**ဤ File ၏ တာဝန် ၃ ခု:**

1. **AppRoutes Constants** — Path Strings ကို Typo မဖြစ်အောင် သတ်မှတ်သည်
2. **GoRouter Instance** — Route Tree, Auth Guard, Error Page သတ်မှတ်သည်
3. **Route Builders** — URL → Screen Mapping လုပ်သည်

```
/login                  → LoginScreen
/home                   → HomeScreen (ShellRoute ထဲ)
/home/product/:id       → ProductDetailScreen
/profile                → ProfileScreen (ShellRoute ထဲ)
/navigation-demo        → NavigationDemoScreen (ShellRoute ထဲ)
/data-passing           → DataPassingScreen (ShellRoute ထဲ)
/settings               → SettingsScreen (ShellRoute ထဲ)
```

---

### `lib/widgets/main_scaffold.dart` — Persistent Shell

**ShellRoute ၏ Shell Widget ဖြစ်သည်**

```dart
class MainScaffold extends StatelessWidget {
  final Widget child;  // ← Active Tab ၏ Screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,              // Active Tab Screen ပြသသည်
      bottomNavigationBar: ..., // Always Visible
    );
  }
}
```

---

### `lib/screens/` — Page Widgets

| Screen | GoRouter Concept | URL |
|--------|----------------|-----|
| `login_screen.dart` | Auth Guard, Redirect | `/login` |
| `home_screen.dart` | push(), Product List | `/home` |
| `product_detail_screen.dart` | Path Params, Extra, pop(data) | `/home/product/:id` |
| `navigation_demo_screen.dart` | push/pop/go/replace, Stack Visual | `/navigation-demo` |
| `data_passing_screen.dart` | Query/Extra/Path/Return | `/data-passing` |
| `profile_screen.dart` | Logout, Redirect Flow | `/profile` |
| `settings_screen.dart` | GoRouterState, Deep Links | `/settings` |
| `error_screen.dart` | errorBuilder, 404 | Any unknown URL |

---

## 🏗️ Architecture Layers

```
┌─────────────────────────────────────────┐
│              UI Layer                   │
│   screens/ + widgets/                   │
│   (Page Widgets, Bottom Nav)            │
├─────────────────────────────────────────┤
│           Navigation Layer              │
│   router/app_router.dart               │
│   (Route Tree, Auth Guard, GoRouter)    │
├─────────────────────────────────────────┤
│            Service Layer                │
│   services/auth_service.dart           │
│   (Business Logic, State Management)    │
├─────────────────────────────────────────┤
│             Data Layer                  │
│   data/mock_data.dart + models/        │
│   (Data Models, Mock/Real Data)         │
└─────────────────────────────────────────┘
```

> **Next:** `02_code_flow.md` တွင် App ၏ Data Flow ကို ကြည့်ပါ

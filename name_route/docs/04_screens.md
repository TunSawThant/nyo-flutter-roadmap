# 04 — Screens (Login, Home, Detail, Logout)

> **ဤ file ဖြင့် သင်ယူမည့်အရာ:** Screen တစ်ခုချင်းစီ ၏ Navigation role, Data flow, Code pattern

---

## Screen Overview

```
┌──────────────┬──────────────────────────────────────────────┐
│ Screen       │ Navigation Role                              │
├──────────────┼──────────────────────────────────────────────┤
│ LoginScreen  │ pushReplacementNamed → Home (+ UserModel)    │
│ HomeScreen   │ Data receive + pushNamed → Detail/Logout     │
│ DetailScreen │ Data receive + pop(data) → Home              │
│ LogoutScreen │ pushNamedAndRemoveUntil → Login              │
└──────────────┴──────────────────────────────────────────────┘
```

---

## 1️⃣ LoginScreen

**File:** `lib/screens/login_screen.dart`
**Route:** `/` (initial route)
**Navigation:** `pushReplacementNamed('/home', arguments: user)`

---

### Constructor

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  // Arguments မလိုအပ် — initial screen
}
```

### State Variables

```dart
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();        // Form validation key
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;      // loading indicator
  bool _obscurePassword = true; // password show/hide
  String? _errorMessage;        // error display
}
```

### Core Logic — `_handleLogin()`

```dart
Future<void> _handleLogin() async {
  // ① Form validate
  if (!_formKey.currentState!.validate()) return;

  // ② Loading state
  setState(() { _isLoading = true; });

  // ③ Simulate API delay
  await Future.delayed(const Duration(seconds: 1));

  // ④ Mock authentication
  final matchedUser = mockUsers.where((user) {
    return user.email == _emailController.text.trim() &&
           user.password == _passwordController.text;
  }).firstOrNull;

  if (!mounted) return;  // Widget disposed check

  // ⑤ Navigate based on result
  if (matchedUser != null) {
    // ✅ SUCCESS: pushReplacementNamed
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: matchedUser,   // ← UserModel pass
    );
    // Login page → stack မှ ပျောက်သည်
    // Back နှိပ်လျှင် login သို့ မပြန်နိုင်
  } else {
    // ❌ FAIL: error message
    setState(() {
      _isLoading = false;
      _errorMessage = 'Email/Password မှားသည်';
    });
  }
}
```

### Key Concept: `pushReplacementNamed` vs `pushNamed`

```
pushNamed('/home'):
Stack:  [Login] [Home]   ← Login ကျန်နေ, back နှိပ်ရင် login ပြန်ရ

pushReplacementNamed('/home'):
Stack:  [Home]           ← Login ပျောက်, back နှိပ်ရင် app ထွက်
```

### Form Validation

```dart
TextFormField(
  validator: (value) {
    if (value == null || value.isEmpty) return 'Email ထည့်ပါ';
    if (!value.contains('@')) return 'Valid email ဖြစ်ရမည်';
    return null;  // null = valid ✅
  },
)
```

### Widget Disposal — Memory Leak ကာကွယ်ခြင်း

```dart
@override
void dispose() {
  _emailController.dispose();     // ← မဖျက်လျှင် memory leak
  _passwordController.dispose();
  super.dispose();
}
```

---

## 2️⃣ HomeScreen

**File:** `lib/screens/home_screen.dart`
**Route:** `/home`
**Receives:** `UserModel` (from Login)
**Sends:** `ProductModel` → Detail, `UserModel` → Logout
**Returns from Detail:** `String` (review text)

---

### Constructor (Type-safe)

```dart
class HomeScreen extends StatefulWidget {
  final UserModel user;  // ← typed, not Object?

  const HomeScreen({super.key, required this.user});
}
```

### State

```dart
class _HomeScreenState extends State<HomeScreen> {
  // getter — widget.user ကိုတိုက်ရိုက်
  UserModel get _currentUser => widget.user;

  // Detail မှ return လာသော reviews
  final List<String> _receivedReviews = [];
}
```

### Core Logic 1 — `_navigateToDetail()` with Return Data

```dart
Future<void> _navigateToDetail(ProductModel product) async {

  // ① await + pushNamed (detail မှ pop ကိုစောင့်)
  final returnedData = await Navigator.pushNamed(
    context,
    AppRoutes.detail,
    arguments: product,    // ← ProductModel pass
  );

  // ② Return data handle
  if (returnedData != null && returnedData is String) {
    // Detail မှ Navigator.pop(context, reviewText) ခေါ်သောအခါ
    // returnedData = reviewText (String)
    setState(() {
      _receivedReviews.add('${product.name}: $returnedData');
    });
  }
  // returnedData = null → back button (data မပါ) နှိပ်ခဲ့
}
```

**`await` ၏ အကျိုး:**
```
pushNamed()     → Detail page ဖွင့်
await           → Detail မပိတ်မချင်း ဤနေရာ hold
pop(ctx, data)  → Detail ပိတ်, data return
await ပြီး       → returnedData ရသည်, code ဆက်သွား
```

### Core Logic 2 — `_navigateToLogout()`

```dart
void _navigateToLogout() {
  Navigator.pushNamed(
    context,
    AppRoutes.logout,
    arguments: _currentUser,   // ← UserModel pass (logout confirm)
  );
  // Logout page stack အပေါ်တင် (Home မပျောက်သေး)
}
```

---

## 3️⃣ DetailScreen

**File:** `lib/screens/detail_screen.dart`
**Route:** `/detail`
**Receives:** `ProductModel` (from Home)
**Returns:** `String` (review) — optional

---

### Constructor (Type-safe)

```dart
class DetailScreen extends StatefulWidget {
  final ProductModel product;  // ← typed

  const DetailScreen({super.key, required this.product});
}
```

### State

```dart
class _DetailScreenState extends State<DetailScreen> {
  // getter — widget.product တိုက်ရိုက်
  ProductModel get _product => widget.product;

  final _reviewController = TextEditingController();
  bool _isAddedToCart = false;
}
```

### Core Logic 1 — Return Data ဖြင့် Pop

```dart
void _submitReviewAndReturn() {
  final reviewText = _reviewController.text.trim();

  if (reviewText.isEmpty) {
    // validation fail
    return;
  }

  // ✅ DATA ဖြင့် Pop
  // Home page ၏ await Navigator.pushNamed() မှ ဤ value ကိုရမည်
  Navigator.pop(
    context,
    reviewText,    // ← Return Data (String)
  );
}
```

### Core Logic 2 — Data မပါဘဲ Pop (Back button)

```dart
void _goBackWithoutReview() {
  Navigator.pop(context);
  // data မပါ → Home page ၏ returnedData = null
}
```

### Data Return Flow

```
DetailScreen                  HomeScreen
     │                             │
     │  (user presses submit)      │
     │                             │
     │  Navigator.pop(ctx,         │
     │    reviewText)              │
     │──────────────────────────►  │
                                   │
                           await finishes
                           returnedData = reviewText ✅
```

---

## 4️⃣ LogoutScreen

**File:** `lib/screens/logout_screen.dart`
**Route:** `/logout`
**Receives:** `UserModel?` (optional — null ခွင့်ပြု)
**Navigation:** `pushNamedAndRemoveUntil` → Login (stack clear)

---

### Constructor (Nullable Type)

```dart
class LogoutScreen extends StatefulWidget {
  final UserModel? user;    // ← nullable (null ဖြစ်နိုင်)

  const LogoutScreen({super.key, this.user});
  //                              ↑ not required
}
```

### State

```dart
class _LogoutScreenState extends State<LogoutScreen> {
  // ?? operator: null ဖြစ်ပါက fallback value
  UserModel get _currentUser => widget.user ?? mockUsers.first;
  // widget.user = UserModel → use it
  // widget.user = null     → use mockUsers.first
}
```

### Core Logic — `_confirmLogout()`

```dart
Future<void> _confirmLogout() async {
  setState(() => _isLoggingOut = true);

  // Loading animation
  await Future.delayed(const Duration(milliseconds: 800));

  if (!mounted) return;

  // ✅ pushNamedAndRemoveUntil — Stack Clear
  Navigator.pushNamedAndRemoveUntil(
    context,
    AppRoutes.login,     // ← push မည့် route
    (route) => false,    // ← predicate: stack အားလုံး ဖျက်
  );
}
```

### Predicate Function ကို ပိုနားလည်ရန်

```dart
// predicate = (Route route) => bool
// Flutter က stack ထဲ route တစ်ခုချင်းစီကို ဤ function ဖြင့် စစ်သည်

(route) => false
// route တိုင်း false → ဖျက်မည် → stack ကွက်လပ်ဖြစ်
// ထို့နောက် '/login' ကို push လုပ်သည်

(route) => route.isFirst
// ပထမဆုံး route မှအပ ကျန်တာ ဖျက်
// Result: [ပထမ route] [login]

ModalRoute.withName(AppRoutes.home)
// '/home' route ကိုတွေ့သည့်အထိ ဖျက်
// Result: [home] [login]
```

### Cancel Logout

```dart
void _cancelLogout() {
  Navigator.pop(context);
  // Logout screen ပိတ်၊ Home ကို ပြန်ပြ
}
```

---

## 5️⃣ Screens ၏ `dispose()` Method

Memory leak ဖြစ်ခြင်းကို ကာကွယ်ရန် **Controller** များကို ဖျက်ရမည်။

```dart
// ✅ LoginScreen
@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();  // ← always last
}

// ✅ DetailScreen
@override
void dispose() {
  _reviewController.dispose();
  super.dispose();
}
```

**Rule:** `TextEditingController`, `AnimationController`, `StreamSubscription`
တို့ကို `initState()` တွင် create လျှင် `dispose()` တွင် မဖြစ်မနေ dispose လုပ်ရမည်။

---

## 6️⃣ `mounted` Check

```dart
// async function ထဲတွင် await ပြီးနောက်
// Widget ဖြစ်ဆဲမဆဲ စစ်ဆေးရမည်

Future<void> _handleLogin() async {
  await Future.delayed(Duration(seconds: 1));

  if (!mounted) return;  // ← ဤ check မပါက error ဖြစ်နိုင်

  // mounted = true မှသာ ဆက်သွားမည်
  Navigator.pushReplacementNamed(context, AppRoutes.home, ...);
}
```

**ဘာကြောင့် မလိုအပ်သည်?**
```
await လုပ်နေချိန်တွင် user က back နှိပ်ပြီး
screen ကို destroy လုပ်သွားနိုင်သည်
→ mounted = false
→ Navigator ခေါ်ဆိုပါက error
→ if (!mounted) return; ဖြင့် ကာကွယ်သည်
```

---

## 7️⃣ Screen-by-Screen Data Table

| Screen | Receives | Sends | Returns |
|--------|---------|-------|---------|
| **Login** | — | `UserModel` → Home | — |
| **Home** | `UserModel` (from Login) | `ProductModel` → Detail | — |
| **Home** | — | `UserModel` → Logout | — |
| **Detail** | `ProductModel` (from Home) | — | `String?` → Home |
| **Logout** | `UserModel?` (from Home) | — | Stack clear → Login |

---

## 8️⃣ Common Patterns — Quick Reference

```dart
// ─── Screen တွင် Data Receive ─────────────────────────────

// Typed constructor (route_generator မှ pass)
class MyScreen extends StatefulWidget {
  final UserModel user;                    // typed ✅
  const MyScreen({super.key, required this.user});
}

// Getter ဖြင့် access
UserModel get _user => widget.user;

// ─── Screen မှ Navigate ──────────────────────────────────

// → push with data
Navigator.pushNamed(context, AppRoutes.detail, arguments: product);

// → push + await return
final result = await Navigator.pushNamed(context, AppRoutes.detail, arguments: product);

// → replace (no back)
Navigator.pushReplacementNamed(context, AppRoutes.home, arguments: user);

// → stack clear
Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);

// → back (no data)
Navigator.pop(context);

// → back (with data)
Navigator.pop(context, reviewText);
```

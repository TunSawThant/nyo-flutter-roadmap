# 🔄 Code Flow & App Architecture

> App ဖွင့်သည်မှ User ၏ Action တိုင်းတွင် Code ဘယ်လို Flow ဖြင့် အလုပ်လုပ်သည်ကို ဖော်ပြသည်

---

## 1️⃣ App Launch Flow

App ကို `flutter run` ဖြင့် ဖွင့်သည်နှင့် ဤ Sequence ဖြင့် အလုပ်လုပ်သည်:

```
main() ကိုခေါ်သည်
       │
       ▼
ChangeNotifierProvider(create: AuthService)
  AuthService Instance တည်ဆောက်သည်
  _currentUser = null (Not Logged In)
       │
       ▼
GoRouterLearnApp Widget Build
  createRouter(authService) ကိုခေါ်သည်
  GoRouter Instance တည်ဆောက်သည်:
    - initialLocation = '/login'
    - redirect() function သတ်မှတ်
    - refreshListenable = authService
    - routes Tree သတ်မှတ်
       │
       ▼
MaterialApp.router(routerConfig: _router)
  GoRouter ကို Navigation System အဖြစ် Register
       │
       ▼
GoRouter ၏ redirect() ကိုခေါ်သည်
  isLoggedIn = false
  isOnLogin = true  (initialLocation = /login)
  → return null (Allow /login)
       │
       ▼
LoginScreen Widget ပြသသည် ✅
```

---

## 2️⃣ Login Flow

User က Email / Password ထည့်ပြီး Login Button နှိပ်သောအခါ:

```
LoginScreen._handleLogin() ကိုခေါ်သည်
       │
       ▼
Form Validation စစ်သည်
  email empty? → Error ပြ
  password empty? → Error ပြ
       │
       ▼
AuthService.login(email, password) ကိုခေါ်သည်
  _isLoading = true
  notifyListeners() → Loading Spinner ပြ
       │
       ▼
Future.delayed(1500ms) — API Call Simulate
       │
       ▼
Password == 'password123' ?
  YES →  _currentUser = foundUser
         _isLoading = false
         notifyListeners()  ←── KEY MOMENT
              │
              ▼
         GoRouter ၏ refreshListenable notify ဖြစ်သည်
         redirect() ကို Re-run:
           isLoggedIn = true
           isOnLogin = true
           → return '/home'
              │
              ▼
         HomeScreen Auto-Navigate ✅ (Manual go() မလို)

  NO  →  _isLoading = false
         notifyListeners()
         return false
         LoginScreen တွင် Error Message ပြ
```

---

## 3️⃣ Navigation Flow (push example)

User က Home Screen တွင် Product Card ကို Tap သောအခါ:

```
HomeScreen._navigateToDetail(product) ကိုခေါ်သည်
       │
       ▼
context.push(
  '/home/product/p001',
  extra: {'from': 'home_screen', 'category': 'Education'}
)
       │
       ▼
GoRouter ၏ redirect() Run:
  isLoggedIn = true → return null (Allow)
       │
       ▼
Route Match: '/home/product/:productId'
  pathParameters['productId'] = 'p001'
  state.extra = {'from': 'home_screen', ...}
       │
       ▼
ProductDetailScreen(
  productId: 'p001',
  fromSource: 'home_screen',
) တည်ဆောက်သည်
       │
       ▼
MockData.findById('p001') ခေါ်ပြီး Product Data ရယူ
       │
       ▼
ProductDetailScreen ပြသသည် ✅
Navigation Stack: [HomeScreen, ProductDetailScreen]
```

---

## 4️⃣ Logout Flow (Auth Redirect Magic)

User က Profile Screen ၏ Logout Button နှိပ်သောအခါ:

```
ProfileScreen._LogoutSection Button onPressed
       │
       ▼
AuthService.logout() ကိုခေါ်သည်
  _isLoading = true
  notifyListeners() → Button Loading State
       │
       ▼
Future.delayed(800ms)
       │
       ▼
_currentUser = null  ←── KEY MOMENT
_isLoading = false
notifyListeners()
       │
       ▼
GoRouter refreshListenable Triggered
redirect() Re-run:
  isLoggedIn = false (currentUser = null)
  isOnLogin = false  (currently on /profile)
  → return '/login'  ←── Auto-Redirect!
       │
       ▼
LoginScreen Navigate ✅
Navigation Stack: [LoginScreen]
(Manual context.go('/login') မလိုပါ!)
```

---

## 5️⃣ Data Flow — MockData မှ Screen သို့

```
App Start
    │
    ▼
MockData.products (Static List in Memory)
    │
    ├──► HomeScreen
    │      MockData.products ကိုဖတ်ပြီး Grid ပြ
    │      Filter: MockData.findByCategory(category)
    │
    ├──► ProductDetailScreen
    │      MockData.findById(productId) ကိုခေါ်
    │      Product Data ရပြီး UI ဆောက်
    │
    └──► DataPassingScreen
           Product ID List ပြပြီး Tap ဖြင့် Detail သွား
```

---

## 6️⃣ ShellRoute — Bottom Navigation Architecture

```
GoRouter Route Tree
│
├── /login → LoginScreen (Shell မပါ)
│
└── ShellRoute (MainScaffold = BottomNav Wrapper)
      │
      ├── /home → HomeScreen
      │     └── /home/product/:id → ProductDetailScreen
      │
      ├── /profile → ProfileScreen
      │
      ├── /navigation-demo → NavigationDemoScreen
      │
      ├── /data-passing → DataPassingScreen
      │
      └── /settings → SettingsScreen
```

**URL Change → UI Update Flow:**

```
User Tap Bottom Nav "Profile"
       │
       ▼
context.go('/profile')
       │
       ▼
GoRouter: URL changes to /profile
       │
       ▼
ShellRoute builder ကို Re-call:
  child = ProfileScreen()
       │
       ▼
MainScaffold(child: ProfileScreen()) Render
  BottomNav ဆက်ရှိနေ (Persistent) ✅
  ActiveIndex: Profile Tab Highlight ✅
```

---

## 7️⃣ State Management Flow

```
AuthService (ChangeNotifier)
       │
       ├── Provider ─────────────────► UI Widgets
       │   context.watch<AuthService>()   Rebuild on change
       │   context.read<AuthService>()    One-time read
       │
       └── GoRouter ─────────────────► Route Redirect
           refreshListenable: authService   Auto re-redirect
```

**Widget Rebuild Flow:**

```dart
// HomeScreen တွင်
final user = context.watch<AuthService>().currentUser;
// AuthService.notifyListeners() ခေါ်တိုင်း ဤ Widget Rebuild ဖြစ်မည်

// SettingsScreen တွင်
final auth = context.watch<AuthService>();
// isLoading ပြောင်းသောအခါ Loading Button State Rebuild
```

---

## 8️⃣ Complete Request-Response Cycle

Product Detail Page ကို Deep Link (`myapp://home/product/p001`) ဖြင့် ဝင်သောအခါ:

```
Deep Link: /home/product/p001
       │
       ▼
GoRouter URL Parse
       │
       ▼
redirect() စစ်သည်:
  isLoggedIn? YES → null (continue)
             NO  → '/login' (redirect first)
       │
       ▼
Route Match: /home/product/:productId
  pathParameters = {'productId': 'p001'}
  extra = null (Deep Link မှ Extra မပါ!)
       │
       ▼
ShellRoute builder:
  MainScaffold(child: ProductDetailScreen(productId: 'p001'))
       │
       ▼
ProductDetailScreen.build():
  MockData.findById('p001') → product
  fromSource = null (extra မပါ)
  UI Build ✅
```

> **Deep Link တွင် Extra Data မပါသည်ကို မမေ့ပါနှင့်!**
> Extra Data သည် In-App Navigation တွင်သာ Survive ဖြစ်သည်။

---

> **Next:** `03_router_guide.md` တွင် GoRouter Setup ကို အသေးစိတ် ကြည့်ပါ

# 🧭 Navigation Methods — push / pop / go / replace

> ဖိုင်: `lib/screens/navigation_demo_screen.dart`
> App တွင် Interactive Demo နှင့်တွဲဖတ်ပါ (Navigation Demo Tab)

---

## Method Overview

```dart
// ─── 4 Main Methods ───────────────────────────────────────
context.push('/path')      // Stack ထဲ ထပ်ထည့် (Back ပြန်နိုင်)
context.pop()              // Stack မှ ဖျက် (Back)
context.go('/path')        // Stack Reset ပြီး Navigate
context.replace('/path')   // Current Page ကို Swap
```

---

## 1. context.push()

### ဘာလုပ်သနည်း?
Navigation Stack ထဲတွင် Page အသစ်ကို **ထိပ်ဆုံးတွင် ထပ်ထည့်**သည်

```dart
// Home Screen တွင်
context.push('/home/product/p001');

// Before:  Stack = [LoginScreen]  (Login ဝင်ပြီးနောက်)
// Before:  Stack = [HomeScreen]
// After:   Stack = [HomeScreen, ProductDetailScreen]
//                                ↑ ထိပ်ဆုံးတွင် ထည့်
```

### Back Button ဖိသောအခါ
```
Stack: [Home, Detail]
         Back Button ↓
Stack: [Home]
Detail ပျောက်ပြီး Home ပြန်ပြသမည် ✅
```

### push() + Extra Data
```dart
context.push(
  '/home/product/p001',
  extra: {
    'from': 'home_screen',
    'category': 'Education',
  },
);
```

### push() + Return Data (await)
```dart
// push() သည် Future<T?> ပြန်ပေးသည် → await ဖြင့်စောင့်နိုင်
final result = await context.push<Map<String, dynamic>>(
  '/home/product/p001',
);

if (result != null) {
  print('User did: ${result['action']}');
}
```

### Use Cases
| Situation | push() သုံးရ |
|-----------|------------|
| Product Detail ကြည့် | ✅ (Back ပြန်နိုင်ရမည်) |
| Article / Blog ဖွင့် | ✅ |
| Sub-form (Address, Payment) | ✅ |
| Bottom Sheet Alternative | ✅ |
| Tab Navigation | ❌ go() ကိုသုံးပါ |

---

## 2. context.pop()

### ဘာလုပ်သနည်း?
Navigation Stack ၏ **ထိပ်ဆုံး Page ကို ဖယ်ရှား**သည် (Back)

```dart
context.pop();

// Before: Stack = [Home, Detail]
// After:  Stack = [Home]
```

### pop() + Data
```dart
// Result Data ဖြင့် ပြန်သွားနိုင်သည်
context.pop({
  'action': 'purchased',
  'quantity': 2,
});
// push() ကို await ဖြင့်ခေါ်ထားသော Screen တွင် ဤ Data ရလာမည်
```

### Safe pop — canPop() စစ်ရန်
```dart
// ❌ Unsafe
context.pop(); // Stack တွင် Page တစ်ခုသာ ကျန်ရင် Error ဖြစ်နိုင်

// ✅ Safe
if (context.canPop()) {
  context.pop();
} else {
  // Root page — pop မနိုင်
  // App exit: SystemNavigator.pop(); (Android only)
}
```

### Use Cases
| Situation | pop() သုံးရ |
|-----------|------------|
| Back Button implement | ✅ |
| Dialog ပိတ် | ✅ |
| BottomSheet ပိတ် | ✅ |
| Form Cancel | ✅ |
| Tab ပြောင်း | ❌ go() ကိုသုံးပါ |

---

## 3. context.go()

### ဘာလုပ်သနည်း?
**Stack ကို ဖျက်ပြီး** Page အသစ်ကို Navigate သည်

```dart
context.go('/profile');

// Before: Stack = [Home, Detail, SubPage]
// After:  Stack = [Profile]   ← Stack ကို Reset လုပ်ပြီး
```

### Back Button ဖိသောအခါ
```
Stack: [Profile]  ← တစ်ခုသာ ကျန်
       Back Button ↓
App မှ ထွက် (Android) သို့ Home Screen ပြ
```

### go() ၏ URL Change
```dart
// go() သည် URL Bar ကိုလည်း Update လုပ်သည် (Web)
context.go('/profile');
// Browser URL: myapp.com/profile ✅
```

### Use Cases
| Situation | go() သုံးရ |
|-----------|----------|
| Bottom Nav Tab ပြောင်း | ✅ |
| Login ပြီးနောက် Home Navigate | ✅ (Login ကို Back မပြန်ချင်) |
| Logout ပြီးနောက် Login Navigate | ✅ |
| Root Level Route Navigate | ✅ |
| Deep Link Navigate | ✅ |
| Detail page (Back ပြန်ချင်ရင်) | ❌ push() ကိုသုံးပါ |

---

## 4. context.replace()

### ဘာလုပ်သနည်း?
Stack ၏ **ထိပ်ဆုံး Page ကိုသာ Swap** လုပ်သည် (Stack Size မပြောင်း)

```dart
// Stack = [A, B]
context.replace('/c');
// Stack = [A, C]   ← B ကို C ဖြင့် Replace
```

### go() vs replace() ကြားခြားနားချက်
```dart
// go() — Stack ကို ပြည်လုံး Reset
context.go('/c');
// [A, B] → [C]

// replace() — ထိပ်သာ Swap
context.replace('/c');
// [A, B] → [A, C]
// Back နှိပ်သောအခါ A ကို ပြန်သွားနိုင်သည်
```

### Use Cases
| Situation | replace() သုံးရ |
|-----------|--------------|
| Login Page → Home (Login Back မသွားချင်) | ✅ |
| OTP Page → Success Page | ✅ |
| Step 1 → Step 2 (Wizard, No back) | ✅ |
| A/B Test Route Swap | ✅ |

---

## 5. Visual Stack Comparison

```
═══════════════════════════════════════════════════
  Initial Stack: [A]
═══════════════════════════════════════════════════

  push('/b')          pop()               go('/b')          replace('/b')
  ────────────────   ──────────────────   ──────────────   ─────────────────
  [A] → [A, B]        [A, B] → [A]        [A] → [B]         [A, C] → [A, B]
  Back: B→A           (removes top)       Back: B→Exit      Back: B→A

═══════════════════════════════════════════════════
```

---

## 6. Named Route Variants

**Named Routes ကိုသုံးပြီး Same Operations လုပ်နိုင်သည်:**

```dart
// push + name
context.pushNamed(
  'product-detail',                       // Route name
  pathParameters: {'productId': 'p001'},  // :productId = 'p001'
  queryParameters: {'ref': 'home'},       // ?ref=home
  extra: {'from': 'named_push'},
);

// go + name
context.goNamed(
  'product-detail',
  pathParameters: {'productId': 'p001'},
);

// replace + name
context.replaceNamed(
  'product-detail',
  pathParameters: {'productId': 'p002'},
);
```

**Named Routes ကောင်းသောအကြောင်း:**
```dart
// Path String ကို မမှတ်ရ
context.go('/home/product/p001');    // Path မှတ်ရသည်

// Route Name ကိုသာ မှတ်ရ
context.goNamed(                     // Name မှတ်ရသည် (Refactoring Safe)
  'product-detail',
  pathParameters: {'productId': 'p001'},
);
```

---

## 7. Method Quick Decision Guide

```
Navigate မည်ဆိုလျှင် ─────────────────────────────────
                           │
                    ┌──────▼──────┐
                    │ Back ပြန်   │
                    │ ချင်သလား?  │
                    └──────┬──────┘
                     YES   │   NO
              ┌────────────┘   └──────────────────┐
              ▼                                    ▼
     ┌────────────────┐               ┌────────────────────┐
     │  Stack ၏       │               │ Current Page ကို   │
     │  ထိပ်ဆုံးမှ    │               │ Replace ချင်သလား? │
     │  ဖျက်ချင်သလား?│               └──────────┬─────────┘
     └───────┬────────┘                   YES    │   NO
        YES  │  NO                   ┌───────────┘   └──────────┐
             │   │                   ▼                           ▼
             ▼   ▼               replace()                     go()
           pop() push()
```

---

## 8. App တွင် ကြည့်ပါ (Navigation Demo Tab)

**Tab 1 — Stack Visualizer:**
- push/pop/go/replace Buttons နှိပ်ပါ
- Stack ပြောင်းလဲသည်ကို Real-time မြင်ရမည်

**Tab 2 — Interactive Navigation:**
- "Push Detail" → push() ဖြင့် Detail သွားပါ
- Detail တွင် Back → pop() ဖြင့် ပြန်လာပါ
- "Go Home" → go() ဖြင့် Stack Reset မြင်ပါ

**Tab 3 — Named Routes:**
- goNamed() / pushNamed() Buttons ကို ကြည့်ပါ

---

> **Next:** `05_data_passing.md` တွင် Data ပေးပို့နည်းများ ကြည့်ပါ

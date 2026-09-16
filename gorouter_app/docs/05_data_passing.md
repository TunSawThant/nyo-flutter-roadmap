# 📦 Data Passing — Routes ကြားတွင် Data ပေးပို့နည်း

> ဖိုင်: `lib/screens/data_passing_screen.dart` + `lib/screens/product_detail_screen.dart`
> App တွင် Data Passing Tab နှင့်တွဲဖတ်ပါ

---

## Overview — Data Passing Methods 4 မျိုး

| Method | ဘယ်လိုသုံးသနည်း | Deep Link | Type-safe |
|--------|---------------|-----------|-----------|
| **Path Parameter** | URL ၏ Segment (`/product/:id`) | ✅ | ✅ |
| **Query Parameter** | URL ၏ Query (`?key=val`) | ✅ | ❌ String only |
| **Extra Data** | `extra: obj` | ❌ | ❌ cast လုပ်ရ |
| **Return Data** | `pop(data)` + `await push()` | N/A | ✅ Generic |

---

## Method 1: Path Parameters

### ဘာသုံးရသနည်း?
URL ၏ Segment တစ်ခုကို Variable ဖြစ်အောင် သတ်မှတ်ပြီး Data ထည့်သည်

### Route Definition
```dart
// lib/router/app_router.dart

GoRoute(
  path: 'product/:productId',
  // ↑ ':productId' = Dynamic Segment
  // Full URL: /home/product/p001
  //                         ↑ ဤ part သည် pathParameter ဖြစ်သည်

  builder: (context, state) {
    // ─── Reading Path Parameter ───────────────────────────
    final productId = state.pathParameters['productId'];
    // productId = 'p001' (URL: /home/product/p001)
    // productId = 'p002' (URL: /home/product/p002)
    // null မဖြစ်နိုင် — URL match ဖြစ်ရမှ ဤ builder ကိုခေါ်မည်

    // Non-null assertion (!) ကိုသုံးနိုင်
    final id = state.pathParameters['productId']!;

    return ProductDetailScreen(productId: id);
  },
),
```

### Navigate ပုံ
```dart
// Method A: Path String ဖြင့်
context.push('/home/product/p001');  // productId = 'p001'
context.push('/home/product/p004');  // productId = 'p004'

// Method B: AppRoutes Helper ဖြင့်
context.push(AppRoutes.productDetailPath('p001'));

// Method C: Named Route ဖြင့်
context.pushNamed(
  'product-detail',
  pathParameters: {'productId': 'p001'},
);
```

### Multiple Path Parameters
```dart
// Route Definition
GoRoute(path: 'category/:catId/product/:productId')

// Navigate
context.push('/category/education/product/p001');

// Reading
final catId     = state.pathParameters['catId'];      // 'education'
final productId = state.pathParameters['productId'];  // 'p001'
```

### ✅ ကောင်းသောအချက်
- Deep Link ဖြင့် Data ပါလာမည်: `myapp://home/product/p001`
- URL ကိုကြည့်ရုံဖြင့် Data ကို ချက်ချင်းသိနိုင်
- Web Bookmark / Share URL အလုပ်လုပ်သည်
- Browser Refresh ဖြင့်လည်း Data ပျောက်မသည်

---

## Method 2: Query Parameters

### ဘာသုံးရသနည်း?
URL ၏ `?` ပြီးနောက် Key=Value Pair ဖြင့် Optional Data ပေးပို့သည်

### Navigate ပုံ
```dart
// Simple
context.go('/data-passing?tab=query');

// Multiple Query Params
context.go('/data-passing?tab=query&sort=asc&page=2&category=education');
// URL: /data-passing?tab=query&sort=asc&page=2&category=education
```

### Route တွင် ရယူပုံ
```dart
GoRoute(
  path: '/data-passing',
  builder: (context, state) {
    // ─── Reading Query Parameters ──────────────────────────
    final tab      = state.uri.queryParameters['tab'];       // 'query'
    final sort     = state.uri.queryParameters['sort'];      // 'asc'
    final page     = state.uri.queryParameters['page'];      // '2' (String!)
    final category = state.uri.queryParameters['category'];  // 'education'

    // All params are String — convert if needed
    final pageNum = int.tryParse(page ?? '1') ?? 1;  // String → int

    return DataPassingScreen(
      initialTab: tab ?? 'query',
      sortOrder: sort ?? 'asc',
      pageNumber: pageNum,
    );
  },
),
```

### Named Route ဖြင့် Query Params
```dart
context.goNamed(
  'data-passing',
  queryParameters: {
    'tab': 'query',
    'sort': 'desc',
    'page': '3',
  },
);
```

### Widget ထဲတွင် Query Params ရယူပုံ
```dart
// GoRouterState.of(context) ဖြင့် Widget ထဲတွင်လည်း ရနိုင်
class DataPassingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = GoRouterState.of(context);
    final tab = state.uri.queryParameters['tab'] ?? 'query';
    return Text('Active Tab: $tab');
  }
}
```

### ✅ ကောင်းသောအချက်
- Optional — မပေးလျှင်လည်း Route Match ဖြစ်မည်
- Deep Link Safe
- Multiple Values တစ်ပြိုင်နက် ပို့နိုင်
- Filter / Sort State ကို URL တွင် Save နိုင်

### ❌ အားနည်းချက်
- **String သာ ဖြစ်နိုင်သည်** — int, bool, List များကို String ဖြင့် Convert ရ
- URL တွင် မြင်ရသောကြောင့် Sensitive Data မထည့်သင့်

---

## Method 3: Extra Data

### ဘာသုံးရသနည်း?
Navigate ချိန်တွင် Any Dart Object ကို တိုက်ရိုက် Pass လုပ်သည်

### Navigate ပုံ
```dart
// Map ဖြင့် Extra Pass
context.push(
  '/home/product/p001',
  extra: {
    'from': 'home_screen',
    'category': 'Education',
    'isRecommended': true,
    'timestamp': DateTime.now(),
    'relatedIds': ['p002', 'p003'],
  },
);

// Object ဖြင့် Extra Pass
context.push(
  '/home/product/p001',
  extra: myProductObject,  // Any Dart Object!
);
```

### Route တွင် ရယူပုံ
```dart
GoRoute(
  path: 'product/:productId',
  builder: (context, state) {
    // ─── Reading Extra ─────────────────────────────────────
    // extra သည် Object? ဖြစ်သောကြောင့် Cast လုပ်ရ
    final extra = state.extra as Map<String, dynamic>?;

    // Null-safe Access
    final from         = extra?['from'] as String?;
    final isRecommended = extra?['isRecommended'] as bool? ?? false;
    final relatedIds   = extra?['relatedIds'] as List<String>? ?? [];

    return ProductDetailScreen(
      productId: state.pathParameters['productId']!,
      fromSource: from,
    );
  },
),
```

### ⚠️ Extra Data ၏ အနှောင့်အယှက်

**Problem 1: Deep Link တွင် ပျောက်သည်**
```
Deep Link: myapp://home/product/p001

→ App ဖွင့်မည်
→ URL Parse လုပ်မည်
→ extra = null  ← ပျောက်သည်!
→ ProductDetailScreen(fromSource: null)  ← Null Handle လုပ်ရမည်
```

**Problem 2: Web Refresh တွင် ပျောက်သည်**
```
Browser URL: /home/product/p001
Browser Refresh ↓
→ extra = null ← ပျောက်သည်!
```

**ဖြေရှင်းနည်း — Extra nullable Handle လုပ်ပါ:**
```dart
// ProductDetailScreen တွင်
@override
Widget build(BuildContext context) {
  // fromSource null ဖြစ်နိုင်သောကြောင့် null-safe handle လုပ်ပါ
  if (fromSource != null) {
    // Extra Data ပါသောအချိန်
    Text('From: $fromSource')
  } else {
    // Deep Link / Refresh — Extra မရှိ
    Text('Direct Access')
  }
}
```

### ✅ ကောင်းသောအချက်
- Any Dart Object (DateTime, List, Custom Class) ပေးနိုင်
- URL တွင် မပြသောကြောင့် Internal Data ဖြစ်သည်
- Complex Object တစ်ခုလုံး Pass လုပ်နိုင်

### ❌ အားနည်းချက်
- Deep Link / Web Refresh တွင် ပျောက်သည်
- Type-safe မဟုတ် — Runtime Cast Error ဖြစ်နိုင်

---

## Method 4: Return Data (pop + await push)

### ဘာသုံးရသနည်း?
Sub-page မှ Result Data ကို Caller Page သို့ ပြန်ပေးပို့သည်

### Caller Page (Data ရယူမည့် Page)

```dart
// lib/screens/data_passing_screen.dart

Future<void> _openDetailForResult() async {
  // ─── push() ကို await ဖြင့်ခေါ်သည် ─────────────────────────
  // Generic Type <Map<String, dynamic>> — return type သတ်မှတ်
  final result = await context.push<Map<String, dynamic>>(
    '/home/product/p001',
    extra: {'from': 'return_demo', 'mode': 'purchase'},
  );
  // ← ဤနေရာသည် Callee Page ၏ pop() ခေါ်ပြီးမှ Resume ဖြစ်မည်

  // ─── Result Handle လုပ်သည် ──────────────────────────────────
  if (result == null) {
    print('User cancelled / Back pressed without data');
    return;
  }

  final action   = result['action'] as String;    // 'purchased'
  final quantity = result['quantity'] as int;     // 2
  final productId = result['productId'] as String; // 'p001'

  print('Action: $action, Qty: $quantity');
  // UI Update, API call, etc.
}
```

### Callee Page (Data ပြန်ပေးမည့် Page)

```dart
// lib/screens/product_detail_screen.dart

// ─── Option 1: Purchase Button ────────────────────────────
ElevatedButton(
  onPressed: () {
    context.pop({           // pop(data) ဖြင့် Data ဖြင့် ပြန်
      'action': 'purchased',
      'productId': 'p001',
      'quantity': _selectedQuantity,
      'totalPrice': product.price * _selectedQuantity,
    });
    // Caller ၏ await push() မှ Resume ဖြစ်ပြီး result = ဤ data
  },
  child: Text('Purchase'),
),

// ─── Option 2: Wishlist Button ────────────────────────────
OutlinedButton(
  onPressed: () {
    context.pop({
      'action': 'wishlisted',
      'productId': 'p001',
    });
  },
  child: Text('Add to Wishlist'),
),

// ─── Option 3: Back / Cancel ──────────────────────────────
IconButton(
  onPressed: () => context.pop(), // Data မပါ pop — result = null
  icon: Icon(Icons.arrow_back),
),
```

### Return Data Flow

```
DataPassingScreen
  final result = await context.push('/home/product/p001')
                                        │
                                        │  App waits here...
                                        │
                              ProductDetailScreen ပွင့်သည်
                              User ဘာတွေ လုပ်ပါမည်...
                                        │
                              context.pop({'action': 'purchased', ...})
                                        │
DataPassingScreen (Resume)
  result = {'action': 'purchased', ...}
  UI Update လုပ်သည် ✅
```

### ✅ ကောင်းသောအချက်
- Pages ကြားတွင် Local Communication လုပ်နိုင်
- Global State (Provider) မသုံးဘဲ Data Exchange လုပ်နိုင်
- Generic Type ဖြင့် Type-safe Result ရနိုင်
- Dialog/BottomSheet Pattern နှင့် တူသည် (Familiar)

---

## Comparison — မည်သည့် Method ကို ရွေးမည်?

```
Data pass ရန် ─────────────────────────────────────────────────────────
                              │
              ┌───────────────▼───────────────┐
              │ Deep Link / Web ကိုပါ         │
              │ Support ချင်သလား?            │
              └───────────┬───────────────────┘
                   YES    │     NO
          ┌──────────────┘     └───────────────────────────┐
          ▼                                                 ▼
  ┌───────────────────┐                        ┌───────────────────────┐
  │ Data သည် Page ၏  │                        │ Sub-page မှ Result    │
  │ Identity ဖြစ်သလား│                        │ ပြန်ချင်သလား?        │
  │ (Product ID, etc) │                        └──────────┬────────────┘
  └────────┬──────────┘                            YES    │    NO
     YES   │    NO                         ┌─────────────┘    └───────────┐
           │     │                         ▼                               ▼
           ▼     ▼                    Return Data                     Extra Data
    Path Param  Query Param           pop(data)                       extra: obj
    /product/:id  ?key=val            + await push()                  (In-App Only)
```

---

## App တွင် ကြည့်ပါ

**Data Passing Tab → Tabs:**
- **"Path" Tab:** Product ID Buttons → Path Param ဖြင့် Detail သွားသည်
- **"Query" Tab:** Filter Buttons → Query Params ဖြင့် Navigate
- **"Extra" Tab:** Complex Object Pass → Extra ဖြင့် Detail
- **"Return" Tab:** await push() + pop(data) Demo

---

> **Next:** `06_best_practices.md` တွင် Do's, Don'ts & Cheatsheet ကြည့်ပါ

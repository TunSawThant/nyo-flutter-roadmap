# 02 — Models (UserModel & ProductModel)

> **ဤ file ဖြင့် သင်ယူမည့်အရာ:** Flutter/Dart တွင် Data Model class များ ဘယ်လိုဖန်တီးသည်၊ Mock data ဘာကြောင့်သုံးသည်

---

## Model ဆိုတာ ဘာလဲ?

**Model** = Data ၏ structure (ပုံစံ) ကို သတ်မှတ်ပေးသော class

```
Real World         Flutter Model
──────────         ─────────────
User တစ်ယောက်  →   UserModel { id, username, email, ... }
Product တစ်ခု  →   ProductModel { id, name, price, ... }
```

Database, API မှ ရလာသော data ကို Model object အဖြစ် ပြောင်းပြီး app တွင် သုံးသည်။

---

## 1️⃣ UserModel

**File:** `lib/models/user_model.dart`

### Fields

```dart
class UserModel {
  final String id;         // unique identifier (e.g. 'u001')
  final String username;   // display name (e.g. 'Mg Mg')
  final String email;      // login email
  final String password;   // login password (real app → hash)
  final String avatarUrl;  // profile photo URL
  final String role;       // 'Admin' | 'User' | 'Editor'
}
```

### ဘာကြောင့် `final` ဖြစ်သည်?

```dart
final String username;
// ✅ immutable — object တည်ဆောက်ပြီးနောက် ပြောင်းမရ
// ✅ thread-safe
// ✅ const constructor နှင့် ဆက်ပတ်သည်
```

### Constructor

```dart
const UserModel({
  required this.id,
  required this.username,
  required this.email,
  required this.password,
  required this.avatarUrl,
  required this.role,
});
```

- `const` → compile time constant (performance ကောင်း)
- `required` → field တိုင်း မဖြည့်မဖြစ် (null safety)

### Factory Constructor — `fromMap()`

```dart
factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map['id'],
    username: map['username'],
    // ...
  );
}
```

**သုံးသည့်နေရာ:** API response (JSON) မှ UserModel ပြောင်းသောအခါ

```dart
// API response
final json = {'id': 'u001', 'username': 'Mg Mg', ...};

// Map → UserModel
final user = UserModel.fromMap(json);
```

### `toMap()` Method

```dart
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'username': username,
    // ...
  };
}
```

**သုံးသည့်နေရာ:** UserModel → JSON (API POST / local storage)

---

## 2️⃣ ProductModel

**File:** `lib/models/product_model.dart`

### Fields

```dart
class ProductModel {
  final String id;           // unique id (e.g. 'p001')
  final String name;         // product name
  final String description;  // long text description
  final double price;        // price in thousands
  final String imageUrl;     // product image URL
  final String category;     // 'Smartphone' | 'Laptop' | ...
  final double rating;       // 0.0 - 5.0
  final int reviewCount;     // total review count
  final bool isAvailable;    // stock status
}
```

### Computed Properties (Getters)

```dart
// Getter: method မဟုတ်ဘဲ property ကဲ့သို့ access လုပ်နိုင်
String get formattedPrice => '${price.toStringAsFixed(0)}K Ks';
// သုံးပုံ: product.formattedPrice → '1500K Ks'

String get ratingStars {
  int fullStars = rating.floor();
  return '★' * fullStars + '☆' * (5 - fullStars);
}
// သုံးပုံ: product.ratingStars → '★★★★★'
```

**Getter ၏ အကျိုးကျေးဇူး:**
- Logic ကို model ထဲ တစ်နေရာသိမ်း
- UI မှ `product.formattedPrice` ဟုသာ ခေါ်ရ
- Logic ပြင်ချင်လျှင် model ထဲမှာသာ ပြင်ရ

---

## 3️⃣ Mock Data

**Mock data** = စစ်မှန်သော database/API မရှိဘဲ hardcode ရေးထားသော sample data

### ဘာကြောင့် Mock data သုံးသည်?

```
Real App Flow:
User login  →  API call  →  Server  →  Database  →  Response
                              ↑
                     Setup လုပ်ရန် ကြာ

Mock Data Flow:
User login  →  Mock List ထဲ ရှာ  →  Result
                    ↑
              ချက်ချင်း ready
```

**Learning အတွက်** backend မလိုဘဲ **navigation logic** ကို focus လုပ်နိုင်သည်။

### Mock Users (user_model.dart)

```dart
final List<UserModel> mockUsers = [
  const UserModel(
    id: 'u001',
    username: 'Mg Mg',
    email: 'mgmg@example.com',
    password: '123456',   // ⚠️ Real app: never store plain text
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    role: 'Admin',
  ),
  // ... 2 more users
];
```

### Mock Products (product_model.dart)

```dart
final List<ProductModel> mockProducts = [
  const ProductModel(
    id: 'p001',
    name: 'iPhone 15 Pro',
    price: 1500,          // 1500K Ks
    rating: 4.8,
    reviewCount: 2341,
    isAvailable: true,
    // ...
  ),
  // ... 5 more products
];
```

### Mock Authentication Logic (login_screen.dart)

```dart
// email + password တိုက်စစ်ပြီး UserModel ရှာသည်
final matchedUser = mockUsers.where((user) {
  return user.email == emailInput &&
         user.password == passwordInput;
}).firstOrNull;   // ← မတွေ့ပါက null return

if (matchedUser != null) {
  // ✅ Login success → Home သို့
} else {
  // ❌ Login fail → Error message
}
```

---

## 4️⃣ Model — Navigation ဆက်နွယ်မှု

```
LoginScreen
    │
    │  pushReplacementNamed('/home', arguments: matchedUser)
    │  ┌──────────────────┐
    └─►│ UserModel object │──► HomeScreen(user: matchedUser)
       └──────────────────┘

HomeScreen
    │
    │  pushNamed('/detail', arguments: product)
    │  ┌─────────────────────┐
    └─►│ ProductModel object │──► DetailScreen(product: product)
       └─────────────────────┘
```

Model object ကို Navigator arguments အဖြစ် တိုက်ရိုက် pass နိုင်သည်။
Route generator တွင် type check ပြီးမှ Screen constructor သို့ ရောက်သည်။

---

## 5️⃣ Quick Reference

```dart
// UserModel ဖန်တီးခြင်း
const user = UserModel(
  id: 'u001',
  username: 'Mg Mg',
  email: 'mgmg@example.com',
  password: '123456',
  avatarUrl: 'https://...',
  role: 'Admin',
);

// Properties access
print(user.username);   // Mg Mg
print(user.role);       // Admin

// ProductModel ဖန်တီးခြင်း
const product = ProductModel(
  id: 'p001',
  name: 'iPhone 15 Pro',
  price: 1500,
  // ...
);

// Computed properties
print(product.formattedPrice);  // 1500K Ks
print(product.ratingStars);     // ★★★★★
```

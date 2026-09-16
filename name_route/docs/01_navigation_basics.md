# 01 — Flutter Navigation Basics (Named Routes)

> **ဤ file ဖြင့် သင်ယူမည့်အရာ:** Flutter ၏ Named Route navigation system ကို အခြေခံမှ နားလည်စေရန်

---

## 1️⃣ Navigation ဆိုတာ ဘာလဲ?

Flutter app တွင် **Screen** (Page) တစ်ခုမှ နောက်တစ်ခုသို့ ပြောင်းလဲသွားနိုင်သည်။
ထို Screen များကို **Route** ဟုခေါ်ပြီး ၎င်းတို့ကို စီမံခန့်ခွဲသည့် system ကို **Navigator** ဟုခေါ်သည်။

```
Navigator ── Stack (အပေါ်ပေါ်ထပ်သွားသော screen များ)
│
├── Screen C  ← လောလောဆယ် ပြသနေသော screen (top)
├── Screen B
└── Screen A  ← ပထမဆုံး screen (bottom)
```

---

## 2️⃣ Named Routes ဆိုတာ ဘာလဲ?

Route တစ်ခုစီကို **string name** ဖြင့် သတ်မှတ်ပြီး ထို name ဖြင့် navigate လုပ်ခြင်း။

```dart
// ❌ Anonymous Route (name မရှိ)
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => HomeScreen()),
);

// ✅ Named Route (name ရှိ)
Navigator.pushNamed(context, '/home');
```

### Named Routes ၏ အားသာချက်များ

| အချက် | ရှင်းလင်းချက် |
|-------|--------------|
| Centralized | Route name တစ်နေရာမှ စီမံ |
| Readable | `/home`, `/detail` ဖြင့် ရှင်းလင်း |
| Type-safe | Argument type စစ်ဆေးနိုင် |
| Debuggable | Route history ကြည့်နိုင် |

---

## 3️⃣ Navigation Stack

Navigator သည် **Stack** (LIFO) ဖြင့် screen များကို စီမံသည်။

```
push    → Stack ၏ အပေါ်တွင် screen တင်သည်
pop     → Stack ၏ အပေါ်ဆုံး screen ဖယ်သည်
replace → အပေါ်ဆုံး screen ကို အစားထိုးသည်
```

### Stack ပုံ

```
push('/detail')          pop()
                    
[Login ]             [Login ]
[Home  ]     ──►    [Home  ]      ──►    [Home ]
[Detail]             (Detail ပျောက်)
   ↑ top
```

---

## 4️⃣ Navigation Methods — ဤ Project တွင် သုံးသော methods

### Method 1: `pushNamed()` — Screen အသစ်တင်ခြင်း

```dart
// Basic — data မပါ
Navigator.pushNamed(context, '/detail');

// With arguments — data ဖြင့်
Navigator.pushNamed(
  context,
  '/detail',
  arguments: product,  // ← data pass
);

// With await — return data ကိုစောင့်
final result = await Navigator.pushNamed(
  context,
  '/detail',
  arguments: product,
);
// result → detail မှ pop ဖြင့် ပြန်ပို့သော data
```

**သုံးသည့်နေရာ:** `home_screen.dart` → `_navigateToDetail()`

---

### Method 2: `pushReplacementNamed()` — လဲလှယ်ပြီးသွားခြင်း

```dart
Navigator.pushReplacementNamed(
  context,
  '/home',
  arguments: user,  // data pass
);
```

**Stack အပြောင်းအလဲ:**
```
Before:             After:
[Login ]            [Home  ]   ← Login ပျောက်သွား
   ↑                   ↑
```

**Back button** နှိပ်ပါက Login page သို့ မပြန်တော့ (Login ပျောက်နေ)

**သုံးသည့်နေရာ:** `login_screen.dart` — login success မှ home သို့

---

### Method 3: `pop()` — ပြန်ခြင်း (+ Return Data)

```dart
// Data မပါဘဲ ပြန်
Navigator.pop(context);

// Data ဖြင့် ပြန် → caller ရ
Navigator.pop(context, 'review text');
```

**Data flow:**
```
Home (await)  ────────────────────────►  Detail
              ◄─── pop(context, data) ───
              ↑ data ဤနေရာမှာ ရသည်
```

**သုံးသည့်နေရာ:** `detail_screen.dart` — review submit ပြီး home သို့

---

### Method 4: `pushNamedAndRemoveUntil()` — Stack ရှင်းပြီးသွားခြင်း

```dart
Navigator.pushNamedAndRemoveUntil(
  context,
  '/login',           // ← သွားမည့် route
  (route) => false,   // ← predicate: အားလုံးဖျက်
);
```

**Predicate function ရှင်းလင်းချက်:**

```dart
// (Route route) => bool
// true  → ထို route ကို ထိန်းမည် (မဖျက်)
// false → ထို route ကို ဖျက်မည်

(route) => false           // အားလုံးဖျက် ✅ (logout)
(route) => route.isFirst   // ပထမဆုံးမှအပ ဖျက်
ModalRoute.withName('/home') // home မှအပ ဖျက်
```

**Stack အပြောင်းအလဲ:**
```
Before:              After:
[Logout ]
[Home   ]    ──►    [Login ]  ← တစ်ခုသာ ကျန်
[Login  ]
```

**သုံးသည့်နေရာ:** `logout_screen.dart` — logout confirm

---

## 5️⃣ Methods Summary Table

| Method | Stack Effect | Back Button | Data Pass | Return Data |
|--------|-------------|-------------|-----------|-------------|
| `pushNamed()` | Screen တင် | ✅ ဖြစ်နိုင် | ✅ | ✅ (await) |
| `pushReplacementNamed()` | လဲလှယ် | ❌ | ✅ | ❌ |
| `pop()` | Screen ဖယ် | — | — | ✅ |
| `pushNamedAndRemoveUntil()` | Stack ရှင်း | ❌ | ✅ | ❌ |

---

## 6️⃣ Data Passing Flow — ဤ Project တွင်

```
[Login]  ──UserModel──►  [Home]
                           │
                  ProductModel│
                           ▼
                        [Detail]
                           │
                    String (review)│
                           ▼
                        [Home]  ← result ရသည်

[Home]  ──UserModel──►  [Logout]
[Logout] ──────────────► [Login]  (stack clear)
```

---

## 7️⃣ `is` Keyword — Type Check (Dart)

Route arguments ၏ type စစ်ဆေးရာတွင် အသုံးပြုသည်။

```dart
Object? args = settings.arguments;

// "is" → instance of ဟုတ်/မဟုတ် စစ်
if (args is UserModel) {
  // ✅ args = UserModel confirmed
  // Smart cast: (args as UserModel) မလိုတော့
  print(args.username);  // တိုက်ရိုက်သုံးနိုင်
}

// "is!" → NOT instance of
if (args is! UserModel) {
  return errorRoute();  // မဟုတ်ရင် early return
}
// ← ဤနေရာ ရောက်ရင် args = UserModel guaranteed ✅
```

**Smart Cast ဆိုတာ:**
Dart compiler သည် `is` check ကဖြတ်ပြီးနောက်
ထို variable ၏ type ကို automatically သိသည်။
`as UserModel` ဟု ထပ်ရေးရန် မလိုတော့ပေ။

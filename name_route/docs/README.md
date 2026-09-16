# Flutter Named Routes — Learning Documentation

> **ရည်ရွယ်ချက်:** Flutter Navigation (Named Routes) ကို လက်တွေ့ project ဖြင့် နားလည်သဘောပေါက်စေရန်
> **Level:** Beginner → Intermediate
> **Language:** Myanmar (Burmese)

---

## Project Structure

```
name_route/lib/
├── main.dart                    ← App entry + Route setup
├── models/
│   ├── user_model.dart          ← User data structure + mock data
│   └── product_model.dart       ← Product data structure + mock data
├── routes/
│   ├── app_routes.dart          ← Route name constants
│   └── route_generator.dart     ← Route builder + Type-safe checker
└── screens/
    ├── login_screen.dart        ← Login (pushReplacementNamed)
    ├── home_screen.dart         ← Home (pushNamed + await return)
    ├── detail_screen.dart       ← Detail (pop with data)
    └── logout_screen.dart       ← Logout (pushNamedAndRemoveUntil)
```

---

## Navigation Flow

```
[Login '/']  ──pushReplacementNamed──►  [Home '/home']
                  + UserModel

[Home]  ──pushNamed──►  [Detail '/detail']
              + ProductModel
[Home]  ◄──pop(review)──  [Detail]

[Home]  ──pushNamed──►  [Logout '/logout']
              + UserModel
[Logout]  ──pushNamedAndRemoveUntil──►  [Login]
                    (stack cleared)
```

---

## Docs Files

| File | အကြောင်းအရာ |
|------|-------------|
| [01_navigation_basics.md](01_navigation_basics.md) | Navigation concepts, push methods, is keyword |
| [02_models.md](02_models.md) | UserModel, ProductModel, Mock data |
| [03_routes.md](03_routes.md) | app_routes, route_generator, type checking |
| [04_screens.md](04_screens.md) | Screen code patterns, data flow |

---

## Quick Start

```bash
cd /Users/tunsawthan/Desktop/flutter_course/nyo/name_route
flutter run
```

**Demo Login:**
- mgmg@example.com / 123456
- mahnin@example.com / abcdef
- koko@example.com / pass123

---

## Concepts Checklist

- [ ] `initialRoute` — app start point
- [ ] `onGenerateRoute` — dynamic route builder
- [ ] `pushNamed()` — navigate with name
- [ ] `pushReplacementNamed()` — replace current screen
- [ ] `pushNamed(arguments:)` — pass data forward
- [ ] `await pushNamed()` — wait for return data
- [ ] `Navigator.pop(context, data)` — return data back
- [ ] `pushNamedAndRemoveUntil()` — clear stack
- [ ] `is` / `is!` — Dart type check
- [ ] Smart Cast — Dart auto type narrowing

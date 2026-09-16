# 📚 GoRouter Learning App — Docs

> **GoRouter ကို Flutter တွင် Professional အဆင့်ဖြင့် သင်ကြားနိုင်သော Documentation**

---

## 🗂️ Docs Structure

```
docs/
├── README.md                  ← ဤ File (Starting Point)
├── 01_project_structure.md    ← Project Folder & File Structure
├── 02_code_flow.md            ← App Data Flow & Architecture
├── 03_router_guide.md         ← GoRouter Setup & Route Declaration
├── 04_navigation_methods.md   ← push / pop / go / replace
├── 05_data_passing.md         ← Data တွေ Routes ကြား ပေးပို့နည်း
└── 06_best_practices.md       ← Do's, Don'ts & Cheatsheet
```

---

## 🚀 Quick Start

```bash
# Project Run နည်း
cd gorouter_app
flutter run

# Demo Login
Email:    koaung@example.com
Password: password123
```

---

## 📖 ဘယ် Doc မှ စဖတ်မလဲ?

| ကိုယ်လိုချင်သည် | ဖတ်မည့် Doc |
|----------------|------------|
| Project ၏ Folder Structure ကြည့်ချင်သည် | `01_project_structure.md` |
| App တစ်ခုလုံး ဘယ်လို Flow ဖြင့် အလုပ်လုပ်သည်ကိုသိချင် | `02_code_flow.md` |
| GoRouter Setup နည်းကိုသိချင် | `03_router_guide.md` |
| push/pop/go ကြားခြားနားချက်သိချင် | `04_navigation_methods.md` |
| Routes ကြားတွင် Data ပေးပို့နည်းသိချင် | `05_data_passing.md` |
| Best Practices & Cheatsheet ကြည့်ချင် | `06_best_practices.md` |

---

## 🎯 App တွင် သင်ကြားနိုင်သောအကြောင်းအရာများ

```
Login Screen    → Auth Guard + refreshListenable
Home Screen     → push() + Product List
Detail Screen   → Path Params + Extra Data + pop(data)
Nav Demo Tab    → push/pop/go/replace Visual + Stack Visualizer
Data Pass Tab   → Query/Extra/Path/Return Data Methods
Profile Tab     → Logout + Auth Redirect Explanation
Settings Tab    → GoRouterState + Features List + Deep Links
Error Screen    → errorBuilder + 404 Handling
```

---

*Updated: 2026 | Flutter + go_router v17.5.0*

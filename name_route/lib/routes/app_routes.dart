// ============================================================
// APP ROUTES - Named Route constants
// Route name များကို string constant အဖြစ် သတ်မှတ်ထားသည်
// Typo error မဖြစ်အောင် ဤ file တွင် centralize လုပ်ထားသည်
// ============================================================

class AppRoutes {
  // Private constructor - instantiate မလုပ်နိုင်
  AppRoutes._();

  // ─── Route Names ───────────────────────────────────────────
  // Login page - app start point
  static const String login = '/';

  // Home page - login success မှသွားသည်
  static const String home = '/home';

  // Product detail page - product ကိုနှိပ်လျှင်သွားသည်
  static const String detail = '/detail';

  // Logout confirm page
  static const String logout = '/logout';
}

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Auth Service - Login / Logout State ကို စီမံသည်
/// ChangeNotifier ကိုသုံးပြီး GoRouter Redirect ကို Reactive ဖြစ်စေသည်
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  /// Demo Credentials - Login Screen ၏ Hint Box တွင်လည်း ဤတန်ဖိုးကို သုံးသည်
  /// (တစ်နေရာတည်းတွင် သတ်မှတ်ထားခြင်းဖြင့် ပြောင်းလဲရလွယ်ကူသည်)
  static const demoEmail = 'koaung@example.com';
  static const demoPassword = 'password123';

  // =====================================================
  // Mock Users - Real API မရှိသေးသောကြောင့် Mock Data သုံးသည်
  // =====================================================
  static const _mockUsers = [
    UserModel(
      id: 'u001',
      name: 'Ko Aung',
      email: 'koaung@example.com',
      avatar: '👨‍💻',
      role: 'admin',
    ),
    UserModel(
      id: 'u002',
      name: 'Ma Thida',
      email: 'mathida@example.com',
      avatar: '👩‍🎓',
      role: 'student',
    ),
    UserModel(
      id: 'u003',
      name: 'Ko Zin',
      email: 'kozin@example.com',
      avatar: '🧑‍💼',
      role: 'student',
    ),
  ];

  // =====================================================
  // Getters
  // =====================================================
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  // =====================================================
  // Login Method
  // =====================================================
  /// Mock Login - Real API ဆိုလျှင် HTTP Request ပေးပို့မည်
  ///
  /// - Email ၏ အစ/အဆုံး Space နှင့် စာလုံးအကြီး/အသေး ကို ဂရုမစိုက်ဘဲ စစ်သည်
  /// - ဤသို့ပြုလုပ်ခြင်းဖြင့် "KOAUNG@example.com" ကဲ့သို့ ရိုက်ထည့်လျှင်လည်း
  ///   မှန်ကန်သော User ကို ရရှိမည် (မူလက အမြဲ Ko Aung ဖြစ်သွားသည်)
  Future<bool> login(String email, String password) async {
    // Login လုပ်နေစဉ် ထပ်နှိပ်လျှင် Request နှစ်ခု မဖြစ်စေရန် ကာကွယ်သည်
    if (_isLoading) return false;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call delay (Real App တွင် http.post ဖြစ်မည်)
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock validation - password မှန်လျှင် login ဝင်နိုင်သည်
      if (password != demoPassword) {
        _currentUser = null;
        return false;
      }

      final normalizedEmail = email.trim().toLowerCase();
      _currentUser = _mockUsers.firstWhere(
        (u) => u.email.toLowerCase() == normalizedEmail,
        // Demo ဖြစ်သောကြောင့် မသိသော Email ဆိုလျှင် Admin အနေဖြင့် ဝင်ခွင့်ပြုသည်
        orElse: () => _mockUsers.first,
      );
      return true;
    } catch (_) {
      // မမျှော်လင့်သော Error ဖြစ်လျှင်လည်း User ကို မဝင်ရောက်စေရန်
      _currentUser = null;
      return false;
    } finally {
      // မည်သည့်လမ်းကြောင်းမှ ထွက်သည်ဖြစ်စေ Loading State ကို အမြဲ ပြန်လည်သတ်မှတ်သည်
      // (မူလက Error ဖြစ်လျှင် Button က အမြဲ Loading ဖြစ်နေနိုင်သည်)
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // Logout Method
  // =====================================================
  Future<void> logout() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Simulate logout process
      await Future.delayed(const Duration(milliseconds: 800));
    } finally {
      _currentUser = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  // =====================================================
  // Quick Login (Demo purpose)
  // =====================================================
  void quickLoginAsAdmin() {
    _currentUser = _mockUsers[0];
    notifyListeners();
  }
}

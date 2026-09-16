import 'package:flutter/foundation.dart';
import '../models/user_model.dart';

/// Auth Service - Login / Logout State ကို စီမံသည်
/// ChangeNotifier ကိုသုံးပြီး GoRouter Redirect ကို Reactive ဖြစ်စေသည်
class AuthService extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

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
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay (Real App တွင် http.post ဖြစ်မည်)
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Mock validation - password: "password123" ဆိုလျှင် အမြဲ login ဝင်နိုင်သည်
      if (password == 'password123') {
        _currentUser = _mockUsers.firstWhere(
          (u) => u.email == email,
          orElse: () => _mockUsers.first,
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // =====================================================
  // Logout Method
  // =====================================================
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    // Simulate logout process
    await Future.delayed(const Duration(milliseconds: 800));

    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  // =====================================================
  // Quick Login (Demo purpose)
  // =====================================================
  void quickLoginAsAdmin() {
    _currentUser = _mockUsers[0];
    notifyListeners();
  }
}

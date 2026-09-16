import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

// ============================================================
// LOGIN SCREEN
// ────────────────────────────────────────────────────────────
// သင်ကြားပေးမည့် Navigation Concepts:
//   ✅ Navigator.pushReplacementNamed() - login success မှ home သို့
//   ✅ Route Arguments passing - user object ကို home page သို့ pass
//   ✅ Form validation
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key - validation အတွက်
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    // Memory leak မဖြစ်အောင် dispose လုပ်ရမည်
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────
  // LOGIN LOGIC - mock authentication
  // ────────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    // Form validation စစ်ဆေးခြင်း
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay (real app မှာ API call ဖြစ်မည်)
    await Future.delayed(const Duration(seconds: 1));

    // Mock user authentication - email နှင့် password တိုက်စစ်ခြင်း
    final matchedUser = mockUsers.where((user) {
      return user.email == _emailController.text.trim() &&
          user.password == _passwordController.text;
    }).firstOrNull;

    if (!mounted) return; // Widget ဖျက်ပြီးဆိုလျှင် ဘာမှ မလုပ်ရ

    if (matchedUser != null) {
      // ✅ LOGIN SUCCESS
      // pushReplacementNamed - login page ကို stack မှ ဖျက်ပြီး home သို့သွားသည်
      // Back button နှိပ်လျှင် login page သို့ မပြန်နိုင်ရန်
      // arguments: UserModel object ကို home page သို့ pass လုပ်ခြင်း
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
        arguments: matchedUser, // ← DATA PASSING ✅
      );
    } else {
      // ❌ LOGIN FAILED
      setState(() {
        _isLoading = false;
        _errorMessage = 'Email သို့မဟုတ် Password မှားနေသည်။ ထပ်မံကြိုးစားပါ။';
      });
    }
  }

  // ────────────────────────────────────────────────────────────
  // DEMO: Quick login buttons (testing အတွက်)
  // ────────────────────────────────────────────────────────────
  void _quickLogin(UserModel user) {
    _emailController.text = user.email;
    _passwordController.text = user.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // ── LOGO / HEADER ──────────────────────────────
              _buildHeader(),

              const SizedBox(height: 40),

              // ── LOGIN FORM ──────────────────────────────────
              _buildLoginForm(),

              const SizedBox(height: 24),

              // ── ERROR MESSAGE ────────────────────────────────
              if (_errorMessage != null) _buildErrorMessage(),

              // ── LOGIN BUTTON ─────────────────────────────────
              _buildLoginButton(),

              const SizedBox(height: 32),

              // ── DEMO QUICK LOGIN ──────────────────────────────
              _buildQuickLoginSection(),

              const SizedBox(height: 24),

              // ── NAVIGATION INFO BOX ───────────────────────────
              _buildNavigationInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  // ─── WIDGETS ───────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withAlpha(100),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.route, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 16),
        const Text(
          'Named Routes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Flutter Navigation Demo App',
          style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // EMAIL FIELD
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              label: 'Email',
              hint: 'mgmg@example.com',
              icon: Icons.email_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email ထည့်ပေးပါ';
              }
              if (!value.contains('@')) {
                return 'Valid email ဖြစ်ရမည်';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // PASSWORD FIELD
          TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: Colors.white),
            obscureText: _obscurePassword,
            //obscureText: true,
            decoration:
                _inputDecoration(
                  label: 'Password',
                  hint: '••••••',
                  icon: Icons.lock_outlined,
                ).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password ထည့်ပေးပါ';
              }
              if (value.length < 6) {
                return 'Password အနည်းဆုံး ၆ လုံးရှိရမည်';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withAlpha(100)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  Widget _buildQuickLoginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚡ Quick Login (Demo)',
          style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13),
        ),
        const SizedBox(height: 8),
        ...mockUsers.map(
          (user) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: OutlinedButton(
              onPressed: () => _quickLogin(user),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.username} (${user.role})',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 11, color: Colors.white54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6C63FF).withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6C63FF).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF6C63FF), size: 16),
              SizedBox(width: 8),
              Text(
                'Navigation Concept ✅',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _infoRow('Method', 'pushReplacementNamed()'),
          _infoRow('Route', 'AppRoutes.login → AppRoutes.home'),
          _infoRow('Data', 'UserModel object pass လုပ်ခြင်း'),
          _infoRow('Effect', 'Login page stack မှပျောက်သည်'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white54),
      labelStyle: const TextStyle(color: Colors.white54),
      hintStyle: const TextStyle(color: Colors.white30),
      filled: true,
      fillColor: Colors.white.withAlpha(13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';

// ============================================================
// LOGOUT SCREEN
// ────────────────────────────────────────────────────────────
// သင်ကြားပေးမည့် Navigation Concepts:
//   ✅ pushAndRemoveUntil() - stack အားလုံးရှင်းပြီး login သို့
//   ✅ RoutePredicate function အသုံးပြုပုံ
//   ✅ (route) => false ဆိုတာ ဘာကို ဆိုလိုသည်
// ════════════════════════════════════════════════════════════
// ✅ Type-safe: constructor argument → UserModel? (null ခွင့်ပြု)
// ============================================================

class LogoutScreen extends StatefulWidget {
  // ✅ UserModel? (null ခွင့်ပြုသည်)
  // null ဖြစ်ပါက fallback တွဲသည်
  final UserModel? user;

  const LogoutScreen({super.key, this.user});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  // user ကို ?? fallback ဖြင့် ရသည်
  // null ဖြစ်ပါကလည် mockUsers.first တွဲပြသည်
  UserModel get _currentUser => widget.user ?? mockUsers.first;
  bool _isLoggingOut = false;


  // ────────────────────────────────────────────────────────────
  // LOGOUT WITH pushAndRemoveUntil
  // Stack ထဲရှိ route အားလုံးကို ဖျက်ပြီး login သို့ သွားသည်
  // ────────────────────────────────────────────────────────────
  Future<void> _confirmLogout() async {
    setState(() => _isLoggingOut = true);

    // Simulate logout process
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // ✅ pushAndRemoveUntil - Navigation Stack Clear
    //
    // Method: Navigator.pushNamedAndRemoveUntil(
    //   context,
    //   newRoute,        → push လုပ်မည့် route
    //   predicate,       → ဘယ် route ထိ ဖျက်မည်
    // )
    //
    // predicate: (Route route) => false
    //   → false return လုပ်လျှင် → ထို route ကို ဖျက်သည်
    //   → true return လုပ်လျှင် → ထို route ကို ထိန်းသည်
    //   → (route) => false → stack ထဲရှိ route အားလုံးဖျက်သည်
    //
    // Result: Login page တစ်ခုသာ stack တွင် ကျန်ရှိသည်
    //         Back button နှိပ်လျှင် app ထွက်သွားမည် (route မရှိတော့)

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login, // ← push မည့် route
      (route) => false, // ← predicate: stack အားလုံး ဖျက်ခြင်း ✅
    );
  }

  // ────────────────────────────────────────────────────────────
  // CANCEL LOGOUT - ပြန်သွားရုံသာ
  // ────────────────────────────────────────────────────────────
  void _cancelLogout() {
    Navigator.pop(context); // logout screen ကို ပိတ်ပြီး home သို့ ပြန်
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1235),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _cancelLogout,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ── CONCEPT EXPLANATION BOX ──────────────────────
            _buildConceptBox(),

            const SizedBox(height: 32),

            // ── LOGOUT ILLUSTRATION ───────────────────────────
            _buildLogoutIllustration(),

            const SizedBox(height: 32),

            // ── USER INFO ─────────────────────────────────────
            _buildUserInfo(),

            const SizedBox(height: 40),

            // ── ACTION BUTTONS ────────────────────────────────
            _buildActionButtons(),

            const Spacer(),

            // ── NAVIGATION STACK DIAGRAM ──────────────────────
            _buildStackDiagram(),
          ],
        ),
      ),
    );
  }

  // ─── WIDGETS ───────────────────────────────────────────────

  Widget _buildConceptBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.school_outlined, color: Colors.orange, size: 16),
              SizedBox(width: 8),
              Text(
                'pushNamedAndRemoveUntil() ✅',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _conceptCode(
            'Navigator.pushNamedAndRemoveUntil(\n'
            '  context,\n'
            '  AppRoutes.login,  // push route\n'
            '  (route) => false, // stack clear\n'
            ');',
          ),
          const SizedBox(height: 8),
          _infoRow('(route) => false', 'stack ထဲ route အားလုံးဖျက်'),
          _infoRow('(route) => route.isFirst', 'ပထမဆုံး route မှအပ ဖျက်'),
          _infoRow(
              'ModalRoute.withName(\'/home\')', 'home route မှအပ ဖျက်'),
        ],
      ),
    );
  }

  Widget _conceptCode(String code) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        code,
        style: const TextStyle(
          color: Color(0xFF3ECFCF),
          fontFamily: 'monospace',
          fontSize: 11,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildLogoutIllustration() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.red.withAlpha(50),
            Colors.transparent,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withAlpha(30),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red.withAlpha(100), width: 2),
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        const Text(
          'Logout အတည်ပြုမည်လား?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentUser.username} (${_currentUser.email})',
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          'Role: ${_currentUser.role}',
          style: const TextStyle(color: Colors.white38, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Cancel button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _cancelLogout,
            icon: const Icon(Icons.close, size: 18),
            label: const Text('ပြန်သွား'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white70,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Confirm logout button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoggingOut ? null : _confirmLogout,
            icon: _isLoggingOut
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.logout, size: 18),
            label: Text(_isLoggingOut ? 'Logging out...' : 'Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStackDiagram() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1235),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 Navigation Stack Diagram',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Before Logout (Current Stack):',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 6),
          _stackItem('Login Page', isGhost: true, label: '(ဖျက်ခြင်းခံရမည်)'),
          _stackItem('Home Page', isGhost: true, label: '(ဖျက်ခြင်းခံရမည်)'),
          _stackItem('Logout Page', isCurrent: true, label: '← current'),
          const SizedBox(height: 10),
          const Text(
            'After pushNamedAndRemoveUntil:',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 6),
          _stackItem('Login Page', isNew: true, label: '← only this remains'),
        ],
      ),
    );
  }

  Widget _stackItem(
    String name, {
    bool isCurrent = false,
    bool isGhost = false,
    bool isNew = false,
    String label = '',
  }) {
    Color bgColor = const Color(0xFF1A1F40);
    Color textColor = Colors.white54;
    Color borderColor = Colors.white12;

    if (isCurrent) {
      bgColor = const Color(0xFF6C63FF).withAlpha(40);
      textColor = const Color(0xFF6C63FF);
      borderColor = const Color(0xFF6C63FF).withAlpha(100);
    } else if (isGhost) {
      bgColor = Colors.red.withAlpha(20);
      textColor = Colors.red.withAlpha(150);
      borderColor = Colors.red.withAlpha(50);
    } else if (isNew) {
      bgColor = Colors.green.withAlpha(20);
      textColor = Colors.green;
      borderColor = Colors.green.withAlpha(80);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(name, style: TextStyle(color: textColor, fontSize: 12)),
          const Spacer(),
          if (label.isNotEmpty)
            Text(label,
                style: TextStyle(
                    color: textColor.withAlpha(150), fontSize: 10)),
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
          Text('• $label: ',
              style: const TextStyle(color: Colors.orange, fontSize: 11)),
          Expanded(
            child: Text(value,
                style:
                    const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

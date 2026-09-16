import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../routes/app_routes.dart';

// ============================================================
// HOME SCREEN
// ────────────────────────────────────────────────────────────
// သင်ကြားပေးမည့် Navigation Concepts:
//   ✅ Route Arguments ရယူခြင်း (UserModel from Login)
//   ✅ pushNamed() with arguments - detail page သို့ data pass
//   ✅ await + Navigator.pushNamed() - return data ရယူခြင်း
//   ✅ pushNamed() to logout page
// ════════════════════════════════════════════════════════════
// ✅ Type-safe: constructor argument → UserModel (Object? မဟုတ်)
//    RouteGenerator မှ type စစ်ပြီးမှ ဤ screen ကိုရောက်သည်
//    ထို့ကြောင့် initState တွင် cast မလုပ်တော့ဘဲ widget.user ကိုသာ သုံးသည်
// ============================================================

class HomeScreen extends StatefulWidget {
  // ❌ မူလ: final Object? arguments  (type မသေချာ)
  // ✅ ပြင်ဆင်: final UserModel user  (type-safe)
  //
  //   RouteGenerator မှာ type စစ်ပြီးပြီ  →  ဤနေရာ safe zone
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // widget.user ကိုတိုက်ရိုက်သုံးနိုင်သည် — cast မလုပ်ရ
  // ❌ မူလ: late UserModel _currentUser; + initState cast
  // ✅ ပြင်ဆင်: getter ဖြင့် တိုက်ရိုက်ရသည်
  UserModel get _currentUser => widget.user;

  // Detail page မှ return လာသော review messages
  final List<String> _receivedReviews = [];

  // ────────────────────────────────────────────────────────────
  // NAVIGATE TO DETAIL - Data Passing + Return Data
  // ────────────────────────────────────────────────────────────
  Future<void> _navigateToDetail(ProductModel product) async {
    // ✅ pushNamed with arguments - ProductModel ကို detail page သို့ pass
    // await ကို သုံးထားသောကြောင့် detail page မှ return လာသည့် data ကိုရနိုင်သည်
    final returnedData = await Navigator.pushNamed(
      context,
      AppRoutes.detail,
      arguments: product, // ← DATA PASSING (ProductModel) ✅
    );

    // ✅ RETURN DATA ရယူခြင်း
    // Detail page မှ Navigator.pop(context, data) ဖြင့် data ပြန်ပို့ပါက
    // ဤနေရာမှာ returnedData ဟုရရှိမည်
    if (returnedData != null && returnedData is String) {
      setState(() {
        _receivedReviews.add('${product.name}: $returnedData');
      });

      // Snackbar ဖြင့် return data ကိုပြသည်
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📝 Review ရရှိပြီ: "$returnedData"'),
            backgroundColor: const Color(0xFF3ECFCF),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ────────────────────────────────────────────────────────────
  // NAVIGATE TO LOGOUT
  // ────────────────────────────────────────────────────────────
  void _navigateToLogout() {
    // pushNamed to logout - user object pass လုပ်သည်
    Navigator.pushNamed(
      context,
      AppRoutes.logout,
      arguments: _currentUser, // ← Logout page သို့ user data pass ✅
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── USER WELCOME CARD ────────────────────────────────
          _buildUserWelcomeCard(),

          // ── NAVIGATION INFO ──────────────────────────────────
          _buildNavigationInfoBanner(),

          // ── RETURN DATA SECTION ──────────────────────────────
          if (_receivedReviews.isNotEmpty) _buildReturnedDataSection(),

          // ── PRODUCT LIST ─────────────────────────────────────
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  // ─── WIDGETS ───────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D1235),
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.home, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          const Text(
            'Home Page',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
      actions: [
        // Logout button
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          tooltip: 'Logout',
          onPressed: _navigateToLogout,
        ),
      ],
      // Back button မပြစေရန် (pushReplacement မှာ back မရှိ)
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildUserWelcomeCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3ECFCF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white24,
            child: Text(
              _currentUser.username.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'မင်္ဂလာပါ, ${_currentUser.username}! 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_currentUser.email} • ${_currentUser.role}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          // Route badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '/home',
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationInfoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withAlpha(80)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Product card ကိုနှိပ်၍ → detail page ကြည့်ပါ\n'
              'Review ထည့်ပြီး ← Back နှိပ်ပါ (Return Data)',
              style: TextStyle(color: Colors.amber, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnedDataSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3ECFCF).withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3ECFCF).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.keyboard_return, color: Color(0xFF3ECFCF), size: 16),
              SizedBox(width: 6),
              Text(
                'Detail Page မှ Return လာသော Data ✅',
                style: TextStyle(
                  color: Color(0xFF3ECFCF),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._receivedReviews.map(
            (review) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• $review',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: mockProducts.length,
            itemBuilder: (context, index) {
              return _buildProductCard(mockProducts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final isReviewed = _receivedReviews.any((r) => r.startsWith(product.name));

    return GestureDetector(
      onTap: () => _navigateToDetail(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1235),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isReviewed
                ? const Color(0xFF3ECFCF).withAlpha(100)
                : Colors.white.withAlpha(20),
          ),
        ),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Image.network(
                product.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (e, s, t) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFF6C63FF).withAlpha(80),
                  child: const Icon(Icons.image, color: Colors.white54),
                ),
              ),
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isReviewed)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF3ECFCF),
                            size: 16,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          product.ratingStars,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          product.formattedPrice,
                          style: const TextStyle(
                            color: Color(0xFF3ECFCF),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (!product.isAvailable)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Out of Stock',
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white24,
              size: 14,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

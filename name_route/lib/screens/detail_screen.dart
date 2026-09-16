import 'package:flutter/material.dart';
import '../models/product_model.dart';

// ============================================================
// DETAIL SCREEN
// ────────────────────────────────────────────────────────────
// သင်ကြားပေးမည့် Navigation Concepts:
//   ✅ Route Arguments ရယူခြင်း (ProductModel from Home)
//   ✅ Navigator.pop(context, data) - returning data to Home
//   ✅ Data ဖြင့် back လုပ်ခြင်း
// ════════════════════════════════════════════════════════════
// ✅ Type-safe: constructor argument → ProductModel (Object? မဟုတ်)
// ============================================================

class DetailScreen extends StatefulWidget {
  // ✅ ProductModel ကိုတိုက်ရိုက်သည် (Object? မဟုတ်)
  // RouteGenerator မှာ type check ပြီးပြီ ဤ screen ကိုရောက်သည်
  final ProductModel product;

  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // widget.product ကိုတိုက်ရိုက်သုံး— cast မခလုရ
  ProductModel get _product => widget.product;

  final _reviewController = TextEditingController();
  bool _isAddedToCart = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────
  // RETURN DATA TO HOME - Navigator.pop with data
  // ────────────────────────────────────────────────────────────
  void _submitReviewAndReturn() {
    final reviewText = _reviewController.text.trim();

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review text ထည့်ပေးပါ'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // ✅ RETURNING DATA - Navigator.pop(context, returnValue)
    // Home page ၏ await Navigator.pushNamed() မှ ဤ value ကို receive မည်
    Navigator.pop(
      context,
      reviewText, // ← RETURN DATA (String) ✅
    );
  }

  // ────────────────────────────────────────────────────────────
  // SIMPLE BACK - data မပါဘဲ ပြန်ခြင်း
  // ────────────────────────────────────────────────────────────
  void _goBackWithoutReview() {
    // ✅ data မပါဘဲ ပြန်ခြင်း - home page မှာ returnedData == null ဖြစ်မည်
    Navigator.pop(context); // data မပါ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: CustomScrollView(
        slivers: [
          // ── SLIVER APP BAR (product image header) ──────────
          _buildSliverAppBar(),

          // ── CONTENT ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigation info box
                  _buildNavigationInfoBox(),

                  const SizedBox(height: 20),

                  // Product details
                  _buildProductHeader(),

                  const SizedBox(height: 16),

                  // Description
                  _buildDescription(),

                  const SizedBox(height: 20),

                  // Specs (mock)
                  _buildSpecsSection(),

                  const SizedBox(height: 24),

                  // ── RETURN DATA SECTION ─────────────────────
                  _buildReturnDataSection(),

                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      // ── BOTTOM ACTION BAR ────────────────────────────────────
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ─── WIDGETS ───────────────────────────────────────────────

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: const Color(0xFF0D1235),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: _goBackWithoutReview,
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (e, s, t) => Container(
                color: const Color(0xFF6C63FF).withAlpha(80),
                child: const Icon(Icons.image, color: Colors.white54, size: 64),
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF0A0E27).withAlpha(200),
                  ],
                ),
              ),
            ),
            // Route label
            Positioned(
              top: 60,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '/detail',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationInfoBox() {
    return Container(
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
              Icon(Icons.info_outline, color: Color(0xFF3ECFCF), size: 14),
              SizedBox(width: 6),
              Text(
                'Navigation Concepts ✅',
                style: TextStyle(
                  color: Color(0xFF3ECFCF),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _infoRow('Data Received', '${_product.name} (ProductModel)'),
          _infoRow('Method', 'pushNamed(context, route, arguments: product)'),
          _infoRow('Return', 'Navigator.pop(context, reviewText)'),
          _infoRow('No Return', 'Navigator.pop(context) ← back button'),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Category chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withAlpha(50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _product.category,
                style: const TextStyle(
                  color: Color(0xFF6C63FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            // Availability badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _product.isAvailable
                    ? Colors.green.withAlpha(50)
                    : Colors.red.withAlpha(50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _product.isAvailable ? '✅ In Stock' : '❌ Out of Stock',
                style: TextStyle(
                  color:
                      _product.isAvailable ? Colors.green : Colors.red,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              _product.ratingStars,
              style: const TextStyle(color: Colors.amber, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              '${_product.rating} (${_product.reviewCount} reviews)',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const Spacer(),
            Text(
              _product.formattedPrice,
              style: const TextStyle(
                color: Color(0xFF3ECFCF),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _product.description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecsSection() {
    // Mock specs
    final specs = {
      'Product ID': _product.id,
      'Category': _product.category,
      'Price': _product.formattedPrice,
      'Rating': '${_product.rating}/5.0',
      'Reviews': '${_product.reviewCount}',
      'Availability': _product.isAvailable ? 'Available' : 'Unavailable',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1235),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withAlpha(20)),
          ),
          child: Column(
            children: specs.entries.map((entry) {
              final isLast = entry.key == specs.keys.last;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 8),
                    Divider(
                        color: Colors.white.withAlpha(15), height: 1),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildReturnDataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withAlpha(30),
            const Color(0xFF3ECFCF).withAlpha(30),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6C63FF).withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.rate_review_outlined,
                  color: Color(0xFF6C63FF), size: 18),
              SizedBox(width: 8),
              Text(
                'Review ထည့်ပြီး Home သို့ Return Data ပို့ပါ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Navigator.pop(context, reviewText) ဖြင့် data return လုပ်မည်',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),

          // Review text field
          TextField(
            controller: _reviewController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'ဤ product အကြောင်း review ရေးပါ...',
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
                borderSide:
                    const BorderSide(color: Color(0xFF6C63FF)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Submit review button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _submitReviewAndReturn,
              icon: const Icon(Icons.send, size: 18),
              label: const Text(
                'Review submit ပြီး Home သို့ Return',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1235),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back without data
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _goBackWithoutReview,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back (data မပါ)'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Add to cart (UI only)
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _product.isAvailable
                    ? () {
                        setState(() => _isAddedToCart = !_isAddedToCart);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isAddedToCart
                                ? '🛒 Cart တွင် ထည့်ပြီး!'
                                : '🗑️ Cart မှ ဖယ်ရှားပြီး!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                icon: Icon(
                  _isAddedToCart ? Icons.check : Icons.shopping_cart_outlined,
                  size: 16,
                ),
                label: Text(_isAddedToCart ? 'Added!' : 'Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAddedToCart
                      ? Colors.green
                      : const Color(0xFF3ECFCF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style:
                  const TextStyle(color: Colors.white54, fontSize: 11)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

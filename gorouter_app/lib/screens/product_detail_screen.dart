import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../models/product_model.dart';

/// Product Detail Screen
/// Path Parameter နှင့် Extra Data ရယူနည်းများပြသည်
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String? fromSource;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.fromSource,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isAddedToCart = false;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = MockData.findById(widget.productId);
    final theme = Theme.of(context);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('မတွေ့ပါ')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('❌', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 16),
              Text('Product "${widget.productId}" မတွေ့ပါ'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('ပြန်သွားပါ'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // =====================================================
          // Hero App Bar with Product Emoji
          // =====================================================
          SliverAppBar.large(
            expandedHeight: 250,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                // context.pop() - Stack မှ Pop လုပ်သည်
                // Return Data ပါ ပို့ပြန်နိုင်သည်
                if (context.canPop()) {
                  context.pop({'action': 'viewed', 'productId': product.id});
                }
              },
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            title: Text(product.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer,
                      theme.colorScheme.secondaryContainer,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    product.imageEmoji,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Navigation Source Info (Extra Data ရယူပြသ)
                  if (widget.fromSource != null) _buildSourceBadge(theme),
                  const SizedBox(height: 16),

                  // Product Info
                  _buildProductHeader(theme, product),
                  const SizedBox(height: 20),

                  // Code Explanation Card
                  _buildCodeExplanation(theme),
                  const SizedBox(height: 20),

                  // Description
                  _buildDescription(theme, product),
                  const SizedBox(height: 20),

                  // Rating Card
                  _buildRatingCard(theme, product),
                  const SizedBox(height: 20),

                  // Quantity Selector
                  if (product.isInStock) _buildQuantitySelector(theme),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: _buildBottomBar(context, theme, product),
    );
  }

  Widget _buildSourceBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline,
              size: 16, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 6),
          Text(
            'Extra Data: from = "${widget.fromSource}"',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onTertiaryContainer,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader(ThemeData theme, ProductModel product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.category,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${product.price}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!product.isInStock)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ကုန်သွားပြီ',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCodeExplanation(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code_rounded,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'GoRouter Concepts ဤ Page တွင် သင်ကြားနေသည်',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _codeRow(theme, '1️⃣ Path Parameter',
                ':productId → widget.productId = "${widget.productId}"'),
            _codeRow(theme, '2️⃣ Extra Data',
                'state.extra → fromSource = "${widget.fromSource ?? 'null'}"'),
            _codeRow(theme, '3️⃣ context.pop(data)',
                'Back ကိုနှိပ်သည်နှင့် Data ပြန်ပို့မည်'),
            _codeRow(theme, '4️⃣ context.canPop()',
                'Pop လုပ်နိုင်/မနိုင် စစ်ဆေးသည်'),
          ],
        ),
      ),
    );
  }

  Widget _codeRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme, ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'အကြောင်းအရာ',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingCard(ThemeData theme, ProductModel product) {
    return Card(
      elevation: 0,
      color: Colors.amber.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  product.rating.toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < product.rating.floor()
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.reviewCount} reviews',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Verified Purchases များမှ',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector(ThemeData theme) {
    return Row(
      children: [
        Text(
          'အရေအတွက်:',
          style: theme.textTheme.titleSmall,
        ),
        const Spacer(),
        IconButton.outlined(
          onPressed: _quantity > 1
              ? () => setState(() => _quantity--)
              : null,
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$_quantity',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton.outlined(
          onPressed: () => setState(() => _quantity++),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
      BuildContext context, ThemeData theme, ProductModel product) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: product.isInStock
                  ? () {
                      setState(() => _isAddedToCart = !_isAddedToCart);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isAddedToCart
                                ? '🛒 Cart ထဲ ထည့်ပြီး!'
                                : '❌ Cart မှ ဖယ်ရှားပြီး',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              icon: Icon(
                _isAddedToCart ? Icons.check_circle_rounded : Icons.shopping_cart_outlined,
              ),
              label: Text(
                _isAddedToCart ? 'Cart ထဲ ထည့်ပြီ' : 'Cart ထဲ ထည့်မည်',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // context.pop with data demo
          OutlinedButton(
            onPressed: () {
              // context.pop() နှင့် Data ပြန်ပို့နည်း
              context.pop({
                'action': 'purchased',
                'productId': product.id,
                'quantity': _quantity,
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_rounded, size: 20),
                Text('pop(data)', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

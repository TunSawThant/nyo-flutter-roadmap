import '../models/product_model.dart';

/// Mock Product Data - Real API မတိုင်မီ ဤ Data များဖြင့် သင်ကြားနိုင်သည်
class MockData {
  // =====================================================
  // Mock Products List
  // =====================================================
  static final List<ProductModel> products = [
    const ProductModel(
      id: 'p001',
      name: 'Flutter Pro Course',
      description:
          'Flutter နှင့် Dart ကို အခြေခံမှ အဆင့်မြင့်အထိ သင်ကြားနိုင်သော ပြည့်စုံသော Course တစ်ခုဖြစ်သည်။ '
          'State Management, Navigation, API Integration စသည်များပါဝင်သည်။',
      price: 49.99,
      category: 'Education',
      imageEmoji: '📱',
      rating: 4.8,
      reviewCount: 1250,
      isInStock: true,
    ),
    const ProductModel(
      id: 'p002',
      name: 'Dart Programming Mastery',
      description:
          'Dart Programming Language ကို အဓိကထားသင်ကြားသော Course ဖြစ်ပြီး '
          'OOP, Async/Await, Null Safety စသည်များပါဝင်သည်။',
      price: 29.99,
      category: 'Education',
      imageEmoji: '🎯',
      rating: 4.6,
      reviewCount: 890,
      isInStock: true,
    ),
    const ProductModel(
      id: 'p003',
      name: 'Firebase + Flutter Integration',
      description:
          'Firebase Authentication, Firestore, Cloud Storage တို့ကို Flutter App တွင် '
          'ပေါင်းစပ်အသုံးပြုနည်းများကို သင်ကြားသည်။',
      price: 39.99,
      category: 'Backend',
      imageEmoji: '🔥',
      rating: 4.7,
      reviewCount: 654,
      isInStock: false,
    ),
    const ProductModel(
      id: 'p004',
      name: 'Go Router Masterclass',
      description:
          'GoRouter ကို အသုံးပြုပြီး Flutter App တွင် Navigation ကို Professional '
          'အဆင့်ဖြင့် စီမံခန့်ခွဲနည်းများပါဝင်သည်။ Deep Linking, Auth Guards ပါဝင်သည်။',
      price: 24.99,
      category: 'Navigation',
      imageEmoji: '🗺️',
      rating: 4.9,
      reviewCount: 432,
      isInStock: true,
    ),
    const ProductModel(
      id: 'p005',
      name: 'Flutter UI Design Kit',
      description:
          'Professional Flutter UI Components, Animations, Custom Widgets တို့ကို '
          'လက်တွေ့ Project များတွင် ထည့်သွင်းသုံးနည်းများသင်ကြားသည်။',
      price: 34.99,
      category: 'UI/UX',
      imageEmoji: '🎨',
      rating: 4.5,
      reviewCount: 2100,
      isInStock: true,
    ),
    const ProductModel(
      id: 'p006',
      name: 'Flutter Testing & CI/CD',
      description:
          'Unit Testing, Widget Testing, Integration Testing တို့နှင့် CI/CD Pipeline '
          'ချိတ်ဆက်ပြီး Production-Ready App တည်ဆောက်နည်းများသင်ကြားသည်။',
      price: 44.99,
      category: 'DevOps',
      imageEmoji: '🧪',
      rating: 4.4,
      reviewCount: 320,
      isInStock: true,
    ),
  ];

  // =====================================================
  // Helper Methods
  // =====================================================
  static ProductModel? findById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<ProductModel> findByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }

  static List<String> get categories =>
      products.map((p) => p.category).toSet().toList();
}

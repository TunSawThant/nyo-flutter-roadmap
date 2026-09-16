// ============================================================
// PRODUCT MODEL
// Home Page တွင် ပြသမည့် product ၏ data
// ============================================================

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isAvailable;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
  });

  // Formatted price (K သင်္ကေတဖြင့်)
  String get formattedPrice => '${price.toStringAsFixed(0)}K Ks';

  // Rating stars string
  String get ratingStars {
    int fullStars = rating.floor();
    return '★' * fullStars + '☆' * (5 - fullStars);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price)';
  }
}

// ============================================================
// MOCK DATA - ကုန်ပစ္စည်း mock data များ
// ============================================================
final List<ProductModel> mockProducts = [
  const ProductModel(
    id: 'p001',
    name: 'iPhone 15 Pro',
    description:
        'Apple ၏ နောက်ဆုံးပေါ် flagship phone ဖြစ်ပြီး A17 Pro chip ဖြင့် '
        'ပြုလုပ်ထားသည်။ Titanium frame, 48MP camera system နှင့် USB-C port '
        'တို့ပါဝင်သည်။ Gaming နှင့် photography အတွက် အကောင်းဆုံးသောဖုန်းတစ်လုံးဖြစ်သည်။',
    price: 1500,
    imageUrl: 'https://picsum.photos/seed/iphone/400/300',
    category: 'Smartphone',
    rating: 4.8,
    reviewCount: 2341,
    isAvailable: true,
  ),
  const ProductModel(
    id: 'p002',
    name: 'Samsung Galaxy S24 Ultra',
    description:
        'Samsung ၏ S Pen ပါဝင်သော premium smartphone ဖြစ်သည်။ '
        '200MP camera, 6.8 inch Dynamic AMOLED display နှင့် '
        '5000mAh battery တို့ပါဝင်သည်။ Productivity အတွက် အထူးသင့်တော်သည်။',
    price: 1350,
    imageUrl: 'https://picsum.photos/seed/samsung/400/300',
    category: 'Smartphone',
    rating: 4.7,
    reviewCount: 1876,
    isAvailable: true,
  ),
  const ProductModel(
    id: 'p003',
    name: 'MacBook Pro M3',
    description:
        'Apple silicon M3 chip ဖြင့် ပြုလုပ်ထားသော professional laptop ဖြစ်သည်။ '
        'Liquid Retina XDR display, 18 နာရီ battery life နှင့် '
        'ProMotion technology တို့ပါဝင်သည်। Developer နှင့် designer များအတွက် '
        'အကောင်းဆုံးရွေးချယ်မှုဖြစ်သည်။',
    price: 2500,
    imageUrl: 'https://picsum.photos/seed/macbook/400/300',
    category: 'Laptop',
    rating: 4.9,
    reviewCount: 987,
    isAvailable: true,
  ),
  const ProductModel(
    id: 'p004',
    name: 'Sony WH-1000XM5',
    description:
        'Industry-leading noise cancellation ဖြင့် ထင်ရှားသော premium headphone ဖြစ်သည်။ '
        '30 နာရီ battery life, multipoint connection နှင့် '
        'Crystal clear hands-free calling feature တို့ပါဝင်သည်။',
    price: 400,
    imageUrl: 'https://picsum.photos/seed/sony/400/300',
    category: 'Audio',
    rating: 4.6,
    reviewCount: 3210,
    isAvailable: true,
  ),
  const ProductModel(
    id: 'p005',
    name: 'iPad Pro M2',
    description:
        'M2 chip ဖြင့် ပြုလုပ်ထားသော professional tablet ဖြစ်သည်။ '
        'Liquid Retina XDR display, Apple Pencil 2 support နှင့် '
        'Thunderbolt connectivity တို့ပါဝင်သည်။ Creative work အတွက် အထူးသင့်တော်သည်။',
    price: 1200,
    imageUrl: 'https://picsum.photos/seed/ipad/400/300',
    category: 'Tablet',
    rating: 4.7,
    reviewCount: 1543,
    isAvailable: false,
  ),
  const ProductModel(
    id: 'p006',
    name: 'Apple Watch Ultra 2',
    description:
        'Adventure နှင့် extreme sports အတွက် ရည်ရွယ်ထားသော rugged smartwatch ဖြစ်သည်။ '
        'Titanium case, dual-frequency GPS, 60 နာရီ battery life နှင့် '
        'Action Button တို့ပါဝင်သည်။',
    price: 900,
    imageUrl: 'https://picsum.photos/seed/watch/400/300',
    category: 'Wearable',
    rating: 4.5,
    reviewCount: 654,
    isAvailable: true,
  ),
];

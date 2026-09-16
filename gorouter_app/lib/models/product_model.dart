/// Product Model - Detail Page အတွက် သုံးမည့် Mock Product Data
class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageEmoji;
  final double rating;
  final int reviewCount;
  final bool isInStock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageEmoji,
    required this.rating,
    required this.reviewCount,
    required this.isInStock,
  });

  @override
  String toString() => 'ProductModel(id: $id, name: $name, price: $price)';
}

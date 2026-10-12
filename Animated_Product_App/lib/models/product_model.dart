class Product {
  final int id;
  final String name;
  final String brand;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewCount;
  final String category;
  final String emoji; // used as placeholder for product image
  final List<String> tags;
  final List<String> colors;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.emoji,
    required this.tags,
    required this.colors,
    this.isFavorite = false,
  });

  double get discountPercent =>
      ((originalPrice - price) / originalPrice * 100).roundToDouble();

  bool get hasDiscount => originalPrice > price;
}

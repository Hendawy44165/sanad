import '../../data/models/book_model.dart';

/// Represents a Book in the business logic layer.
class BookEntity {
  final String id;
  final String name;
  final String category;
  final String? description;
  final double price;
  final String currency;
  final bool inStock;
  final int stockQuantity;
  final List<String> accessibilityTags;
  final String? thumbnailUrl;
  final String? brand;

  BookEntity({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.price,
    required this.currency,
    required this.inStock,
    required this.stockQuantity,
    required this.accessibilityTags,
    this.thumbnailUrl,
    this.brand,
  });

  /// Factory to create a [BookEntity] from a data layer [BookModel].
  factory BookEntity.fromModel(BookModel model) {
    return BookEntity(
      id: model.id,
      name: model.name,
      category: model.category,
      description: model.description,
      price: model.price.toDouble(),
      currency: model.currency,
      inStock: model.inStock,
      stockQuantity: model.stockQuantity,
      accessibilityTags: model.accessibilityTags,
      thumbnailUrl: model.thumbnailUrl,
      brand: model.brand,
    );
  }
}

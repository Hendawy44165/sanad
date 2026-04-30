/// Data model for Books (Store Products) as received from the API.
class BookModel {
  final String id;
  final String name;
  final String category;
  final String? description;
  final num price;
  final String currency;
  final bool inStock;
  final int stockQuantity;
  final List<String> accessibilityTags;
  final String? thumbnailUrl;
  final String? brand;

  BookModel({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.price,
    this.currency = 'EGP',
    this.inStock = true,
    this.stockQuantity = 0,
    this.accessibilityTags = const [],
    this.thumbnailUrl,
    this.brand,
  });

  /// Factory to create a [BookModel] from JSON data.
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      price: json['price'] as num? ?? 0,
      currency: json['currency'] as String? ?? 'EGP',
      inStock: json['in_stock'] as bool? ?? true,
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      accessibilityTags: (json['accessibility_tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      thumbnailUrl: json['thumbnail_url'] as String?,
      brand: json['brand'] as String?,
    );
  }
}

/// Response wrapper for book list API calls.
class BooksResponse {
  final List<BookModel> books;
  final int total;
  final bool hasNext;

  BooksResponse({
    required this.books,
    required this.total,
    required this.hasNext,
  });

  /// Creates a [BooksResponse] from the API's standard success response.
  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    
    return BooksResponse(
      books: data.map((b) => BookModel.fromJson(b as Map<String, dynamic>)).toList(),
      total: meta['total'] as int? ?? 0,
      hasNext: meta['has_next'] as bool? ?? false,
    );
  }
}

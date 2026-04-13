/// Represents a news article or update.
class NewsItem {
  /// Unique identifier for the news item.
  final String id;

  /// Headline or title of the news.
  final String title;

  /// Short summary or excerpt.
  final String? summary;

  /// Full content/body of the news article.
  final String? content;

  /// Category of the news (e.g., Health, Technology).
  final String category;

  /// Date when the news was published.
  final DateTime publishedAt;

  /// Source of the news (e.g., "BBC", "Sanad Team").
  final String? source;

  /// URL to a featured image.
  final String? imageUrl;

  /// Creates a [NewsItem] instance.
  NewsItem({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    required this.category,
    required this.publishedAt,
    this.source,
    this.imageUrl,
  });

  /// Creates a [NewsItem] instance from a JSON map.
  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'],
      category: json['category'],
      publishedAt: DateTime.parse(json['published_at']),
      source: json['source'],
      imageUrl: json['image_url'],
    );
  }
}

/// Represents a community or social event.
class Event {
  /// Unique identifier for the event.
  final String id;

  /// Title of the event.
  final String title;

  /// Detailed description of the event.
  final String? description;

  /// Date of the event.
  final DateTime date;

  /// formatted time string (e.g., "10:00 AM").
  final String time;

  /// Physical location or "Online".
  final String? location;

  /// Name of the event organizer.
  final String? organizer;

  /// Category of the event (e.g., Workshop, Social).
  final String category;

  /// List of accessibility features available at the event (e.g., "Wheelchair Accessible").
  final List<String> accessibilityFeatures;

  /// URL to an event banner or image.
  final String? imageUrl;

  /// Email address for contacting the event organizer.
  final String? contactEmail;

  /// Creates an [Event] instance.
  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.time,
    this.location,
    this.organizer,
    required this.category,
    this.accessibilityFeatures = const [],
    this.imageUrl,
    this.contactEmail,
  });

  /// Creates an [Event] instance from a JSON map.
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      location: json['location'],
      organizer: json['organizer'],
      category: json['category'],
      accessibilityFeatures: List<String>.from(
        json['accessibility_features'] ?? [],
      ),
      imageUrl: json['image_url'],
      contactEmail: json['contact_email'],
    );
  }
}

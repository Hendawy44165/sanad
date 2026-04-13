/// Represents a medication reminder or alarm.
class MedicationAlarm {
  /// Unique identifier for the alarm.
  final String id;

  /// ID of the user who owns this alarm.
  final String userId;

  /// Name of the medication.
  final String title;

  /// Dosage information (e.g., "50mg", "1 pill").
  final String? dosage;

  /// Time for the alarm (e.g., "08:00 AM").
  final String time;

  /// Frequency of the alarm (e.g., "Daily").
  final String frequency;

  /// Whether the alarm is currently active.
  final bool isActive;

  /// Creates a [MedicationAlarm] instance.
  const MedicationAlarm({
    required this.id,
    required this.userId,
    required this.title,
    this.dosage,
    required this.time,
    this.frequency = 'Daily',
    this.isActive = true,
  });

  /// Creates a [MedicationAlarm] instance from a JSON map.
  factory MedicationAlarm.fromJson(Map<String, dynamic> json) {
    return MedicationAlarm(
      id: json['id'],
      userId:
          json['user_id'] ??
          '', // Handle potential missing field internally or ensure DB has it
      title: json['title'],
      dosage: json['dosage'],
      time: json['time'],
      frequency: json['frequency'] ?? 'Daily',
      isActive: json['is_active'] ?? true,
    );
  }

  /// Converts the [MedicationAlarm] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'dosage': dosage,
      'time': time,
      'frequency': frequency,
      'is_active': isActive,
    };
  }
}

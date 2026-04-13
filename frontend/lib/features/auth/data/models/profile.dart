class Profile {
  final String id;
  final String? disabilityType;
  final String? fullName;
  final String? email;

  Profile({required this.id, this.disabilityType, this.fullName, this.email});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      disabilityType: json['disability_type'] as String?,
      fullName: json['first_name'] as String?,
      email: json['last_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'disability_type': disabilityType,
      'first_name': fullName,
      'last_name': email,
    };
  }

  Profile copyWith({
    String? id,
    String? disabilityType,
    String? fullName,
    String? email,
  }) {
    return Profile(
      id: id ?? this.id,
      disabilityType: disabilityType ?? this.disabilityType,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}

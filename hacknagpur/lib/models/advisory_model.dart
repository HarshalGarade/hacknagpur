/// Advisory data model for storing crop recommendations
class Advisory {
  final String? id; // Local SQLite ID
  final String cropId;
  final String cropName;
  final String advice;
  final String language;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isSynced; // Track sync status with global DB

  Advisory({
    this.id,
    required this.cropId,
    required this.cropName,
    required this.advice,
    required this.language,
    required this.createdAt,
    this.updatedAt,
    this.isSynced = false,
  });

  /// Convert to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropId': cropId,
      'cropName': cropName,
      'advice': advice,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  /// Create from Map (SQLite)
  factory Advisory.fromMap(Map<String, dynamic> map) {
    return Advisory(
      id: map['id'],
      cropId: map['cropId'],
      cropName: map['cropName'],
      advice: map['advice'],
      language: map['language'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      isSynced: map['isSynced'] == 1,
    );
  }

  /// Convert to JSON for API sync
  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'cropName': cropName,
      'advice': advice,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

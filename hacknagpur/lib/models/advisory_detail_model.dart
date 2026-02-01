/// Represents a crop advisory section with metadata
class CropAdvisory {
  final String cropName;
  final String language; // 'english', 'hindi', 'marathi'
  final String category; // 'watering'/'पानी_प्रबंधन'/'पाणी_व्यवस्थापन', 'fertilizer'/'खाद_प्रबंधन'/'खत_व्यवस्थापन', 'growth'/'विकास_चरण'/'विकास_चरण'
  final String advisoryText;
  final DateTime fetchedAt;

  CropAdvisory({
    required this.cropName,
    required this.language,
    required this.category,
    required this.advisoryText,
    required this.fetchedAt,
  });

  /// Convert to Map for local storage
  Map<String, dynamic> toMap() {
    return {
      'cropName': cropName,
      'language': language,
      'category': category,
      'advisoryText': advisoryText,
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }

  /// Create from Map
  factory CropAdvisory.fromMap(Map<String, dynamic> map) {
    return CropAdvisory(
      cropName: map['cropName'],
      language: map['language'],
      category: map['category'],
      advisoryText: map['advisoryText'],
      fetchedAt: DateTime.parse(map['fetchedAt']),
    );
  }
}

/// Represents available crops in a language
class AvailableCrops {
  final String language;
  final List<String> crops;
  final Map<String, List<String>> categories; // crop name -> available categories

  AvailableCrops({
    required this.language,
    required this.crops,
    required this.categories,
  });
}

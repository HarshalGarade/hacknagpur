// Test the category mappings in advisory_data_service.dart
void main() {
  final categoryMappings = {
    'english': {
      'watering': 'watering',
      'water': 'watering',
      'fertilizer': 'fertilizer',
      'growth': 'growth',
    },
    'hindi': {
      'watering': 'पानी_प्रबंधन',
      'water': 'पानी_प्रबंधन',
      'fertilizer': 'खाद_प्रबंधन',
      'growth': 'विकास_चरण',
      'पानी': 'पानी_प्रबंधन',
      'पानी_प्रबंधन': 'पानी_प्रबंधन',
      'खाद': 'खाद_प्रबंधन',
      'खाद_प्रबंधन': 'खाद_प्रबंधन',
      'खत': 'खाद_प्रबंधन',
      'विकास': 'विकास_चरण',
      'विकास_चरण': 'विकास_चरण',
    },
  };

  print("Testing Hindi category mappings:");
  print("================================");
  
  List<String> testCategories = ['watering', 'fertilizer', 'growth'];
  
  for (String category in testCategories) {
    String? mapped = categoryMappings['hindi']?[category.toLowerCase()];
    if (mapped != null) {
      print("✅ '$category' -> '$mapped'");
    } else {
      print("❌ '$category' NOT FOUND");
    }
  }
}

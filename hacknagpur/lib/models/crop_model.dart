import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';

/// 🌾 CROP DATA MODEL WITH MULTILINGUAL SUPPORT
class Crop {
  final String id;
  final Map<AppLanguage, String> names;
  final IconData icon;
  final Color color;

  const Crop({
    required this.id,
    required this.names,
    required this.icon,
    required this.color,
  });

  String getName(AppLanguage language) {
    return names[language] ?? names[AppLanguage.english] ?? id;
  }
}

class CropData {
  static const List<Crop> crops = [
    Crop(
      id: 'rice',
      names: {
        AppLanguage.english: 'Rice',
        AppLanguage.hindi: 'चावल',
        AppLanguage.marathi: 'तांदूळ',
      },
      icon: Icons.grain,
      color: Color(0xFFD4AF37),
    ),
    Crop(
      id: 'wheat',
      names: {
        AppLanguage.english: 'Wheat',
        AppLanguage.hindi: 'गेहूं',
        AppLanguage.marathi: 'गहू',
      },
      icon: Icons.agriculture,
      color: Color(0xFFDEB887),
    ),
    Crop(
      id: 'maize',
      names: {
        AppLanguage.english: 'Maize',
        AppLanguage.hindi: 'मक्का',
        AppLanguage.marathi: 'मका',
      },
      icon: Icons.eco,
      color: Color(0xFFFFD700),
    ),
    Crop(
      id: 'bajra',
      names: {
        AppLanguage.english: 'Bajra',
        AppLanguage.hindi: 'बाजरा',
        AppLanguage.marathi: 'बाजरी',
      },
      icon: Icons.grass,
      color: Color(0xFF8B7355),
    ),
    Crop(
      id: 'jowar',
      names: {
        AppLanguage.english: 'Jowar',
        AppLanguage.hindi: 'ज्वार',
        AppLanguage.marathi: 'ज्वारी',
      },
      icon: Icons.spa,
      color: Color(0xFFA0826D),
    ),
    Crop(
      id: 'ragi',
      names: {
        AppLanguage.english: 'Ragi',
        AppLanguage.hindi: 'रागी',
        AppLanguage.marathi: 'नाचणी',
      },
      icon: Icons.nature,
      color: Color(0xFF8B4513),
    ),
    Crop(
      id: 'barley',
      names: {
        AppLanguage.english: 'Barley',
        AppLanguage.hindi: 'जौ',
        AppLanguage.marathi: 'जव',
      },
      icon: Icons.local_florist,
      color: Color(0xFFDAA520),
    ),
    Crop(
      id: 'gram',
      names: {
        AppLanguage.english: 'Gram',
        AppLanguage.hindi: 'चना',
        AppLanguage.marathi: 'हरभरा',
      },
      icon: Icons.bubble_chart,
      color: Color(0xFFCD853F),
    ),
    Crop(
      id: 'tur',
      names: {
        AppLanguage.english: 'Tur',
        AppLanguage.hindi: 'तूर',
        AppLanguage.marathi: 'तूर',
      },
      icon: Icons.circle,
      color: Color(0xFFB8860B),
    ),
    Crop(
      id: 'urad',
      names: {
        AppLanguage.english: 'Urad',
        AppLanguage.hindi: 'उड़द',
        AppLanguage.marathi: 'उडीद',
      },
      icon: Icons.lens,
      color: Color(0xFF654321),
    ),
    Crop(
      id: 'moong',
      names: {
        AppLanguage.english: 'Moong',
        AppLanguage.hindi: 'मूंग',
        AppLanguage.marathi: 'मूग',
      },
      icon: Icons.fiber_manual_record,
      color: Color(0xFF90EE90),
    ),
    Crop(
      id: 'lentil',
      names: {
        AppLanguage.english: 'Lentil',
        AppLanguage.hindi: 'मसूर',
        AppLanguage.marathi: 'मसूर',
      },
      icon: Icons.adjust,
      color: Color(0xFFD2691E),
    ),
    Crop(
      id: 'sugarcane',
      names: {
        AppLanguage.english: 'Sugarcane',
        AppLanguage.hindi: 'गन्ना',
        AppLanguage.marathi: 'ऊस',
      },
      icon: Icons.park,
      color: Color(0xFF3CB371),
    ),
    Crop(
      id: 'cotton',
      names: {
        AppLanguage.english: 'Cotton',
        AppLanguage.hindi: 'कपास',
        AppLanguage.marathi: 'कापूस',
      },
      icon: Icons.cloud,
      color: Color(0xFFF5F5DC),
    ),
    Crop(
      id: 'jute',
      names: {
        AppLanguage.english: 'Jute',
        AppLanguage.hindi: 'जूट',
        AppLanguage.marathi: 'ताग',
      },
      icon: Icons.grass_outlined,
      color: Color(0xFFBDB76B),
    ),
    Crop(
      id: 'groundnut',
      names: {
        AppLanguage.english: 'Groundnut',
        AppLanguage.hindi: 'मूंगफली',
        AppLanguage.marathi: 'भुईमूग',
      },
      icon: Icons.set_meal,
      color: Color(0xFFD2B48C),
    ),
    Crop(
      id: 'soybean',
      names: {
        AppLanguage.english: 'Soybean',
        AppLanguage.hindi: 'सोयाबीन',
        AppLanguage.marathi: 'सोयाबीन',
      },
      icon: Icons.scatter_plot,
      color: Color(0xFFDAA520),
    ),
    Crop(
      id: 'mustard',
      names: {
        AppLanguage.english: 'Mustard',
        AppLanguage.hindi: 'सरसों',
        AppLanguage.marathi: 'मोहरी',
      },
      icon: Icons.star,
      color: Color(0xFFFFD700),
    ),
    Crop(
      id: 'tea',
      names: {
        AppLanguage.english: 'Tea',
        AppLanguage.hindi: 'चाय',
        AppLanguage.marathi: 'चहा',
      },
      icon: Icons.local_cafe,
      color: Color(0xFF556B2F),
    ),
    Crop(
      id: 'potato',
      names: {
        AppLanguage.english: 'Potato',
        AppLanguage.hindi: 'आलू',
        AppLanguage.marathi: 'बटाटा',
      },
      icon: Icons.circle_outlined,
      color: Color(0xFFD2B48C),
    ),
    Crop(
      id: 'banana',
      names: {
        AppLanguage.english: 'Banana',
        AppLanguage.hindi: 'केला',
        AppLanguage.marathi: 'केळी',
      },
      icon: Icons.waves,
      color: Color(0xFFFFE135),
    ),
    Crop(
      id: 'mango',
      names: {
        AppLanguage.english: 'Mango',
        AppLanguage.hindi: 'आम',
        AppLanguage.marathi: 'आंबा',
      },
      icon: Icons.water_drop,
      color: Color(0xFFFF8C00),
    ),
    Crop(
      id: 'apple',
      names: {
        AppLanguage.english: 'Apple',
        AppLanguage.hindi: 'सेब',
        AppLanguage.marathi: 'सफरचंद',
      },
      icon: Icons.favorite,
      color: Color(0xFFDC143C),
    ),
    Crop(
      id: 'orange',
      names: {
        AppLanguage.english: 'Orange',
        AppLanguage.hindi: 'संतरा',
        AppLanguage.marathi: 'संत्री',
      },
      icon: Icons.wb_sunny,
      color: Color(0xFFFFA500),
    ),
    Crop(
      id: 'grapes',
      names: {
        AppLanguage.english: 'Grapes',
        AppLanguage.hindi: 'अंगूर',
        AppLanguage.marathi: 'द्राक्षे',
      },
      icon: Icons.circle_sharp,
      color: Color(0xFF6A0DAD),
    ),
    Crop(
      id: 'tomato',
      names: {
        AppLanguage.english: 'Tomato',
        AppLanguage.hindi: 'टमाटर',
        AppLanguage.marathi: 'टोमॅटो',
      },
      icon: Icons.brightness_1,
      color: Color(0xFFFF6347),
    ),
    Crop(
      id: 'onion',
      names: {
        AppLanguage.english: 'Onion',
        AppLanguage.hindi: 'प्याज',
        AppLanguage.marathi: 'कांदा',
      },
      icon: Icons.radio_button_checked,
      color: Color(0xFFF5DEB3),
    ),
    Crop(
      id: 'brinjal',
      names: {
        AppLanguage.english: 'Brinjal',
        AppLanguage.hindi: 'बैंगन',
        AppLanguage.marathi: 'वांगे',
      },
      icon: Icons.egg,
      color: Color(0xFF9370DB),
    ),
    Crop(
      id: 'cabbage',
      names: {
        AppLanguage.english: 'Cabbage',
        AppLanguage.hindi: 'पत्ता गोभी',
        AppLanguage.marathi: 'कोबी',
      },
      icon: Icons.layers,
      color: Color(0xFF90EE90),
    ),
    Crop(
      id: 'cauliflower',
      names: {
        AppLanguage.english: 'Cauliflower',
        AppLanguage.hindi: 'फूल गोभी',
        AppLanguage.marathi: 'फुलकोबी',
      },
      icon: Icons.filter_vintage,
      color: Color(0xFFFFFAF0),
    ),
  ];
}

/// 🌐 LANGUAGE CONFIGURATION
/// Multilingual support for English, Hindi, and Marathi
enum AppLanguage { english, hindi, marathi }

class LanguageStrings {
  static Map<AppLanguage, Map<String, String>> translations = {
    AppLanguage.english: {
      'app_name': 'KrishiSetu',
      'app_subtitle': 'Farmer Bridge',
      'start_advisory': 'Start Crop Advisory',
      'offline_mode': 'Offline Advisory',
      'offline_subtitle': 'No Internet Required',
      'online_mode': 'Online Advisory',
      'online_subtitle': 'Internet Required',
      'select_manually': 'Select Manually',
      'select_manually_subtitle': 'Choose from database',
      'take_photo_mode': 'Take Photo',
      'take_photo_subtitle': 'Capture from camera',
      'select_crop': 'Select Your Crop',
      'take_photo': 'Take Photo',
      'upload_photo': 'Upload Photo',
      'from_gallery': 'From Gallery',
      'camera': 'Camera',
      'continue': 'Continue',
      'home': 'Home',
      'my_advice': 'My Advice',
      'settings': 'Settings',
      'profile': 'Profile',
      'farmer_name': 'Farmer Name',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'marathi': 'मराठी (Marathi)',
      'advisory_title': 'Choose Advisory Mode',
      'tap_crop': 'Tap on your crop',
      'smart_detection': 'AI-Powered Detection',
      'select_image': 'Select Image',
      'no_image': 'No image selected',
      'retake': 'Retake',
      'analyze': 'Analyze Crop',
      'todays_tip': "Today's Farm Tip",
      'recent_advisories': 'Recent Advisories',
      'smart_alerts': 'Smart Alerts',
      'weather_update': 'Weather Update',
      'multi_lang': 'Multi-Language',
      'get_advice': 'Get Advice',
      'crop_selected': 'Crop Selected',
      'offline_mode': 'Offline Mode',
      'syncing': 'Syncing',
      'sync_complete': 'Sync Complete',
      'sync_failed': 'Sync Failed',
    },
    AppLanguage.hindi: {
      'app_name': 'KrishiSetu',
      'app_subtitle': 'किसान सेतु',
      'start_advisory': 'फसल सलाह शुरू करें',
      'offline_mode': 'ऑफलाइन सलाह',
      'offline_subtitle': 'इंटरनेट की आवश्यकता नहीं',
      'online_mode': 'ऑनलाइन सलाह',
      'online_subtitle': 'इंटरनेट आवश्यक',
      'select_manually': 'मैनुअली चुनें',
      'select_manually_subtitle': 'डेटाबेस से चुनें',
      'take_photo_mode': 'फोटो लें',
      'take_photo_subtitle': 'कैमरे से कैप्चर करें',
      'select_crop': 'अपनी फसल चुनें',
      'take_photo': 'फोटो लें',
      'upload_photo': 'फोटो अपलोड करें',
      'from_gallery': 'गैलरी से',
      'camera': 'कैमरा',
      'continue': 'जारी रखें',
      'home': 'होम',
      'my_advice': 'मेरी सलाह',
      'settings': 'सेटिंग',
      'profile': 'प्रोफ़ाइल',
      'farmer_name': 'किसान का नाम',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'marathi': 'मराठी (Marathi)',
      'advisory_title': 'सलाह मोड चुनें',
      'tap_crop': 'अपनी फसल पर टैप करें',
      'smart_detection': 'AI-संचालित पहचान',
      'select_image': 'छवि चुनें',
      'no_image': 'कोई छवि नहीं चुनी गई',
      'retake': 'फिर से लें',
      'analyze': 'फसल विश्लेषण करें',
      'todays_tip': 'आज की खेती युक्ति',
      'recent_advisories': 'हाल की सलाह',
      'smart_alerts': 'स्मार्ट अलर्ट',
      'weather_update': 'मौसम अपडेट',
      'multi_lang': 'बहु-भाषा',
      'get_advice': 'सलाह लें',
      'crop_selected': 'फसल चयनित',
      'offline_mode': 'ऑफलाइन मोड',
      'syncing': 'सिंक हो रहा है',
      'sync_complete': 'सिंक पूर्ण',
      'sync_failed': 'सिंक विफल',
    },
    AppLanguage.marathi: {
      'app_name': 'KrishiSetu',
      'app_subtitle': 'शेतकरी सेतू',
      'start_advisory': 'पीक सल्ला सुरू करा',
      'offline_mode': 'ऑफलाइन सल्ला',
      'offline_subtitle': 'इंटरनेट आवश्यक नाही',
      'online_mode': 'ऑनलाइन सल्ला',
      'online_subtitle': 'इंटरनेट आवश्यक',
      'select_manually': 'हाताने निवडा',
      'select_manually_subtitle': 'डेटाबेसमधून निवडा',
      'take_photo_mode': 'फोटो घ्या',
      'take_photo_subtitle': 'कॅमेरामधून कॅप्चर करा',
      'select_crop': 'तुमचे पीक निवडा',
      'take_photo': 'फोटो घ्या',
      'upload_photo': 'फोटो अपलोड करा',
      'from_gallery': 'गॅलरीमधून',
      'camera': 'कॅमेरा',
      'continue': 'सुरू ठेवा',
      'home': 'होम',
      'my_advice': 'माझा सल्ला',
      'settings': 'सेटिंग्ज',
      'profile': 'प्रोफाइल',
      'farmer_name': 'शेतकऱ्याचे नाव',
      'select_language': 'भाषा निवडा',
      'english': 'English',
      'hindi': 'हिंदी (Hindi)',
      'marathi': 'मराठी (Marathi)',
      'advisory_title': 'सल्ला मोड निवडा',
      'tap_crop': 'तुमच्या पिकावर टॅप करा',
      'smart_detection': 'AI-संचालित शोध',
      'select_image': 'प्रतिमा निवडा',
      'no_image': 'कोणतीही प्रतिमा निवडलेली नाही',
      'retake': 'पुन्हा घ्या',
      'analyze': 'पीक विश्लेषण करा',
      'todays_tip': 'आजची शेती टीप',
      'recent_advisories': 'अलीकडील सल्ले',
      'smart_alerts': 'स्मार्ट सूचना',
      'weather_update': 'हवामान अपडेट',
      'multi_lang': 'बहु-भाषा',
      'get_advice': 'सल्ला घ्या',
      'crop_selected': 'पीक निवडले',
      'offline_mode': 'ऑफलाइन मोड',
      'syncing': 'सिंक होत आहे',
      'sync_complete': 'सिंक पूर्ण',
      'sync_failed': 'सिंक अयशस्वी',
    },
  };

  static String get(String key, AppLanguage language) {
    return translations[language]?[key] ?? key;
  }
}

/// 🔤 LANGUAGE CONFIG - Helper class for string-based language codes
class LanguageConfig {
  static final Map<String, Map<String, String>> _stringTranslations = {
    'en': LanguageStrings.translations[AppLanguage.english]!,
    'hi': LanguageStrings.translations[AppLanguage.hindi]!,
    'mr': LanguageStrings.translations[AppLanguage.marathi]!,
  };

  static const Map<String, String> _additionalTranslations = {
    'search_crop': 'Search Crop',
    'search_crop_hi': 'फसल खोजें',
    'search_crop_mr': 'पीक शोधा',
    'crop_not_found': 'Crop not found in database',
    'crop_not_found_hi': 'फसल डेटाबेस में नहीं मिली',
    'crop_not_found_mr': 'पीक डेटाबेसमध्ये आढळले नाही',
    'crop_advisory': 'Crop Advisory',
    'crop_advisory_hi': 'फसल सलाह',
    'crop_advisory_mr': 'पीक सल्ला',
    'select_advisory': 'Select Advisory Category',
    'select_advisory_hi': 'सलाह श्रेणी चुनें',
    'select_advisory_mr': 'सल्ला श्रेणी निवडा',
    'advisory_details': 'Advisory Details',
    'advisory_details_hi': 'सलाह विवरण',
    'advisory_details_mr': 'सल्ला तपशील',
    'offline_available': '📱 Available offline - No internet required',
    'offline_available_hi': '📱 ऑफलाइन उपलब्ध - इंटरनेट की आवश्यकता नहीं',
    'offline_available_mr': '📱 ऑफलाइन उपलब्ध - इंटरनेट आवश्यक नाही',
  };

  static String getTranslation(String key, String language) {
    // Try to get from additional translations first
    final langKey = '${key}_${language == 'en' ? '' : language}'.trim();
    if (_additionalTranslations.containsKey(langKey)) {
      return _additionalTranslations[langKey]!;
    }
    if (_additionalTranslations.containsKey(key)) {
      return _additionalTranslations[key]!;
    }
    
    // Try to get from main translations
    return _stringTranslations[language]?[key] ?? key;
  }
}

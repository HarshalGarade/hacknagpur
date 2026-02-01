"""
KrishiSetu Offline Advisory Backend - Flask Implementation
Simplified version for stability
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
from datetime import datetime

# Import advisory data
from advisor_data import advisor_data as advisor_data_english
from advisort_hindi import advisort_hindi as advisor_data_hindi

# Try to import Marathi data
try:
    import importlib.util
    spec = importlib.util.spec_from_file_location("advisory_marathi", "advisory_data_marathi (1).py")
    advisory_marathi = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(advisory_marathi)
    advisor_data_marathi = advisory_marathi.advisor_data
except:
    advisor_data_marathi = {}

# Initialize Flask app
app = Flask(__name__)
CORS(app)

# Data sources
DATA_SOURCES = {
    'english': advisor_data_english,
    'hindi': advisor_data_hindi,
    'marathi': advisor_data_marathi,
}

# Crop ID to language-specific name mappings
CROP_NAME_MAPPINGS = {
    'english': {
        'rice': 'rice', 'wheat': 'wheat', 'maize': 'maize', 'bajra': 'bajra',
        'jowar': 'jowar', 'ragi': 'ragi', 'barley': 'barley', 'gram': 'gram',
        'tur': 'tur', 'urad': 'urad', 'moong': 'moong', 'lentil': 'lentil',
        'sugarcane': 'sugarcane', 'cotton': 'cotton', 'jute': 'jute', 'groundnut': 'groundnut',
        'soybean': 'soybean', 'mustard': 'mustard', 'tea': 'tea', 'potato': 'potato',
        'banana': 'banana', 'mango': 'mango', 'apple': 'apple', 'orange': 'orange',
        'grapes': 'grapes', 'tomato': 'tomato', 'onion': 'onion', 'brinjal': 'brinjal',
        'cabbage': 'cabbage', 'cauliflower': 'cauliflower',
    },
    'hindi': {
        'rice': 'चावल', 'wheat': 'गेहूँ', 'maize': 'मक्का', 'bajra': 'बाजरा',
        'jowar': 'ज्वार', 'ragi': 'रागी', 'barley': 'जौ', 'gram': 'चना',
        'tur': 'अरहर', 'urad': 'मूग', 'moong': 'मूग', 'lentil': 'मसूर',
        'sugarcane': 'ऊस', 'cotton': 'कापूस', 'jute': 'ताग', 'groundnut': 'भुईमूग',
        'soybean': 'सोयाबीन', 'mustard': 'सरसों', 'tea': 'चाय', 'potato': 'आलू',
        'banana': 'केला', 'mango': 'आम', 'apple': 'सेब', 'orange': 'संतरा',
        'grapes': 'अंगूर', 'tomato': 'टमाटर', 'onion': 'प्याज', 'brinjal': 'बैंगन',
        'cabbage': 'पत्तागोभी', 'cauliflower': 'फूलगोभी',
    },
    'marathi': {
        'rice': 'तांदूळ', 'wheat': 'गहू', 'maize': 'मका', 'bajra': 'बाजरी',
        'jowar': 'ज्वारी', 'ragi': 'नाचणी', 'barley': 'जव', 'gram': 'हरभरा',
        'tur': 'तुर', 'urad': 'उड', 'moong': 'मुग', 'lentil': 'मसूर',
        'sugarcane': 'उस', 'cotton': 'कपाड', 'jute': 'जूट', 'groundnut': 'भुयमूग',
        'soybean': 'सोयाबीन', 'mustard': 'सरसा', 'tea': 'चहा', 'potato': 'बटाटा',
        'banana': 'केळी', 'mango': 'आंब', 'apple': 'सफरचंद', 'orange': 'संत्रा',
        'grapes': 'द्राक्ष', 'tomato': 'टोमॅटो', 'onion': 'कांदा', 'brinjal': 'वांगी',
        'cabbage': 'पत्तागोभी', 'cauliflower': 'फुलगोभी',
    },
}

# Category mappings for each language
CATEGORY_MAPPINGS = {
    'english': {
        'watering': 'watering', 'water': 'watering', 'fertilizer': 'fertilizer', 'growth': 'growth',
    },
    'hindi': {
        'watering': 'पानी_प्रबंधन', 'water': 'पानी_प्रबंधन', 'fertilizer': 'खाद_प्रबंधन', 'growth': 'विकास_चरण',
        'पानी': 'पानी_प्रबंधन', 'पानी_प्रबंधन': 'पानी_प्रबंधन', 'खाद': 'खाद_प्रबंधन', 'खाद_प्रबंधन': 'खाद_प्रबंधन',
        'खत': 'खाद_प्रबंधन', 'विकास': 'विकास_चरण', 'विकास_चरण': 'विकास_चरण',
    },
    'marathi': {
        'watering': 'पाणी_व्यवस्थापन', 'water': 'पाणी_व्यवस्थापन', 'fertilizer': 'खत_व्यवस्थापन', 'growth': 'विकास_चरण',
        'पाणी': 'पाणी_व्यवस्थापन', 'पाणी_व्यवस्थापन': 'पाणी_व्यवस्थापन', 'खत': 'खत_व्यवस्थापन',
        'खत_व्यवस्थापन': 'खत_व्यवस्थापन', 'विकास': 'विकास_चरण', 'विकास_चरण': 'विकास_चरण',
    },
}

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy', 'service': 'KrishiSetu Advisory Backend'}), 200

@app.route('/api/v1/advisories/crops', methods=['GET'])
def get_crops():
    language = request.args.get('language', 'english').lower()
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    crops = list(data.keys())
    
    return jsonify({
        'success': True,
        'language': language,
        'crops': crops,
        'total': len(crops),
    }), 200

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch_advisory():
    crop = request.args.get('crop', '').strip()
    category = request.args.get('category', '').strip()
    language = request.args.get('language', 'english').lower()
    
    # Validate inputs
    if not crop or not category:
        return jsonify({'success': False, 'error': 'Missing parameters: crop, category, language'}), 400
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': f'Invalid language: {language}'}), 400
    
    data = DATA_SOURCES[language]
    
    # Map crop ID to language-specific crop name
    crop_key = None
    crop_lower = crop.lower()
    
    # Use CROP_NAME_MAPPINGS to find the correct crop name
    if language in CROP_NAME_MAPPINGS:
        if crop_lower in CROP_NAME_MAPPINGS[language]:
            crop_key = CROP_NAME_MAPPINGS[language][crop_lower]
    
    # Fallback: search in data
    if not crop_key:
        if language == 'english':
            for key in data.keys():
                if key.lower() == crop_lower:
                    crop_key = key
                    break
        else:
            # For Hindi/Marathi, try exact match first
            if crop in data:
                crop_key = crop
            else:
                # Try case-insensitive
                for key in data.keys():
                    if key.lower() == crop_lower:
                        crop_key = key
                        break
    
    if not crop_key:
        return jsonify({
            'success': False,
            'error': f'Crop "{crop}" not found in {language} dataset',
            'available_crops': list(data.keys())[:5],
            'total_crops': len(data),
        }), 404
    
    # Map category to language-specific key
    category_lower = category.lower()
    category_mappings = CATEGORY_MAPPINGS.get(language, {})
    mapped_category = category_mappings.get(category_lower)
    
    if not mapped_category:
        return jsonify({
            'success': False,
            'error': f'Category "{category}" not found for {language}',
            'available_categories': list(data[crop_key].keys()),
        }), 404
    
    if mapped_category not in data[crop_key]:
        return jsonify({
            'success': False,
            'error': f'Category "{mapped_category}" not found for crop "{crop_key}"',
            'available_categories': list(data[crop_key].keys()),
        }), 404
    
    advisory_text = data[crop_key][mapped_category]
    
    return jsonify({
        'success': True,
        'crop_name': crop_key,
        'category': mapped_category,
        'language': language,
        'advisory': advisory_text,
        'character_count': len(advisory_text),
        'fetched_at': datetime.now().isoformat(),
    }), 200

@app.errorhandler(404)
def not_found(error):
    return jsonify({'success': False, 'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def server_error(error):
    return jsonify({'success': False, 'error': 'Internal server error'}), 500

if __name__ == '__main__':
    print("Starting KrishiSetu Advisory Backend...")
    print(f"Available Languages: {list(DATA_SOURCES.keys())}")
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)

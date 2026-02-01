# -*- coding: utf-8 -*-
"""
Simple Flask Backend for Hindi Advisories - Direct Execution
"""

print("="*70)
print("ADVISOR BACKEND - STARTING UP")
print("="*70)

# Step 1: Check imports
print("\n[1] Checking imports...")
try:
    from flask import Flask, request, jsonify
    from flask_cors import CORS
    from datetime import datetime
    print("    ✓ Flask and dependencies imported")
except ImportError as e:
    print(f"    ✗ Import error: {e}")
    exit(1)

# Step 2: Load data
print("\n[2] Loading data files...")
try:
    from advisor_data import advisor_data as advisor_data_english
    print(f"    ✓ English data: {len(advisor_data_english)} crops")
except Exception as e:
    print(f"    ✗ English data error: {e}")
    exit(1)

try:
    from advisort_hindi import advisort_hindi as advisor_data_hindi
    print(f"    ✓ Hindi data: {len(advisor_data_hindi)} crops")
except Exception as e:
    print(f"    ✗ Hindi data error: {e}")
    exit(1)

try:
    import importlib.util
    spec = importlib.util.spec_from_file_location("advisory_marathi", "advisory_data_marathi (1).py")
    advisory_marathi = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(advisory_marathi)
    advisor_data_marathi = advisory_marathi.advisor_data
    print(f"    ✓ Marathi data: {len(advisor_data_marathi)} crops")
except Exception as e:
    print(f"    ✗ Marathi data (optional): {e}")
    advisor_data_marathi = {}

# Step 3: Create Flask app
print("\n[3] Creating Flask app...")
app = Flask(__name__)
CORS(app)
print("    ✓ Flask app created with CORS")

# Step 4: Setup data
DATA_SOURCES = {
    'english': advisor_data_english,
    'hindi': advisor_data_hindi,
    'marathi': advisor_data_marathi,
}

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
        'tur': 'अरहर', 'urad': 'उड़द', 'moong': 'मूग', 'lentil': 'मसूर',
        'sugarcane': 'ऊस', 'cotton': 'कापूस', 'jute': 'ताग', 'groundnut': 'भुईमूग',
        'soybean': 'सोयाबीन', 'mustard': 'सरसों', 'tea': 'चाय', 'potato': 'आलू',
        'banana': 'केला', 'mango': 'आम', 'apple': 'सेब', 'orange': 'संतरा',
        'grapes': 'अंगूर', 'tomato': 'टमाटर', 'onion': 'प्याज़', 'brinjal': 'बैंगन',
        'cabbage': 'पत्ता_गोभी', 'cauliflower': 'फूलगोभी',
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
    },
}

print("    ✓ Data mappings configured")

# Step 5: Setup routes
print("\n[4] Setting up routes...")

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/api/v1/advisories/crops', methods=['GET'])
def get_crops():
    language = request.args.get('language', 'english').lower()
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    data = DATA_SOURCES[language]
    return jsonify({'success': True, 'language': language, 'crops': list(data.keys()), 'total': len(data)}), 200

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch_advisory():
    crop = request.args.get('crop', '').strip()
    category = request.args.get('category', '').strip()
    language = request.args.get('language', 'english').lower()
    
    if not crop or not category:
        return jsonify({'success': False, 'error': 'Missing parameters'}), 400
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    crop_key = None
    crop_lower = crop.lower()
    
    if language in CROP_NAME_MAPPINGS:
        if crop_lower in CROP_NAME_MAPPINGS[language]:
            crop_key = CROP_NAME_MAPPINGS[language][crop_lower]
    
    if not crop_key:
        if language == 'english':
            for key in data.keys():
                if key.lower() == crop_lower:
                    crop_key = key
                    break
        else:
            if crop in data:
                crop_key = crop
            else:
                for key in data.keys():
                    if key.lower() == crop_lower:
                        crop_key = key
                        break
    
    if not crop_key:
        return jsonify({'success': False, 'error': f'Crop "{crop}" not found', 'available': list(data.keys())[:5]}), 404
    
    category_lower = category.lower()
    category_mappings = CATEGORY_MAPPINGS.get(language, {})
    mapped_category = category_mappings.get(category_lower)
    
    if not mapped_category:
        return jsonify({'success': False, 'error': f'Category "{category}" not found', 'available': list(data[crop_key].keys())}), 404
    
    if mapped_category not in data[crop_key]:
        return jsonify({'success': False, 'error': f'Category "{mapped_category}" not found for crop', 'available': list(data[crop_key].keys())}), 404
    
    advisory_text = data[crop_key][mapped_category]
    return jsonify({'success': True, 'crop_name': crop_key, 'category': mapped_category, 'language': language, 'advisory': advisory_text, 'character_count': len(advisory_text)}), 200

print("    ✓ Routes configured (/health, /api/v1/advisories/crops, /api/v1/advisories/fetch)")

# Step 6: Run the app
print("\n[5] Starting Flask server...")
print("="*70)
app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False, threaded=True)

"""
Minimal Flask backend for advisory data
"""
import os
os.environ['FLASK_ENV'] = 'production'

from flask import Flask, request, jsonify
from flask_cors import CORS
import sys

sys.path.insert(0, 'c:\\Users\\Victus\\Desktop\\hacknagpur')

# Load data
from advisor_data import advisor_data as advisor_data_english
from advisort_hindi import advisort_hindi as advisor_data_hindi

import importlib.util
spec = importlib.util.spec_from_file_location(
    "advisory_marathi", 
    "c:\\Users\\Victus\\Desktop\\hacknagpur\\advisory_data_marathi (1).py"
)
advisory_marathi_module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(advisory_marathi_module)
advisor_data_marathi = advisory_marathi_module.advisor_data

print(f"✅ English: {len(advisor_data_english)} crops")
print(f"✅ Hindi: {len(advisor_data_hindi)} crops")
print(f"✅ Marathi: {len(advisor_data_marathi)} crops")

app = Flask(__name__)
CORS(app)

DATA_SOURCES = {
    'english': advisor_data_english,
    'hindi': advisor_data_hindi,
    'marathi': advisor_data_marathi,
}

CATEGORY_MAPPINGS = {
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
    'marathi': {
        'watering': 'पाणी_व्यवस्थापन',
        'water': 'पाणी_व्यवस्थापन',
        'fertilizer': 'खत_व्यवस्थापन',
        'growth': 'विकास_चरण',
        'पाणी': 'पाणी_व्यवस्थापन',
        'पाणी_व्यवस्थापन': 'पाणी_व्यवस्थापन',
        'खत': 'खत_व्यवस्थापन',
        'खत_व्यवस्थापन': 'खत_व्यवस्थापन',
        'विकास': 'विकास_चरण',
        'विकास_चरण': 'विकास_चरण',
    },
}

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch_advisory():
    crop = request.args.get('crop', '').strip().lower()
    category = request.args.get('category', '').strip().lower()
    language = request.args.get('language', 'english').strip().lower()
    
    if not crop or not category or language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid parameters'}), 400
    
    data = DATA_SOURCES[language]
    
    # Find crop (case-insensitive)
    crop_key = None
    for key in data.keys():
        if key.lower() == crop:
            crop_key = key
            break
    
    if not crop_key:
        return jsonify({'success': False, 'error': f'Crop not found: {crop}'}), 404
    
    # Map category
    mapped_cat = CATEGORY_MAPPINGS[language].get(category)
    if not mapped_cat:
        return jsonify({'success': False, 'error': f'Category not found: {category}'}), 404
    
    if mapped_cat not in data[crop_key]:
        return jsonify({'success': False, 'error': f'No data for category: {mapped_cat}'}), 404
    
    advisory = data[crop_key][mapped_cat]
    return jsonify({
        'success': True,
        'crop': crop_key,
        'category': mapped_cat,
        'language': language,
        'advisory': advisory,
    })

if __name__ == '__main__':
    print("🚀 Starting on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)

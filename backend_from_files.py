#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
KrishiSetu Backend - Load from Actual Data Files + AI Plant Disease Detection
Uses: advisor_data.py (English), advisort_hindi.py (Hindi), advisory_data_marathi.py (Marathi)
Categories: watering, fertilizer, growth, storage
AI Model: Trained CNN for plant disease detection
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import json
import numpy as np
import tensorflow as tf
from PIL import Image
import io
import base64
import os
import json
import numpy as np
import tensorflow as tf
from PIL import Image
import io
import base64

print("\n" + "="*70)
print("BACKEND STARTING - LOADING FROM DATA FILES + AI MODEL")
print("="*70)

# Step 1: Load English data
print("\n[1] Loading English data...")
try:
    from advisor_data import advisor_data as data_english
    print(f"    ✓ English data loaded: {len(data_english)} crops")
except Exception as e:
    print(f"    ✗ Error loading English data: {e}")
    data_english = {}

# Step 2: Load Hindi data
print("\n[2] Loading Hindi data...")
try:
    from advisort_hindi import advisort_hindi as data_hindi
    print(f"    ✓ Hindi data loaded: {len(data_hindi)} crops")
except Exception as e:
    print(f"    ✗ Error loading Hindi data: {e}")
    data_hindi = {}

# Step 3: Load Marathi data
print("\n[3] Loading Marathi data...")
try:
    import importlib.util
    spec = importlib.util.spec_from_file_location("advisory_marathi", "advisory_data_marathi (1).py")
    advisory_marathi = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(advisory_marathi)
    data_marathi = advisory_marathi.advisor_data
    print(f"    ✓ Marathi data loaded: {len(data_marathi)} crops")
except Exception as e:
    print(f"    ✗ Error loading Marathi data: {e}")
    data_marathi = {}

# Step 4: Load Storage advisories
print("\n[4] Loading Storage advisories...")
try:
    from generate_storage_advisories import STORAGE_ADVISORIES
    print(f"    ✓ Storage advisories loaded: {len(STORAGE_ADVISORIES)} crops")
except Exception as e:
    print(f"    ✗ Error loading storage advisories: {e}")
    STORAGE_ADVISORIES = {}

# Step 5: Load AI Model for Plant Disease Detection
print("\n[5] Loading AI Plant Disease Detection Model...")
try:
    model_path = "plant-disease-prediction-cnn-deep-leanring-project/app/trained_model/plant_disease_prediction_model.h5"
    class_indices_path = "plant-disease-prediction-cnn-deep-leanring-project/app/class_indices.json"
    
    if os.path.exists(model_path) and os.path.exists(class_indices_path):
        ai_model = tf.keras.models.load_model(model_path)
        with open(class_indices_path) as f:
            class_indices_dict = json.load(f)
        print(f"    ✓ AI Model loaded successfully")
        print(f"    ✓ Class indices loaded: {len(class_indices_dict)} classes")
        AI_MODEL_AVAILABLE = True
    else:
        print(f"    ⚠ AI Model files not found")
        AI_MODEL_AVAILABLE = False
        ai_model = None
except Exception as e:
    print(f"    ✗ Error loading AI model: {e}")
    AI_MODEL_AVAILABLE = False
    ai_model = None

# Create Flask app
app = Flask(__name__)
CORS(app)

# Map languages to data
DATA_SOURCES = {
    'english': data_english,
    'hindi': data_hindi,
    'marathi': data_marathi,
}

# Storage data mapping
STORAGE_DATA = {
    'english': {crop: data.get('en', '') for crop, data in STORAGE_ADVISORIES.items()},
    'hindi': {crop: data.get('hi', '') for crop, data in STORAGE_ADVISORIES.items()},
    'marathi': {crop: data.get('mr', '') for crop, data in STORAGE_ADVISORIES.items()},
}

# Category mappings for each language
CATEGORY_MAPPINGS = {
    'english': {
        'watering': 'watering',
        'water': 'watering',
        'irrigation': 'watering',
        'fertilizer': 'fertilizer',
        'nutrients': 'fertilizer',
        'khad': 'fertilizer',
        'growth': 'growth',
        'stages': 'growth',
        'development': 'growth',
    },
    'hindi': {
        'watering': 'पानी_प्रबंधन',
        'water': 'पानी_प्रबंधन',
        'सिंचाई': 'पानी_प्रबंधन',
        'पानी': 'पानी_प्रबंधन',
        'fertilizer': 'खाद_प्रबंधन',
        'khad': 'खाद_प्रबंधन',
        'खाद': 'खाद_प्रबंधन',
        'nutrients': 'खाद_प्रबंधन',
        'growth': 'विकास_चरण',
        'stages': 'विकास_चरण',
        'vikas': 'विकास_चरण',
        'विकास': 'विकास_चरण',
    },
    'marathi': {
        'watering': 'पाणी_व्यवस्थापन',
        'water': 'पाणी_व्यवस्थापन',
        'सिंचन': 'पाणी_व्यवस्थापन',
        'पाणी': 'पाणी_व्यवस्थापन',
        'fertilizer': 'खत_व्यवस्थापन',
        'khad': 'खत_व्यवस्थापन',
        'खत': 'खत_व्यवस्थापन',
        'nutrients': 'खत_व्यवस्थापन',
        'growth': 'विकास_चरण',
        'stages': 'विकास_चरण',
        'vikas': 'विकास_चरण',
        'विकास': 'विकास_चरण',
    },
}

print("\n[6] Setting up routes...")

@app.route('/health', methods=['GET'])
def health():
    return jsonify({
        'status': 'ok',
        'english_crops': len(data_english),
        'hindi_crops': len(data_hindi),
        'marathi_crops': len(data_marathi),
        'categories': ['watering', 'fertilizer', 'growth']
    })

@app.route('/api/v1/advisories/crops', methods=['GET'])
def get_crops():
    language = request.args.get('language', 'english').lower()
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    return jsonify({
        'success': True,
        'language': language,
        'crops': list(data.keys()),
        'total': len(data)
    }), 200

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch_advisory():
    crop = request.args.get('crop', '').strip()
    category = request.args.get('category', '').strip()
    language = request.args.get('language', 'english').lower()
    
    if not crop or not category:
        return jsonify({'success': False, 'error': 'Missing crop or category'}), 400
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    # Handle storage category separately (from generate_storage_advisories.py)
    if category.lower() in ['storage', 'storage_life_months']:
        if language not in STORAGE_DATA:
            return jsonify({'success': False, 'error': f'No storage data for language {language}'}), 400
        
        storage_data = STORAGE_DATA[language]
        
        # Find crop (case insensitive)
        crop_key = None
        crop_lower = crop.lower()
        for k in storage_data.keys():
            if k.lower() == crop_lower:
                crop_key = k
                break
        
        if not crop_key:
            return jsonify({
                'success': False,
                'error': f'Crop "{crop}" not found in storage advisories',
                'available': list(storage_data.keys())[:5]
            }), 404
        
        advisory = storage_data.get(crop_key)
        
        if not advisory:
            return jsonify({
                'success': False,
                'error': f'Storage advisory not found for "{crop_key}"'
            }), 404
        
        return jsonify({
            'success': True,
            'crop': crop_key,
            'category': 'storage',
            'language': language,
            'advisory': advisory,
            'character_count': len(str(advisory))
        }), 200
    
    # Handle watering, fertilizer, growth (original logic)
    data = DATA_SOURCES[language]
    if not data:
        return jsonify({'success': False, 'error': f'No data for language {language}'}), 400
    
    # Find crop (case insensitive)
    crop_key = None
    crop_lower = crop.lower()
    for k in data.keys():
        if k.lower() == crop_lower:
            crop_key = k
            break
    
    if not crop_key:
        return jsonify({
            'success': False,
            'error': f'Crop "{crop}" not found',
            'available': list(data.keys())[:5]
        }), 404
    
    # Map category to actual field name
    category_lower = category.lower()
    category_mappings = CATEGORY_MAPPINGS.get(language, {})
    mapped_category = category_mappings.get(category_lower)
    
    if not mapped_category:
        return jsonify({
            'success': False,
            'error': f'Category "{category}" not found',
            'available_categories': ['watering', 'fertilizer', 'growth', 'storage']
        }), 400
    
    # Get advisory from data
    crop_data = data.get(crop_key, {})
    advisory = crop_data.get(mapped_category)
    
    if not advisory:
        return jsonify({
            'success': False,
            'error': f'Advisory for "{crop}/{mapped_category}" not found',
            'available_in_crop': list(crop_data.keys())
        }), 404
    
    return jsonify({
        'success': True,
        'crop': crop_key,
        'category': mapped_category,
        'language': language,
        'advisory': advisory,
        'character_count': len(str(advisory))
    }), 200

@app.route('/api/v1/ai/predict-plant', methods=['POST'])
def predict_plant():
    """AI endpoint to predict crop/disease from image"""
    if not AI_MODEL_AVAILABLE:
        return jsonify({
            'success': False,
            'error': 'AI model not available'
        }), 503
    
    try:
        # Get image from request
        if 'image' not in request.files:
            return jsonify({
                'success': False,
                'error': 'No image provided'
            }), 400
        
        image_file = request.files['image']
        if image_file.filename == '':
            return jsonify({
                'success': False,
                'error': 'No image selected'
            }), 400
        
        # Read and preprocess image
        image = Image.open(io.BytesIO(image_file.read())).convert('RGB')
        image_resized = image.resize((128, 128))
        img_array = np.array(image_resized)
        img_array = np.expand_dims(img_array, axis=0)
        img_array = img_array.astype('float32') / 255.0
        
        # Make prediction
        predictions = ai_model.predict(img_array, verbose=0)
        predicted_class_index = np.argmax(predictions, axis=1)[0]
        predicted_class_name = class_indices_dict[str(predicted_class_index)]
        confidence = float(predictions[0][predicted_class_index]) * 100
        
        # Parse prediction: format is "Crop___Disease" or "Crop___healthy"
        parts = predicted_class_name.split('___')
        crop_name = parts[0].replace('_(including_sour)', '').replace(',_bell', '').replace('_(maize)', '').strip().lower()
        disease_status = parts[1] if len(parts) > 1 else 'unknown'
        
        return jsonify({
            'success': True,
            'prediction': predicted_class_name,
            'crop': crop_name,
            'disease': disease_status,
            'confidence': round(confidence, 2),
            'message': f'Detected: {predicted_class_name} (Confidence: {confidence:.1f}%)'
        }), 200
    
    except Exception as e:
        return jsonify({
            'success': False,
            'error': f'Prediction error: {str(e)}'
        }), 500

print("    ✓ AI prediction route configured")
print("\n[5] Starting Flask server...")
print("="*70)
print("✓ Backend ready!")
print("✓ Categories: watering, fertilizer, growth")
print("✓ Languages: english, hindi, marathi")
print("✓ Listening on http://localhost:5000")
print("="*70 + "\n")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False, threaded=True)

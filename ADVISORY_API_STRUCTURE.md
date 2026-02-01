"""
=============================================================================
BACKEND API STRUCTURE FOR OFFLINE-FIRST ADVISORY SYSTEM
=============================================================================

This file documents the API endpoints that should be implemented in your 
Python backend (Flask/FastAPI) to serve crop advisory data to the Flutter app.

The Flutter app will call these endpoints to:
1. Fetch available crops (offline mode)
2. Fetch specific crop advisories
3. Sync uploaded data to global database

=============================================================================
ENDPOINTS REQUIRED
=============================================================================

1. GET /api/v1/advisories/crops
   ────────────────────────────
   Description: Get list of all available crops in a specific language
   
   Parameters:
     - language: str (required) - 'english', 'hindi', or 'marathi'
   
   Response (JSON):
   {
     "success": true,
     "language": "english",
     "crops": ["rice", "wheat", "maize", "cotton", "sugarcane", ...],
     "total": 30,
     "timestamp": "2026-01-31T10:30:00Z"
   }
   
   Example URL:
   GET /api/v1/advisories/crops?language=english
   
   Source Files:
   - English: advisor_data.py → keys of advisor_data dict
   - Hindi: advisort_hindi.py → keys of advisort_hindi dict
   - Marathi: advisory_data_marathi (1).py → keys of advisor_data dict


2. GET /api/v1/advisories/fetch
   ────────────────────────────
   Description: Fetch specific crop advisory for a given category and language
   
   Parameters:
     - crop: str (required) - crop name (must match exactly from dataset)
     - category: str (required) - 'watering'/'पानी_प्रबंधन'/'पाणी_व्यवस्थापन',
                                  'fertilizer'/'खाद_प्रबंधन'/'खत_व्यवस्थापन',
                                  'growth'/'विकास_चरण'/'विकास_चरण'
     - language: str (required) - 'english', 'hindi', or 'marathi'
   
   Response (JSON):
   {
     "success": true,
     "crop_name": "Rice",
     "category": "watering",
     "language": "english",
     "advisory": "[EXACT TEXT FROM DATASET - INCLUDING FORMATTING/EMOJIS]",
     "fetched_at": "2026-01-31T10:30:00Z"
   }
   
   Error Response:
   {
     "success": false,
     "error": "Data not found",
     "crop": "rice",
     "category": "watering",
     "language": "english"
   }
   
   Example URL:
   GET /api/v1/advisories/fetch?crop=rice&category=watering&language=english


3. POST /api/v1/advisories/sync/upload
   ───────────────────────────────────
   Description: Upload farmer's advisory data to global database
   
   Request Body (JSON):
   {
     "farmer_id": "farmer_uuid",
     "crop": "rice",
     "category": "watering",
     "language": "english",
     "notes": "[USER NOTES IF ANY]",
     "timestamp": "2026-01-31T10:30:00Z"
   }
   
   Response:
   {
     "success": true,
     "message": "Advisory recorded successfully",
     "sync_id": "sync_12345",
     "timestamp": "2026-01-31T10:30:00Z"
   }


4. GET /api/v1/advisories/all
   ──────────────────────────
   Description: Get all advisories (for offline sync)
   
   Parameters:
     - language: str (required) - 'english', 'hindi', or 'marathi'
     - since: str (optional) - ISO timestamp for delta sync
   
   Response (JSON):
   {
     "success": true,
     "language": "english",
     "advisories": [
       {
         "crop": "rice",
         "categories": {
           "watering": "[TEXT]",
           "fertilizer": "[TEXT]",
           "growth": "[TEXT]"
         }
       },
       ...
     ],
     "total": 30,
     "timestamp": "2026-01-31T10:30:00Z"
   }

=============================================================================
IMPLEMENTATION IN PYTHON (Flask Example)
=============================================================================

from flask import Flask, request, jsonify
from advisor_data import advisor_data
from advisort_hindi import advisort_hindi
from advisory_data_marathi import advisor_data as advisor_data_marathi
import json
from datetime import datetime

app = Flask(__name__)

# Data sources
DATA_SOURCES = {
    'english': advisor_data,
    'hindi': advisort_hindi,
    'marathi': advisor_data_marathi,
}

# Category mappings
CATEGORIES = {
    'english': {
        'watering': 'watering',
        'fertilizer': 'fertilizer',
        'growth': 'growth',
    },
    'hindi': {
        'पानी_प्रबंधन': 'पानी_प्रबंधन',
        'खाद_प्रबंधन': 'खाद_प्रबंधन',
        'विकास_चरण': 'विकास_चरण',
    },
    'marathi': {
        'पाणी_व्यवस्थापन': 'पाणी_व्यवस्थापन',
        'खत_व्यवस्थापन': 'खत_व्यवस्थापन',
        'विकास_चरण': 'विकास_चरण',
    },
}

@app.route('/api/v1/advisories/crops', methods=['GET'])
def get_crops():
    \"\"\"Get list of all available crops\"\"\"
    language = request.args.get('language', 'english')
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    crops = list(data.keys())
    
    return jsonify({
        'success': True,
        'language': language,
        'crops': crops,
        'total': len(crops),
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch_advisory():
    \"\"\"Fetch specific crop advisory\"\"\"
    crop = request.args.get('crop', '').lower()
    category = request.args.get('category', '')
    language = request.args.get('language', 'english')
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    
    # Find crop (case-insensitive for English, exact for Hindi/Marathi)
    crop_key = None
    if language == 'english':
        for key in data.keys():
            if key.lower() == crop:
                crop_key = key
                break
    else:
        crop_key = crop if crop in data else None
    
    if not crop_key:
        return jsonify({
            'success': False,
            'error': 'Crop not found',
            'crop': crop,
            'language': language
        }), 404
    
    if category not in data[crop_key]:
        return jsonify({
            'success': False,
            'error': 'Category not found',
            'crop': crop_key,
            'category': category,
            'language': language
        }), 404
    
    return jsonify({
        'success': True,
        'crop_name': crop_key,
        'category': category,
        'language': language,
        'advisory': data[crop_key][category],
        'fetched_at': datetime.now().isoformat()
    })

@app.route('/api/v1/advisories/all', methods=['GET'])
def get_all_advisories():
    \"\"\"Get all advisories for offline sync\"\"\"
    language = request.args.get('language', 'english')
    
    if language not in DATA_SOURCES:
        return jsonify({'success': False, 'error': 'Invalid language'}), 400
    
    data = DATA_SOURCES[language]
    
    return jsonify({
        'success': True,
        'language': language,
        'advisories': data,
        'total': len(data),
        'timestamp': datetime.now().isoformat()
    })

if __name__ == '__main__':
    app.run(debug=True, port=5000)

=============================================================================
FRONTEND INTEGRATION (Flutter)
=============================================================================

The AdvisoryDataService will use these endpoints. Update the _getAdvisoryFromSource
method to call your backend:

Future<String?> _getAdvisoryFromSource(
  String cropName,
  String category,
  String language,
) async {
  try {
    final response = await http.get(
      Uri.parse(
        'https://your-backend.com/api/v1/advisories/fetch'
        '?crop=$cropName&category=$category&language=$language'
      ),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Save to local database
        final advisory = CropAdvisory(
          cropName: cropName,
          language: language,
          category: category,
          advisoryText: data['advisory'],
          fetchedAt: DateTime.now(),
        );
        await _db.insertAdvisory(advisory);
        return data['advisory'];
      }
    }
    return null;
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

=============================================================================
"""

"""
Simple HTTP server for advisory data using http.server
"""
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import json
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

DATA_SOURCES = {
    'english': advisor_data_english,
    'hindi': advisor_data_hindi,
    'marathi': advisor_data_marathi,
}

CATEGORY_MAPPINGS = {
    'english': {
        'watering': 'watering',
        'fertilizer': 'fertilizer',
        'growth': 'growth',
    },
    'hindi': {
        'watering': 'पानी_प्रबंधन',
        'fertilizer': 'खाद_प्रबंधन',
        'growth': 'विकास_चरण',
    },
    'marathi': {
        'watering': 'पाणी_व्यवस्थापन',
        'fertilizer': 'खत_व्यवस्थापन',
        'growth': 'विकास_चरण',
    },
}

class AdvisoryHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path
        params = parse_qs(parsed.query)
        
        # CORS headers
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.end_headers()
        
        if path == '/api/v1/advisories/fetch':
            crop = params.get('crop', [''])[0].lower()
            category = params.get('category', [''])[0].lower()
            language = params.get('language', ['english'])[0].lower()
            
            if not crop or not category:
                response = {'success': False, 'error': 'Missing parameters'}
                self.wfile.write(json.dumps(response).encode())
                return
            
            if language not in DATA_SOURCES:
                response = {'success': False, 'error': 'Invalid language'}
                self.wfile.write(json.dumps(response).encode())
                return
            
            data = DATA_SOURCES[language]
            
            # Find crop
            crop_key = None
            for key in data.keys():
                if key.lower() == crop:
                    crop_key = key
                    break
            
            if not crop_key:
                response = {'success': False, 'error': f'Crop not found: {crop}', 'available': list(data.keys())[:5]}
                self.wfile.write(json.dumps(response).encode())
                return
            
            # Map category
            mapped_cat = CATEGORY_MAPPINGS[language].get(category)
            if not mapped_cat or mapped_cat not in data[crop_key]:
                response = {'success': False, 'error': f'Category not found: {category}'}
                self.wfile.write(json.dumps(response).encode())
                return
            
            advisory = data[crop_key][mapped_cat]
            response = {
                'success': True,
                'crop': crop_key,
                'category': mapped_cat,
                'language': language,
                'advisory': advisory,
            }
            self.wfile.write(json.dumps(response).encode())
        else:
            response = {'error': 'Not found'}
            self.wfile.write(json.dumps(response).encode())
    
    def log_message(self, format, *args):
        print(f"[{self.client_address[0]}] {format%args}")

if __name__ == '__main__':
    server = HTTPServer(('0.0.0.0', 5000), AdvisoryHandler)
    print("🚀 Advisory server running on http://0.0.0.0:5000")
    print("Test: http://localhost:5000/api/v1/advisories/fetch?crop=rice&category=watering&language=english")
    server.serve_forever()

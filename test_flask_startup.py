#!/usr/bin/env python
"""Test Flask app startup"""
import sys
print("Python version:", sys.version)
print("Starting Flask import test...")

try:
    from flask import Flask, jsonify
    from flask_cors import CORS
    print("✓ Flask imported")
    
    from advisor_data import advisor_data
    from advisort_hindi import advisort_hindi
    print("✓ Data files imported")
    
    app = Flask(__name__)
    CORS(app)
    print("✓ Flask app created")
    
    # Test that a basic request works
    with app.test_client() as client:
        response = client.get('/api/v1/advisories/crops?language=hindi')
        print(f"✓ Test request returned: {response.status_code}")
    
    print("✓ All tests passed - Flask is working!")
    
except Exception as e:
    print(f"✗ Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

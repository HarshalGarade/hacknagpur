#!/usr/bin/env python
"""Test Hindi advisory API after waiting for backend"""
import time
import requests
import sys

# Wait for backend to start
print("Waiting for backend to start...")
for i in range(10):
    try:
        r = requests.get('http://localhost:5000/health', timeout=1)
        if r.status_code == 200:
            print("✓ Backend is ready!\n")
            break
    except:
        pass
    time.sleep(1)
else:
    print("✗ Backend did not start in time")
    sys.exit(1)

print("Testing Hindi Advisory System")
print("="*70)

tests = [
    ("Rice + Watering + Hindi", {'crop': 'rice', 'category': 'watering', 'language': 'hindi'}),
    ("Rice + Fertilizer + Hindi", {'crop': 'rice', 'category': 'fertilizer', 'language': 'hindi'}),
    ("Rice + Growth + Hindi", {'crop': 'rice', 'category': 'growth', 'language': 'hindi'}),
    ("Wheat + Watering + Hindi", {'crop': 'wheat', 'category': 'watering', 'language': 'hindi'}),
    ("Wheat + Fertilizer + Hindi", {'crop': 'wheat', 'category': 'fertilizer', 'language': 'hindi'}),
    ("Wheat + Growth + Hindi", {'crop': 'wheat', 'category': 'growth', 'language': 'hindi'}),
]

success_count = 0
for test_name, params in tests:
    try:
        url = 'http://localhost:5000/api/v1/advisories/fetch'
        r = requests.get(url, params=params, timeout=5)
        data = r.json()
        
        if data.get('success'):
            print(f"✓ {test_name}")
            print(f"  Crop: {data.get('crop_name')} | Category: {data.get('category')}")
            print(f"  Advisory length: {data.get('character_count')} characters")
            success_count += 1
        else:
            print(f"✗ {test_name}")
            print(f"  Error: {data.get('error')}")
    except Exception as e:
        print(f"✗ {test_name}")
        print(f"  Exception: {e}")

print("\n" + "="*70)
print(f"Results: {success_count}/{len(tests)} tests passed")

if success_count == len(tests):
    print("✓ ALL TESTS PASSED - Hindi advisories are working!")
    sys.exit(0)
else:
    print("✗ Some tests failed")
    sys.exit(1)

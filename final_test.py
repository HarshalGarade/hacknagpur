#!/usr/bin/env python3
"""
Complete end-to-end test for Hindi advisory system
"""
import requests
import json

print("\n" + "="*80)
print("TESTING HINDI ADVISORY SYSTEM - END-TO-END")
print("="*80 + "\n")

# Test 1: Check backend is running
print("1️⃣  Testing Backend Health...")
try:
    response = requests.get("http://localhost:5000/health", timeout=5)
    if response.status_code == 200:
        print("   ✅ Backend is running and healthy\n")
    else:
        print(f"   ❌ Backend returned status {response.status_code}\n")
except Exception as e:
    print(f"   ❌ Backend not running: {e}\n")
    exit(1)

# Test 2: Get available Hindi crops
print("2️⃣  Getting available Hindi crops...")
try:
    response = requests.get("http://localhost:5000/api/v1/advisories/crops?language=hindi", timeout=5)
    data = response.json()
    if data.get('success'):
        crops = data.get('crops', [])
        print(f"   ✅ Found {len(crops)} Hindi crops")
        print(f"   Crops: {crops[:5]}... (showing first 5)\n")
    else:
        print(f"   ❌ Error: {data.get('error')}\n")
except Exception as e:
    print(f"   ❌ Error: {e}\n")

# Test 3: Test each category for rice in Hindi
print("3️⃣  Testing all three advisory categories for Rice in Hindi...\n")

categories = ['watering', 'fertilizer', 'growth']
category_names = {
    'watering': 'पानी प्रबंधन',
    'fertilizer': 'खाद प्रबंधन', 
    'growth': 'विकास चरण'
}

all_success = True
for category in categories:
    url = f"http://localhost:5000/api/v1/advisories/fetch?crop=rice&category={category}&language=hindi"
    try:
        response = requests.get(url, timeout=5)
        data = response.json()
        
        if data.get('success'):
            advisory_len = len(data.get('advisory', ''))
            print(f"   ✅ {category_names[category]}")
            print(f"      - Advisory received: {advisory_len} characters")
            print(f"      - Crop: {data.get('crop_name')}")
            print(f"      - Category: {data.get('category')}\n")
        else:
            print(f"   ❌ {category_names[category]}")
            print(f"      - Error: {data.get('error')}\n")
            all_success = False
    except Exception as e:
        print(f"   ❌ {category_names[category]}")
        print(f"      - Connection error: {e}\n")
        all_success = False

# Test 4: Test wheat in Hindi
print("4️⃣  Testing all three advisory categories for Wheat in Hindi...\n")

for category in categories:
    url = f"http://localhost:5000/api/v1/advisories/fetch?crop=wheat&category={category}&language=hindi"
    try:
        response = requests.get(url, timeout=5)
        data = response.json()
        
        if data.get('success'):
            advisory_len = len(data.get('advisory', ''))
            print(f"   ✅ {category_names[category]}")
            print(f"      - Advisory received: {advisory_len} characters\n")
        else:
            print(f"   ❌ {category_names[category]}")
            print(f"      - Error: {data.get('error')}\n")
            all_success = False
    except Exception as e:
        print(f"   ❌ {category_names[category]}")
        print(f"      - Connection error: {e}\n")
        all_success = False

# Final result
print("="*80)
if all_success:
    print("✅ ALL TESTS PASSED! Hindi advisories are working correctly!")
else:
    print("❌ Some tests failed. Check the output above.")
print("="*80 + "\n")

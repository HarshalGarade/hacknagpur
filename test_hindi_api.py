#!/usr/bin/env python
import requests
import time

# Wait for backend to be ready
time.sleep(2)

print("Testing backend API for Hindi advisories...")
print("="*60)

try:
    # Test 1: Health check
    print("\n1. Health Check:")
    r = requests.get('http://localhost:5000/health', timeout=5)
    print(f"   Status: {r.status_code}")
    print(f"   Response: {r.json()}")
    
    # Test 2: Get Hindi crops
    print("\n2. Get Hindi crops:")
    r = requests.get('http://localhost:5000/api/v1/advisories/crops?language=hindi', timeout=5)
    data = r.json()
    print(f"   Status: {r.status_code}")
    print(f"   Total crops: {data.get('total')}")
    print(f"   First 5 crops: {data.get('crops')[:5]}")
    
    # Test 3: Fetch rice (चावल) watering advisory in Hindi
    print("\n3. Fetch Rice (चावल) Watering Advisory in Hindi:")
    r = requests.get('http://localhost:5000/api/v1/advisories/fetch?crop=rice&category=watering&language=hindi', timeout=5)
    data = r.json()
    print(f"   Status: {r.status_code}")
    print(f"   Success: {data.get('success')}")
    if data.get('success'):
        print(f"   Crop name: {data.get('crop_name')}")
        print(f"   Category: {data.get('category')}")
        print(f"   Advisory length: {data.get('character_count')} characters")
        print(f"   First 100 chars: {data.get('advisory', '')[:100]}...")
    else:
        print(f"   Error: {data.get('error')}")
        print(f"   Available crops: {data.get('available_crops')}")
    
    # Test 4: Fetch wheat (गेहूँ) fertilizer advisory in Hindi
    print("\n4. Fetch Wheat (गेहूँ) Fertilizer Advisory in Hindi:")
    r = requests.get('http://localhost:5000/api/v1/advisories/fetch?crop=wheat&category=fertilizer&language=hindi', timeout=5)
    data = r.json()
    print(f"   Status: {r.status_code}")
    print(f"   Success: {data.get('success')}")
    if data.get('success'):
        print(f"   Crop name: {data.get('crop_name')}")
        print(f"   Category: {data.get('category')}")
        print(f"   Advisory length: {data.get('character_count')} characters")
    else:
        print(f"   Error: {data.get('error')}")
    
    # Test 5: Fetch maize growth advisory in Hindi
    print("\n5. Fetch Maize (मक्का) Growth Advisory in Hindi:")
    r = requests.get('http://localhost:5000/api/v1/advisories/fetch?crop=maize&category=growth&language=hindi', timeout=5)
    data = r.json()
    print(f"   Status: {r.status_code}")
    print(f"   Success: {data.get('success')}")
    if data.get('success'):
        print(f"   Crop name: {data.get('crop_name')}")
        print(f"   Category: {data.get('category')}")
        print(f"   Advisory length: {data.get('character_count')} characters")
    else:
        print(f"   Error: {data.get('error')}")
    
    print("\n" + "="*60)
    print("✓ All tests completed!")
    
except requests.exceptions.ConnectionError as e:
    print(f"\n✗ Connection Error: {e}")
    print("   Backend may not be running on localhost:5000")
except Exception as e:
    print(f"\n✗ Error: {e}")

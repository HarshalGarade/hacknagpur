#!/usr/bin/env python3
"""
Final verification test for Hindi advisory system
"""
import requests
import sys

print("\n" + "="*80)
print("FINAL VERIFICATION - HINDI ADVISORY SYSTEM")
print("="*80 + "\n")

# Test backend
print("1. Testing backend at http://192.168.1.37:5000...")
try:
    response = requests.get("http://192.168.1.37:5000/health", timeout=5)
    if response.status_code == 200:
        print("   ✅ Backend is accessible\n")
    else:
        print(f"   ❌ Backend returned {response.status_code}\n")
        sys.exit(1)
except Exception as e:
    print(f"   ❌ Cannot reach backend: {e}\n")
    sys.exit(1)

# Test all three categories for Rice
print("2. Testing Rice (चावल) with all categories in Hindi:\n")

categories = {
    'watering': 'पानी_प्रबंधन',
    'fertilizer': 'खाद_प्रबंधन',
    'growth': 'विकास_चरण'
}

all_passed = True
for eng_cat, hindi_cat in categories.items():
    url = f"http://192.168.1.37:5000/api/v1/advisories/fetch?crop=rice&category={eng_cat}&language=hindi"
    try:
        response = requests.get(url, timeout=5)
        data = response.json()
        
        if data.get('success'):
            length = len(data.get('advisory', ''))
            print(f"   ✅ {hindi_cat}: {length} characters")
        else:
            print(f"   ❌ {hindi_cat}: {data.get('error')}")
            all_passed = False
    except Exception as e:
        print(f"   ❌ {hindi_cat}: {e}")
        all_passed = False

# Test all three categories for Wheat
print("\n3. Testing Wheat (गेहूँ) with all categories in Hindi:\n")

for eng_cat, hindi_cat in categories.items():
    url = f"http://192.168.1.37:5000/api/v1/advisories/fetch?crop=wheat&category={eng_cat}&language=hindi"
    try:
        response = requests.get(url, timeout=5)
        data = response.json()
        
        if data.get('success'):
            length = len(data.get('advisory', ''))
            print(f"   ✅ {hindi_cat}: {length} characters")
        else:
            print(f"   ❌ {hindi_cat}: {data.get('error')}")
            all_passed = False
    except Exception as e:
        print(f"   ❌ {hindi_cat}: {e}")
        all_passed = False

print("\n" + "="*80)
if all_passed:
    print("✅ ALL TESTS PASSED!")
    print("\nNext steps:")
    print("1. Go to the Flutter app in Chrome")
    print("2. Select 'Manual Crop Search'")
    print("3. Click the language dropdown and select 'हिंदी' (Hindi)")
    print("4. Search for any crop (e.g., 'rice' or 'चावल')")
    print("5. Click on the crop")
    print("6. You should now see all three Hindi advisory categories!")
else:
    print("❌ Some tests failed")
    sys.exit(1)
print("="*80 + "\n")

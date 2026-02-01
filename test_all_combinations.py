import requests
import json

# Test different crops and categories in Hindi
test_cases = [
    ('rice', 'watering', 'hindi'),
    ('wheat', 'watering', 'hindi'),
    ('rice', 'fertilizer', 'hindi'),
    ('wheat', 'fertilizer', 'hindi'),
    ('rice', 'growth', 'hindi'),
    ('wheat', 'growth', 'hindi'),
]

print("Testing all crop + category combinations in Hindi:\n")
print("=" * 80)

for crop, category, language in test_cases:
    url = f"http://localhost:5000/api/v1/advisories/fetch?crop={crop}&category={category}&language={language}"
    print(f"\n📍 Testing: crop={crop}, category={category}, language={language}")
    print(f"   URL: {url}")
    
    try:
        response = requests.get(url, timeout=5)
        data = response.json()
        
        if data.get('success'):
            advisory_len = len(data.get('advisory', ''))
            print(f"   ✅ SUCCESS - Advisory length: {advisory_len} chars")
            print(f"      Crop name in response: {data.get('crop_name')}")
            print(f"      Category in response: {data.get('category')}")
        else:
            print(f"   ❌ FAILED - Error: {data.get('error')}")
            if data.get('available_crops'):
                print(f"      Available crops in {language}: {data.get('available_crops')}")
            if data.get('available_categories'):
                print(f"      Available categories: {data.get('available_categories')}")
    except Exception as e:
        print(f"   ❌ CONNECTION ERROR: {e}")

print("\n" + "=" * 80)

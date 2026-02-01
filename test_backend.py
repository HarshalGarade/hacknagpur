import requests
import json

# Test English
print("Testing English:")
url = "http://localhost:5000/api/v1/advisories/fetch?crop=rice&category=watering&language=english"
try:
    response = requests.get(url)
    data = response.json()
    print(f"  Status: {response.status_code}")
    print(f"  Success: {data.get('success')}")
    if data.get('success'):
        print(f"  Crop: {data.get('crop_name')}")
        print(f"  Advisory length: {len(data.get('advisory', ''))}")
    else:
        print(f"  Error: {data.get('error')}")
except Exception as e:
    print(f"  Error: {e}")

# Test Hindi
print("\nTesting Hindi:")
url = "http://localhost:5000/api/v1/advisories/fetch?crop=rice&category=watering&language=hindi"
try:
    response = requests.get(url)
    data = response.json()
    print(f"  Status: {response.status_code}")
    print(f"  Success: {data.get('success')}")
    if data.get('success'):
        print(f"  Crop: {data.get('crop_name')}")
        print(f"  Advisory length: {len(data.get('advisory', ''))}")
    else:
        print(f"  Error: {data.get('error')}")
except Exception as e:
    print(f"  Error: {e}")

# Test Hindi with wheat
print("\nTesting Hindi Wheat:")
url = "http://localhost:5000/api/v1/advisories/fetch?crop=wheat&category=watering&language=hindi"
try:
    response = requests.get(url)
    data = response.json()
    print(f"  Status: {response.status_code}")
    print(f"  Success: {data.get('success')}")
    if data.get('success'):
        print(f"  Crop: {data.get('crop_name')}")
        print(f"  Advisory length: {len(data.get('advisory', ''))}")
    else:
        print(f"  Error: {data.get('error')}")
except Exception as e:
    print(f"  Error: {e}")

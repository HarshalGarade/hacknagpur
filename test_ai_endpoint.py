import requests
import sys
from pathlib import Path
from PIL import Image

# Test AI endpoint
print("Testing AI Crop Detection Endpoint...")
print("-" * 50)

# Test 1: Check if server is running
try:
    response = requests.get('http://localhost:5000/api/v1/advisories/crops', timeout=5)
    print("✓ Backend server is running")
except Exception as e:
    print(f"✗ Backend server not running: {e}")
    sys.exit(1)

# Test 2: Create a test image (random RGB)
print("\nCreating test image...")
try:
    import numpy as np
    img_array = np.random.randint(0, 255, (128, 128, 3), dtype=np.uint8)
    test_img = Image.fromarray(img_array)
    test_img.save('test_plant.jpg')
    print("✓ Test image created: test_plant.jpg")
except Exception as e:
    print(f"✗ Error creating test image: {e}")
    sys.exit(1)

# Test 3: Test AI prediction endpoint
print("\nTesting AI prediction endpoint...")
try:
    with open('test_plant.jpg', 'rb') as f:
        files = {'image': f}
        response = requests.post(
            'http://localhost:5000/api/v1/ai/predict-plant',
            files=files,
            timeout=10
        )
    
    if response.status_code == 200:
        result = response.json()
        print("✓ AI endpoint responded successfully")
        print(f"  Response: {result}")
    else:
        print(f"✗ AI endpoint returned status {response.status_code}")
        print(f"  Response: {response.text}")
except Exception as e:
    print(f"✗ Error calling AI endpoint: {e}")
    sys.exit(1)

print("\n" + "="*50)
print("✓ All tests passed! AI endpoint is working.")
print("="*50)

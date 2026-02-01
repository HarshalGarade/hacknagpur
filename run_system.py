#!/usr/bin/env python
"""
Quick start script - Start backend and show Flutter instructions
"""
import subprocess
import time
import requests
import sys
import os

print("\n" + "="*70)
print("KRISHISETU - HINDI ADVISORY SYSTEM")
print("="*70 + "\n")

# Change to directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Start backend
print("[1] Starting backend server...")
backend_process = subprocess.Popen([sys.executable, 'advisory_backend.py'])

# Wait and test
print("[2] Waiting for backend to start...", end="", flush=True)
backend_ready = False
for i in range(15):
    try:
        response = requests.get('http://localhost:5000/health', timeout=1)
        if response.status_code == 200:
            backend_ready = True
            print(f" ✓ (Ready in {i+1}s)")
            break
    except:
        pass
    print(".", end="", flush=True)
    time.sleep(1)

if not backend_ready:
    print(" ✗ FAILED")
    print("ERROR: Backend did not start. Check console for errors.")
    backend_process.terminate()
    sys.exit(1)

# Verify Hindi data
print("[3] Testing Hindi advisory retrieval...", end="", flush=True)
try:
    response = requests.get(
        'http://localhost:5000/api/v1/advisories/fetch',
        params={'crop': 'rice', 'category': 'watering', 'language': 'hindi'},
        timeout=5
    )
    if response.status_code == 200 and response.json().get('success'):
        print(" ✓")
    else:
        print(" ✗")
        print("ERROR: Backend returned error:", response.json())
except Exception as e:
    print(f" ✗ (Error: {e})")

print("\n" + "="*70)
print("READY TO USE!")
print("="*70)
print("\nNow do the following in ANOTHER terminal window:\n")
print("  1. Navigate to the hacknagpur directory")
print("  2. Run: flutter run -d chrome")
print("\nOR:\n")
print("  1. Open the Flutter app in Chrome (should already be running)")
print("  2. Press 'r' in the Flutter terminal to reload")
print("\nThen test:\n")
print("  1. Select 'Manual Crop Search'")
print("  2. Choose Language: Hindi")
print("  3. Select a crop (e.g., Rice/चावल, Wheat/गेहूँ)")
print("  4. Click advisory categories:")
print("     - पानी प्रबंधन (Water Management)")
print("     - खाद_प्रबंधन (Fertilizer Management)")
print("     - विकास_चरण (Growth Stages)")
print("\nBackend is running on:")
print("  - Local:  http://localhost:5000")
print("  - Network: http://192.168.1.37:5000")
print("\nPress CTRL+C to stop the backend\n")
print("="*70 + "\n")

try:
    backend_process.wait()
except KeyboardInterrupt:
    print("\n\nShutting down backend...")
    backend_process.terminate()
    backend_process.wait(timeout=5)
    print("Backend stopped.")

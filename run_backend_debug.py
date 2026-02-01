#!/usr/bin/env python
"""Debug wrapper for advisory_backend.py"""
import sys
import os

print("=" * 70)
print("BACKEND DIAGNOSTICS")
print("=" * 70)

# Check Python version
print(f"\nPython: {sys.version}")

# Check imports
print("\nChecking imports...")
try:
    from flask import Flask
    print("✓ Flask")
except ImportError as e:
    print(f"✗ Flask: {e}")
    sys.exit(1)

try:
    from flask_cors import CORS
    print("✓ Flask-CORS")
except ImportError as e:
    print(f"✗ Flask-CORS: {e}")
    sys.exit(1)

try:
    from advisor_data import advisor_data
    print(f"✓ English data ({len(advisor_data)} crops)")
except ImportError as e:
    print(f"✗ English data: {e}")
    sys.exit(1)

try:
    from advisort_hindi import advisort_hindi
    print(f"✓ Hindi data ({len(advisort_hindi)} crops)")
except ImportError as e:
    print(f"✗ Hindi data: {e}")
    sys.exit(1)

print("\nAll imports OK!")
print("\n" + "=" * 70)
print("Starting Flask app...")
print("=" * 70)

# Now run the backend
try:
    with open('advisory_backend.py', 'r', encoding='utf-8') as f:
        exec(f.read())
except KeyboardInterrupt:
    print("\n\nBackend interrupted by user")
except Exception as e:
    print(f"\n\nFATAL ERROR: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

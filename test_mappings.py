from advisor_data import advisor_data
from advisort_hindi import advisort_hindi

print("English crops:", list(advisor_data.keys()))
print("\nHindi crops:", list(advisort_hindi.keys()))

# Check if genu mappings work
test_crops = ['rice', 'wheat', 'maize', 'bajra', 'jowar']
print("\nTesting mappings:")
for crop in test_crops:
    if crop in advisor_data:
        print(f"  ✓ English '{crop}' found")
    else:
        print(f"  ✗ English '{crop}' NOT found")

# Map English to Hindi
mappings = {
    'rice': 'चावल', 'wheat': 'गेहूँ', 'maize': 'मक्का', 'bajra': 'बाजरा',
    'jowar': 'ज्वार', 'ragi': 'रागी', 'barley': 'जौ', 'gram': 'चना',
}

print("\nHindi mappings:")
for eng, hindi in mappings.items():
    if hindi in advisort_hindi:
        print(f"  ✓ {eng} -> {hindi} found in Hindi data")
    else:
        print(f"  ✗ {eng} -> {hindi} NOT found in Hindi data")

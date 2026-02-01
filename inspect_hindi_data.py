from advisort_hindi import advisort_hindi

print("Hindi Advisory Data Structure Analysis")
print("="*80)

# Check a specific crop to see what categories it has
test_crop = "गेहूँ"  # Wheat in Hindi

if test_crop in advisort_hindi:
    print(f"\n✅ Found crop: {test_crop}")
    categories = list(advisort_hindi[test_crop].keys())
    print(f"   Categories available: {categories}")
    print(f"   Number of categories: {len(categories)}\n")
    
    for cat in categories:
        advisory_text = advisort_hindi[test_crop][cat]
        print(f"   📌 {cat}: {len(advisory_text)} characters")
else:
    print(f"\n❌ Crop '{test_crop}' not found in Hindi data")

# Show all crops and their categories
print("\n" + "="*80)
print("All Hindi crops with their categories:\n")

for crop in sorted(advisort_hindi.keys()):
    categories = list(advisort_hindi[crop].keys())
    print(f"• {crop}")
    for cat in categories:
        print(f"  - {cat}")

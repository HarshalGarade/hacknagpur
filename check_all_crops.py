from advisor_data import advisor_data
from advisort_hindi import advisort_hindi

# Complete mapping needed
english_crops = list(advisor_data.keys())
hindi_crops = list(advisort_hindi.keys())

print(f"English crops ({len(english_crops)}): {english_crops}")
print(f"\nHindi crops ({len(hindi_crops)}): {hindi_crops}")

# Try to match them
print("\nMatching status:")
for eng in english_crops:
    found = False
    for hindi in hindi_crops:
        # Check if there's a logical match
        if eng == 'moong' and hindi == 'मूग':
            found = True
        elif eng == 'urad' and hindi == 'उड़द':
            found = True
        elif eng == 'lentil' and hindi == 'मसूर':
            found = True
        elif eng == 'sugarcane' and hindi == 'ऊस':
            found = True
        elif eng == 'cotton' and hindi == 'कापूस':
            found = True
        elif eng == 'jute' and hindi == 'ताग':
            found = True
        elif eng == 'groundnut' and hindi == 'भुईमूग':
            found = True
        elif eng == 'soybean' and hindi == 'सोयाबीन':
            found = True
        elif eng == 'mustard' and hindi == 'सरसों':
            found = True
        elif eng == 'tea' and hindi == 'चाय':
            found = True
        elif eng == 'potato' and hindi == 'आलू':
            found = True
        elif eng == 'banana' and hindi == 'केला':
            found = True
        elif eng == 'mango' and hindi == 'आम':
            found = True
        elif eng == 'apple' and hindi == 'सेब':
            found = True
        elif eng == 'orange' and hindi == 'संतरा':
            found = True
        elif eng == 'grapes' and hindi == 'अंगूर':
            found = True
        elif eng == 'tomato' and hindi == 'टमाटर':
            found = True
        elif eng == 'onion' and hindi == 'प्याज़':
            found = True
        elif eng == 'brinjal' and hindi == 'बैंगन':
            found = True
        elif eng == 'cabbage' and hindi == 'पत्ता_गोभी':
            found = True
        elif eng == 'cauliflower' and hindi == 'फूलगोभी':
            found = True
        elif eng == 'tur' and hindi == 'अरहर':
            found = True
        elif eng == 'rice' and hindi == 'चावल':
            found = True
        elif eng == 'wheat' and hindi == 'गेहूँ':
            found = True
        elif eng == 'maize' and hindi == 'मक्का':
            found = True
        elif eng == 'bajra' and hindi == 'बाजरा':
            found = True
        elif eng == 'jowar' and hindi == 'ज्वार':
            found = True
        elif eng == 'ragi' and hindi == 'रागी':
            found = True
        elif eng == 'barley' and hindi == 'जौ':
            found = True
        elif eng == 'gram' and hindi == 'चना':
            found = True
    
    status = "✓" if found else "✗"
    print(f"  {status} {eng}")

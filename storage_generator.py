"""
Generate comprehensive storage advisories for all crops
"""

def get_storage_advisory(crop_name, storage_months, language='en'):
    """Generate storage advisory based on shelf life"""
    
    if language == 'en':
        if storage_months == 0:
            shelf_msg = "Perishable - Use Fresh"
            duration = "1-2 weeks"
        elif storage_months <= 2:
            shelf_msg = "Short Storage Life"
            duration = f"{storage_months} month(s)"
        elif storage_months <= 4:
            shelf_msg = "Medium Storage Life"
            duration = f"{storage_months} months"
        else:
            shelf_msg = "Long Storage Life"
            duration = f"{storage_months} months"
        
        advisory = f"""📦 {crop_name.capitalize()} Storage Guide ({storage_months} months)

🌾 **Shelf Life:** {duration}
**Category:** {shelf_msg}

**Before Storage:**
• Dry completely (10-14% moisture)
• Remove damaged/diseased produce
• Clean and sort carefully
• Cool to room temperature

**Storage Conditions:**
• Temperature: 10-20°C (ideal)
• Humidity: 40-60%
• Cool, dry, well-ventilated place
• Never in direct sunlight
• Keep away from damp areas

**Storage Methods:**

1️⃣ **Sealed Containers** ⭐ BEST (Extends life by 50%)
   • Use airtight containers
   • Reduces pest damage
   • Maintains quality longest
   • Best for this crop

2️⃣ **Regular Bags**
   • On wooden platforms
   • Covered with cloth
   • Check every 2-3 weeks
   • Works for {storage_months//2} months+

3️⃣ **Bulk Storage**
   • In bins or heaps
   • Covered properly
   • Ventilation important
   • Traditional method

**Prevention Tips:**
• Keep storage area clean
• Remove all dust first
• Use natural repellents (neem, chili)
• Check monthly for pests
• Never mix with chemicals

**Monthly Checks:**
✅ No musty smell
✅ Grain feels dry
✅ No visible insects
✅ No mold/discoloration
✅ Temperature stable

**When to Use/Discard:**
• Best used within {storage_months} months
• Check before cooking
• Discard if moldy
• Don't keep beyond shelf life
• Quality decreases over time

**Pro Tips:**
💡 Store in cool months
💡 Keep away from cooking area
💡 Separate from other crops
💡 Use labels with dates
💡 Rotate old stock first"""
        
        return advisory
    
    return f"Storage advisory for {crop_name}"


# Test with some crops
if __name__ == "__main__":
    crops = {
        "maize": 8,
        "bajra": 7,
        "tomato": 0,
        "potato": 4,
        "orange": 3,
    }
    
    for crop, months in crops.items():
        print(f"\n{crop.upper()} - {months} months")
        print("="*60)
        advisory = get_storage_advisory(crop, months, 'en')
        print(advisory[:300] + "...")

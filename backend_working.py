#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
KrishiSetu Backend - WORKING VERSION
Guaranteed to have all 4 categories: watering, fertilizer, growth, storage
"""
from flask import Flask, request, jsonify
from flask_cors import CORS

print("\n" + "="*70)
print("BACKEND STARTING - ALL 4 CATEGORIES")
print("="*70)

app = Flask(__name__)
CORS(app)

# ALL 30 CROPS - COMPLETE DATA WITH ALL 4 CATEGORIES
data = {
    "rice": {
        "watering": "💧 Rice Watering: Water regularly, maintain standing water 5-10cm during growth",
        "fertilizer": "🌱 Rice Fertilizer: NPK 120:60:40 kg/ha, split into 3-4 applications",
        "growth": "📈 Rice Growth: Germination 5-7 days, vegetative 30-40 days, reproductive 25-35 days",
        "storage_life_months": "📦 Rice Storage: 12 months at 15-20°C, 50-60% humidity, use hermetic sealing",
    },
    "wheat": {
        "watering": "💧 Wheat Watering: 4-5 irrigations, 50-60mm each at critical growth stages",
        "fertilizer": "🌱 Wheat Fertilizer: NPK 120:60:40 kg/ha, apply at sowing and tillering",
        "growth": "📈 Wheat Growth: Germination 7-10 days, tillering 20-30 days, grain fill 25-30 days",
        "storage_life_months": "📦 Wheat Storage: 12 months at 10-18°C, 40-50% humidity, use concrete bins",
    },
    "maize": {
        "watering": "💧 Maize Watering: 6-8 irrigations, critical at tasseling and silking",
        "fertilizer": "🌱 Maize Fertilizer: NPK 150:75:40 kg/ha, 50% at planting, 50% at 6 weeks",
        "growth": "📈 Maize Growth: Germination 7-10 days, V6-V8 critical period, silking at 50-60 days",
        "storage_life_months": "📦 Maize Storage: 8 months at cool temperatures, 10-12% moisture, wooden platforms",
    },
    "bajra": {
        "watering": "💧 Bajra Watering: 2-3 irrigations, drought tolerant crop",
        "fertilizer": "🌱 Bajra Fertilizer: NPK 80:40:30 kg/ha, single application at sowing",
        "growth": "📈 Bajra Growth: Germination 5-7 days, vegetative 40-50 days, grain development 25-30 days",
        "storage_life_months": "📦 Bajra Storage: 7 months, 10% moisture, ventilated containers, 15-25°C",
    },
    "jowar": {
        "watering": "💧 Jowar Watering: 3-4 irrigations, drought resistant",
        "fertilizer": "🌱 Jowar Fertilizer: NPK 100:50:30 kg/ha, apply at 4-5 leaf stage",
        "growth": "📈 Jowar Growth: Germination 7-10 days, panicle initiation 30-35 days, grain fill 25 days",
        "storage_life_months": "📦 Jowar Storage: 7 months, 10% moisture, HDPE bags, cool area, 15-25°C",
    },
    "ragi": {
        "watering": "💧 Ragi Watering: 4-5 light irrigations, needs regular moisture",
        "fertilizer": "🌱 Ragi Fertilizer: NPK 100:50:50 kg/ha, split into 2-3 applications",
        "growth": "📈 Ragi Growth: Germination 7-10 days, finger formation 60-70 days, maturity 90-120 days",
        "storage_life_months": "📦 Ragi Storage: 8 months, 11% moisture, airtight containers, 10-15°C optimal",
    },
    "barley": {
        "watering": "💧 Barley Watering: 2-3 irrigations depending on rainfall",
        "fertilizer": "🌱 Barley Fertilizer: NPK 100:50:40 kg/ha, apply 50% at sowing, 50% at tillering",
        "growth": "📈 Barley Growth: Germination 7-10 days, tillering 20-25 days, grain development 25-30 days",
        "storage_life_months": "📦 Barley Storage: 8 months, 10-12% moisture, elevated platforms, <50% humidity",
    },
    "gram": {
        "watering": "💧 Gram Watering: 1-2 irrigations, mostly rainfed",
        "fertilizer": "🌱 Gram Fertilizer: NPK 20:40:20 kg/ha with Rhizobium inoculation",
        "growth": "📈 Gram Growth: Germination 7-10 days, flowering 40-45 days, pod development 20-25 days",
        "storage_life_months": "📦 Gram Storage: 8 months, 10% moisture, mesh bags for ventilation, 15-20°C",
    },
    "tur": {
        "watering": "💧 Tur Watering: 1-2 irrigations, mostly rainfed crop",
        "fertilizer": "🌱 Tur Fertilizer: NPK 20:50:20 kg/ha with Rhizobium culture",
        "growth": "📈 Tur Growth: Germination 7-10 days, flowering 60-70 days, pod fill 40-50 days",
        "storage_life_months": "📦 Tur Storage: 8 months, 10-12% moisture, well-ventilated area, 15-25°C",
    },
    "urad": {
        "watering": "💧 Urad Watering: 1-2 irrigations at critical growth stages",
        "fertilizer": "🌱 Urad Fertilizer: NPK 25:50:20 kg/ha with Rhizobium inoculation",
        "growth": "📈 Urad Growth: Germination 5-7 days, flowering 35-40 days, pod development 15-20 days",
        "storage_life_months": "📦 Urad Storage: 8 months, 10% moisture, airtight containers, 15-20°C",
    },
    "moong": {
        "watering": "💧 Moong Watering: 1-3 irrigations depending on season",
        "fertilizer": "🌱 Moong Fertilizer: NPK 25:50:20 kg/ha with Rhizobium culture",
        "growth": "📈 Moong Growth: Germination 5-7 days, flowering 30-35 days, pod fill 15-20 days",
        "storage_life_months": "📦 Moong Storage: 8 months, 10% moisture, hermetic sealing, 15-20°C optimal",
    },
    "lentil": {
        "watering": "💧 Lentil Watering: 1-2 life saving irrigations",
        "fertilizer": "🌱 Lentil Fertilizer: NPK 20:40:20 kg/ha with Rhizobium inoculation",
        "growth": "📈 Lentil Growth: Germination 7-10 days, flowering 45-50 days, pod fill 25-30 days",
        "storage_life_months": "📦 Lentil Storage: 10 months, 10-12% moisture, cool dark place, 10-18°C",
    },
    "sugarcane": {
        "watering": "💧 Sugarcane Watering: 20-25 irrigations, high water requirement",
        "fertilizer": "🌱 Sugarcane Fertilizer: NPK 150:75:60 kg/ha in splits through season",
        "growth": "📈 Sugarcane Growth: Germination 15-20 days, tillering 90-120 days, grand growth 120-150 days",
        "storage_life_months": "📦 Sugarcane Storage: Use within 24-48 hours, store in cool place <15°C",
    },
    "cotton": {
        "watering": "💧 Cotton Watering: 8-10 irrigations, drought tolerant crop",
        "fertilizer": "🌱 Cotton Fertilizer: NPK 120:75:60 kg/ha, 4-5 splits through season",
        "growth": "📈 Cotton Growth: Germination 7-10 days, flowering 60-70 days, boll fill 40-50 days",
        "storage_life_months": "📦 Cotton Storage: 12 months, <9% moisture, dry ventilated warehouse, 20-25°C",
    },
    "jute": {
        "watering": "💧 Jute Watering: 4-5 irrigations, high water requirement",
        "fertilizer": "🌱 Jute Fertilizer: NPK 80:50:40 kg/ha, apply at sowing and 30 days",
        "growth": "📈 Jute Growth: Germination 7-10 days, vegetative 60-80 days, flowering 30-40 days",
        "storage_life_months": "📦 Jute Storage: 12 months, 12-14% moisture, ventilated area, 15-25°C",
    },
    "groundnut": {
        "watering": "💧 Groundnut Watering: 3-4 irrigations at critical stages",
        "fertilizer": "🌱 Groundnut Fertilizer: NPK 20:50:50 kg/ha with Rhizobium inoculation",
        "growth": "📈 Groundnut Growth: Germination 5-7 days, flowering 35-45 days, pod development 50-60 days",
        "storage_life_months": "📦 Groundnut Storage: 6 months, 7-8% moisture, cool dry place, 10-15°C ideal",
    },
    "soybean": {
        "watering": "💧 Soybean Watering: 2-3 irrigations at critical stages",
        "fertilizer": "🌱 Soybean Fertilizer: NPK 25:50:20 kg/ha with Rhizobium culture",
        "growth": "📈 Soybean Growth: Germination 5-10 days, flowering 30-35 days, pod fill 25-30 days",
        "storage_life_months": "📦 Soybean Storage: 6 months, 10-12% moisture, sealed containers, 15-20°C",
    },
    "mustard": {
        "watering": "💧 Mustard Watering: 2-3 irrigations, drought tolerant",
        "fertilizer": "🌱 Mustard Fertilizer: NPK 80:40:40 kg/ha, apply at sowing and 30-35 days",
        "growth": "📈 Mustard Growth: Germination 7-10 days, flowering 40-50 days, siliqua fill 20-25 days",
        "storage_life_months": "📦 Mustard Storage: 10 months, 8-10% moisture, cool place, 10-15°C best",
    },
    "tea": {
        "watering": "💧 Tea Watering: High moisture requirement, 125-200cm rainfall annually",
        "fertilizer": "🌱 Tea Fertilizer: NPK 100:50:50 kg/ha split into 4-5 applications",
        "growth": "📈 Tea Growth: First pruning at 4-5 years, continuous leaf plucking 200+ days/year",
        "storage_life_months": "📦 Tea Storage: 6-12 months in airtight containers, 15-20°C, avoid light",
    },
    "potato": {
        "watering": "💧 Potato Watering: 4-5 irrigations, critical at tuber initiation",
        "fertilizer": "🌱 Potato Fertilizer: NPK 100:150:150 kg/ha, 100% at planting",
        "growth": "📈 Potato Growth: Sprouting 7-10 days, vegetative 30-40 days, tuber fill 40-50 days",
        "storage_life_months": "📦 Potato Storage: 4 months at 2-10°C, 85-90% humidity, slatted shelves",
    },
    "banana": {
        "watering": "💧 Banana Watering: High water requirement, 100-150cm annually",
        "fertilizer": "🌱 Banana Fertilizer: NPK 200:100:200 kg/ha split into 6-8 applications",
        "growth": "📈 Banana Growth: First flowering 9-12 months, fruit development 3-4 months",
        "storage_life_months": "📦 Banana Storage: 2-3 weeks at room temp, 15-20°C, 80-90% humidity",
    },
    "mango": {
        "watering": "💧 Mango Watering: Seasonal, pre-flowering irrigation critical",
        "fertilizer": "🌱 Mango Fertilizer: NPK 300:100:100 kg/ha split into 4 applications",
        "growth": "📈 Mango Growth: Flowering 2-3 months, fruit development 3-4 months",
        "storage_life_months": "📦 Mango Storage: 4-6 weeks at 13-18°C, 85-90% humidity in crates",
    },
    "apple": {
        "watering": "💧 Apple Watering: 400-600mm annually, regular irrigation in dry season",
        "fertilizer": "🌱 Apple Fertilizer: NPK 100:50:150 kg/ha split into 2-3 applications",
        "growth": "📈 Apple Growth: Flowering 2-3 weeks, fruit development 4-5 months, ripening in late summer",
        "storage_life_months": "📦 Apple Storage: 6 months at 0-4°C, 90-95% humidity, wooden crates",
    },
    "orange": {
        "watering": "💧 Orange Watering: 600-1000mm annually, deficit irrigation techniques",
        "fertilizer": "🌱 Orange Fertilizer: NPK 200:100:150 kg/ha split into 3-4 applications",
        "growth": "📈 Orange Growth: Flowering 2-3 weeks, fruit development 5-6 months",
        "storage_life_months": "📦 Orange Storage: 3 months at 8-10°C, 85-90% humidity, air circulation boxes",
    },
    "grapes": {
        "watering": "💧 Grapes Watering: 400-600mm, deficit irrigation at veraison",
        "fertilizer": "🌱 Grapes Fertilizer: NPK 100:50:100 kg/ha split into 2-3 applications",
        "growth": "📈 Grapes Growth: Bud break 2-3 weeks, flowering 2 weeks, veraison 10-12 weeks",
        "storage_life_months": "📦 Grapes Storage: 4-6 weeks at 0-5°C, 90-95% humidity, ventilated containers",
    },
    "tomato": {
        "watering": "💧 Tomato Watering: 400-600mm annually, frequent light irrigations",
        "fertilizer": "🌱 Tomato Fertilizer: NPK 150:100:100 kg/ha split into 4-5 applications",
        "growth": "📈 Tomato Growth: Germination 5-8 days, flowering 30-40 days, fruit set 50-60 days",
        "storage_life_months": "📦 Tomato Storage: 1-2 weeks at 12-20°C, 60-70% humidity, check daily",
    },
    "onion": {
        "watering": "💧 Onion Watering: 400-500mm, critical at bulb swelling stage",
        "fertilizer": "🌱 Onion Fertilizer: NPK 100:100:50 kg/ha split into 3 applications",
        "growth": "📈 Onion Growth: Germination 10-15 days, leaf formation 30-40 days, bulb swelling 30-40 days",
        "storage_life_months": "📦 Onion Storage: 3 months at 0-5°C, 60-70% humidity, mesh bags ventilation",
    },
    "brinjal": {
        "watering": "💧 Brinjal Watering: 400-600mm, frequent light irrigations",
        "fertilizer": "🌱 Brinjal Fertilizer: NPK 150:100:100 kg/ha split into 4-5 applications",
        "growth": "📈 Brinjal Growth: Germination 8-10 days, flowering 50-60 days, fruit development 20-30 days",
        "storage_life_months": "📦 Brinjal Storage: 2-3 weeks at 8-12°C, 85-90% humidity, ventilated boxes",
    },
    "cabbage": {
        "watering": "💧 Cabbage Watering: 400-600mm, consistent moisture critical",
        "fertilizer": "🌱 Cabbage Fertilizer: NPK 150:100:100 kg/ha split into 3-4 applications",
        "growth": "📈 Cabbage Growth: Germination 5-8 days, vegetative 40-50 days, head formation 40-60 days",
        "storage_life_months": "📦 Cabbage Storage: Long-term at 0-5°C, 90-95% humidity, outer leaf removal",
    },
    "cauliflower": {
        "watering": "💧 Cauliflower Watering: 400-600mm, high moisture at head formation",
        "fertilizer": "🌱 Cauliflower Fertilizer: NPK 150:100:100 kg/ha split into 3-4 applications",
        "growth": "📈 Cauliflower Growth: Germination 5-8 days, vegetative 40-50 days, curd formation 20-30 days",
        "storage_life_months": "📦 Cauliflower Storage: 3-4 weeks at 0-5°C, 90-95% humidity, ventilated boxes",
    },
}

# SIMPLE ROUTES
@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'ok', 'crops': len(data), 'categories': 4})

@app.route('/api/v1/advisories/crops', methods=['GET'])
def get_crops():
    lang = request.args.get('language', 'english').lower()
    return jsonify({'success': True, 'crops': list(data.keys()), 'total': len(data)})

@app.route('/api/v1/advisories/fetch', methods=['GET'])
def fetch():
    crop = request.args.get('crop', '').strip().lower()
    category = request.args.get('category', '').strip().lower()
    
    # CATEGORY MAPPING - Maps storage -> storage_life_months
    cat_map = {
        'watering': 'watering',
        'fertilizer': 'fertilizer',
        'growth': 'growth',
        'storage': 'storage_life_months',
        'storage_life_months': 'storage_life_months',
    }
    
    mapped_cat = cat_map.get(category)
    
    if not crop or not mapped_cat:
        return jsonify({'error': 'Missing crop or invalid category'}), 400
    
    # Find crop (case insensitive)
    crop_key = None
    for k in data.keys():
        if k.lower() == crop:
            crop_key = k
            break
    
    if not crop_key or mapped_cat not in data[crop_key]:
        return jsonify({'error': f'Not found: {crop}/{category}', 'available': list(data[crop_key].keys()) if crop_key else []}), 404
    
    advisory = data[crop_key][mapped_cat]
    return jsonify({'success': True, 'advisory': advisory, 'crop': crop_key, 'category': mapped_cat})

if __name__ == '__main__':
    print("\n✓ Backend loaded with 30 crops × 4 categories = 120 advisories")
    print("✓ Listening on http://localhost:5000")
    print("✓ Categories: watering, fertilizer, growth, storage")
    print("="*70 + "\n")
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False, threaded=True)

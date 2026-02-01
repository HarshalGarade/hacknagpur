# 🌾 KrishiSetu Offline-First Advisory System

## Overview
KrishiSetu is a complete offline-first crop advisory platform for Indian farmers with low connectivity. The system has three layers:

1. **Flutter Mobile App** - Works offline, syncs when online
2. **Python Backend** - Serves advisory data from local files
3. **Local SQLite Database** - Stores all data offline

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│         (Offline-First with Local SQLite Database)           │
├──────────────────────────────────────────────────────────────┤
│  • Dashboard with theme/language toggle                      │
│  • Advisory selection (Manual/Camera)                        │
│  • Local database (advisories, user prefs, sync metadata)    │
│  • Auto-sync when network available                          │
│  • Offline indicator + sync notifications                    │
└──────────────────────────────────────────────────────────────┘
                            ↕ (HTTP)
┌──────────────────────────────────────────────────────────────┐
│                    Python Flask Backend                      │
│          (Serves Data from advisory_data.py files)           │
├──────────────────────────────────────────────────────────────┤
│  • Load data from 3 Python files                             │
│  • REST API endpoints for advisories                         │
│  • Sync endpoint for farmer data                             │
│  • Multi-language support (EN/HI/MR)                         │
└──────────────────────────────────────────────────────────────┘
                            ↕ (File System)
┌──────────────────────────────────────────────────────────────┐
│               Python Advisory Data Files                     │
├──────────────────────────────────────────────────────────────┤
│  📄 advisor_data.py                      (English)           │
│  📄 advisort_hindi.py                     (Hindi)            │
│  📄 advisory_data_marathi (1).py          (Marathi)          │
│  📄 advisory.py                           (Metadata)         │
└──────────────────────────────────────────────────────────────┘
```

---

## Data Flow

### Offline Mode (No Internet)
1. User opens app → Loads cached data from SQLite
2. Selects crop + advisory type
3. Shows exact data from local database
4. App displays offline indicator

### Online Mode (Internet Available)
1. App detects internet connection (auto-detects)
2. Triggers sync service
3. Uploads unsynced farmer records to backend
4. Downloads latest advisories from backend
5. Stores in SQLite with `isSynced = true`
6. Shows sync status notification

---

## Implementation Guide

### Step 1: Run Flask Backend

```bash
cd c:\Users\Victus\Desktop\hacknagpur

# Install dependencies
pip install flask flask-cors python-dotenv

# Run backend
python advisory_backend.py
```

Backend will start at: `http://localhost:5000`

### Step 2: Update Flutter Backend URL

Edit `lib/services/advisory_data_service.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:5000';  // For local testing
// or
static const String apiBaseUrl = 'https://api.krishisetu.com';  // For production
```

### Step 3: Test API Endpoints

**Get available crops (English):**
```bash
curl "http://localhost:5000/api/v1/advisories/crops?language=english"
```

**Fetch specific advisory:**
```bash
curl "http://localhost:5000/api/v1/advisories/fetch?crop=rice&category=watering&language=english"
```

**Get all advisories (for offline sync):**
```bash
curl "http://localhost:5000/api/v1/advisories/all?language=english"
```

### Step 4: Run Flutter App

```bash
cd c:\Users\Victus\Desktop\hacknagpur\hacknagpur
flutter run -d chrome
```

---

## API Endpoints

### 1. Get Available Crops
```http
GET /api/v1/advisories/crops?language=english
```

**Response:**
```json
{
  "success": true,
  "language": "english",
  "crops": ["rice", "wheat", "maize", "cotton", "sugarcane"],
  "total": 30,
  "timestamp": "2026-01-31T10:30:00Z"
}
```

### 2. Fetch Crop Advisory
```http
GET /api/v1/advisories/fetch?crop=rice&category=watering&language=english
```

**Response:**
```json
{
  "success": true,
  "crop_name": "rice",
  "category": "watering",
  "language": "english",
  "advisory": "🌧️ **Rice Watering Guide...[EXACT TEXT FROM FILE]",
  "fetched_at": "2026-01-31T10:30:00Z"
}
```

### 3. Download All Advisories (for offline cache)
```http
GET /api/v1/advisories/all?language=english
```

**Response:**
```json
{
  "success": true,
  "language": "english",
  "advisories": {
    "rice": {
      "watering": "...",
      "fertilizer": "...",
      "growth": "..."
    },
    "wheat": { ... }
  },
  "total": 30
}
```

---

## Category Mappings

### English
- `watering` → watering advice
- `fertilizer` → fertilizer guide
- `growth` → growth stages

### Hindi
- `पानी_प्रबंधन` (Water Management) → water advice
- `खाद_प्रबंधन` (Fertilizer Management) → fertilizer guide
- `विकास_चरण` (Growth Stages) → growth info

### Marathi
- `पाणी_व्यवस्थापन` (Water Management) → water advice
- `खत_व्यवस्थापन` (Fertilizer Management) → fertilizer guide
- `विकास_चरण` (Growth Stages) → growth info

---

## Database Schema

### SQLite Tables

#### 1. advisories
```sql
CREATE TABLE advisories(
  id INTEGER PRIMARY KEY,
  cropId TEXT NOT NULL,
  cropName TEXT NOT NULL,
  advice TEXT NOT NULL,
  language TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT,
  isSynced INTEGER DEFAULT 0,  -- 1 = synced, 0 = pending
  UNIQUE(cropId, language)
)
```

#### 2. sync_metadata
```sql
CREATE TABLE sync_metadata(
  id INTEGER PRIMARY KEY,
  lastSyncTime TEXT,
  pendingCount INTEGER DEFAULT 0
)
```

#### 3. user_preferences
```sql
CREATE TABLE user_preferences(
  id INTEGER PRIMARY KEY,
  key TEXT UNIQUE NOT NULL,
  value TEXT NOT NULL
)
```

---

## Usage Examples

### Example 1: Get Rice Watering Advice (English)

**Flutter Code:**
```dart
final advisory = await _advisoryService.fetchAdvisory(
  cropName: 'rice',
  category: 'watering',
  language: 'english',
);

if (advisory != null) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(advisory.cropName),
      content: Text(advisory.advisoryText),
    ),
  );
}
```

### Example 2: Manual Sync

**Flutter Code:**
```dart
void _manualSync() async {
  final success = await _syncService.fullSync();
  
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ Data synced successfully!')),
    );
  }
}
```

### Example 3: Get All Crops (Hindi)

**cURL:**
```bash
curl "http://localhost:5000/api/v1/advisories/crops?language=hindi"
```

**Response:**
```json
{
  "success": true,
  "language": "hindi",
  "crops": ["गेहूँ", "चावल", "मक्का"],
  "total": 30
}
```

---

## File Locations

```
hacknagpur/
├── advisories/              ← Python advisory data
│   ├── advisor_data.py      ← English (30 crops)
│   ├── advisort_hindi.py    ← Hindi (30 crops)
│   ├── advisory_data_marathi (1).py ← Marathi (30 crops)
│   └── advisory_backend.py  ← Flask API Server
│
├── hacknagpur/              ← Flutter App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   │   ├── theme.dart
│   │   │   └── language.dart
│   │   ├── models/
│   │   │   ├── crop_model.dart
│   │   │   ├── advisory_model.dart
│   │   │   └── advisory_detail_model.dart
│   │   ├── services/
│   │   │   ├── database_service.dart      ← SQLite
│   │   │   ├── connectivity_service.dart  ← Network detection
│   │   │   ├── sync_service.dart          ← Data sync
│   │   │   └── advisory_data_service.dart ← Advisory fetching
│   │   ├── pages/
│   │   │   ├── dashboard_page.dart
│   │   │   ├── advisory_mode_selection_page.dart
│   │   │   ├── offline_crop_selection_page.dart
│   │   │   ├── online_photo_selection_page.dart
│   │   │   └── profile_page.dart
│   │   └── widgets/
│   └── pubspec.yaml
│
└── README.md
```

---

## Troubleshooting

### Backend not connecting
- Check if Flask is running: `http://localhost:5000/health`
- Verify firewall allows port 5000
- Check backend logs for errors

### Offline mode not working
- Ensure SQLite database is initialized
- Check device storage permissions
- Verify data was synced before going offline

### Sync not working
- Check internet connection
- Verify backend is reachable
- Check pending sync count: `SELECT COUNT(*) FROM advisories WHERE isSynced = 0`

### Data not found error
- Verify crop name matches dataset exactly
- Check language parameter is correct
- Confirm category mapping is correct

---

## Future Enhancements

- [ ] Push notifications when new advisories available
- [ ] Voice/TTS advisory reading
- [ ] Farmer feedback system
- [ ] Weather integration
- [ ] Pest detection with AI
- [ ] Marketplace for crop selling
- [ ] Community forum
- [ ] Video tutorials

---

## Support

For issues or questions:
1. Check API endpoint responses
2. Review logs in terminal
3. Verify data source files exist
4. Test with cURL before Flutter

---

**Built with ❤️ for Indian Farmers**

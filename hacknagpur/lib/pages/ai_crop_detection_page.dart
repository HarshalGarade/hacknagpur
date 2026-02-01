import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/pages/crop_advisory_page.dart';
import 'package:hacknagpur/models/crop_model.dart';

class AICropDetectionPage extends StatefulWidget {
  final AppLanguage currentLanguage;

  const AICropDetectionPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  State<AICropDetectionPage> createState() => _AICropDetectionPageState();
}

class _AICropDetectionPageState extends State<AICropDetectionPage> {
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _selectedImagePath;
  bool _isAnalyzing = false;
  String? _detectionResult;
  String? _detectedCrop;
  double? _confidence;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImagePath = pickedFile.path;
          _detectionResult = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImageBytes == null || _selectedImagePath == null) {
      setState(() {
        _errorMessage = 'Please select an image first';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:5000/api/v1/ai/predict-plant'),
      );

      // Add image file
      request.files.add(
        http.MultipartFile.fromBytes('image', _selectedImageBytes!, filename: _selectedImagePath),
      );

      // Send request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - server not responding');
        },
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            _detectionResult = data['message'];
            _detectedCrop = data['crop'];
            _confidence = data['confidence'];
            _isAnalyzing = false;
          });

          // Show success and navigate
          _showDetectionResult(data);
        } else {
          setState(() {
            _errorMessage = data['error'] ?? 'Detection failed';
            _isAnalyzing = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isAnalyzing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isAnalyzing = false;
      });
    }
  }

  void _showDetectionResult(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎯 Detection Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prediction: ${data['prediction']}'),
            const SizedBox(height: 8),
            Text('Crop: ${data['crop'].toString().toUpperCase()}'),
            const SizedBox(height: 8),
            Text('Confidence: ${data['confidence']}%'),
            const SizedBox(height: 8),
            Text('Status: ${data['disease']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAdvisory(data['crop']);
            },
            child: const Text('View Advisory'),
          ),
        ],
      ),
    );
  }

  void _navigateToAdvisory(String cropName) {
    // Map detected crop to Crop model
    final Crop? crop = _getCropFromName(cropName);
    if (crop != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropAdvisoryPage(
            crop: crop,
            currentLanguage: _getCurrentLanguageCode(),
            onLanguageChange: (lang) {},
          ),
        ),
      );
    }
  }

  Crop? _getCropFromName(String name) {
    // Find crop in CropData by matching id
    final cropName = name.toLowerCase();
    
    // Direct mapping of AI detected names to crop IDs
    final cropIdMap = {
      'apple': 'apple',
      'blueberry': 'apple',
      'cherry': 'apple',
      'corn': 'maize',
      'grape': 'grapes',
      'orange': 'orange',
      'peach': 'apple',
      'pepper': 'onion',
      'potato': 'potato',
      'raspberry': 'apple',
      'soybean': 'soybean',
      'squash': 'onion',
      'strawberry': 'apple',
      'tomato': 'tomato',
      'rice': 'rice',
      'wheat': 'wheat',
    };

    final cropId = cropIdMap[cropName] ?? cropName;
    
    // Find crop from CropData.crops list
    try {
      return CropData.crops.firstWhere((crop) => crop.id == cropId);
    } catch (e) {
      return null;
    }
  }

  String _getCurrentLanguageCode() {
    switch (widget.currentLanguage) {
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.marathi:
        return 'mr';
      default:
        return 'en';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤖 AI Crop Detection'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Image display
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(
                          _selectedImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No image selected',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('📷 Camera'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('📁 Gallery'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Analyze button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeImage,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.smart_toy),
                  label: Text(_isAnalyzing ? 'Analyzing...' : '🤖 Analyze with AI'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Results
              if (_detectionResult != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Detection Result:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(_detectionResult ?? ''),
                      if (_confidence != null) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _confidence! / 100,
                          minHeight: 8,
                        ),
                      ],
                    ],
                  ),
                ),

              // Errors
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '❌ Error:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 8),
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

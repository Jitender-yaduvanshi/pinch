import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageTakenProvider with ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List<String> _imagePaths = [];
  String _jsonDataText = '';
  String _extractedText = '';
  bool _isLoading = false;

  XFile? get image => _image;
  List<String> get imagePaths => _imagePaths;
  String get jsonDataText => _jsonDataText;
  String get extractedText => _extractedText;
  bool get isLoading => _isLoading;

  imageProvider() {
    _loadImagePaths();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final compressedImage = await _compressImage(image.path);
      _image = XFile(compressedImage);
      notifyListeners();
    }
  }

  Future<String> _compressImage(String path) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      '${path}_compressed.jpg',
      quality: 70,
    );
    return result!.path;
  }

  Future<void> saveImagePath(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    _imagePaths = prefs.getStringList('imagePaths') ?? [];
    _imagePaths.add(imagePath);
    await prefs.setStringList('imagePaths', _imagePaths);
    notifyListeners();
  }

  Future<void> _loadImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    _imagePaths = prefs.getStringList('imagePaths') ?? [];
    notifyListeners();
  }

  Future<void> imageDecode(String imagePath) async {
    _isLoading = true;
    notifyListeners();

    var headers = {'apikey': 'K87230218288957'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.ocr.space/parse/image'));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);
        _jsonDataText = responseBody;
        _extractedText = jsonData['ParsedResults'] != null &&
                jsonData['ParsedResults'].isNotEmpty
            ? jsonData['ParsedResults'][0]['ParsedText'] ?? 'No text found'
            : 'No OCR result found';
      } else {
        _jsonDataText = 'Error: ${response.reasonPhrase}';
        _extractedText = 'Error extracting text';
      }
    } catch (e) {
      _jsonDataText = 'Exception: $e';
      _extractedText = 'Error extracting text';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../models/passport_standard.dart';

class PassportProvider extends ChangeNotifier {
  Uint8List? _originalImageBytes;
  Uint8List? _processedImageBytes;
  PassportStandard? _selectedStandard;
  bool _isProcessing = false;

  Uint8List? get originalImageBytes => _originalImageBytes;
  Uint8List? get processedImageBytes => _processedImageBytes;
  PassportStandard? get selectedStandard => _selectedStandard;
  bool get isProcessing => _isProcessing;

  PassportProvider() {
    // default standard
    _selectedStandard = PassportStandard.defaultStandards[0];
  }

  void setStandard(PassportStandard standard) {
    _selectedStandard = standard;
    notifyListeners();
    if (_originalImageBytes != null) {
      applyStandard();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final bytes = await image.readAsBytes();
      await setImageBytes(bytes);
    }
  }

  Future<void> setImageBytes(Uint8List bytes) async {
    _originalImageBytes = bytes;
    _processedImageBytes = null;
    notifyListeners();
    await applyStandard();
  }

  Future<void> applyStandard() async {
    if (_originalImageBytes == null || _selectedStandard == null) return;
    _isProcessing = true;
    notifyListeners();

    try {
      // Use compute to run heavy image processing in a background Isolate
      _processedImageBytes = await compute(_processImageTask, {
        'bytes': _originalImageBytes!,
        'standard': _selectedStandard!,
      });
    } catch (e) {
      debugPrint('Processing error: $e');
    }

    _isProcessing = false;
    notifyListeners();
  }

  void clear() {
    _originalImageBytes = null;
    _processedImageBytes = null;
    notifyListeners();
  }
}

// Top-level function for background processing (Isolate requirement)
Future<Uint8List?> _processImageTask(Map<String, dynamic> params) async {
  final Uint8List bytes = params['bytes'];
  final PassportStandard standard = params['standard'];
  
  final decodedImage = img.decodeImage(bytes);
  if (decodedImage == null) return null;

  // Compute target aspect ratio from standard
  final targetAspect = standard.widthMm / standard.heightMm;
  
  img.Image cropped;
  int width = decodedImage.width;
  int height = decodedImage.height;
  double currentAspect = width / height;

  if (currentAspect > targetAspect) {
    int newWidth = (height * targetAspect).toInt();
    int offset = (width - newWidth) ~/ 2;
    cropped = img.copyCrop(decodedImage, x: offset, y: 0, width: newWidth, height: height);
  } else {
    int newHeight = (width / targetAspect).toInt();
    int offset = (height - newHeight) ~/ 2;
    cropped = img.copyCrop(decodedImage, x: 0, y: offset, width: width, height: newHeight);
  }

  // Use higher compression quality but keep processing optimized
  return Uint8List.fromList(img.encodeJpg(cropped, quality: 95));
}

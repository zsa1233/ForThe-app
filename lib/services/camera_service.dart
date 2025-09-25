import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;

class CameraService {
  final ImagePicker _picker = ImagePicker();

  /// Check if camera permission is granted
  Future<bool> hasCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      developer.log('Error checking camera permission: $e');
      return false;
    }
  }

  /// Request camera permission
  Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      developer.log('Error requesting camera permission: $e');
      return false;
    }
  }

  /// Capture image from camera
  Future<File?> captureImage() async {
    try {
      // Check permissions
      final hasPermission = await hasCameraPermission();
      if (!hasPermission) {
        final granted = await requestCameraPermission();
        if (!granted) {
          developer.log('Camera permission denied');
          return null;
        }
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compress to 85% quality
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      developer.log('Error capturing image: $e');
      return null;
    }
  }

  /// Pick image from gallery (alternative option)
  Future<File?> pickFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      developer.log('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Compress image to reduce file size
  Future<File?> compressImage(File imageFile, {int quality = 85}) async {
    try {
      final XFile? compressedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: quality,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (compressedFile != null) {
        return File(compressedFile.path);
      }
      return null;
    } catch (e) {
      developer.log('Error compressing image: $e');
      return imageFile; // Return original if compression fails
    }
  }

  /// Get image file size in MB
  Future<double> getImageSizeInMB(File imageFile) async {
    try {
      final bytes = await imageFile.length();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (e) {
      developer.log('Error getting image size: $e');
      return 0.0;
    }
  }

  /// Validate image file
  bool isValidImage(File? imageFile) {
    if (imageFile == null) return false;
    
    final extension = imageFile.path.toLowerCase();
    return extension.endsWith('.jpg') || 
           extension.endsWith('.jpeg') || 
           extension.endsWith('.png');
  }

  /// Show camera options dialog (camera or gallery)
  Future<File?> showImageSourceOptions() async {
    // This would typically show a dialog, but for now we'll default to camera
    return captureImage();
  }
}

// Provider for CameraService
final cameraServiceProvider = Provider<CameraService>((ref) {
  return CameraService();
});
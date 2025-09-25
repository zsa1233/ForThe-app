import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const Uuid _uuid = Uuid();

  // Storage paths
  static const String cleanupImagesPath = 'cleanup_images';
  static const String profileImagesPath = 'profile_images';
  static const String hotspotImagesPath = 'hotspot_images';

  /// Upload an image file to Firebase Storage
  Future<String> uploadImage(File image, String storagePath) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create unique filename
      final fileName = '${_uuid.v4()}${path.extension(image.path)}';
      final fullPath = '$storagePath/$userId/$fileName';

      // Create reference
      final ref = _storage.ref().child(fullPath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(image.path),
        customMetadata: {
          'uploadedBy': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file
      final uploadTask = ref.putFile(image, metadata);
      
      // Monitor upload progress (optional)
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        developer.log('Upload progress: ${progress.toStringAsFixed(2)}%');
      });

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log('Image uploaded successfully: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      developer.log('Firebase Storage error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error uploading image: $e');
      rethrow;
    }
  }

  /// Upload image data (Uint8List) to Firebase Storage
  Future<String> uploadImageData(Uint8List imageData, String storagePath, String fileName) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Create unique filename if not provided
      final uniqueFileName = fileName.isEmpty ? '${_uuid.v4()}.jpg' : fileName;
      final fullPath = '$storagePath/$userId/$uniqueFileName';

      // Create reference
      final ref = _storage.ref().child(fullPath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'uploadedBy': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload data
      final uploadTask = ref.putData(imageData, metadata);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      developer.log('Image data uploaded successfully: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      developer.log('Firebase Storage error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error uploading image data: $e');
      rethrow;
    }
  }

  /// Upload cleanup before/after photos
  Future<Map<String, String>> uploadCleanupPhotos({
    File? beforePhoto,
    File? afterPhoto,
    String? sessionId,
  }) async {
    try {
      final results = <String, String>{};
      final cleanupPath = '$cleanupImagesPath/${sessionId ?? _uuid.v4()}';

      if (beforePhoto != null) {
        final beforeUrl = await uploadImage(beforePhoto, '$cleanupPath/before');
        results['beforePhotoUrl'] = beforeUrl;
      }

      if (afterPhoto != null) {
        final afterUrl = await uploadImage(afterPhoto, '$cleanupPath/after');
        results['afterPhotoUrl'] = afterUrl;
      }

      developer.log('Cleanup photos uploaded: ${results.length} photos');
      return results;
    } catch (e) {
      developer.log('Error uploading cleanup photos: $e');
      rethrow;
    }
  }

  /// Upload profile image
  Future<String> uploadProfileImage(File image) async {
    try {
      return await uploadImage(image, profileImagesPath);
    } catch (e) {
      developer.log('Error uploading profile image: $e');
      rethrow;
    }
  }

  /// Delete an image from Firebase Storage
  Future<void> deleteImage(String downloadUrl) async {
    try {
      // Extract the path from download URL
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      
      developer.log('Image deleted successfully: $downloadUrl');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        developer.log('Image not found (already deleted): $downloadUrl');
        return; // Not an error if already deleted
      }
      developer.log('Firebase Storage delete error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error deleting image: $e');
      rethrow;
    }
  }

  /// Get download URL for a storage reference
  Future<String> getDownloadUrl(String storagePath) async {
    try {
      final ref = _storage.ref().child(storagePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      developer.log('Firebase Storage error getting URL: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error getting download URL: $e');
      rethrow;
    }
  }

  /// List files in a storage directory
  Future<List<Reference>> listFiles(String path) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();
      
      developer.log('Listed ${result.items.length} files in $path');
      return result.items;
    } on FirebaseException catch (e) {
      developer.log('Firebase Storage list error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error listing files: $e');
      rethrow;
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      return await ref.getMetadata();
    } on FirebaseException catch (e) {
      developer.log('Firebase Storage metadata error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      developer.log('Error getting file metadata: $e');
      rethrow;
    }
  }

  /// Upload with retry logic
  Future<String> uploadImageWithRetry(
    File image, 
    String storagePath, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async {
    int attempts = 0;
    Exception? lastException;

    while (attempts < maxRetries) {
      try {
        return await uploadImage(image, storagePath);
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempts++;
        
        if (attempts < maxRetries) {
          developer.log('Upload attempt $attempts failed, retrying in ${retryDelay.inSeconds}s: $e');
          await Future.delayed(retryDelay);
          // Exponential backoff
          retryDelay = Duration(seconds: retryDelay.inSeconds * 2);
        }
      }
    }

    throw lastException ?? Exception('Upload failed after $maxRetries attempts');
  }

  /// Compress and upload image
  Future<String> uploadCompressedImage(
    File image, 
    String storagePath, {
    int? maxWidth,
    int? maxHeight,
    int quality = 85,
  }) async {
    try {
      // Note: In a real implementation, you would compress the image here
      // using packages like 'image' or 'flutter_image_compress'
      
      developer.log('Uploading compressed image (compression not implemented in demo)');
      return await uploadImage(image, storagePath);
    } catch (e) {
      developer.log('Error uploading compressed image: $e');
      rethrow;
    }
  }

  /// Batch upload multiple images
  Future<List<String>> uploadMultipleImages(
    List<File> images, 
    String storagePath,
  ) async {
    try {
      final results = <String>[];
      
      // Upload images concurrently
      final futures = images.map((image) => uploadImage(image, storagePath));
      final urls = await Future.wait(futures);
      
      results.addAll(urls);
      developer.log('Batch uploaded ${results.length} images');
      return results;
    } catch (e) {
      developer.log('Error in batch upload: $e');
      rethrow;
    }
  }

  /// Get storage usage stats for user
  Future<Map<String, dynamic>> getUserStorageStats() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final userRef = _storage.ref().child('$cleanupImagesPath/$userId');
      final result = await userRef.listAll();
      
      int totalFiles = result.items.length;
      int totalSize = 0;
      
      // Get metadata for each file to calculate total size
      for (final item in result.items) {
        try {
          final metadata = await item.getMetadata();
          totalSize += metadata.size ?? 0;
        } catch (e) {
          developer.log('Error getting metadata for ${item.name}: $e');
        }
      }
      
      return {
        'totalFiles': totalFiles,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      developer.log('Error getting storage stats: $e');
      rethrow;
    }
  }

  /// Helper method to determine content type
  String _getContentType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.heic':
        return 'image/heic';
      default:
        return 'image/jpeg'; // Default fallback
    }
  }

  /// Clean up old files (for maintenance)
  Future<void> cleanupOldFiles({
    required String path,
    required Duration maxAge,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      final result = await ref.listAll();
      
      final cutoffDate = DateTime.now().subtract(maxAge);
      int deletedCount = 0;
      
      for (final item in result.items) {
        try {
          final metadata = await item.getMetadata();
          final createdTime = metadata.timeCreated;
          
          if (createdTime != null && createdTime.isBefore(cutoffDate)) {
            await item.delete();
            deletedCount++;
          }
        } catch (e) {
          developer.log('Error processing file ${item.name}: $e');
        }
      }
      
      developer.log('Cleaned up $deletedCount old files from $path');
    } catch (e) {
      developer.log('Error cleaning up old files: $e');
      rethrow;
    }
  }
}

final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../models/cleanup_models.dart';
import 'dart:developer' as developer;

class LocalStorageService {
  static const String _cleanupSessionsFileName = 'cleanup_sessions.json';
  static const String _pendingUploadsFileName = 'pending_uploads.json';
  
  /// Get the application documents directory
  Future<Directory> _getAppDir() async {
    return await getApplicationDocumentsDirectory();
  }
  
  /// Save a cleanup session locally
  Future<bool> saveCleanupSession(CleanupSession session) async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_cleanupSessionsFileName');
      
      List<Map<String, dynamic>> sessions = [];
      
      // Load existing sessions
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> existingSessions = json.decode(content);
        sessions = existingSessions.cast<Map<String, dynamic>>();
      }
      
      // Update or add the session
      final sessionJson = session.toJson();
      final existingIndex = sessions.indexWhere((s) => s['id'] == session.id);
      
      if (existingIndex != -1) {
        sessions[existingIndex] = sessionJson;
      } else {
        sessions.add(sessionJson);
      }
      
      // Save back to file
      await file.writeAsString(json.encode(sessions));
      
      developer.log('Cleanup session saved locally: ${session.id}');
      return true;
    } catch (e) {
      developer.log('Error saving cleanup session: $e');
      return false;
    }
  }
  
  /// Load all cleanup sessions from local storage
  Future<List<CleanupSession>> loadCleanupSessions() async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_cleanupSessionsFileName');
      
      if (!await file.exists()) {
        return [];
      }
      
      final content = await file.readAsString();
      final List<dynamic> sessionsJson = json.decode(content);
      
      return sessionsJson
          .map((json) => CleanupSession.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error loading cleanup sessions: $e');
      return [];
    }
  }
  
  /// Load a specific cleanup session
  Future<CleanupSession?> loadCleanupSession(String sessionId) async {
    try {
      final sessions = await loadCleanupSessions();
      return sessions.firstWhere(
        (session) => session.id == sessionId,
        orElse: () => throw StateError('Session not found'),
      );
    } catch (e) {
      developer.log('Error loading cleanup session $sessionId: $e');
      return null;
    }
  }
  
  /// Delete a cleanup session from local storage
  Future<bool> deleteCleanupSession(String sessionId) async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_cleanupSessionsFileName');
      
      if (!await file.exists()) {
        return true; // Already doesn't exist
      }
      
      final content = await file.readAsString();
      final List<dynamic> sessionsJson = json.decode(content);
      
      // Remove the session
      sessionsJson.removeWhere((session) => session['id'] == sessionId);
      
      // Save back to file
      await file.writeAsString(json.encode(sessionsJson));
      
      developer.log('Cleanup session deleted: $sessionId');
      return true;
    } catch (e) {
      developer.log('Error deleting cleanup session $sessionId: $e');
      return false;
    }
  }
  
  /// Add session to pending uploads queue
  Future<bool> addToPendingUploads(String sessionId) async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_pendingUploadsFileName');
      
      List<String> pendingIds = [];
      
      // Load existing pending uploads
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> existingIds = json.decode(content);
        pendingIds = existingIds.cast<String>();
      }
      
      // Add if not already present
      if (!pendingIds.contains(sessionId)) {
        pendingIds.add(sessionId);
        await file.writeAsString(json.encode(pendingIds));
      }
      
      developer.log('Session added to pending uploads: $sessionId');
      return true;
    } catch (e) {
      developer.log('Error adding to pending uploads: $e');
      return false;
    }
  }
  
  /// Remove session from pending uploads queue
  Future<bool> removeFromPendingUploads(String sessionId) async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_pendingUploadsFileName');
      
      if (!await file.exists()) {
        return true; // Already doesn't exist
      }
      
      final content = await file.readAsString();
      final List<dynamic> pendingIds = json.decode(content);
      
      // Remove the session
      pendingIds.remove(sessionId);
      
      // Save back to file
      await file.writeAsString(json.encode(pendingIds));
      
      developer.log('Session removed from pending uploads: $sessionId');
      return true;
    } catch (e) {
      developer.log('Error removing from pending uploads: $e');
      return false;
    }
  }
  
  /// Get all pending upload session IDs
  Future<List<String>> getPendingUploads() async {
    try {
      final dir = await _getAppDir();
      final file = File('${dir.path}/$_pendingUploadsFileName');
      
      if (!await file.exists()) {
        return [];
      }
      
      final content = await file.readAsString();
      final List<dynamic> pendingIds = json.decode(content);
      
      return pendingIds.cast<String>();
    } catch (e) {
      developer.log('Error loading pending uploads: $e');
      return [];
    }
  }
  
  /// Clear all local data (for testing or user logout)
  Future<bool> clearAllData() async {
    try {
      final dir = await _getAppDir();
      
      final sessionsFile = File('${dir.path}/$_cleanupSessionsFileName');
      final pendingFile = File('${dir.path}/$_pendingUploadsFileName');
      
      if (await sessionsFile.exists()) {
        await sessionsFile.delete();
      }
      
      if (await pendingFile.exists()) {
        await pendingFile.delete();
      }
      
      developer.log('All local data cleared');
      return true;
    } catch (e) {
      developer.log('Error clearing local data: $e');
      return false;
    }
  }
  
  /// Get the current active cleanup session (in progress)
  Future<CleanupSession?> getActiveCleanupSession() async {
    try {
      final sessions = await loadCleanupSessions();
      
      // Find the most recent session that is still in progress
      final activeSessions = sessions
          .where((s) => s.status == CleanupStatus.inProgress)
          .toList();
      
      if (activeSessions.isEmpty) {
        return null;
      }
      
      // Sort by creation time and return the most recent
      activeSessions.sort((a, b) {
        final aTime = a.createdAt ?? a.startTime;
        final bTime = b.createdAt ?? b.startTime;
        return bTime.compareTo(aTime);
      });
      return activeSessions.first;
    } catch (e) {
      developer.log('Error getting active cleanup session: $e');
      return null;
    }
  }

  /// Get storage stats
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final sessions = await loadCleanupSessions();
      final pendingUploads = await getPendingUploads();
      
      return {
        'totalSessions': sessions.length,
        'pendingUploads': pendingUploads.length,
        'completedSessions': sessions.where((s) => s.status == CleanupStatus.completed).length,
        'submittedSessions': sessions.where((s) => s.status == CleanupStatus.submitted).length,
      };
    } catch (e) {
      developer.log('Error getting storage stats: $e');
      return {};
    }
  }
}

// Provider for LocalStorageService
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
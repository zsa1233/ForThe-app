/**
 * Terra Cloud Functions Entry Point
 * 
 * This file exports all Firebase Cloud Functions for the Terra cleanup verification system.
 */

// Main cleanup verification function
export { verifyCleanup } from './cleanup-verification';

// Additional utility functions
export { 
  getUserStats,
  getVerificationStats,
  reprocessSubmission,
  healthCheck
} from './admin-functions';

// Scheduled maintenance functions
export {
  cleanupOldLogs,
  updateLeaderboards,
  generateAnalytics
} from './scheduled-functions';
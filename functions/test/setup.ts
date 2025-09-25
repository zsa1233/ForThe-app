/**
 * Test setup and configuration
 */

import { initializeApp } from 'firebase-admin/app';

// Initialize Firebase Admin for tests (using default project)
if (!process.env.FIREBASE_CONFIG && !process.env.GCLOUD_PROJECT) {
  process.env.GCLOUD_PROJECT = 'terra-cleanup-test';
}

// Initialize app for testing
initializeApp({
  projectId: 'terra-cleanup-test'
});

// Global test configuration
global.console = {
  ...console,
  // Suppress logs during tests unless debugging
  log: process.env.DEBUG_TESTS ? console.log : jest.fn(),
  info: process.env.DEBUG_TESTS ? console.info : jest.fn(),
  warn: process.env.DEBUG_TESTS ? console.warn : jest.fn(),
  error: console.error // Keep errors visible
};
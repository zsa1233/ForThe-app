# Terra Cloud Functions

This directory contains Firebase Cloud Functions for the Terra cleanup verification system.

## Functions Overview

### 1. Cleanup Verification (`verifyCleanup`)
- **Trigger**: Firestore document creation in `cleanup_submissions` collection
- **Purpose**: Automatically verifies cleanup submissions using Google Cloud Vision API
- **Process**:
  1. Validates submission data
  2. Verifies location against hotspot (if provided)
  3. Analyzes before/after images using Vision API
  4. Calculates cleanup effectiveness
  5. Updates user stats and badges if approved
  6. Updates submission status

### 2. Administrative Functions
- `getUserStats`: Retrieves user statistics and submission history
- `getVerificationStats`: System-wide verification statistics (admin only)
- `reprocessSubmission`: Reprocesses failed submissions (admin only)
- `healthCheck`: Health check endpoint for monitoring

### 3. Scheduled Functions
- `cleanupOldLogs`: Daily cleanup of old verification logs
- `updateLeaderboards`: Hourly leaderboard updates
- `generateAnalytics`: Daily analytics generation

## Setup

### Prerequisites
- Node.js 18+
- Firebase CLI
- Google Cloud Project with Vision API enabled

### Installation
```bash
cd functions
npm install
```

### Development
```bash
# Build TypeScript
npm run build

# Watch mode
npm run build:watch

# Run emulators
npm run serve

# Run tests
npm test

# Run tests with coverage
npm run test:coverage
```

### Configuration

#### Environment Variables
Set these in Firebase Functions config:

```bash
# Required for Vision API
firebase functions:config:set vision.project_id="your-project-id"

# Optional: Custom thresholds
firebase functions:config:set cleanup.effectiveness_threshold=70
firebase functions:config:set cleanup.location_radius_meters=100
```

#### IAM Permissions
The Cloud Functions service account needs these permissions:
- `cloudsql.client`
- `storage.objectViewer`
- `ml.online_prediction`

### Google Cloud Vision API Setup

1. Enable the Vision API in your Google Cloud Console
2. The function will automatically use the default service account
3. For local development, set `GOOGLE_APPLICATION_CREDENTIALS`

## Deployment

### Deploy all functions
```bash
npm run deploy
```

### Deploy specific function
```bash
firebase deploy --only functions:verifyCleanup
```

### Deploy with emulator testing
```bash
# Start emulators
firebase emulators:start

# Deploy to emulators
firebase deploy --only functions --project demo-project
```

## Testing

### Unit Tests
```bash
npm test
```

### Integration Tests
```bash
# With emulators running
npm run test:integration
```

### Manual Testing
Use the Firebase Functions Emulator UI at `http://localhost:4000`

## Monitoring

### Logs
```bash
# View logs
firebase functions:log

# Follow logs
firebase functions:log --follow

# Filter by function
firebase functions:log --only verifyCleanup
```

### Performance Monitoring
- Function execution times are logged
- Failed verifications are tracked
- Analytics are generated daily

### Error Handling
- All errors are logged with context
- Failed submissions can be reprocessed
- Automatic retry logic for Vision API calls

## Security

### Data Privacy
- Images are only analyzed, never stored by functions
- User data is processed with minimal necessary permissions
- All database operations use security rules

### Access Control
- Admin functions require authenticated users with admin role
- User stats functions require proper user authentication
- Public functions (health check) have rate limiting

## Performance Optimization

### Vision API Optimization
- Images analyzed in parallel where possible
- Results cached temporarily to avoid redundant calls
- Confidence scores used to determine analysis quality

### Database Optimization
- Batch operations for user stats updates
- Efficient queries with proper indexing
- Transaction-based updates for consistency

### Function Optimization
- 9-minute timeout for complex image analysis
- 1GB memory allocation for Vision API processing
- Proper error boundaries to prevent cascading failures

## Troubleshooting

### Common Issues

1. **Vision API Quota Exceeded**
   - Monitor Vision API usage in Google Cloud Console
   - Implement request throttling if needed
   - Consider Vision API pricing tiers

2. **Function Timeouts**
   - Large images may cause timeouts
   - Implement image compression before analysis
   - Use streaming for large batch operations

3. **Authentication Errors**
   - Verify service account permissions
   - Check Firebase project configuration
   - Ensure proper IAM roles are assigned

4. **Database Permission Errors**
   - Review Firestore security rules
   - Verify user authentication tokens
   - Check admin role assignments

### Debug Mode
Set `DEBUG_FUNCTIONS=true` in environment variables to enable detailed logging.

### Performance Analysis
Use Firebase Performance Monitoring and Cloud Monitoring to track:
- Function execution times
- Memory usage
- Error rates
- Vision API call latency

## Contributing

1. Write tests for new features
2. Follow TypeScript strict mode
3. Use proper error handling
4. Document new functions
5. Update this README for significant changes

## API Documentation

### Function Triggers
- Document creation triggers are automatically handled
- HTTP callable functions require authentication
- Scheduled functions run on specified cron schedules

### Data Structures
See `src/utils/` for detailed type definitions and validation schemas.

### Error Codes
- `invalid-argument`: Invalid input parameters
- `permission-denied`: Insufficient permissions
- `not-found`: Resource not found
- `internal`: Server-side processing error
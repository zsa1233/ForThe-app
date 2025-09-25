# Leaderboard Scalability Plan

## Current Implementation
The leaderboard currently uses mock data in `lib/services/city_dashboard_service.dart` with hardcoded user lists.

## Required Changes for Hundreds of Users

### 1. Backend Optimizations (Firebase Functions)
- [ ] Implement pagination for leaderboard queries
  - Limit initial load to top 20-50 users
  - Load more on scroll (infinite scrolling)
  - Use Firestore's `startAfter()` for cursor-based pagination

- [ ] Add caching layer
  - Cache leaderboard data in Firestore with TTL (5-10 minutes)
  - Use Firebase Realtime Database for live updates
  - Implement Redis/Memcached for frequently accessed data

- [ ] Create leaderboard aggregation functions
  - Scheduled Cloud Function to calculate rankings (every 5-10 mins)
  - Store pre-computed rankings in separate collection
  - Use composite indexes for efficient queries

### 2. Database Structure Changes
```javascript
// Proposed Firestore structure
/leaderboards/{cityId}/rankings/{period}/users/{userId}
{
  rank: number,
  userId: string,
  userName: string,
  poundsCollected: number,
  cleanupsCompleted: number,
  points: number,
  lastUpdated: timestamp,
  // Denormalized data for fast reads
}

// Separate collection for user details to reduce payload
/leaderboards/{cityId}/userDetails/{userId}
{
  badges: array,
  profilePicture: string,
  joinDate: timestamp,
  // Additional user data
}
```

### 3. Frontend Optimizations (Flutter)

#### File: `lib/services/city_dashboard_service.dart`
- [ ] Replace mock data with Firebase queries
- [ ] Implement pagination logic
- [ ] Add local caching with expiration
- [ ] Implement lazy loading for user details

#### File: `lib/screens/city_dashboard_screen.dart`
- [ ] Add infinite scroll to leaderboard list
- [ ] Implement virtualized list rendering
- [ ] Add loading skeletons for better UX
- [ ] Implement pull-to-refresh with smart updates

#### New File: `lib/services/leaderboard_cache_service.dart`
- [ ] Create local SQLite cache for offline support
- [ ] Implement smart sync with server
- [ ] Add background refresh logic

### 4. Performance Optimizations

#### Query Optimization
- [ ] Create composite indexes: `cityId + period + points DESC`
- [ ] Limit fields returned in queries (select only needed fields)
- [ ] Use Firestore bundles for initial data load

#### Data Loading Strategy
```dart
// Proposed implementation approach
class OptimizedLeaderboardService {
  // Load top 20 users immediately
  Future<List<CityUser>> getInitialLeaderboard(String cityId, TimePeriod period) {
    // Query: limit(20).orderBy('points', descending: true)
  }
  
  // Load next batch on scroll
  Future<List<CityUser>> getNextPage(DocumentSnapshot lastDoc) {
    // Query: startAfterDocument(lastDoc).limit(20)
  }
  
  // Get user's position if not in top list
  Future<int> getUserRank(String userId, String cityId) {
    // Separate query for user's specific rank
  }
}
```

### 5. Monitoring & Analytics
- [ ] Add performance monitoring for query times
- [ ] Track cache hit rates
- [ ] Monitor Firestore read costs
- [ ] Set up alerts for slow queries

### 6. Cost Optimization
- [ ] Implement request batching
- [ ] Use Firestore bundles for common data
- [ ] Consider denormalization to reduce reads
- [ ] Implement client-side caching aggressively

### 7. Testing Requirements
- [ ] Load test with 1000+ users
- [ ] Test pagination edge cases
- [ ] Verify offline functionality
- [ ] Performance benchmarks for list rendering

## Implementation Priority
1. **Phase 1**: Basic pagination (top 50 users)
2. **Phase 2**: Infinite scroll and caching
3. **Phase 3**: Real-time updates and optimizations
4. **Phase 4**: Advanced features (search, filters, etc.)

## Estimated Timeline
- Phase 1: 2-3 days
- Phase 2: 3-4 days
- Phase 3: 4-5 days
- Phase 4: 3-4 days

Total: ~2-3 weeks for complete implementation

## Notes
- Current mock implementation in `_getMockLeaderboard()` returns 5 users
- Need to maintain backward compatibility during migration
- Consider A/B testing for rollout
- Monitor Firebase billing closely during scaling
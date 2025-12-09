# Wave 5: Optimization & Extras - Test Specifications

## Test Coverage Overview

### Unit Tests (Core Functions)

1. **Redis Cache Service** (`src/services/cache/redis.ts`)
   - `connect()`: Establishes Redis connection with connection pooling, handles connection errors gracefully
   - `healthCheck()`: Pings Redis instance, returns health status (healthy/unhealthy), throws on connection failure
   - `reconnect()`: Implements exponential backoff reconnection logic (max 5 retries), restores connection state
   - `generateCacheKey()`: Creates namespaced cache keys (`stats:user:{userId}:recent`, `history:user:{userId}:top-artists`)
   - Edge cases: Connection timeout, Redis unavailable, connection pool exhaustion, invalid key format

2. **Statistics Cache Service** (`src/services/statistics/statisticsService.ts`)
   - `getCachedStatistics()`: Checks Redis cache before database query, returns cached data if available
   - `setCachedStatistics()`: Stores computed statistics with TTL (1h recent, 24h historical), handles serialization errors
   - `invalidateStatisticsCache()`: Removes cache entries for user, handles partial invalidation scenarios
   - Cache hit/miss tracking: Records hit/miss metrics, calculates hit rate correctly
   - TTL handling: Verifies different TTLs for recent (1h) vs historical (24h) statistics

3. **Listening History Cache Service** (`src/services/listeningHistory/listeningHistoryService.ts`)
   - `getCachedHistory()`: Implements cache-first loading, falls back to database on cache miss
   - `cacheTopGenres()`: Extracts and caches top genres with appropriate TTL based on freshness
   - `cacheTopArtists()`: Caches top artists list, updates cache on new listening events
   - `cacheTopTracks()`: Stores top tracks in Redis, handles cache size limits
   - Cache freshness: Verifies TTL based on last listening event timestamp

4. **Recommendations Cache Service** (`src/services/recommendations/recommendationService.ts`)
   - `getCachedRecommendations()`: Retrieves recommendations from cache, handles missing cache gracefully
   - `setCachedRecommendations()`: Stores recommendations with type-specific TTL (daily/weekly/monthly)
   - `invalidateRecommendationsCache()`: Removes cached recommendations on new listening data
   - `warmCacheForActiveUsers()`: Pre-loads recommendations for active users (last 7 days activity)
   - Cache type handling: Verifies different TTLs for daily (1h), weekly (6h), monthly (24h) recommendations

5. **Cache Invalidation Service** (`src/services/cache/invalidationService.ts`)
   - `invalidateUserCache()`: Atomically invalidates all user-related cache entries
   - `invalidateStatisticsOnDataChange()`: Triggers statistics cache invalidation on data updates
   - `invalidateRecommendationsOnListeningEvent()`: Invalidates recommendations cache on new listening event
   - Atomic operations: Ensures cache and database updates complete atomically
   - Batch invalidation: Handles multiple cache key invalidation efficiently

6. **Cache Monitoring Service** (`src/services/cache/monitoringService.ts`)
   - `trackCacheHit()`: Records cache hit event, updates hit rate calculation
   - `trackCacheMiss()`: Records cache miss event, updates hit rate calculation
   - `getHitRate()`: Calculates hit rate percentage correctly (hits / (hits + misses))
   - `checkMemoryUsage()`: Monitors Redis memory usage, alerts when approaching limits
   - Alerting: Triggers alert when hit rate < 70% for 30 minutes
   - Metrics export: Exports cache metrics for dashboard (hit rate, memory usage, operation count)

### Integration Tests (API Endpoints)

7. **Statistics API with Caching** (`src/api/routes/statisticsRoutes.ts`)
   - GET `/api/v1/statistics/user/:userId/recent`: Returns cached statistics on hit, queries database on miss
   - GET `/api/v1/statistics/user/:userId/historical`: Uses 24h TTL cache, falls back to database
   - Cache invalidation: POST `/api/v1/statistics/invalidate/:userId` removes cache, next request hits database
   - Performance: Cached responses return within 50ms, database queries within 200ms
   - Hit rate: Verifies >70% cache hit rate after warm-up period

8. **Listening History API with Caching** (`src/api/routes/listeningHistoryRoutes.ts`)
   - GET `/api/v1/listening-history/:userId/top-genres`: Returns cached top genres, updates cache on miss
   - GET `/api/v1/listening-history/:userId/top-artists`: Cache-first loading with database fallback
   - Cache update: POST `/api/v1/listening-history/:userId/events` invalidates related cache entries
   - TTL validation: Verifies cache TTL refreshes on new listening events
   - Concurrent requests: Multiple simultaneous requests use same cache entry

9. **Recommendations API with Caching** (`src/api/routes/recommendationsRoutes.ts`)
   - GET `/api/v1/recommendations/:userId/daily`: Returns cached daily recommendations if available
   - GET `/api/v1/recommendations/:userId/weekly`: Uses 6h TTL cache for weekly recommendations
   - Cache warming: POST `/api/v1/recommendations/warm/:userId` pre-loads recommendations
   - Cache invalidation: New listening event invalidates recommendations cache
   - Performance: Cached recommendations return within 100ms vs 2s for fresh calculation

10. **Cache Monitoring API** (`src/api/routes/cacheRoutes.ts`)
    - GET `/api/v1/cache/metrics`: Returns cache hit rate, memory usage, operation counts
    - GET `/api/v1/cache/health`: Returns Redis connection status and health metrics
    - Alert endpoint: POST `/api/v1/cache/alerts` triggers alert when hit rate drops below threshold
    - Dashboard data: Returns formatted metrics for cache performance dashboard

### E2E Tests (User Flows)

11. **Complete Statistics Flow with Caching**
    - User requests statistics ? Cache miss ? Database query ? Store in cache ? Return results
    - Subsequent request ? Cache hit ? Return cached results within 50ms
    - New listening event ? Cache invalidation ? Next request ? Cache miss ? Fresh calculation ? Cache update
    - Hit rate tracking: Verifies cache hit rate improves over time, reaches >70% after warm-up

12. **Recommendations Cache Warming Flow**
    - Active user identified (activity in last 7 days) ? Cache warming triggered ? Recommendations pre-calculated ? Stored in cache
    - User requests recommendations ? Cache hit ? Returns within 100ms
    - New listening event ? Recommendations cache invalidated ? Next request triggers fresh calculation
    - Performance: Cache warming reduces average response time by >60%

13. **Cache Failure and Fallback Flow**
    - Redis connection fails ? Health check detects failure ? Falls back to database queries
    - Reconnection logic ? Exponential backoff ? Connection restored ? Cache operations resume
    - User experience: No errors during Redis downtime, graceful degradation to database
    - Recovery: Cache repopulates automatically after Redis recovery

14. **Cache Monitoring and Alerting Flow**
    - Hit rate drops below 70% ? Monitoring service detects ? Alert triggered ? Dashboard updated
    - Memory usage approaches limit ? Alert sent ? Cache eviction triggered ? Memory freed
    - Metrics collection: Real-time hit rate, memory usage, operation counts tracked continuously
    - Dashboard: Visual representation of cache performance metrics updates in real-time

## Test Implementation Priority

**Phase 1 (Critical Path):**
- Tests #1, #2 (Redis Cache Setup & Statistics Caching)
- Test #7 (Statistics API with Caching)
- Test #11 (Complete Statistics Flow)

**Phase 2 (Core Functionality):**
- Tests #3, #4 (Listening History & Recommendations Caching)
- Tests #8, #9 (Listening History & Recommendations APIs)
- Test #6 (Cache Monitoring Service)

**Phase 3 (E2E & Optimization):**
- Tests #5, #10 (Cache Invalidation & Monitoring APIs)
- Tests #12, #13, #14 (E2E flows: warming, failure, monitoring)
- Performance validation (hit rates, response times, memory usage)

## Test Environment Requirements

- Redis 7+ instance: Test Redis cluster with connection pooling enabled
- Cache metrics: Mock Redis for cache hit/miss tracking
- Database: Test database for fallback scenarios
- Monitoring: Test monitoring service for metrics collection
- Load testing: Test suite for concurrent cache operations
- Redis failure simulation: Ability to simulate Redis downtime and recovery

## Performance Targets

- Cache hit rate: >70% for all cached endpoints
- Response time: Cached responses <50ms, database fallback <200ms
- Cache invalidation: Completes within 5 seconds of data change
- Memory usage: Stays within configured Redis limits
- Connection recovery: Reconnects within 30 seconds of Redis restoration
- Cache warming: Reduces average response time by >60%

## Cache Key Structure

- Statistics: `stats:user:{userId}:recent`, `stats:user:{userId}:historical`
- Listening History: `history:user:{userId}:top-genres`, `history:user:{userId}:top-artists`, `history:user:{userId}:top-tracks`
- Recommendations: `recs:user:{userId}:daily`, `recs:user:{userId}:weekly`, `recs:user:{userId}:monthly`
- Session: `session:{sessionId}`

## Accessibility Testing Requirements

All API endpoints must include:
- Proper error messages for cache failures
- Graceful degradation when cache unavailable
- Clear user feedback for cache operations
- Accessible error handling and recovery options

---

*Generated for Wave 5: Optimization & Extras*

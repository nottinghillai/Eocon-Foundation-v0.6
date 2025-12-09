# Wave 3: Advanced Features - Test Specifications

## Test Coverage Overview

### Unit Tests (Core Functions)

1. **Similar Artists Discovery Service** (`src/services/discovery/SimilarArtistsService.swift`)
   - `findSimilarArtists()`: Returns similar artists within 2 seconds, handles API failures gracefully
   - `cacheSimilarArtists()`: Stores results in cache, retrieves from cache on subsequent calls
   - Edge cases: Empty artist ID, non-existent artist, API timeout handling

2. **Mood-Based Discovery Service** (`src/services/discovery/MoodDiscoveryService.swift`)
   - `discoverByMood()`: Returns tracks matching mood ("energetic", "calm", "focused") using metadata APIs
   - `analyzeListeningHistoryForMood()`: Analyzes user history to infer preferred moods
   - Mood preference storage: Saves user mood preferences, retrieves correctly

3. **Daily Discovery Playlist Generator** (`src/services/discovery/DailyDiscoveryPlaylistService.swift`)
   - `generateDailyPlaylist()`: Creates 20-30 track playlist based on user listening history
   - Playlist uniqueness: No duplicate tracks in playlist, excludes recently played tracks
   - Preference integration: Respects user discovery preferences (genres, artists, moods)

4. **Time-Based Statistics Calculator** (`src/services/analytics/TimeBasedStatisticsService.swift`)
   - `calculateDailyStats()`: Returns listening time, top artists/tracks for today
   - `calculateWeeklyStats()`: Aggregates daily stats into weekly totals
   - `calculateYearlyStats()`: Handles leap years, aggregates monthly data correctly
   - Response time: All calculations complete within 2 seconds

5. **Comparative Analytics Engine** (`src/services/analytics/ComparativeAnalyticsService.swift`)
   - `comparePeriods()`: Calculates "this period vs previous period" with accurate percentage changes
   - Edge cases: Zero listening time in previous period, month boundary handling
   - Percentage calculation: Correctly handles increases/decreases, formats to 2 decimal places

### Integration Tests (API Endpoints)

6. **GET /api/v1/discovery/similar-artists/:artistId** (`src/api/routes/discoveryRoutes.swift`)
   - Valid request: Returns 200 with array of similar artists (max 20 results)
   - Non-existent artist: Returns 404 not found
   - API failure: Returns 503 service unavailable with error message
   - Caching: Subsequent identical requests return cached results within 500ms

7. **POST /api/v1/discovery/daily-playlist** (`src/api/routes/discoveryRoutes.swift`)
   - Valid request: Returns 201 with generated playlist (20-30 tracks)
   - Unauthorized access: Returns 401 if token missing/invalid
   - Empty history: Returns 200 with default discovery playlist based on preferences
   - Playlist uniqueness: No duplicate tracks, respects exclusions

8. **GET /api/v1/analytics/statistics/:period** (`src/api/routes/analyticsRoutes.swift`)
   - Valid periods: Returns 200 with stats for daily/weekly/monthly/yearly/all-time
   - Invalid period: Returns 400 validation error
   - Response time: All period queries respond within 2 seconds
   - Caching: Statistics retrieved from cache when available

9. **GET /api/v1/analytics/comparative/:period** (`src/api/routes/analyticsRoutes.swift`)
   - Valid request: Returns 200 with comparative stats (current vs previous period)
   - Percentage changes: Calculates correctly, handles negative values
   - Insufficient data: Returns 200 with partial data when previous period has no data

### E2E Tests (User Flows)

10. **Complete Discovery Flow**
    - User authenticates ? requests similar artists ? receives playlist ? saves to favorites ? playlist appears in dashboard

11. **Statistics Dashboard Flow**
    - User opens dashboard ? selects time period ? views comparative analytics ? shares statistics ? verifies shareable link works

12. **Public Profile Sharing Flow**
    - User enables public profile ? generates share link ? accesses link (unauthenticated) ? views public statistics ? verifies privacy settings respected

## Test Implementation Priority

**Phase 1 (Critical Path):**
- Tests #1, #3 (Similar Artists & Daily Playlist services)
- Test #4 (Time-Based Statistics)
- Test #6 (Similar Artists API endpoint)

**Phase 2 (Core Functionality):**
- Tests #2, #5 (Mood Discovery & Comparative Analytics)
- Tests #7, #8 (Playlist & Analytics API endpoints)

**Phase 3 (E2E Validation):**
- Tests #10, #11, #12 (Complete user flows)
- Performance validation (response times < 2 seconds)

## Test Environment Requirements

- Test database: PostgreSQL instance with listening history seed data
- Mock music metadata APIs: Spotify/Apple Music/YouTube Music API mocks
- Redis cache: Test Redis instance for caching layer tests
- Test data: User listening history spanning multiple time periods
- Performance testing: Measure query response times, verify < 2 second requirement

---

*Generated for Wave 3: Advanced Features*
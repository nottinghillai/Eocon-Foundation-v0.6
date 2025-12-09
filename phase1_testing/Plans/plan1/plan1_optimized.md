# Music Listening Tracker - Optimized Plan

## Critical Clarifications & Enhanced Implementation Details

### 1. Real-Time Sync Specifications

**Sync Timing Definition:**
- **"Within 5 seconds"** means: From when track playback **ends** (user stops, skips, or track completes)
- **Polling Strategy**: Hybrid approach combining client-side events + server polling

**Polling Intervals by Service:**
- **Spotify**: 
  - Primary: Client-side SDK events (real-time via Web Playback SDK)
  - Fallback: Server polling every 30 seconds for active users
  - API Endpoint: `GET /v1/me/player/recently-played` (last 50 tracks)
  - Rate Limit: 300 requests/30 seconds per user
  
- **Apple Music**: 
  - Server polling every 60 seconds (no real-time API available)
  - API Endpoint: `GET /v1/me/library/recently-added` (last 100 tracks)
  - Rate Limit: 600 requests/minute
  
- **YouTube Music**: 
  - Server polling every 60 seconds (limited API support)
  - API Endpoint: YouTube Data API v3 watch history
  - Rate Limit: 10,000 units/day (1 unit per request)

**Implementation Files:**
- `apps/api/src/services/listening-tracker/spotify-tracker.ts` - Spotify event handler
- `apps/api/src/services/listening-tracker/polling-service.ts` - Server polling worker
- `apps/api/src/jobs/sync-listening-history.ts` - Background sync job

**Sync Logic:**
```typescript
// apps/api/src/services/listening-tracker/sync-strategy.ts
export class SyncStrategy {
  // Client-side event (preferred)
  async handleClientEvent(event: ListeningEvent): Promise<void> {
    const timestamp = new Date(event.timestamp);
    const now = new Date();
    const delay = now.getTime() - timestamp.getTime();
    
    if (delay <= 5000) { // Within 5 seconds
      await this.recordEvent(event);
    }
  }
  
  // Server polling fallback
  async pollForUpdates(userId: string, service: string): Promise<void> {
    const interval = this.getPollingInterval(service);
    const lastSync = await this.getLastSyncTime(userId, service);
    const cutoff = new Date(Date.now() - interval * 1000);
    
    if (lastSync < cutoff) {
      await this.fetchRecentPlays(userId, service);
    }
  }
}
```

### 2. Deduplication Specifications

**Deduplication Window:**
- **Time Window**: 5 minutes (300 seconds)
- **Matching Criteria**: Same `user_id` + `track_id` + `listened_at` within ±5 minutes
- **Source Priority**: If multiple sources have same track within window:
  1. Spotify > Apple Music > YouTube Music > Manual
  2. Longer duration wins if same source
  3. More recent timestamp wins if duration equal

**Implementation:**
```typescript
// apps/api/src/services/listening-history/deduplication.ts
export class DeduplicationService {
  private readonly DEDUP_WINDOW_MS = 5 * 60 * 1000; // 5 minutes
  
  async deduplicate(event: ListeningEvent): Promise<boolean> {
    const windowStart = new Date(event.listened_at.getTime() - this.DEDUP_WINDOW_MS);
    const windowEnd = new Date(event.listened_at.getTime() + this.DEDUP_WINDOW_MS);
    
    const existing = await db.listening_history.findFirst({
      where: {
        user_id: event.user_id,
        track_id: event.track_id,
        listened_at: {
          gte: windowStart,
          lte: windowEnd
        }
      }
    });
    
    if (existing) {
      // Merge: Keep longer duration, more recent timestamp
      if (event.duration_listened > existing.duration_listened) {
        await this.updateRecord(existing.id, event);
      }
      return false; // Duplicate, don't insert
    }
    
    return true; // Not duplicate, proceed with insert
  }
}
```

**File Location:** `apps/api/src/services/listening-history/deduplication.ts`

### 3. Partial Listen Thresholds

**Minimum Duration Threshold:**
- **Recorded**: ≥ 30 seconds of listening
- **Counted as Play**: ≥ 80% of track duration OR ≥ 30 seconds (whichever is shorter)
- **Counted as Skip**: < 30 seconds OR < 20% of track duration

**Skip Detection:**
```typescript
// apps/api/src/services/listening-history/play-classifier.ts
export class PlayClassifier {
  classify(event: ListeningEvent, trackDuration: number): PlayClassification {
    const MIN_DURATION = 30; // seconds
    const MIN_PERCENTAGE = 0.2; // 20%
    const FULL_PLAY_PERCENTAGE = 0.8; // 80%
    
    // Too short to count
    if (event.duration_listened < MIN_DURATION) {
      return { is_play: false, is_skipped: true, play_weight: 0 };
    }
    
    // Less than 20% of track
    if (event.duration_listened < trackDuration * MIN_PERCENTAGE) {
      return { is_play: false, is_skipped: true, play_weight: 0 };
    }
    
    // Full play (80%+ or 30+ seconds)
    if (event.duration_listened >= trackDuration * FULL_PLAY_PERCENTAGE || 
        event.duration_listened >= MIN_DURATION) {
      return { is_play: true, is_skipped: false, play_weight: 1 };
    }
    
    // Partial play (20-80%)
    const percentage = event.duration_listened / trackDuration;
    return { 
      is_play: true, 
      is_skipped: false, 
      play_weight: percentage < 0.5 ? 0.5 : 1 
    };
  }
}
```

**File Location:** `apps/api/src/services/listening-history/play-classifier.ts`

### 4. Historical Import Specifications

**Supported Formats:**
- **CSV**: Standard format with columns: `timestamp, track_name, artist_name, album_name, duration`
- **JSON**: Array of listening events with same structure as API
- **Spotify Export**: Spotify extended history JSON format
- **Last.fm Export**: Last.fm scrobbling history CSV/JSON
- **Apple Music**: Apple Music Library export (XML/JSON)

**Batch Processing:**
- **Maximum Batch Size**: 1000 entries per request
- **Processing Strategy**: 
  - Upload file → Parse → Validate → Queue for background processing
  - Process in batches of 100 entries
  - Rate limit: 1 batch per second (to avoid API throttling)
  - Progress tracking via job status endpoint

**Implementation:**
```typescript
// apps/api/src/services/listening-history/import-service.ts
export class ImportService {
  private readonly MAX_BATCH_SIZE = 1000;
  private readonly PROCESSING_BATCH_SIZE = 100;
  private readonly PROCESSING_RATE_LIMIT = 1000; // ms between batches
  
  async importFromFile(
    userId: string, 
    file: File, 
    format: ImportFormat
  ): Promise<ImportJob> {
    // Parse file
    const parser = this.getParser(format);
    const entries = await parser.parse(file);
    
    if (entries.length > this.MAX_BATCH_SIZE) {
      throw new Error(`Maximum ${this.MAX_BATCH_SIZE} entries per import`);
    }
    
    // Validate entries
    const validated = await this.validateEntries(entries);
    
    // Create import job
    const job = await this.createImportJob(userId, validated);
    
    // Queue for background processing
    await this.queueImportJob(job.id);
    
    return job;
  }
  
  private async processBatch(jobId: string, entries: ListeningEvent[]): Promise<void> {
    const batches = this.chunkArray(entries, this.PROCESSING_BATCH_SIZE);
    
    for (const batch of batches) {
      await this.processBatchEntries(jobId, batch);
      await this.sleep(this.PROCESSING_RATE_LIMIT);
    }
  }
}
```

**File Locations:**
- `apps/api/src/services/listening-history/import-service.ts`
- `apps/api/src/services/listening-history/parsers/csv-parser.ts`
- `apps/api/src/services/listening-history/parsers/json-parser.ts`
- `apps/api/src/services/listening-history/parsers/spotify-parser.ts`

### 5. Streaming Service API Specifications

**Spotify Web API:**
- **OAuth Flow**: Authorization Code Flow with PKCE
- **Endpoints Used**:
  - `GET /v1/me/player/recently-played?limit=50` - Recently played tracks
  - `GET /v1/me/player/currently-playing` - Currently playing track
  - `GET /v1/tracks/{id}` - Track metadata
  - `GET /v1/artists/{id}` - Artist metadata
  - `GET /v1/artists/{id}/related-artists` - Similar artists
- **Rate Limits**: 
  - 300 requests per 30 seconds per user
  - Burst: 50 requests per second
- **Token Refresh**: Automatic refresh 5 minutes before expiration
- **Scopes Required**: `user-read-recently-played`, `user-read-currently-playing`, `user-read-playback-state`

**Apple Music API:**
- **OAuth Flow**: MusicKit OAuth 2.0
- **Endpoints Used**:
  - `GET /v1/me/library/recently-added?limit=100` - Recently added tracks
  - `GET /v1/catalog/{storefront}/songs/{id}` - Track metadata
  - `GET /v1/catalog/{storefront}/artists/{id}` - Artist metadata
- **Rate Limits**: 
  - 600 requests per minute
  - Varies by endpoint
- **Limitations**: 
  - Requires Apple Developer account
  - Limited access to listening history (only recently added)
  - No real-time playback API

**YouTube Music API:**
- **OAuth Flow**: OAuth 2.0
- **Endpoints Used**:
  - YouTube Data API v3: `activities.list` for watch history
  - Custom endpoints for music-specific data (limited)
- **Rate Limits**: 
  - 10,000 units per day
  - 1 unit per request
- **Limitations**: 
  - Limited official API support
  - No dedicated music listening history endpoint
  - May require web scraping fallback (not recommended)

**Implementation Files:**
- `apps/api/src/integrations/spotify/client.ts` - Spotify API client
- `apps/api/src/integrations/spotify/oauth.ts` - Spotify OAuth handler
- `apps/api/src/integrations/apple-music/client.ts` - Apple Music API client
- `apps/api/src/integrations/youtube-music/client.ts` - YouTube Music API client
- `apps/api/src/integrations/base-client.ts` - Base API client with rate limiting

**Rate Limiting Implementation:**
```typescript
// apps/api/src/integrations/base-client.ts
export class BaseStreamingClient {
  private rateLimiters: Map<string, RateLimiter> = new Map();
  
  async request(endpoint: string, options: RequestOptions): Promise<Response> {
    const limiter = this.getRateLimiter(this.service);
    
    await limiter.acquire(); // Wait for available slot
    
    try {
      const response = await fetch(endpoint, options);
      
      // Handle rate limit headers
      if (response.status === 429) {
        const retryAfter = parseInt(response.headers.get('Retry-After') || '60');
        await this.sleep(retryAfter * 1000);
        return this.request(endpoint, options); // Retry
      }
      
      return response;
    } catch (error) {
      if (error.status === 429) {
        await this.handleRateLimitError(error);
      }
      throw error;
    }
  }
}
```

### 6. Listening Streak Definition

**Streak Calculation:**
- **Day Definition**: User's local timezone (from `user_preferences.timezone`)
- **Valid Day**: At least one play with `is_play = true` and `duration_listened >= 30 seconds`
- **Streak Logic**: 
  - Count consecutive days from most recent play date backwards
  - Break streak if gap > 1 day
  - Timezone-aware: Same calendar day in user's timezone

**Implementation:**
```typescript
// apps/api/src/services/statistics/streak-calculator.ts
export class StreakCalculator {
  async calculateStreak(userId: string): Promise<StreakInfo> {
    const user = await db.users.findUnique({ 
      where: { id: userId },
      include: { preferences: true }
    });
    
    const timezone = user?.preferences?.timezone || 'UTC';
    const now = this.getCurrentDateInTimezone(timezone);
    
    // Get all dates with plays
    const playDates = await this.getPlayDates(userId, timezone);
    
    if (playDates.length === 0) {
      return { current: 0, longest: 0, lastPlayDate: null };
    }
    
    // Sort dates descending
    playDates.sort((a, b) => b.getTime() - a.getTime());
    
    // Calculate current streak
    let currentStreak = 0;
    let expectedDate = now;
    
    for (const playDate of playDates) {
      const daysDiff = this.daysBetween(playDate, expectedDate);
      
      if (daysDiff === 0 || daysDiff === 1) {
        currentStreak++;
        expectedDate = this.subtractDays(playDate, 1);
      } else {
        break; // Streak broken
      }
    }
    
    // Calculate longest streak
    const longestStreak = this.calculateLongestStreak(playDates);
    
    return {
      current: currentStreak,
      longest: longestStreak,
      lastPlayDate: playDates[0]
    };
  }
  
  private getCurrentDateInTimezone(timezone: string): Date {
    const now = new Date();
    const formatter = new Intl.DateTimeFormat('en-US', {
      timeZone: timezone,
      year: 'numeric',
      month: '2-digit',
      day: '2-digit'
    });
    
    const parts = formatter.formatToParts(now);
    const year = parseInt(parts.find(p => p.type === 'year')!.value);
    const month = parseInt(parts.find(p => p.type === 'month')!.value) - 1;
    const day = parseInt(parts.find(p => p.type === 'day')!.value);
    
    return new Date(Date.UTC(year, month, day));
  }
}
```

**File Location:** `apps/api/src/services/statistics/streak-calculator.ts`

## Enhanced File Structure

```
apps/api/src/
├── services/
│   ├── listening-history/
│   │   ├── deduplication.ts          # Deduplication logic
│   │   ├── play-classifier.ts        # Play vs skip classification
│   │   ├── import-service.ts          # Historical import handler
│   │   └── recording-service.ts      # Event recording service
│   ├── statistics/
│   │   ├── streak-calculator.ts       # Streak calculation
│   │   ├── aggregator.ts              # Statistics aggregation
│   │   └── cache-manager.ts           # Statistics caching
│   └── listening-tracker/
│       ├── sync-strategy.ts           # Sync strategy (client + polling)
│       ├── spotify-tracker.ts         # Spotify event handler
│       └── polling-service.ts         # Server polling worker
├── integrations/
│   ├── spotify/
│   │   ├── client.ts                  # Spotify API client
│   │   ├── oauth.ts                   # OAuth handler
│   │   └── rate-limiter.ts            # Rate limiting
│   ├── apple-music/
│   │   └── client.ts                  # Apple Music API client
│   └── base-client.ts                 # Base API client with rate limiting
└── jobs/
    ├── sync-listening-history.ts      # Background sync job
    └── process-import-job.ts           # Import processing job
```

## Database Schema Enhancements

**Add to `listening_history` table:**
```sql
-- Add play classification fields
ALTER TABLE listening_history ADD COLUMN play_weight DECIMAL(3,2) DEFAULT 1.0;
ALTER TABLE listening_history ADD COLUMN classification JSONB DEFAULT '{}';

-- Add index for deduplication queries
CREATE INDEX idx_listening_history_dedup 
ON listening_history(user_id, track_id, listened_at) 
WHERE is_play = true;

-- Add index for streak calculation
CREATE INDEX idx_listening_history_streak 
ON listening_history(user_id, DATE(listened_at), is_play) 
WHERE is_play = true;
```

**Add `import_jobs` table:**
```sql
CREATE TABLE import_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    format VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_entries INTEGER NOT NULL,
    processed_entries INTEGER DEFAULT 0,
    successful_entries INTEGER DEFAULT 0,
    failed_entries INTEGER DEFAULT 0,
    error_log JSONB DEFAULT '[]',
    file_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    completed_at TIMESTAMP
);

CREATE INDEX idx_import_jobs_user_id ON import_jobs(user_id);
CREATE INDEX idx_import_jobs_status ON import_jobs(status);
```

## API Endpoint Additions

**Historical Import:**
- `POST /api/v1/listening-history/import` - Upload and queue import file
  - Request: Multipart form with file and format
  - Response: Import job ID and status
- `GET /api/v1/listening-history/import/:jobId` - Get import job status
  - Response: Progress, success/failure counts, errors

**File Location:** `apps/api/src/routes/listening-history.ts`

## Testing Specifications

**Unit Tests Required:**
- `apps/api/src/services/listening-history/__tests__/deduplication.test.ts`
- `apps/api/src/services/listening-history/__tests__/play-classifier.test.ts`
- `apps/api/src/services/statistics/__tests__/streak-calculator.test.ts`
- `apps/api/src/integrations/spotify/__tests__/rate-limiter.test.ts`

**Test Coverage Targets:**
- Deduplication logic: 100% coverage
- Play classification: 100% coverage
- Streak calculation: 95% coverage (edge cases)
- Rate limiting: 90% coverage

## Performance Benchmarks

**Sync Performance:**
- Client event processing: < 100ms
- Server polling batch: < 2 seconds for 50 tracks
- Deduplication check: < 50ms per event
- Import processing: 100 entries/second

**Database Performance:**
- Streak calculation: < 500ms for 1 year of history
- Deduplication query: < 100ms with indexes
- Statistics aggregation: < 2 seconds for monthly stats

## Configuration Values

**Environment Variables:**
```bash
# Sync Configuration
LISTENING_SYNC_POLL_INTERVAL_SPOTIFY=30      # seconds
LISTENING_SYNC_POLL_INTERVAL_APPLE_MUSIC=60  # seconds
LISTENING_SYNC_POLL_INTERVAL_YOUTUBE=60      # seconds
LISTENING_SYNC_REAL_TIME_WINDOW=5            # seconds

# Deduplication
LISTENING_DEDUP_WINDOW_MINUTES=5

# Play Classification
LISTENING_MIN_DURATION_SECONDS=30
LISTENING_MIN_PERCENTAGE=0.2
LISTENING_FULL_PLAY_PERCENTAGE=0.8

# Import Limits
IMPORT_MAX_BATCH_SIZE=1000
IMPORT_PROCESSING_BATCH_SIZE=100
IMPORT_PROCESSING_RATE_LIMIT_MS=1000
```

This optimized plan addresses all critical questions with specific implementation details, file paths, and technical specifications.

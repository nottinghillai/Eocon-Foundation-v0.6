# Plan Optimization Summary

## Critical Questions Answered

### ✅ 1. Real-Time Sync Specifications
- **Timing**: 5 seconds from playback **end** (not start)
- **Strategy**: Hybrid (client events + server polling)
- **Polling Intervals**: Spotify 30s, Apple Music 60s, YouTube Music 60s
- **Implementation**: `apps/api/src/services/listening-tracker/sync-strategy.ts`

### ✅ 2. Deduplication Window
- **Window**: 5 minutes (300 seconds)
- **Matching**: Same user + track + timestamp within ±5 minutes
- **Priority**: Spotify > Apple Music > YouTube > Manual
- **Logic**: Longer duration wins, then more recent timestamp
- **Implementation**: `apps/api/src/services/listening-history/deduplication.ts`

### ✅ 3. Partial Listen Thresholds
- **Recorded**: ≥ 30 seconds
- **Counted as Play**: ≥ 80% duration OR ≥ 30 seconds
- **Counted as Skip**: < 30 seconds OR < 20% duration
- **Play Weight**: 0.5 for 20-50%, 1.0 for 50-80%+
- **Implementation**: `apps/api/src/services/listening-history/play-classifier.ts`

### ✅ 4. Historical Import
- **Formats**: CSV, JSON, Spotify Export, Last.fm, Apple Music
- **Max Batch**: 1000 entries per request
- **Processing**: Batches of 100, 1 batch/second
- **Implementation**: `apps/api/src/services/listening-history/import-service.ts`

### ✅ 5. Streaming Service APIs
- **Spotify**: 300 req/30s, Web Playback SDK for real-time
- **Apple Music**: 600 req/min, limited history access
- **YouTube Music**: 10k units/day, limited API support
- **Rate Limiting**: Automatic with retry logic
- **Implementation**: `apps/api/src/integrations/{service}/client.ts`

### ✅ 6. Listening Streak
- **Day Definition**: User's local timezone
- **Valid Day**: ≥ 1 play with ≥ 30 seconds duration
- **Calculation**: Consecutive days from most recent backwards
- **Break**: Gap > 1 day breaks streak
- **Implementation**: `apps/api/src/services/statistics/streak-calculator.ts`

## Key Enhancements Made

### 1. Added Specific File Paths
- All services have explicit file locations
- Clear separation of concerns
- Easier code navigation

### 2. Added Configuration Values
- Environment variables for all thresholds
- Configurable polling intervals
- Rate limiting parameters

### 3. Enhanced Database Schema
- Added `play_weight` and `classification` fields
- New indexes for deduplication and streaks
- `import_jobs` table for tracking imports

### 4. Added Implementation Code Examples
- TypeScript code snippets for key logic
- Clear algorithm implementations
- Error handling patterns

### 5. Enhanced Testing Specifications
- Specific test file locations
- Coverage targets per component
- Test strategy clarifications

## Next Steps

1. **Review** `plan1_optimized.md` for complete technical details
2. **Update** original plan with these clarifications
3. **Create** wave decomposition using optimized specifications
4. **Begin** implementation with clear requirements

## File Locations Reference

**Core Services:**
- Sync Strategy: `apps/api/src/services/listening-tracker/sync-strategy.ts`
- Deduplication: `apps/api/src/services/listening-history/deduplication.ts`
- Play Classification: `apps/api/src/services/listening-history/play-classifier.ts`
- Import Service: `apps/api/src/services/listening-history/import-service.ts`
- Streak Calculator: `apps/api/src/services/statistics/streak-calculator.ts`

**Integrations:**
- Spotify Client: `apps/api/src/integrations/spotify/client.ts`
- Apple Music Client: `apps/api/src/integrations/apple-music/client.ts`
- Base Client: `apps/api/src/integrations/base-client.ts`

**Background Jobs:**
- Sync Job: `apps/api/src/jobs/sync-listening-history.ts`
- Import Job: `apps/api/src/jobs/process-import-job.ts`

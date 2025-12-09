Created an optimized plan addressing the critical questions. Here's what was added:
## Optimizations complete
### 1. Real-time sync — clarified
- Timing: 5 seconds from playback end (not start)
- Hybrid approach: client-side events (Spotify SDK) + server polling fallback
- Polling intervals: Spotify 30s, Apple Music 60s, YouTube Music 60s
- Implementation files and code examples provided
### 2. Deduplication — specified
- Window: 5 minutes (300 seconds)
- Priority order: Spotify > Apple Music > YouTube > Manual
- Merge logic: longer duration wins, then more recent timestamp
- Database indexes added for performance
### 3. Partial listens — thresholds defined
- Recorded: ≥ 30 seconds
- Full play: ≥ 80% duration OR ≥ 30 seconds
- Skip: < 30 seconds OR < 20% duration
- Play weight system: 0.5 for partial, 1.0 for full
### 4. Historical import — formats & limits
- Supported: CSV, JSON, Spotify Export, Last.fm, Apple Music
- Max batch: 1000 entries per request
- Processing: 100 entries/second with rate limiting
- Background job system with progress tracking
### 5. Streaming APIs — endpoints & limits
- Spotify: 300 req/30s, Web Playback SDK for real-time
- Apple Music: 600 req/min, limited history access
- YouTube Music: 10k units/day, limited API support
- Rate limiting with automatic retry logic
### 6. Listening streak — timezone-aware
- Day definition: user's local timezone
- Valid day: ≥ 1 play with ≥ 30 seconds
- Calculation: consecutive days from most recent backwards
- Break condition: gap > 1 day
## Deliverables
1. `plan1_optimized.md` — Complete optimized plan with:
   - Implementation code examples
   - Specific file paths
   - Database schema enhancements
   - Configuration values
   - Testing specifications
2. `optimization_summary.md` — Quick reference summary
## Next steps
The plan is ready for wave decomposition with these clarifications. All ambiguous requirements are now specified with:
- Exact thresholds and values
- File paths and structure
- Code implementation examples
- Database schema additions
- Configuration parameters
You can proceed with implementation using these specifications.

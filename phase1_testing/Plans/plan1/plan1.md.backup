# Plan: Music Listening Tracker

## Overview

A comprehensive music listening tracking application that allows users to track their listening history, discover new music, analyze listening patterns, and build personalized music statistics. The app provides insights into listening habits, favorite artists, genres, and tracks over time.

The application serves as a personal music analytics platform that helps users understand their listening behavior, discover music trends, and maintain a detailed history of their musical journey. The app works across multiple platforms (web, mobile, desktop) and integrates with popular music streaming services including Spotify, Apple Music, and YouTube Music.

## Purpose

Create a personal music analytics platform that helps users understand their listening behavior, discover music trends, and maintain a detailed history of their musical journey. The app should work across multiple platforms and integrate with popular music streaming services.

The primary goals are:
1. Provide users with comprehensive insights into their music listening habits
2. Enable automatic tracking of listening history from multiple streaming services
3. Generate personalized music recommendations based on listening patterns
4. Create a social platform for music discovery and sharing
5. Offer detailed analytics and statistics to help users understand their music preferences

## Requirements

### Functional Requirements

1. **Listening History Tracking**
   - Automatically track songs played from connected streaming services
   - Manual entry for songs listened to offline or from other sources
   - Timestamp and duration tracking for each listening session
   - Support for multiple music sources (Spotify, Apple Music, YouTube Music, etc.)
   - Real-time synchronization with streaming services
   - Batch import of historical listening data
   - Deduplication of listening events
   - Support for partial listens (tracking when user skips songs)

2. **User Profile Management**
   - User registration and authentication via email/password or OAuth
   - Profile customization (avatar, bio, display name)
   - Preferences and settings management (theme, notifications, privacy)
   - Privacy controls for listening data (private, friends-only, public)
   - Account deletion and data export (GDPR compliance)
   - Multi-factor authentication support
   - Session management and device tracking

3. **Music Discovery**
   - Recommendations based on listening history using collaborative filtering
   - Similar artists and tracks discovery using music metadata APIs
   - Genre exploration with filtering and sorting options
   - Trending music in user's preferred genres
   - Personalized daily/weekly discovery playlists
   - "Discover Weekly" style automated recommendations
   - Mood-based music discovery
   - Decade and era-based exploration

4. **Analytics & Statistics**
   - Listening time statistics (daily, weekly, monthly, yearly, all-time)
   - Top artists, tracks, and genres with customizable time ranges
   - Listening trends over time with visualizations (charts, graphs)
   - Listening streak tracking (consecutive days with plays)
   - Custom date range analysis
   - Comparative analytics (this period vs previous period)
   - Listening patterns by time of day and day of week
   - Genre distribution visualization
   - Artist discovery timeline

5. **Playlist Management**
   - Create and manage playlists (public, private, collaborative)
   - Auto-generated playlists based on listening patterns
   - Share playlists with other users via link or social media
   - Import/export playlists in various formats (JSON, CSV, M3U)
   - Playlist templates and smart playlists
   - Bulk track operations (add, remove, reorder)
   - Playlist descriptions and cover images
   - Duplicate detection and removal

6. **Social Features**
   - Share listening statistics via images or links
   - Follow friends and see their listening activity feed
   - Compare music taste with friends (compatibility scores)
   - Community features and music discussions
   - User profiles with public listening statistics
   - Activity feed showing friends' recent listens
   - Comment and like functionality on shared content
   - Group playlists and collaborative listening sessions

### Non-Functional Requirements

1. **Performance**
   - Real-time listening history updates (within 5 seconds of play)
   - Fast query response times (< 2 seconds for analytics queries)
   - Efficient data storage and retrieval with proper indexing
   - Support for large listening history databases (millions of records per user)
   - Lazy loading and pagination for large datasets
   - Client-side caching for frequently accessed data
   - Optimized database queries with query plan analysis

2. **Security**
   - Secure authentication and authorization using JWT tokens
   - Encryption of sensitive user data at rest (AES-256)
   - Encryption of data in transit (TLS 1.3)
   - Privacy controls for sharing listening data
   - Secure API integrations with streaming services (OAuth 2.0)
   - Input validation and sanitization
   - SQL injection prevention using parameterized queries
   - XSS prevention with content security policies
   - Rate limiting to prevent abuse
   - Security audit logging

3. **Reliability**
   - 99.9% uptime SLA with monitoring and alerting
   - Data backup and recovery (daily backups, point-in-time recovery)
   - Error handling and logging (structured logging with correlation IDs)
   - Graceful degradation when external services are unavailable
   - Health check endpoints for monitoring
   - Circuit breaker pattern for external API calls
   - Retry logic with exponential backoff
   - Dead letter queues for failed processing

4. **Usability**
   - Intuitive user interface with clear navigation
   - Responsive design (mobile, tablet, desktop) with breakpoints
   - Accessibility compliance (WCAG 2.1 AA minimum)
   - Multi-language support (i18n) with at least English, Spanish, French
   - Keyboard navigation support
   - Screen reader compatibility
   - Consistent design system and UI components
   - Loading states and progress indicators
   - Helpful error messages and user guidance

5. **Scalability**
   - Support for millions of users with horizontal scaling
   - Horizontal scaling capability (stateless services)
   - Efficient database design with proper normalization
   - Database sharding strategy for large datasets
   - Caching strategies for high traffic (Redis, CDN)
   - Load balancing across multiple instances
   - Auto-scaling based on metrics
   - Database connection pooling and read replicas

## Architecture

### System Architecture

The application follows a microservices architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    Client Applications                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │   Web    │  │  Mobile  │  │  Desktop │  │   API    │          │
│  │   App    │  │   App    │  │   App    │  │  Clients │          │
│  │ (Next.js)│  │ (React   │  │ (Electron│  │          │          │
│  │          │  │  Native) │  │   20+)   │  │          │          │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘          │
└────────────────────┬───────────────────────────────────────────────┘
                     │ HTTPS/WSS
┌────────────────────┴───────────────────────────────────────────────┐
│                   API Gateway / Load Balancer                      │
│         (Authentication, Rate Limiting, Routing, SSL)             │
│         (AWS API Gateway / Nginx / Kong)                          │
└────────────────────┬───────────────────────────────────────────────┘
                     │
┌────────────────────┴───────────────────────────────────────────────┐
│              Microservices Architecture                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │   User       │  │  Listening    │  │  Analytics   │           │
│  │  Service    │  │  Service      │  │  Service     │           │
│  │  (Auth,     │  │  (History     │  │  (Stats,     │           │
│  │   Profile)  │  │   Tracking)   │  │   Reports)   │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │  Discovery   │  │  Playlist    │  │  Streaming   │           │
│  │  Service     │  │  Service     │  │  Integration │           │
│  │  (Recommend │  │  (CRUD,      │  │  Service     │           │
│  │   Engine)   │  │   Sharing)   │  │  (API Sync)  │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│  ┌──────────────┐                                                │
│  │  Social      │                                                │
│  │  Service     │                                                │
│  │  (Follows,  │                                                │
│  │   Activity) │                                                │
│  └──────────────┘                                                │
└────────────────────┬───────────────────────────────────────────────┘
                     │
┌────────────────────┴───────────────────────────────────────────────┐
│              Message Queue & Event Bus                             │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │   AWS SQS   │  │  Redis       │                             │
│  │             │  │  Pub/Sub     │                             │
│  └──────────────┘  └──────────────┘                             │
└────────────────────┬───────────────────────────────────────────────┘
                     │
┌────────────────────┴───────────────────────────────────────────────┐
│              Data Layer                                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │ PostgreSQL   │  │   Redis      │  │  S3/Storage  │           │
│  │  (Primary)   │  │  (Cache)     │  │  (Files)     │           │
│  │  Read        │  │  Session     │  │  CDN         │           │
│  │  Replicas    │  │  Store       │  │  (Assets)    │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│  ┌──────────────┐                                                │
│  │ Elasticsearch│                                                │
│  │  (Search)    │                                                │
│  └──────────────┘                                                │
└───────────────────────────────────────────────────────────────────┘
                     │
┌────────────────────┴───────────────────────────────────────────────┐
│              External Services                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐           │
│  │   Spotify    │  │  Apple Music │  │  YouTube     │           │
│  │     API      │  │     API      │  │   Music API  │           │
│  └──────────────┘  └──────────────┘  └──────────────┘           │
│  ┌──────────────┐  ┌──────────────┐                             │
│  │  MusicBrainz │  │   Last.fm    │                             │
│  │     API      │  │     API      │                             │
│  └──────────────┘  └──────────────┘                             │
└───────────────────────────────────────────────────────────────────┘
```

**Architecture Principles:**
- **Microservices**: Each service handles a specific domain (users, listening, analytics, etc.)
- **API Gateway**: Single entry point for all client requests with authentication and rate limiting
- **Event-Driven**: Services communicate via message queues for asynchronous processing
- **Database per Service**: Each service has its own database to ensure loose coupling
- **Caching Layer**: Redis for session management and frequently accessed data
- **CDN**: CloudFront/S3 for static assets and media files
- **Horizontal Scaling**: Services can scale independently based on load

### Technology Stack

#### Frontend
- **Web**: Next.js 14+ with React 18+ and TypeScript 5+
- **State Management**: Zustand or Redux Toolkit for global state
- **Styling**: Tailwind CSS 3+ with CSS Modules for component-specific styles
- **UI Components**: Radix UI or shadcn/ui for accessible components
- **Data Fetching**: React Query (TanStack Query) for server state management
- **Forms**: React Hook Form with Zod validation
- **Mobile**: React Native 0.72+ with TypeScript (optional Phase 2+)
- **Desktop**: Electron with Next.js (optional Phase 3+)

#### Backend
- **Runtime**: Node.js 20+ LTS
- **Framework**: Express.js 4.18+ with TypeScript
- **API Style**: RESTful API with GraphQL support (optional Phase 2+)
- **Validation**: Zod for runtime type validation
- **Error Handling**: Custom error middleware with structured error responses
- **Logging**: Winston or Pino for structured logging
- **API Documentation**: Swagger/OpenAPI 3.0 with auto-generated docs

#### Database
- **Primary**: PostgreSQL 15+ for relational data (users, playlists, listening history)
- **Cache**: Redis 7+ for session management, caching, and pub/sub
- **Search**: Elasticsearch 8+ for music search and full-text search (optional Phase 2+)
- **ORM**: Prisma 5+ for database access and migrations
- **Migrations**: Prisma Migrate for schema versioning

#### Infrastructure
- **Hosting**: AWS (EC2, ECS/EKS, RDS, S3, CloudFront, Route53)
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes (production) or Docker Compose (development)
- **CI/CD**: GitHub Actions with automated testing and deployment
- **Monitoring**: CloudWatch, Prometheus + Grafana
- **Logging**: CloudWatch Logs or ELK Stack
- **Error Tracking**: Sentry for error monitoring

#### External Integrations
- **Spotify Web API**: OAuth 2.0, Recently Played, Currently Playing, Track Metadata
- **Apple Music API**: OAuth, User Library, Track Metadata
- **YouTube Music API**: OAuth, Watch History, Video Metadata
- **Last.fm API**: Scrobbling, Track Metadata, Similar Artists
- **MusicBrainz API**: Free music metadata database
- **Discogs API**: Album and artist information

## User Flows

### Flow 1: User Registration and Setup
1. User visits application homepage
2. User clicks "Sign Up" button in navigation
3. User selects authentication method:
   - Email/password registration form
   - OAuth with Google
   - OAuth with Apple (iOS/macOS)
4. User provides required information:
   - Email address (if email/password)
   - Password (minimum 8 characters, complexity requirements)
   - Display name (optional)
5. System validates input and creates user account
6. User receives email verification link (if email/password)
7. User clicks verification link in email
8. System redirects user to onboarding flow
9. User sees streaming service connection prompt
10. User clicks "Connect Spotify" (or other service)
11. System redirects to OAuth flow for streaming service
12. User authorizes application access
13. System receives OAuth callback with tokens
14. System fetches initial listening history (last 30 days)
15. System processes and stores listening history
16. User is presented with onboarding tutorial:
    - Dashboard overview
    - How to view statistics
    - How to create playlists
    - Privacy settings
17. User completes onboarding (can skip)
18. User lands on personalized dashboard

### Flow 2: View Listening Statistics
1. User navigates to "Statistics" page via navigation menu
2. System loads user's listening history from database
3. System checks cache for recent statistics
4. If cache miss, system calculates statistics:
   - Query listening history for time period
   - Aggregate top artists by play count
   - Aggregate top tracks by play count
   - Aggregate top genres by listening time
   - Calculate total listening time
   - Calculate listening streaks
5. System stores computed statistics in cache
6. System displays statistics dashboard:
   - Overview cards (total time, total tracks, streak)
   - Charts and graphs (trends over time)
   - Top artists list with play counts
   - Top tracks list with play counts
   - Top genres list with percentages
7. User selects time period filter (week, month, year, all-time, custom)
8. System updates statistics display with new time period
9. User can drill down into specific categories:
   - Click artist to see all tracks by that artist
   - Click track to see detailed play history
   - Click genre to see all tracks in that genre
10. User can share statistics:
    - Click "Share" button
    - Select sharing format (image, link)
    - Customize what to share
    - Generate shareable content
    - Copy link or download image

### Flow 3: Track New Listening Session
1. User starts playing music on connected streaming service (Spotify, Apple Music, etc.)
2. Streaming service webhook/API notifies our system:
   - Option A: Webhook callback from streaming service (if supported)
   - Option B: Polling mechanism checks currently playing track every 30 seconds
   - Option C: Client-side SDK sends listening events
3. System receives listening event with:
   - Track ID from streaming service
   - Track name, artist, album
   - Timestamp
   - Duration listened
   - Source (which streaming service)
4. System validates listening event:
   - Check minimum listening duration (30 seconds)
   - Check for duplicate events (within 5 minutes)
   - Validate user authentication
5. System records listening event in database:
   - Insert into listening_history table
   - Update track metadata if needed
   - Update artist metadata if needed
6. System publishes event to message queue for async processing
7. Background worker processes event:
   - Update user statistics cache
   - Update real-time statistics
   - Check if recommendations need updating
   - Update listening streaks
8. System updates user's listening history in real-time
9. System may trigger recommendations update if patterns change
10. User sees updated statistics on dashboard (if viewing)

### Flow 4: Discover New Music
1. User navigates to "Discover" page via navigation menu
2. System loads user's listening history from cache or database
3. System analyzes user's listening patterns:
   - Extract top genres from listening history
   - Extract top artists from listening history
   - Analyze listening patterns (time of day, day of week)
   - Identify music preferences and trends
4. System generates recommendations using algorithm:
   - Collaborative filtering: Find similar users and recommend their tracks
   - Content-based: Find similar artists/tracks using metadata
   - Hybrid approach combining both methods
   - Exclude recently played tracks
   - Weight recommendations by recency and frequency
5. System fetches additional metadata from music APIs:
   - Track preview URLs
   - Album artwork
   - Artist images
   - Track popularity scores
6. System displays recommendations:
   - "Recommended for You" section
   - "Similar Artists" section
   - "Trending in Your Genres" section
   - "Discover Weekly" playlist
7. User browses recommendations with infinite scroll or pagination
8. User can preview tracks:
   - Click play button on track
   - 30-second preview plays
   - User can skip or continue listening
9. User can interact with recommendations:
   - Click "Add to Playlist" to add track to playlist
   - Click "Like" to mark as favorite
   - Click "Hide" to remove from recommendations
   - Click artist name to see artist page
10. System learns from user interactions:
    - Update recommendation algorithm weights
    - Adjust future recommendations
    - Store user preferences

### Flow 5: Create and Manage Playlist
1. User navigates to "Playlists" page via navigation menu
2. System displays user's existing playlists:
   - Grid or list view
   - Playlist cards with name, track count, cover image
   - Filter and sort options
3. User clicks "Create Playlist" button
4. System displays playlist creation form:
   - Playlist name input (required)
   - Description textarea (optional)
   - Privacy toggle (public/private)
   - Collaborative toggle (optional)
5. User provides playlist details and clicks "Create"
6. System creates playlist record in database
7. System redirects user to empty playlist edit page
8. User searches for tracks to add:
   - Click "Add Tracks" button
   - Search dialog opens
   - User types track name, artist, or album
   - System searches local database and streaming service APIs
   - System displays search results with preview option
9. User selects tracks from search results:
   - Click checkbox or "Add" button for each track
   - Selected tracks appear in "To Add" section
   - User can remove tracks before adding
10. User clicks "Add to Playlist" button
11. System adds tracks to playlist:
    - Insert records into playlist_tracks table
    - Maintain track order (position field)
    - Update playlist metadata (track count, duration)
12. User can reorder tracks:
    - Drag and drop tracks in playlist
    - Update position values in database
13. User can remove tracks:
    - Click remove button on track
    - Confirm removal dialog
    - Remove track from playlist_tracks table
14. User can manage playlist settings:
    - Edit name and description
    - Change privacy settings
    - Add playlist cover image
    - Delete playlist
15. User can share playlist:
    - Click "Share" button
    - Choose sharing method (link, social media)
    - Generate shareable link
    - Copy link or share via social media
16. User saves playlist (auto-saved or explicit save button)
17. System displays success message and redirects to playlist view

## Business Logic

### Listening History Rules

**Recording Requirements:**
- Each listening session must record:
  - Track ID (from streaming service)
  - Track name (canonical)
  - Artist name(s) (comma-separated for multiple artists)
  - Album name
  - Genre(s) (array, primary genre first)
  - Duration listened (integer, seconds)
  - Track duration (integer, seconds, for percentage calculation)
  - Timestamp (ISO 8601 format, UTC)
  - Source (which streaming service: "spotify", "apple_music", "youtube_music", "manual")
  - User ID (foreign key)
  - Is_skipped (boolean, true if user skipped before completion)

**Counting Rules:**
- Minimum listening duration: 30 seconds to count as a play
- Skips within 30 seconds don't count as plays (marked as skipped)
- Partial listens (30-80% of track) count as 0.5 plays
- Full listens (80%+ of track) count as 1 play
- Duplicate plays within 5 minutes count as single play (deduplication)
- Background plays (app in background) still count if minimum duration met

**Deduplication Logic:**
- Check for same track_id + user_id + listened_at within 5-minute window
- If duplicate found, update existing record with longer duration
- If duplicate found with shorter duration, discard new record

**Manual Entry Rules:**
- Users can manually add listening history entries
- Manual entries require:
  - Track name (required)
  - Artist name (required)
  - Album name (optional)
  - Duration listened (required)
  - Timestamp (defaults to current time, can be edited)
- System attempts to match manual entries with track metadata:
  - Search local database for matching track
  - If found, link to existing track record
  - If not found, create new track record
  - Fetch additional metadata from music APIs if available

### Statistics Calculation

**Top Artists Calculation:**
- Query listening_history filtered by user_id and time_range
- Group by artist_name
- Count total plays (sum of is_play = true)
- Sum total listening_time
- Rank by play count descending
- Limit to top N (default 50)
- Cache results with TTL based on time_range (1 hour for recent, 24 hours for historical)

**Top Tracks Calculation:**
- Query listening_history filtered by user_id and time_range
- Group by track_id and track_name
- Count total plays
- Sum total listening_time
- Rank by play count descending
- Limit to top N (default 50)
- Include artist_name in results
- Cache results with TTL

**Top Genres Calculation:**
- Query listening_history filtered by user_id and time_range
- Unnest genre array
- Group by genre
- Sum total listening_time per genre
- Calculate percentage of total listening time
- Rank by listening_time descending
- Limit to top N (default 20)
- Cache results with TTL

**Listening Time Calculation:**
- Sum of all duration_listened values where is_play = true
- Filter by user_id and time_range
- Convert seconds to human-readable format (hours, minutes, seconds)
- Calculate daily average: total_time / number_of_days_in_range
- Cache results with TTL

**Streak Calculation:**
- Query listening_history filtered by user_id
- Group by date (listened_at::date)
- Filter dates with at least one play
- Order by date descending
- Count consecutive days from most recent date
- Break streak if gap > 1 day
- Cache current streak (update daily)

**Trends Calculation:**
- Compare current period vs previous period (e.g., this month vs last month)
- Calculate percentage change:
  - Artist plays: (current_count - previous_count) / previous_count * 100
  - Listening time: (current_time - previous_time) / previous_time * 100
- Identify trending artists (biggest increase)
- Identify declining artists (biggest decrease)
- Generate trend insights (e.g., "You listened to 20% more jazz this month")

### Recommendation Algorithm

**Collaborative Filtering:**
1. Find users with similar listening patterns:
   - Calculate similarity score using cosine similarity or Jaccard index
   - Compare top artists, genres, and tracks
   - Consider listening time patterns
2. Identify tracks liked by similar users but not yet played by current user
3. Score recommendations based on:
   - Similarity score of recommending user
   - Play count of track by similar users
   - Recency of plays by similar users

**Content-Based Filtering:**
1. Analyze user's listening history:
   - Extract top genres, artists, and tracks
   - Identify music characteristics (tempo, energy, valence)
   - Analyze listening patterns (time of day, day of week)
2. Find similar tracks using music metadata:
   - Query music APIs for similar artists
   - Use genre and subgenre matching
   - Consider audio features (if available from APIs)
3. Score recommendations based on:
   - Genre similarity
   - Artist similarity
   - Track characteristics similarity

**Hybrid Approach:**
- Combine collaborative and content-based scores
- Weight by user's listening history size:
  - New users (< 100 plays): More content-based
  - Active users (> 1000 plays): More collaborative
- Apply diversity factor to avoid recommending only similar tracks
- Exclude recently played tracks (last 7 days)
- Exclude tracks user has explicitly hidden
- Weight by recency: Recent listening patterns weighted higher

**Recommendation Refresh:**
- Generate recommendations daily via scheduled job
- Store recommendations in cache (Redis)
- Refresh on demand if user requests new recommendations
- Limit to top 100 recommendations per user
- Categorize recommendations (artists, tracks, genres, playlists)

### Privacy Controls

**Listening History Visibility:**
- **Private**: Only user can see their listening history
- **Friends**: Only followed users can see listening history
- **Public**: Anyone can see listening history

**Default Settings:**
- New users: Listening history set to "Private"
- Users can change privacy settings at any time
- Privacy changes apply retroactively to existing data

**Data Sharing Controls:**
- Users can opt out of data sharing with streaming services
- Users can opt out of anonymous analytics
- Users can control what data is used for recommendations

**Data Deletion:**
- Users can delete individual listening history entries
- Users can delete all listening history
- Users can delete entire account (GDPR compliance)
- Deleted data is permanently removed within 30 days
- Backup data is also deleted within retention period

**Data Export:**
- Users can export their data in JSON or CSV format
- Export includes:
  - Listening history
  - Playlists
  - Statistics
  - User preferences
- Export is generated asynchronously and sent via email
- Export link expires after 7 days

## Integration Points

### Streaming Service APIs

**Spotify Web API:**
- **Authentication**: OAuth 2.0 Authorization Code Flow
- **Endpoints Used**:
  - `GET /v1/me/player/recently-played` - Get recently played tracks
  - `GET /v1/me/player/currently-playing` - Get currently playing track
  - `GET /v1/tracks/{id}` - Get track metadata
  - `GET /v1/artists/{id}` - Get artist metadata
  - `GET /v1/artists/{id}/related-artists` - Get similar artists
  - `GET /v1/recommendations` - Get track recommendations
- **Rate Limits**: 300 requests per 30 seconds per user
- **Token Refresh**: Automatically refresh access tokens using refresh tokens
- **Webhook Support**: Not available, use polling or client-side SDK

**Apple Music API:**
- **Authentication**: OAuth 2.0 with MusicKit
- **Endpoints Used**:
  - `GET /v1/me/library/recently-added` - Get recently added tracks
  - `GET /v1/catalog/{storefront}/songs/{id}` - Get track metadata
  - `GET /v1/catalog/{storefront}/artists/{id}` - Get artist metadata
- **Rate Limits**: Varies by endpoint
- **Token Refresh**: Automatically refresh access tokens
- **Limitations**: Requires Apple Developer account, limited access to listening history

**YouTube Music API:**
- **Authentication**: OAuth 2.0
- **Endpoints Used**:
  - YouTube Data API v3 for watch history (if available)
  - Custom endpoints for music-specific data
- **Rate Limits**: 10,000 units per day
- **Limitations**: Limited official API support, may require unofficial methods

**Last.fm API:**
- **Authentication**: API Key authentication
- **Endpoints Used**:
  - `user.getRecentTracks` - Get recent tracks (scrobbling)
  - `track.getSimilar` - Get similar tracks
  - `artist.getSimilar` - Get similar artists
  - `track.getInfo` - Get track metadata
- **Rate Limits**: 5 requests per second
- **Use Case**: Scrobbling support and additional metadata

### Music Metadata Services

**MusicBrainz API:**
- **Authentication**: User-Agent header required
- **Endpoints Used**:
  - `GET /ws/2/recording/{mbid}` - Get recording metadata
  - `GET /ws/2/artist/{mbid}` - Get artist metadata
  - `GET /ws/2/release/{mbid}` - Get release (album) metadata
- **Rate Limits**: 1 request per second
- **Use Case**: Free music metadata database, fallback for missing data

**Discogs API:**
- **Authentication**: OAuth 1.0
- **Endpoints Used**:
  - `GET /database/search` - Search for releases
  - `GET /releases/{id}` - Get release details
- **Rate Limits**: 60 requests per minute
- **Use Case**: Album artwork and detailed release information

### Authentication Providers

**OAuth 2.0 for Streaming Services:**
- Implement Authorization Code Flow with PKCE
- Store refresh tokens securely (encrypted in database)
- Automatic token refresh before expiration
- Handle token revocation and re-authentication

**Google OAuth:**
- **Scopes**: `openid`, `email`, `profile`
- **Use Case**: User authentication
- **Implementation**: Google Sign-In button, redirect to OAuth flow

**Apple Sign-In:**
- **Scopes**: `email`, `name`
- **Use Case**: User authentication for iOS/macOS users
- **Implementation**: Apple Sign-In button, handle callback

**Email/Password Authentication:**
- **Implementation**: Custom authentication with bcrypt password hashing
- **Security**: Password complexity requirements, rate limiting, account lockout
- **Features**: Email verification, password reset flow, account recovery

## Technical Approach

### Database Schema Design

**Users Table**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255), -- NULL if OAuth only
    display_name VARCHAR(100),
    avatar_url TEXT,
    bio TEXT,
    preferences JSONB DEFAULT '{}',
    privacy_settings JSONB DEFAULT '{"listening_history": "private"}',
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_created_at ON users(created_at);
```

**Listening_History Table**
```sql
CREATE TABLE listening_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    track_id VARCHAR(255), -- From streaming service or generated
    track_name VARCHAR(255) NOT NULL,
    artist_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),
    genre VARCHAR(100)[] DEFAULT '{}',
    duration_listened INTEGER NOT NULL, -- seconds
    track_duration INTEGER, -- seconds
    listened_at TIMESTAMP NOT NULL,
    source VARCHAR(50) NOT NULL, -- 'spotify', 'apple_music', 'youtube_music', 'manual'
    is_play BOOLEAN DEFAULT TRUE, -- false if skipped
    is_skipped BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_listening_history_user_id ON listening_history(user_id);
CREATE INDEX idx_listening_history_listened_at ON listening_history(listened_at);
CREATE INDEX idx_listening_history_track_id ON listening_history(track_id);
CREATE INDEX idx_listening_history_user_listened ON listening_history(user_id, listened_at DESC);
CREATE INDEX idx_listening_history_source ON listening_history(source);
```

**Playlists Table**
```sql
CREATE TABLE playlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    cover_image_url TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    is_collaborative BOOLEAN DEFAULT FALSE,
    track_count INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0, -- seconds
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_playlists_user_id ON playlists(user_id);
CREATE INDEX idx_playlists_is_public ON playlists(is_public);
CREATE INDEX idx_playlists_created_at ON playlists(created_at DESC);
```

**Playlist_Tracks Table**
```sql
CREATE TABLE playlist_tracks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    playlist_id UUID NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
    track_id VARCHAR(255) NOT NULL,
    track_name VARCHAR(255) NOT NULL,
    artist_name VARCHAR(255) NOT NULL,
    album_name VARCHAR(255),
    position INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT NOW(),
    added_by UUID REFERENCES users(id)
);

CREATE INDEX idx_playlist_tracks_playlist_id ON playlist_tracks(playlist_id);
CREATE INDEX idx_playlist_tracks_position ON playlist_tracks(playlist_id, position);
CREATE UNIQUE INDEX idx_playlist_tracks_unique ON playlist_tracks(playlist_id, track_id, position);
```

**Artists Table**
```sql
CREATE TABLE artists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    spotify_id VARCHAR(255),
    apple_music_id VARCHAR(255),
    genres VARCHAR(100)[] DEFAULT '{}',
    image_url TEXT,
    popularity_score INTEGER,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_artists_name ON artists(name);
CREATE INDEX idx_artists_spotify_id ON artists(spotify_id);
CREATE INDEX idx_artists_apple_music_id ON artists(apple_music_id);
```

**Tracks Table**
```sql
CREATE TABLE tracks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    artist_id UUID REFERENCES artists(id),
    artist_name VARCHAR(255) NOT NULL, -- Denormalized for quick access
    album_name VARCHAR(255),
    duration INTEGER, -- seconds
    spotify_id VARCHAR(255),
    apple_music_id VARCHAR(255),
    youtube_id VARCHAR(255),
    genre VARCHAR(100)[] DEFAULT '{}',
    popularity_score INTEGER,
    preview_url TEXT,
    image_url TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_tracks_name ON tracks(name);
CREATE INDEX idx_tracks_artist_id ON tracks(artist_id);
CREATE INDEX idx_tracks_spotify_id ON tracks(spotify_id);
CREATE INDEX idx_tracks_apple_music_id ON tracks(apple_music_id);
CREATE INDEX idx_tracks_artist_name ON tracks(artist_name);
```

**User_Streaming_Connections Table**
```sql
CREATE TABLE user_streaming_connections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service VARCHAR(50) NOT NULL, -- 'spotify', 'apple_music', 'youtube_music'
    service_user_id VARCHAR(255) NOT NULL,
    access_token TEXT NOT NULL, -- Encrypted
    refresh_token TEXT, -- Encrypted
    token_expires_at TIMESTAMP,
    scopes TEXT[] DEFAULT '{}',
    is_active BOOLEAN DEFAULT TRUE,
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, service)
);

CREATE INDEX idx_streaming_connections_user_id ON user_streaming_connections(user_id);
CREATE INDEX idx_streaming_connections_service ON user_streaming_connections(service);
CREATE INDEX idx_streaming_connections_is_active ON user_streaming_connections(is_active);
```

**Recommendations Table**
```sql
CREATE TABLE recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    track_id VARCHAR(255) NOT NULL,
    recommendation_type VARCHAR(50) NOT NULL, -- 'collaborative', 'content_based', 'trending'
    score DECIMAL(5, 4) NOT NULL, -- 0.0000 to 1.0000
    reason TEXT, -- Why this recommendation was made
    is_seen BOOLEAN DEFAULT FALSE,
    is_hidden BOOLEAN DEFAULT FALSE,
    generated_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP
);

CREATE INDEX idx_recommendations_user_id ON recommendations(user_id);
CREATE INDEX idx_recommendations_user_score ON recommendations(user_id, score DESC);
CREATE INDEX idx_recommendations_generated_at ON recommendations(generated_at);
CREATE INDEX idx_recommendations_expires_at ON recommendations(expires_at);
```

**Friends Table**
```sql
CREATE TABLE friends (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    friend_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL, -- 'pending', 'accepted', 'blocked'
    requested_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, friend_id),
    CHECK (user_id != friend_id)
);

CREATE INDEX idx_friends_user_id ON friends(user_id);
CREATE INDEX idx_friends_friend_id ON friends(friend_id);
CREATE INDEX idx_friends_status ON friends(status);
```

**Sessions Table**
```sql
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    refresh_token_hash VARCHAR(255),
    device_info JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    expires_at TIMESTAMP NOT NULL,
    last_used_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token_hash ON sessions(token_hash);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);
```

**Activity_Feed Table**
```sql
CREATE TABLE activity_feed (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    activity_type VARCHAR(50) NOT NULL, -- 'listened', 'added_playlist', 'shared_stats', 'followed_user'
    target_user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    target_resource_type VARCHAR(50), -- 'track', 'playlist', 'user', 'stats'
    target_resource_id UUID,
    metadata JSONB DEFAULT '{}',
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_activity_feed_user_id ON activity_feed(user_id);
CREATE INDEX idx_activity_feed_target_user_id ON activity_feed(target_user_id);
CREATE INDEX idx_activity_feed_created_at ON activity_feed(created_at DESC);
CREATE INDEX idx_activity_feed_activity_type ON activity_feed(activity_type);
CREATE INDEX idx_activity_feed_is_public ON activity_feed(is_public);
```

**Notifications Table**
```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- 'friend_request', 'playlist_shared', 'recommendation', 'system'
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    action_url TEXT,
    is_read BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    read_at TIMESTAMP
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);
CREATE INDEX idx_notifications_type ON notifications(type);
```

**User_Preferences Table**
```sql
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    theme VARCHAR(20) DEFAULT 'light', -- 'light', 'dark', 'auto'
    language VARCHAR(10) DEFAULT 'en', -- ISO 639-1 code
    timezone VARCHAR(50) DEFAULT 'UTC',
    email_notifications JSONB DEFAULT '{"recommendations": true, "friend_requests": true, "playlist_updates": false}',
    push_notifications JSONB DEFAULT '{}',
    privacy_settings JSONB DEFAULT '{"listening_history": "private", "profile": "public", "playlists": "private"}',
    display_settings JSONB DEFAULT '{"date_format": "YYYY-MM-DD", "time_format": "24h"}',
    music_preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);
```

**Sync_Jobs Table**
```sql
CREATE TABLE sync_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    service VARCHAR(50) NOT NULL, -- 'spotify', 'apple_music', 'youtube_music'
    status VARCHAR(20) NOT NULL, -- 'pending', 'running', 'completed', 'failed', 'cancelled'
    sync_type VARCHAR(50) NOT NULL, -- 'full', 'incremental', 'manual'
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    records_processed INTEGER DEFAULT 0,
    records_synced INTEGER DEFAULT 0,
    error_message TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_sync_jobs_user_id ON sync_jobs(user_id);
CREATE INDEX idx_sync_jobs_status ON sync_jobs(status);
CREATE INDEX idx_sync_jobs_service ON sync_jobs(service);
CREATE INDEX idx_sync_jobs_created_at ON sync_jobs(created_at DESC);
```

### API Endpoints

**API Versioning:**
- All endpoints prefixed with `/api/v1/` for version 1
- Version included in request headers: `Accept: application/vnd.musictracker.v1+json`
- Backward compatibility maintained for at least 1 major version

**Authentication**
- `POST /api/v1/auth/register` - Register new user
  - Request Body:
    ```json
    {
      "email": "user@example.com",
      "password": "SecurePass123!",
      "display_name": "John Doe"
    }
    ```
  - Response (201 Created):
    ```json
    {
      "user": {
        "id": "uuid",
        "email": "user@example.com",
        "display_name": "John Doe",
        "email_verified": false,
        "created_at": "2024-01-01T00:00:00Z"
      },
      "token": {
        "access_token": "jwt_token",
        "refresh_token": "refresh_token",
        "expires_in": 3600,
        "token_type": "Bearer"
      }
    }
    ```
  - Error Responses:
    - 400 Bad Request: Invalid input data
    - 409 Conflict: Email already exists
    - 422 Unprocessable Entity: Validation errors

- `POST /api/v1/auth/login` - Login user
  - Request Body:
    ```json
    {
      "email": "user@example.com",
      "password": "SecurePass123!"
    }
    ```
  - Response (200 OK):
    ```json
    {
      "user": {
        "id": "uuid",
        "email": "user@example.com",
        "display_name": "John Doe",
        "email_verified": true
      },
      "token": {
        "access_token": "jwt_token",
        "refresh_token": "refresh_token",
        "expires_in": 3600,
        "token_type": "Bearer"
      }
    }
    ```
  - Error Responses:
    - 401 Unauthorized: Invalid credentials
    - 429 Too Many Requests: Too many login attempts

- `POST /api/v1/auth/logout` - Logout user
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Logged out successfully"
    }
    ```

- `POST /api/v1/auth/refresh` - Refresh access token
  - Request Body:
    ```json
    {
      "refresh_token": "refresh_token_string"
    }
    ```
  - Response (200 OK):
    ```json
    {
      "token": {
        "access_token": "new_jwt_token",
        "refresh_token": "new_refresh_token",
        "expires_in": 3600,
        "token_type": "Bearer"
      }
    }
    ```
  - Error Responses:
    - 401 Unauthorized: Invalid or expired refresh token

- `GET /api/v1/auth/me` - Get current user
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "user": {
        "id": "uuid",
        "email": "user@example.com",
        "display_name": "John Doe",
        "avatar_url": "https://cdn.example.com/avatar.jpg",
        "bio": "Music enthusiast",
        "email_verified": true,
        "preferences": {},
        "privacy_settings": {
          "listening_history": "private"
        },
        "created_at": "2024-01-01T00:00:00Z"
      }
    }
    ```
  - Error Responses:
    - 401 Unauthorized: Invalid or missing token

**Listening History**
- `GET /api/v1/listening-history` - Get listening history
  - Query params: `?page=1&limit=50&start_date=2024-01-01&end_date=2024-01-31&source=spotify`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "history": [
        {
          "id": "uuid",
          "track_id": "spotify:track:abc123",
          "track_name": "Song Title",
          "artist_name": "Artist Name",
          "album_name": "Album Name",
          "genre": ["Rock", "Alternative"],
          "duration_listened": 180,
          "track_duration": 240,
          "listened_at": "2024-01-15T10:30:00Z",
          "source": "spotify",
          "is_play": true,
          "is_skipped": false
        }
      ],
      "pagination": {
        "page": 1,
        "limit": 50,
        "total": 1250,
        "total_pages": 25,
        "has_next": true,
        "has_prev": false
      }
    }
    ```
  - Error Responses:
    - 400 Bad Request: Invalid date format or query parameters
    - 401 Unauthorized: Missing or invalid token

- `POST /api/v1/listening-history` - Add manual listening entry
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "track_name": "Song Title",
      "artist_name": "Artist Name",
      "album_name": "Album Name",
      "duration_listened": 180,
      "listened_at": "2024-01-15T10:30:00Z"
    }
    ```
  - Response (201 Created):
    ```json
    {
      "entry": {
        "id": "uuid",
        "track_name": "Song Title",
        "artist_name": "Artist Name",
        "album_name": "Album Name",
        "duration_listened": 180,
        "listened_at": "2024-01-15T10:30:00Z",
        "source": "manual"
      }
    }
    ```
  - Error Responses:
    - 400 Bad Request: Missing required fields
    - 422 Unprocessable Entity: Validation errors

- `GET /api/v1/listening-history/stats` - Get listening statistics
  - Query params: `?time_range=week|month|year|all_time&start_date=2024-01-01&end_date=2024-01-31`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "total_time": {
        "seconds": 86400,
        "formatted": "24 hours 0 minutes"
      },
      "total_tracks": 150,
      "total_artists": 45,
      "streak": {
        "current": 7,
        "longest": 30
      },
      "period": {
        "start": "2024-01-01T00:00:00Z",
        "end": "2024-01-31T23:59:59Z"
      }
    }
    ```

- `GET /api/v1/listening-history/top-artists` - Get top artists
  - Query params: `?time_range=week|month|year|all_time&limit=50`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "artists": [
        {
          "name": "Artist Name",
          "play_count": 125,
          "listening_time": {
            "seconds": 18000,
            "formatted": "5 hours"
          },
          "rank": 1
        }
      ]
    }
    ```

- `GET /api/v1/listening-history/top-tracks` - Get top tracks
  - Query params: `?time_range=week|month|year|all_time&limit=50`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "tracks": [
        {
          "track_id": "spotify:track:abc123",
          "name": "Song Title",
          "artist": "Artist Name",
          "play_count": 45,
          "listening_time": {
            "seconds": 8100,
            "formatted": "2 hours 15 minutes"
          },
          "rank": 1
        }
      ]
    }
    ```

- `GET /api/v1/listening-history/top-genres` - Get top genres
  - Query params: `?time_range=week|month|year|all_time&limit=20`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "genres": [
        {
          "name": "Rock",
          "listening_time": {
            "seconds": 36000,
            "formatted": "10 hours"
          },
          "percentage": 45.5,
          "rank": 1
        }
      ]
    }
    ```

- `DELETE /api/v1/listening-history/:id` - Delete listening entry
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Listening entry deleted successfully"
    }
    ```
  - Error Responses:
    - 404 Not Found: Entry not found
    - 403 Forbidden: Entry belongs to another user

**Playlists**
- `GET /api/v1/playlists` - Get user playlists
  - Query params: `?include_public=true&limit=50&offset=0`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "playlists": [
        {
          "id": "uuid",
          "name": "My Playlist",
          "description": "Great songs",
          "cover_image_url": "https://cdn.example.com/cover.jpg",
          "is_public": false,
          "is_collaborative": false,
          "track_count": 25,
          "total_duration": 5400,
          "created_at": "2024-01-01T00:00:00Z",
          "updated_at": "2024-01-15T10:30:00Z"
        }
      ],
      "pagination": {
        "limit": 50,
        "offset": 0,
        "total": 10,
        "has_more": false
      }
    }
    ```

- `POST /api/v1/playlists` - Create playlist
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "name": "New Playlist",
      "description": "Description here",
      "is_public": false,
      "is_collaborative": false
    }
    ```
  - Response (201 Created):
    ```json
    {
      "playlist": {
        "id": "uuid",
        "name": "New Playlist",
        "description": "Description here",
        "is_public": false,
        "is_collaborative": false,
        "track_count": 0,
        "total_duration": 0,
        "created_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `GET /api/v1/playlists/:id` - Get playlist details
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "playlist": {
        "id": "uuid",
        "name": "My Playlist",
        "description": "Great songs",
        "cover_image_url": "https://cdn.example.com/cover.jpg",
        "is_public": false,
        "is_collaborative": false,
        "track_count": 25,
        "total_duration": 5400,
        "created_at": "2024-01-01T00:00:00Z"
      },
      "tracks": [
        {
          "id": "uuid",
          "track_id": "spotify:track:abc123",
          "track_name": "Song Title",
          "artist_name": "Artist Name",
          "album_name": "Album Name",
          "position": 1,
          "added_at": "2024-01-01T00:00:00Z"
        }
      ]
    }
    ```
  - Error Responses:
    - 404 Not Found: Playlist not found
    - 403 Forbidden: User doesn't have access to playlist

- `PUT /api/v1/playlists/:id` - Update playlist
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "name": "Updated Name",
      "description": "Updated description",
      "is_public": true
    }
    ```
  - Response (200 OK):
    ```json
    {
      "playlist": {
        "id": "uuid",
        "name": "Updated Name",
        "description": "Updated description",
        "is_public": true,
        "updated_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `DELETE /api/v1/playlists/:id` - Delete playlist
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Playlist deleted successfully"
    }
    ```

- `POST /api/v1/playlists/:id/tracks` - Add tracks to playlist
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "tracks": [
        {
          "track_id": "spotify:track:abc123",
          "track_name": "Song Title",
          "artist_name": "Artist Name",
          "position": 1
        }
      ]
    }
    ```
  - Response (200 OK):
    ```json
    {
      "playlist": {
        "id": "uuid",
        "track_count": 26,
        "total_duration": 5640
      },
      "added_tracks": 1
    }
    ```

- `DELETE /api/v1/playlists/:id/tracks/:track_id` - Remove track from playlist
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Track removed successfully",
      "playlist": {
        "id": "uuid",
        "track_count": 24
      }
    }
    ```

- `PUT /api/v1/playlists/:id/tracks/reorder` - Reorder tracks
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "tracks": [
        {
          "track_id": "spotify:track:abc123",
          "position": 1
        },
        {
          "track_id": "spotify:track:def456",
          "position": 2
        }
      ]
    }
    ```
  - Response (200 OK):
    ```json
    {
      "message": "Tracks reordered successfully"
    }
    ```

**Discovery**
- `GET /api/v1/discover/recommendations` - Get personalized recommendations
  - Query params: `?limit=50&type=all|artists|tracks|genres&offset=0`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "recommendations": [
        {
          "id": "uuid",
          "track_id": "spotify:track:abc123",
          "track_name": "Recommended Song",
          "artist_name": "Artist Name",
          "recommendation_type": "collaborative",
          "score": 0.85,
          "reason": "Similar users also enjoy this track",
          "preview_url": "https://preview.spotify.com/track/abc123",
          "image_url": "https://cdn.example.com/artwork.jpg"
        }
      ],
      "pagination": {
        "limit": 50,
        "offset": 0,
        "total": 100,
        "has_more": true
      }
    }
    ```

- `GET /api/v1/discover/similar-artists/:artistId` - Get similar artists
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "artists": [
        {
          "id": "uuid",
          "name": "Similar Artist",
          "spotify_id": "spotify:artist:xyz789",
          "image_url": "https://cdn.example.com/artist.jpg",
          "genres": ["Rock", "Alternative"],
          "similarity_score": 0.92
        }
      ]
    }
    ```

- `GET /api/v1/discover/trending` - Get trending music
  - Query params: `?genre=rock&limit=50&offset=0`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "tracks": [
        {
          "track_id": "spotify:track:abc123",
          "name": "Trending Song",
          "artist": "Artist Name",
          "trend_score": 0.95,
          "image_url": "https://cdn.example.com/artwork.jpg"
        }
      ]
    }
    ```

- `POST /api/v1/discover/recommendations/hide` - Hide recommendation
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "recommendation_id": "uuid"
    }
    ```
  - Response (200 OK):
    ```json
    {
      "message": "Recommendation hidden successfully"
    }
    ```

**Streaming Service Integration**
- `POST /api/v1/integrations/spotify/connect` - Connect Spotify account
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "auth_url": "https://accounts.spotify.com/authorize?client_id=...&redirect_uri=...&scope=...&state=..."
    }
    ```

- `GET /api/v1/integrations/spotify/callback` - Handle Spotify OAuth callback
  - Query params: `?code=authorization_code&state=state_token`
  - Response (200 OK):
    ```json
    {
      "message": "Spotify account connected successfully",
      "connection": {
        "service": "spotify",
        "is_active": true,
        "last_synced_at": null
      }
    }
    ```
  - Error Responses:
    - 400 Bad Request: Invalid authorization code or state
    - 401 Unauthorized: OAuth flow failed

- `POST /api/v1/integrations/apple-music/connect` - Connect Apple Music account
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "auth_url": "https://appleid.apple.com/auth/authorize?client_id=...&redirect_uri=...&scope=...&state=..."
    }
    ```

- `GET /api/v1/integrations/apple-music/callback` - Handle Apple Music OAuth callback
  - Query params: `?code=authorization_code&state=state_token`
  - Response (200 OK):
    ```json
    {
      "message": "Apple Music account connected successfully",
      "connection": {
        "service": "apple_music",
        "is_active": true,
        "last_synced_at": null
      }
    }
    ```

- `GET /api/v1/integrations/status` - Get integration status
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "connections": [
        {
          "service": "spotify",
          "is_active": true,
          "last_synced_at": "2024-01-15T10:30:00Z",
          "sync_status": "success"
        },
        {
          "service": "apple_music",
          "is_active": false,
          "last_synced_at": null,
          "sync_status": "disconnected"
        }
      ]
    }
    ```

- `DELETE /api/v1/integrations/:service/disconnect` - Disconnect service
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Service disconnected successfully"
    }
    ```

- `POST /api/v1/integrations/:service/sync` - Manual sync trigger
  - Headers: `Authorization: Bearer <token>`
  - Response (202 Accepted):
    ```json
    {
      "message": "Sync started",
      "sync_id": "uuid",
      "estimated_completion": "2024-01-15T10:35:00Z"
    }
    ```

**User Profile & Preferences**
- `GET /api/v1/users/me` - Get current user profile
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "user": {
        "id": "uuid",
        "email": "user@example.com",
        "display_name": "John Doe",
        "avatar_url": "https://cdn.example.com/avatar.jpg",
        "bio": "Music enthusiast",
        "email_verified": true,
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `PUT /api/v1/users/me` - Update user profile
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "display_name": "Updated Name",
      "bio": "Updated bio",
      "avatar_url": "https://cdn.example.com/new-avatar.jpg"
    }
    ```
  - Response (200 OK):
    ```json
    {
      "user": {
        "id": "uuid",
        "display_name": "Updated Name",
        "bio": "Updated bio",
        "avatar_url": "https://cdn.example.com/new-avatar.jpg",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `GET /api/v1/users/me/preferences` - Get user preferences
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "preferences": {
        "theme": "dark",
        "language": "en",
        "timezone": "America/New_York",
        "email_notifications": {
          "recommendations": true,
          "friend_requests": true,
          "playlist_updates": false
        },
        "privacy_settings": {
          "listening_history": "private",
          "profile": "public",
          "playlists": "private"
        },
        "display_settings": {
          "date_format": "YYYY-MM-DD",
          "time_format": "24h"
        }
      }
    }
    ```

- `PUT /api/v1/users/me/preferences` - Update user preferences
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "theme": "dark",
      "language": "en",
      "email_notifications": {
        "recommendations": true,
        "friend_requests": false
      },
      "privacy_settings": {
        "listening_history": "friends"
      }
    }
    ```
  - Response (200 OK):
    ```json
    {
      "preferences": {
        "theme": "dark",
        "language": "en",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

**Social Features**
- `GET /api/v1/friends` - Get user's friends list
  - Query params: `?status=accepted|pending&limit=50&offset=0`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "friends": [
        {
          "id": "uuid",
          "user_id": "uuid",
          "friend_id": "uuid",
          "friend": {
            "id": "uuid",
            "display_name": "Friend Name",
            "avatar_url": "https://cdn.example.com/friend.jpg"
          },
          "status": "accepted",
          "created_at": "2024-01-01T00:00:00Z"
        }
      ],
      "pagination": {
        "limit": 50,
        "offset": 0,
        "total": 25,
        "has_more": false
      }
    }
    ```

- `POST /api/v1/friends/request` - Send friend request
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "friend_id": "uuid"
    }
    ```
  - Response (201 Created):
    ```json
    {
      "friendship": {
        "id": "uuid",
        "user_id": "uuid",
        "friend_id": "uuid",
        "status": "pending",
        "requested_by": "uuid",
        "created_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `PUT /api/v1/friends/:friend_id/accept` - Accept friend request
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Friend request accepted",
      "friendship": {
        "id": "uuid",
        "status": "accepted",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `DELETE /api/v1/friends/:friend_id` - Remove friend or decline request
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Friend relationship removed"
    }
    ```

- `GET /api/v1/activity-feed` - Get activity feed
  - Query params: `?limit=50&offset=0&include_friends=true`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "activities": [
        {
          "id": "uuid",
          "user": {
            "id": "uuid",
            "display_name": "Friend Name",
            "avatar_url": "https://cdn.example.com/friend.jpg"
          },
          "activity_type": "listened",
          "target_resource_type": "track",
          "target_resource_id": "uuid",
          "metadata": {
            "track_name": "Song Title",
            "artist_name": "Artist Name"
          },
          "created_at": "2024-01-15T10:30:00Z"
        }
      ],
      "pagination": {
        "limit": 50,
        "offset": 0,
        "total": 100,
        "has_more": true
      }
    }
    ```

**Notifications**
- `GET /api/v1/notifications` - Get user notifications
  - Query params: `?is_read=false&limit=50&offset=0`
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "notifications": [
        {
          "id": "uuid",
          "type": "friend_request",
          "title": "New Friend Request",
          "message": "John Doe sent you a friend request",
          "action_url": "/friends/pending",
          "is_read": false,
          "created_at": "2024-01-15T10:30:00Z"
        }
      ],
      "pagination": {
        "limit": 50,
        "offset": 0,
        "total": 15,
        "has_more": false
      },
      "unread_count": 5
    }
    ```

- `PUT /api/v1/notifications/:id/read` - Mark notification as read
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "notification": {
        "id": "uuid",
        "is_read": true,
        "read_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `PUT /api/v1/notifications/read-all` - Mark all notifications as read
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "All notifications marked as read",
      "updated_count": 5
    }
    ```

- `DELETE /api/v1/notifications/:id` - Delete notification
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "message": "Notification deleted successfully"
    }
    ```

**Data Export & Deletion**
- `POST /api/v1/users/me/export` - Request data export (GDPR)
  - Headers: `Authorization: Bearer <token>`
  - Response (202 Accepted):
    ```json
    {
      "message": "Data export initiated",
      "export_id": "uuid",
      "estimated_completion": "2024-01-15T11:00:00Z",
      "download_url": null,
      "expires_at": "2024-01-22T11:00:00Z"
    }
    ```

- `GET /api/v1/users/me/export/:export_id` - Get export status
  - Headers: `Authorization: Bearer <token>`
  - Response (200 OK):
    ```json
    {
      "export": {
        "id": "uuid",
        "status": "completed",
        "download_url": "https://cdn.example.com/exports/uuid.zip",
        "expires_at": "2024-01-22T11:00:00Z",
        "created_at": "2024-01-15T10:30:00Z"
      }
    }
    ```

- `DELETE /api/v1/users/me` - Delete user account (GDPR)
  - Headers: `Authorization: Bearer <token>`
  - Request Body:
    ```json
    {
      "confirmation": "DELETE",
      "password": "SecurePass123!"
    }
    ```
  - Response (200 OK):
    ```json
    {
      "message": "Account deletion initiated. All data will be permanently deleted within 30 days."
    }
    ```

### Error Handling & Response Standards

**Standard Error Response Format:**
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "Additional error details"
    },
    "request_id": "correlation_id_for_debugging",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

**HTTP Status Codes:**
- `200 OK`: Successful GET, PUT, PATCH requests
- `201 Created`: Successful POST requests creating resources
- `202 Accepted`: Request accepted for async processing
- `204 No Content`: Successful DELETE requests
- `400 Bad Request`: Invalid request syntax or parameters
- `401 Unauthorized`: Missing or invalid authentication token
- `403 Forbidden`: Authenticated but insufficient permissions
- `404 Not Found`: Resource doesn't exist
- `409 Conflict`: Resource conflict (e.g., duplicate email)
- `422 Unprocessable Entity`: Validation errors
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server-side error
- `503 Service Unavailable`: Service temporarily unavailable

**Error Codes:**
- `AUTH_INVALID_CREDENTIALS`: Invalid email/password
- `AUTH_TOKEN_EXPIRED`: Access token expired
- `AUTH_TOKEN_INVALID`: Invalid token format
- `VALIDATION_ERROR`: Input validation failed
- `RESOURCE_NOT_FOUND`: Requested resource not found
- `RESOURCE_CONFLICT`: Resource conflict (duplicate)
- `RATE_LIMIT_EXCEEDED`: Too many requests
- `EXTERNAL_SERVICE_ERROR`: External API error
- `DATABASE_ERROR`: Database operation failed
- `PERMISSION_DENIED`: Insufficient permissions

### Input Validation Rules

**Email Validation:**
- Must match RFC 5322 email format
- Must be between 5 and 255 characters
- Must contain exactly one `@` symbol
- Domain must have valid TLD
- Examples:
  - Valid: `user@example.com`, `test.user+tag@domain.co.uk`
  - Invalid: `invalid`, `@domain.com`, `user@`, `user@domain`

**Password Validation:**
- Minimum 8 characters
- Maximum 128 characters
- Must contain at least one uppercase letter (A-Z)
- Must contain at least one lowercase letter (a-z)
- Must contain at least one digit (0-9)
- Must contain at least one special character (!@#$%^&*()_+-=[]{}|;:,.<>?)
- Cannot be common password (checked against common password list)
- Cannot contain user's email address

**Display Name Validation:**
- Must be between 1 and 100 characters
- Can contain letters, numbers, spaces, hyphens, underscores
- Cannot contain special characters except hyphens and underscores
- Cannot start or end with space
- Cannot contain consecutive spaces
- Trimmed before validation

**URL Validation:**
- Must be valid HTTP/HTTPS URL
- Must match RFC 3986 format
- Maximum length: 2048 characters
- Must use HTTPS in production (except for localhost/development)
- Examples:
  - Valid: `https://example.com`, `https://subdomain.example.com/path`
  - Invalid: `not-a-url`, `ftp://example.com`, `javascript:alert(1)`

**Date/Time Validation:**
- ISO 8601 format: `YYYY-MM-DDTHH:mm:ssZ` or `YYYY-MM-DD`
- Timezone must be UTC or valid IANA timezone
- Date must be valid calendar date
- Cannot be in future for most operations (except scheduled events)
- Timestamp must be within reasonable range (1970-2100)

**Numeric Validation:**
- Integers: Must be whole numbers within specified range
- Floats: Must be valid decimal numbers within specified range
- Duration (seconds): Must be positive integer, max 86400 (24 hours)
- Percentage: Must be between 0 and 100
- Counts: Must be non-negative integer

**Enum Validation:**
- Must match one of allowed values
- Case-sensitive unless specified otherwise
- Examples:
  - `source`: `['spotify', 'apple_music', 'youtube_music', 'manual']`
  - `privacy`: `['private', 'friends', 'public']`
  - `status`: `['pending', 'accepted', 'blocked']`

**JSON Schema Validation:**
- Must be valid JSON
- Must match specified schema structure
- Nested objects validated recursively
- Arrays validated for type and constraints
- Used for: `preferences`, `privacy_settings`, `metadata` fields

**Array Validation:**
- Maximum length: Specified per field (e.g., genres: 10 items)
- Items must match item type constraints
- Duplicate items removed automatically
- Empty arrays allowed unless `required: true`

**Pagination Validation:**
- `page`: Must be positive integer, default: 1
- `limit`: Must be between 1 and 100, default: 50
- `offset`: Must be non-negative integer, default: 0
- Cannot use both `page` and `offset` in same request

**File Upload Validation:**
- Maximum file size: 10MB for images, 5MB for other files
- Allowed MIME types:
  - Images: `image/jpeg`, `image/png`, `image/webp`, `image/gif`
  - Documents: `application/json`, `text/csv`
- File extension must match MIME type
- Content scanned for malicious content

**UUID Validation:**
- Must be valid UUID v4 format
- Example: `550e8400-e29b-41d4-a716-446655440000`
- Case-insensitive matching

**Track/Artist Name Validation:**
- Must be between 1 and 255 characters
- Can contain Unicode characters (supports international characters)
- Cannot be empty or whitespace only
- Trimmed before validation

**Playlist Name Validation:**
- Must be between 1 and 255 characters
- Can contain letters, numbers, spaces, and common punctuation
- Cannot be empty or whitespace only
- Trimmed before validation

### Security Specifications

**Authentication Security:**
- **JWT Tokens:**
  - Access token expiry: 1 hour
  - Refresh token expiry: 30 days
  - Algorithm: HS256 (HMAC-SHA256) or RS256 (RSA-SHA256) in production
  - Token payload includes: `user_id`, `email`, `exp`, `iat`, `jti`
  - Token stored in HTTP-only, secure cookies (preferred) or Authorization header
  - Token rotation on refresh token use
  - Token revocation on logout or security event

- **Session Management:**
  - Session stored in database (`sessions` table)
  - Session hash stored, not plain token
  - Maximum concurrent sessions per user: 5
  - Session timeout: 24 hours of inactivity
  - Session invalidation on password change
  - Device tracking: IP address, user agent stored

- **Password Security:**
  - Hashing: bcrypt with cost factor 12
  - Password reset tokens: Cryptographically secure random, expiry: 1 hour
  - Password reset requires email verification
  - Account lockout: 5 failed attempts within 15 minutes = 30 minute lockout
  - Password history: Cannot reuse last 5 passwords

- **Multi-Factor Authentication (MFA):**
  - TOTP (Time-based One-Time Password) support
  - Backup codes: 10 codes generated, single-use
  - MFA required for sensitive operations (account deletion, export)
  - Recovery codes securely stored (hashed)

**API Security:**
- **CORS (Cross-Origin Resource Sharing):**
  - Production: Whitelist specific origins only
  - Development: Allow localhost origins
  - Credentials: Include cookies/authorization headers
  - Max age: 86400 seconds (24 hours)
  - Allowed methods: GET, POST, PUT, DELETE, OPTIONS
  - Allowed headers: Content-Type, Authorization, X-Requested-With

- **CSRF (Cross-Site Request Forgery) Protection:**
  - CSRF tokens for state-changing operations
  - SameSite cookie attribute: `Strict` in production
  - Origin header validation
  - Referer header validation for sensitive operations

- **Rate Limiting:**
  - Per-user limits: Stored in Redis with sliding window
  - Per-IP limits: Fallback for unauthenticated requests
  - Rate limit headers included in all responses
  - Exponential backoff on rate limit exceeded
  - Rate limit bypass for internal services (service-to-service)

- **Request Size Limits:**
  - JSON body: 1MB maximum
  - URL length: 2048 characters maximum
  - Query parameters: 100 maximum
  - File uploads: 10MB maximum

**Data Security:**
- **Encryption at Rest:**
  - Database: AES-256 encryption via PostgreSQL transparent data encryption
  - File storage: S3 server-side encryption (SSE-S3 or SSE-KMS)
  - Sensitive fields encrypted: Passwords (hashed), OAuth tokens (encrypted), API keys
  - Encryption keys: Rotated quarterly, stored in AWS Secrets Manager

- **Encryption in Transit:**
  - TLS 1.3 minimum (fallback to TLS 1.2)
  - HTTPS enforced in production (HSTS header: max-age=31536000)
  - Certificate pinning for mobile apps
  - Internal service communication: mTLS (mutual TLS)

- **Data Privacy:**
  - Personal data minimization: Only collect necessary data
  - Data retention: Per retention policy (see Data Retention section)
  - Data anonymization: Anonymize data older than 2 years for analytics
  - Right to deletion: Complete data deletion within 30 days
  - Right to access: Data export available within 7 days

**OAuth Security:**
- **PKCE (Proof Key for Code Exchange):**
  - Required for all OAuth flows
  - Code verifier: 43-128 characters, URL-safe
  - Code challenge: SHA256 hash of verifier
  - Challenge method: S256

- **Token Management:**
  - Access tokens encrypted at rest
  - Refresh tokens stored securely (encrypted)
  - Token expiration: Access tokens expire, refresh tokens long-lived
  - Token refresh: Automatic refresh before expiration (5 minutes before)
  - Token revocation: Immediate revocation on disconnect

- **State Parameter:**
  - Cryptographically random state token
  - State validated on callback
  - State stored in session (expires in 10 minutes)
  - Prevents CSRF attacks

**Input Sanitization:**
- **XSS (Cross-Site Scripting) Prevention:**
  - All user input sanitized before storage
  - HTML entities encoded: `&`, `<`, `>`, `"`, `'`
  - Content Security Policy (CSP) headers:
    - `default-src 'self'`
    - `script-src 'self' 'unsafe-inline'` (for development only)
    - `style-src 'self' 'unsafe-inline'`
    - `img-src 'self' data: https:`
    - `connect-src 'self' https://api.spotify.com https://api.music.apple.com`
  - Output encoding: All dynamic content HTML-encoded

- **SQL Injection Prevention:**
  - Parameterized queries only (via Prisma ORM)
  - No dynamic SQL string concatenation
  - Input validation before database queries
  - Database user: Least privilege (read/write only, no DDL)

- **Command Injection Prevention:**
  - No shell command execution from user input
  - External command execution: Whitelist of allowed commands only
  - Input validation for file paths, URLs

**Security Headers:**
- **HTTP Security Headers:**
  - `Strict-Transport-Security`: `max-age=31536000; includeSubDomains`
  - `X-Content-Type-Options`: `nosniff`
  - `X-Frame-Options`: `DENY`
  - `X-XSS-Protection`: `1; mode=block`
  - `Referrer-Policy`: `strict-origin-when-cross-origin`
  - `Permissions-Policy`: `geolocation=(), microphone=(), camera=()`
  - `Content-Security-Policy`: As specified above

**Security Monitoring:**
- **Security Event Logging:**
  - Failed login attempts
  - Suspicious activity (multiple failed requests)
  - Token revocation events
  - Account lockouts
  - Unauthorized access attempts
  - Data export/deletion requests

- **Security Alerts:**
  - Immediate alerts: Multiple failed logins, account lockouts
  - Daily reports: Security event summary
  - Weekly reviews: Security audit log review

- **Vulnerability Management:**
  - Dependency scanning: Automated weekly scans
  - Security patches: Applied within 7 days of release
  - Penetration testing: Annual third-party security audit
  - Bug bounty program: For production environment

**Access Control:**
- **Authorization:**
  - Role-based access control (RBAC): User, Admin roles
  - Resource ownership: Users can only access their own resources
  - Public resources: Explicitly marked public, privacy settings respected
  - Permission checks: Per-request authorization validation

- **API Access:**
  - Authentication required for all endpoints except public endpoints
  - Token validation: On every request
  - Token expiry: Handled gracefully with 401 response
  - Refresh token: Automatic refresh via middleware

### Monitoring & Observability

**Metrics to Track:**
- **API Metrics:**
  - Request rate (requests per second)
  - Response time (p50, p95, p99)
  - Error rate (4xx, 5xx errors)
  - Endpoint-specific metrics
- **Application Metrics:**
  - Active users (concurrent, daily active)
  - Listening events processed per second
  - Recommendation generation time
  - Statistics calculation time
  - Cache hit/miss rates
- **Infrastructure Metrics:**
  - CPU utilization
  - Memory usage
  - Database connection pool usage
  - Queue depth (SQS)
  - Cache memory usage (Redis)
- **Business Metrics:**
  - New user registrations
  - Streaming service connections
  - Listening events recorded
  - Recommendations generated
  - Playlists created

**Logging Standards:**
- **Log Levels:**
  - `ERROR`: Error conditions requiring immediate attention
  - `WARN`: Warning conditions (e.g., rate limit approaching)
  - `INFO`: Informational messages (e.g., user registration)
  - `DEBUG`: Detailed debug information (development only)
- **Structured Logging Format:**
  ```json
  {
    "timestamp": "2024-01-15T10:30:00Z",
    "level": "INFO",
    "service": "user-service",
    "correlation_id": "uuid",
    "user_id": "uuid",
    "message": "User registered successfully",
    "metadata": {
      "email": "user@example.com",
      "ip_address": "192.168.1.1"
    }
  }
  ```
- **Log Retention:**
  - Application logs: 30 days
  - Access logs: 90 days
  - Error logs: 365 days
  - Audit logs: 7 years (compliance)

**Alerting Rules:**
- **Critical Alerts (Immediate Response):**
  - Error rate > 5% for 5 minutes
  - API response time p95 > 5 seconds for 5 minutes
  - Database connection pool exhaustion
  - Service downtime detected
- **Warning Alerts (Review Within 1 Hour):**
  - Error rate > 1% for 15 minutes
  - Cache hit rate < 70% for 30 minutes
  - Queue depth > 1000 messages
  - Disk usage > 80%

**Distributed Tracing:**
- Use OpenTelemetry for distributed tracing
- Trace all requests across services
- Include trace IDs in logs and error responses
- Track external API calls (Spotify, Apple Music, etc.)

### Caching Strategy

**Cache Layers:**
1. **CDN Cache (CloudFront):**
   - Static assets (images, CSS, JS)
   - TTL: 1 year (with versioning)
   - Cache invalidation on deployment

2. **Application Cache (Redis):**
   - User sessions: TTL 24 hours
   - Listening statistics: TTL based on time range
     - Recent (today): 5 minutes
     - Weekly: 1 hour
     - Monthly: 6 hours
     - Yearly: 24 hours
   - Recommendations: TTL 24 hours
   - Top artists/tracks/genres: TTL based on time range
   - User profile data: TTL 1 hour

**Cache Invalidation:**
- User profile: Invalidate on profile update
- Listening statistics: Invalidate on new listening event
- Recommendations: Invalidate on hide/like action
- Playlists: Invalidate on playlist modification

**Cache Keys:**
- Format: `service:resource:identifier:params`
- Examples:
  - `stats:user:uuid:week`
  - `recommendations:user:uuid`
  - `top-artists:user:uuid:month`
  - `playlist:uuid`

### Rate Limiting

**Rate Limit Strategy:**
- **Per User Limits:**
  - Authentication endpoints: 5 requests/minute
  - Statistics endpoints: 60 requests/hour
  - Listening history endpoints: 100 requests/hour
  - Playlist endpoints: 200 requests/hour
  - Discovery endpoints: 100 requests/hour

- **Per IP Limits:**
  - General API: 1000 requests/hour
  - Authentication endpoints: 20 requests/minute

**Rate Limit Headers:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1642248000
```

**Rate Limit Response (429 Too Many Requests):**
```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Please try again later.",
    "retry_after": 60
  }
}
```

### Data Retention & Archival

**Data Retention Policies:**
- **Active Data:**
  - Listening history: Indefinite (user-controlled)
  - User profiles: Indefinite (until account deletion)
  - Playlists: Indefinite (until deletion)
  - Recommendations: 90 days

- **Archived Data:**
  - Listening history older than 2 years: Archive to cold storage (S3 Glacier)
  - Inactive user accounts (> 2 years): Archive and mark as inactive
  - Deleted accounts: Retain for 30 days then permanent deletion

- **Audit Logs:**
  - Security events: 7 years
  - User actions: 2 years
  - API access logs: 90 days

**Data Archival Process:**
- Monthly archival job runs on 1st of month
- Archive data older than retention period
- Compress and encrypt archived data
- Store in S3 Glacier for cost efficiency
- Maintain ability to restore archived data

### Data Processing Pipeline

**1. Real-time Listening Tracking**

Architecture:
- Webhook receiver endpoint for streaming service notifications
- Event queue (AWS SQS) for async processing
- Background workers process events from queue
- Update database and cache atomically

Flow:
1. Streaming service sends webhook/event to our system
2. Webhook receiver validates request (signature, authentication)
3. Parse event payload (track info, user info, timestamp)
4. Validate event (user exists, data is valid)
5. Publish event to message queue with routing key
6. Background worker picks up event from queue
7. Worker processes event:
   - Check for duplicates (same track + user + timestamp within 5 min)
   - Apply business rules (minimum duration, skip detection)
   - Insert/update listening_history record
   - Update track and artist metadata if needed
   - Update statistics cache
   - Trigger recommendation update if needed
8. Worker acknowledges event completion
9. If processing fails, event goes to dead letter queue for retry

**2. Statistics Calculation**

Architecture:
- Scheduled jobs (cron) for aggregate statistics
- Cache computed statistics in Redis
- Incremental updates for real-time stats
- Batch processing for historical stats

Flow:
1. Scheduled job runs daily at 2 AM UTC
2. For each active user:
   - Calculate statistics for previous day
   - Update daily statistics cache
   - Calculate weekly statistics (if Monday)
   - Calculate monthly statistics (if first day of month)
   - Calculate yearly statistics (if January 1st)
3. Store statistics in cache with appropriate TTL:
   - Daily stats: 24 hours
   - Weekly stats: 7 days
   - Monthly stats: 30 days
   - Yearly stats: 365 days
4. For real-time stats (when user requests):
   - Check cache first
   - If cache miss or stale, calculate on-demand
   - Cache results for future requests
5. Incremental updates:
   - When new listening event processed, update relevant statistics
   - Update cache atomically
   - Maintain consistency between cache and database

**3. Recommendation Generation**

Architecture:
- Scheduled batch job analyzes user listening patterns
- Generate recommendations using hybrid algorithm
- Store recommendations in cache and database
- Refresh recommendations periodically

Flow:
1. Scheduled job runs daily at 3 AM UTC
2. For each active user (listened in last 30 days):
   - Load user's listening history (last 90 days)
   - Analyze listening patterns:
     - Extract top genres, artists, tracks
     - Identify listening patterns (time of day, day of week)
     - Calculate music preferences
   - Generate collaborative filtering recommendations:
     - Find similar users (cosine similarity)
     - Get tracks liked by similar users
     - Score recommendations
   - Generate content-based recommendations:
     - Find similar artists using metadata APIs
     - Find similar tracks using audio features
     - Score recommendations
   - Combine recommendations using hybrid approach
   - Filter recommendations:
     - Exclude recently played tracks (last 7 days)
     - Exclude hidden recommendations
     - Apply diversity factor
   - Sort by score descending
   - Limit to top 100 recommendations
   - Store recommendations in database
   - Cache recommendations in Redis (TTL: 24 hours)
3. On-demand refresh:
   - User requests new recommendations
   - Check if last generation was > 1 hour ago
   - If stale, trigger immediate generation
   - Return cached recommendations if fresh

## Dependencies

### External Dependencies
- **Streaming Service APIs**: Spotify Web API, Apple Music API, YouTube Music API
  - Required for listening history tracking
  - Rate limits and availability affect functionality
  - OAuth tokens must be managed and refreshed
- **Music Metadata APIs**: MusicBrainz API, Last.fm API, Discogs API
  - Required for track and artist metadata
  - Fallback mechanisms needed if APIs unavailable
- **OAuth Providers**: Google OAuth, Apple Sign-In
  - Required for user authentication
  - User experience depends on provider availability
- **Cloud Hosting Provider**: AWS (EC2, ECS/EKS, RDS, S3, CloudFront, Route53)
  - Required for infrastructure and hosting
  - Costs scale with usage
- **Database Hosting**: Managed PostgreSQL (AWS RDS)
  - Required for data persistence
  - Backup and recovery capabilities essential
- **CDN**: CloudFront or similar for static assets
  - Required for fast content delivery
  - Global distribution improves user experience

### Internal Dependencies
- **User Authentication System**: Must be complete before listening history tracking
  - Users must be authenticated to track listening history
  - User IDs required for all data operations
- **Streaming Service Integration**: Must be complete before automatic tracking
  - OAuth flows must be implemented
  - Token management must be working
  - API clients must be functional
- **Database Schema**: Must be designed and migrated before any data operations
  - All tables must exist before inserts
  - Indexes must be created for performance
  - Migrations must be tested
- **Analytics Service**: Depends on listening history data
  - Cannot calculate statistics without listening history
  - Statistics calculation algorithms depend on data structure
- **Recommendation Engine**: Depends on listening history and analytics
  - Needs listening patterns to generate recommendations
  - Needs user statistics for personalization
- **Playlist Service**: Depends on track metadata
  - Needs track information to create playlists
  - Depends on music metadata APIs

### Development Dependencies
- **Node.js Runtime**: Node.js 20+ LTS required
  - Required for backend development
  - Must be installed on development machines
- **PostgreSQL Database**: PostgreSQL 15+ required
  - Required for local development
  - Can use Docker for easy setup
- **Redis Cache**: Redis 7+ required
  - Required for caching and session management
  - Can use Docker for local development
- **Docker**: Docker Desktop required
  - Required for containerization
  - Used for local development environment
- **Testing Frameworks**: Jest, React Testing Library, Supertest
  - Required for unit and integration tests
  - Must be configured in CI/CD pipeline
- **CI/CD Pipeline**: GitHub Actions required
  - Required for automated testing and deployment
  - Must be configured with secrets and environment variables
- **TypeScript**: TypeScript 5+ required
  - Required for type safety
  - Must be configured in tsconfig.json

## Acceptance Criteria

### Phase 1: Core Functionality
- User can register with email/password or OAuth (Google, Apple)
- User can log in and maintain authenticated session
- User can connect at least one streaming service (Spotify minimum)
- System can authenticate with streaming service via OAuth
- System can fetch and store listening history from connected service
- System can track listening events in real-time (within 5 seconds)
- User can view basic listening statistics on dashboard:
  - Total listening time
  - Total tracks played
  - Listening streak
- User can manually add listening history entries with required fields
- User can view their listening history with pagination
- User can filter listening history by date range and source
- All API endpoints return proper error responses
- All database operations are transactional and consistent

### Phase 2: Analytics & Insights
- User can view detailed statistics for multiple time periods (week, month, year, all-time, custom)
- User can view top artists ranked by play count with listening time
- User can view top tracks ranked by play count with listening time
- User can view top genres ranked by listening time with percentages
- User can view listening trends over time with visualizations (charts, graphs)
- User can view listening streaks with consecutive day counts
- User can compare statistics between time periods (this month vs last month)
- Statistics calculations are accurate and match expected results
- Statistics queries complete within 2 seconds for typical datasets
- Statistics are cached appropriately to reduce database load
- User can export statistics as images or shareable links
- Statistics update in real-time as new listening events are recorded

### Phase 3: Discovery & Recommendations
- System generates personalized music recommendations based on listening history
- Recommendations use hybrid approach (collaborative + content-based filtering)
- User can view recommendations categorized by type (artists, tracks, genres)
- User can preview recommended tracks (30-second preview if available)
- User can add recommended tracks to playlists
- User can like or hide recommendations to improve future suggestions
- User can discover similar artists based on their listening history
- User can browse trending music in their preferred genres
- Recommendations are relevant and personalized to user's taste
- Recommendations exclude recently played tracks (last 7 days)
- Recommendation generation completes within reasonable time (< 30 seconds per user)
- Recommendations are refreshed daily via scheduled job
- User can request manual refresh of recommendations

### Phase 4: Playlists & Social
- User can create playlists with name, description, and privacy settings
- User can add tracks to playlists from search results or recommendations
- User can remove tracks from playlists
- User can reorder tracks within playlists
- User can edit playlist details (name, description, privacy)
- User can delete playlists
- User can share playlists via link or social media
- User can set playlists as public, private, or collaborative
- User can import playlists from streaming services (if supported)
- User can export playlists in various formats (JSON, CSV, M3U)
- User can follow other users
- User can see friends' listening activity in feed
- User can compare music taste with friends (compatibility scores)
- User can share listening statistics with friends or publicly
- Social features respect privacy settings
- Playlist operations are performant (< 1 second for typical operations)

### Phase 5: Polish & Optimization
- Application is fully responsive and works on mobile (320px+), tablet (768px+), and desktop (1024px+)
- Application meets WCAG 2.1 AA accessibility standards
- All interactive elements have proper accessibility labels and hints
- Application supports keyboard navigation
- Application is compatible with screen readers
- Performance meets requirements:
  - API response times < 2 seconds for analytics queries
  - Page load times < 3 seconds on 3G connection
  - Smooth scrolling and interactions (60 FPS)
- Application is secure:
  - All inputs are validated and sanitized
  - SQL injection prevention via parameterized queries
  - XSS prevention via content security policies
  - API rate limiting implemented
  - Authentication tokens are secure and properly managed
- Application handles errors gracefully:
  - User-friendly error messages
  - Proper error logging and monitoring
  - Fallback behaviors when external services unavailable
- Application has comprehensive test coverage (> 80%)
- Application is deployed to production with monitoring and alerting
- Application has backup and disaster recovery procedures

## Test Requirements

### Unit Tests
- **User Authentication Logic**:
  - Password hashing and validation
  - JWT token generation and verification
  - OAuth flow handling
  - Session management
- **Listening History Recording Logic**:
  - Event validation and deduplication
  - Minimum duration checking
  - Skip detection
  - Manual entry processing
- **Statistics Calculation Algorithms**:
  - Top artists calculation
  - Top tracks calculation
  - Top genres calculation
  - Listening time aggregation
  - Streak calculation
  - Trend comparison
- **Recommendation Algorithm**:
  - Collaborative filtering scoring
  - Content-based filtering scoring
  - Hybrid recommendation combination
  - Recommendation filtering and ranking
- **Playlist Management Logic**:
  - Playlist creation and validation
  - Track addition and removal
  - Track reordering
  - Playlist sharing logic

### Integration Tests
- **API Endpoint Testing**:
  - All authentication endpoints
  - All listening history endpoints
  - All playlist endpoints
  - All discovery endpoints
  - All integration endpoints
- **Database Operations**:
  - CRUD operations on all tables
  - Transaction handling
  - Foreign key constraints
  - Index usage and query performance
- **Streaming Service API Integrations**:
  - OAuth flows for each service
  - Token refresh mechanisms
  - API request/response handling
  - Error handling and retries
- **Authentication Flows**:
  - Registration flow
  - Login flow
  - OAuth flows (Google, Apple)
  - Token refresh flow
- **Data Synchronization**:
  - Listening history sync from streaming services
  - Real-time event processing
  - Batch processing jobs

### End-to-End Tests
- **Complete User Registration Flow**:
  - User visits site → registers → verifies email → connects service → views dashboard
- **Listening History Tracking Flow**:
  - User plays music → system detects → records event → updates statistics → displays on dashboard
- **Statistics Viewing Flow**:
  - User navigates to statistics → selects time period → views top artists/tracks/genres → drills down → shares statistics
- **Playlist Creation Flow**:
  - User creates playlist → searches for tracks → adds tracks → reorders → saves → shares
- **Discovery and Recommendations Flow**:
  - User views recommendations → previews tracks → adds to playlist → hides recommendations → views new recommendations

### Performance Tests
- **Database Query Performance**:
  - Statistics queries under 2 seconds for 1M records
  - Listening history queries under 1 second for 10K records
  - Index effectiveness verification
- **API Response Times**:
  - All endpoints respond within SLA (< 2 seconds)
  - Concurrent request handling (100+ simultaneous users)
  - Rate limiting effectiveness
- **Concurrent User Handling**:
  - System handles 1000+ concurrent users
  - No performance degradation under load
  - Proper connection pooling
- **Data Processing Pipeline Throughput**:
  - Process 1000+ listening events per second
  - Recommendation generation completes within 30 seconds per user
  - Statistics calculation completes within scheduled window

### Security Tests
- **Authentication and Authorization**:
  - Password strength requirements enforced
  - JWT tokens are properly validated
  - OAuth flows are secure
  - Unauthorized access is prevented
- **Input Validation**:
  - SQL injection attempts are blocked
  - XSS attempts are sanitized
  - Invalid data is rejected with proper error messages
- **API Security**:
  - Rate limiting prevents abuse
  - CORS policies are properly configured
  - HTTPS is enforced in production
  - Sensitive data is encrypted
- **Data Privacy**:
  - User data is accessible only by authorized users
  - Privacy settings are properly enforced
  - Data export includes all user data
  - Data deletion is complete and permanent

## Estimated Complexity

**Overall Complexity**: Medium-High

**Breakdown by Component**:
- **User Authentication**: Low-Medium
  - Standard OAuth and JWT implementation
  - Email verification and password reset flows
  - Estimated: 1-2 weeks
- **Listening History Tracking**: Medium
  - Real-time event processing
  - Streaming service integrations
  - Deduplication and business rules
  - Estimated: 3-4 weeks
- **Statistics & Analytics**: Medium-High
  - Complex aggregation queries
  - Caching strategies
  - Performance optimization
  - Estimated: 3-4 weeks
- **Discovery & Recommendations**: High
  - Machine learning algorithms
  - Music metadata processing
  - Performance optimization
  - Estimated: 4-5 weeks
- **Playlist Management**: Medium
  - CRUD operations
  - Search and filtering
  - Import/export functionality
  - Estimated: 2-3 weeks
- **Social Features**: Medium
  - Friend relationships
  - Activity feeds
  - Comparison algorithms
  - Estimated: 3-4 weeks
- **Streaming Service Integration**: Medium-High
  - OAuth implementations for multiple services
  - Token management
  - API client development
  - Error handling and retries
  - Estimated: 3-4 weeks
- **Mobile App**: Medium-High
  - React Native development
  - Native integrations
  - Cross-platform testing
  - Estimated: 4-6 weeks (optional Phase 2+)

**Estimated Development Time**:
- **Phase 1 (Core)**: 4-6 weeks
  - User authentication: 1-2 weeks
  - Streaming service integration: 2-3 weeks
  - Basic listening history tracking: 1-2 weeks
  - Basic statistics: 1 week
  - Manual entry: 1 week
- **Phase 2 (Analytics)**: 3-4 weeks
  - Detailed statistics: 2 weeks
  - Trends and comparisons: 1 week
  - Performance optimization: 1 week
- **Phase 3 (Discovery)**: 4-5 weeks
  - Recommendation algorithm: 2-3 weeks
  - Similar artists discovery: 1 week
  - Trending music: 1 week
- **Phase 4 (Social)**: 3-4 weeks
  - Playlist management: 2 weeks
  - Social features: 2 weeks
- **Phase 5 (Polish)**: 2-3 weeks
  - Responsive design: 1 week
  - Accessibility: 1 week
  - Performance optimization: 1 week
  - Security hardening: 1 week
- **Total**: 16-22 weeks (4-5.5 months)

**Risk Factors**:
- Streaming service API limitations and changes
- Complex recommendation algorithm development
- Performance optimization for large datasets
- Mobile app development complexity (if included)
- Third-party API dependencies and rate limits

## Target Stack Specifications

### Frontend Stack
- **Framework**: Next.js 14+ with App Router
- **Language**: TypeScript 5+
- **State Management**: Zustand for global state, React Query for server state
- **Styling**: Tailwind CSS 3+ with CSS Modules
- **UI Components**: Radix UI or shadcn/ui for accessible components
- **Forms**: React Hook Form with Zod validation
- **Data Fetching**: TanStack Query (React Query) v5+
- **Routing**: Next.js App Router
- **Testing**: Jest + React Testing Library + Playwright for E2E
- **Build Tool**: Next.js built-in (Turbopack)
- **Linting**: ESLint + Prettier
- **Type Checking**: TypeScript strict mode

### Backend Stack
- **Runtime**: Node.js 20+ LTS
- **Framework**: Express.js 4.18+ with TypeScript
- **Language**: TypeScript 5+
- **ORM**: Prisma 5+ for database access
- **Validation**: Zod for runtime validation
- **Authentication**: JWT (jsonwebtoken) + bcrypt for passwords
- **API Documentation**: Swagger/OpenAPI 3.0 with Swagger UI
- **Logging**: Winston or Pino for structured logging
- **Error Handling**: Custom error middleware
- **Testing**: Jest + Supertest for API testing
- **Process Management**: PM2 for production
- **API Style**: RESTful with JSON responses

### Mobile Stack (Optional Phase 2+)
- **Framework**: React Native 0.72+
- **Language**: TypeScript 5+
- **State Management**: Zustand or Redux Toolkit
- **Navigation**: React Navigation 6+
- **UI Components**: React Native Paper or NativeBase
- **Testing**: Jest + React Native Testing Library
- **Build**: Expo (managed workflow)
- **Platforms**: iOS and Android

### Infrastructure Stack
- **Cloud Provider**: AWS
  - **Compute**: ECS/EKS for containers or EC2 for VMs
  - **Database**: RDS PostgreSQL 15+ (Multi-AZ for production)
  - **Cache**: ElastiCache Redis 7+
  - **Storage**: S3 for files and assets
  - **CDN**: CloudFront for static assets
  - **DNS**: Route53
  - **Load Balancer**: Application Load Balancer
- **Database**: PostgreSQL 15+ (managed via RDS)
- **Cache**: Redis 7+ (managed via ElastiCache)
- **Message Queue**: AWS SQS
- **Search**: Elasticsearch 8+ (optional, managed via AWS OpenSearch)
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes (EKS) for production, Docker Compose for development
- **Monitoring**: CloudWatch + Prometheus + Grafana
- **Logging**: CloudWatch Logs or ELK Stack

### DevOps Stack
- **CI/CD**: GitHub Actions
  - Automated testing on pull requests
  - Automated deployment to staging on merge to develop
  - Automated deployment to production on release tags
- **Monitoring**: Prometheus + Grafana for metrics, CloudWatch for logs
- **Logging**: CloudWatch Logs or ELK Stack (Elasticsearch, Logstash, Kibana)
- **Error Tracking**: Sentry for error monitoring and alerting
- **Infrastructure as Code**: Terraform
- **Secrets Management**: AWS Secrets Manager
- **Backup**: Automated daily backups with point-in-time recovery

## Deployment Strategy

### Development Environment
- **Local Development**: Docker Compose setup
  - PostgreSQL container
  - Redis container
  - Backend API container with hot reload
  - Frontend dev server with hot reload
- **Hot Reloading**: Enabled for both frontend and backend
- **Database**: Local PostgreSQL instance or Docker container
- **Cache**: Local Redis instance or Docker container
- **Mock Services**: Mock streaming service APIs for testing
- **Environment Variables**: `.env` files for local configuration
- **Database Migrations**: Prisma Migrate for schema changes

### Staging Environment
- **Hosting**: Cloud-hosted staging environment (AWS)
- **Infrastructure**: Production-like setup with smaller scale
- **Database**: Managed PostgreSQL (RDS) with automated backups
- **Cache**: Managed Redis (ElastiCache)
- **Integrations**: Real streaming service API integrations (test accounts)
- **Monitoring**: Same monitoring stack as production
- **Automated Testing**: Full test suite runs before deployment
- **Deployment**: Automated via GitHub Actions on merge to develop branch
- **Data**: Seed data for testing and demos

### Production Environment
- **High Availability**: Multi-AZ deployment across availability zones
- **Load Balancing**: Application Load Balancer with health checks
- **Database**: RDS PostgreSQL Multi-AZ with automated backups and read replicas
- **Cache**: ElastiCache Redis with replication
- **CDN**: CloudFront for static assets and API caching
- **Monitoring and Alerting**: CloudWatch alarms, Prometheus alerts, Sentry notifications
- **Backup and Disaster Recovery**:
  - Daily automated backups with 30-day retention
  - Point-in-time recovery capability
  - Disaster recovery plan documented and tested
- **Scaling**: Auto-scaling groups for compute resources
- **Security**: WAF, SSL/TLS certificates, security groups, VPC isolation
- **Deployment**: Blue-green or rolling deployments via GitHub Actions
- **Rollback**: Automated rollback capability on deployment failure

## Future Enhancements

### Potential Features
- **Machine Learning**: Advanced ML models for better recommendations (collaborative filtering improvements, neural networks)
- **Collaborative Playlists**: Real-time collaborative playlist editing with multiple users
- **Music Taste Compatibility**: Algorithm to calculate music taste compatibility between users
- **More Streaming Services**: Integration with Tidal, Deezer, SoundCloud, Bandcamp
- **Podcast Tracking**: Extend to track podcast listening history and statistics
- **Music Mood Analysis**: Analyze music mood and energy levels from listening history
- **Listening Goals and Challenges**: Set listening goals (e.g., "Listen to 100 new artists this year") and track progress
- **Music Journaling**: Add notes and thoughts about tracks, albums, or listening sessions
- **Artist Following**: Follow favorite artists and get notifications about new releases
- **Concert Recommendations**: Recommend concerts and live events based on listening history and location
- **Music Challenges**: Participate in music discovery challenges (e.g., "Listen to 1 album from each decade")
- **Year in Review**: Annual summary of listening habits with shareable visualizations
- **Music Groups**: Create and join music groups based on genres or interests
- **Live Listening Sessions**: Share real-time listening sessions with friends
- **Music Quiz**: Interactive quizzes about music knowledge and taste

### Scalability Considerations
- **Microservices Architecture**: Ready for microservices split if needed
- **Horizontal Scaling**: All services designed for horizontal scaling
- **Database Sharding**: Strategy for database sharding if user base grows beyond single database capacity
- **Caching Strategies**: Multi-layer caching (CDN, Redis, application-level) for high traffic
- **CDN**: Global CDN for static assets and API responses
- **Read Replicas**: Database read replicas for read-heavy operations
- **Event Sourcing**: Consider event sourcing for audit trail and replay capability
- **CQRS**: Consider CQRS pattern for read/write separation if needed
- **Message Queue Scaling**: Horizontal scaling of message queue workers
- **API Rate Limiting**: Per-user and per-IP rate limiting to prevent abuse

## Implementation Roadmap

### Phase 1: Foundation & Core Tracking (Weeks 1-6)
**Goal**: Establish core infrastructure and basic listening history tracking

**Week 1-2: Project Setup & Authentication**
- Initialize project structure (Next.js + Express.js)
- Set up development environment (Docker Compose)
- Configure PostgreSQL database with Prisma
- Implement user authentication (email/password + OAuth)
- Set up JWT token management
- Create user registration and login flows
- Implement email verification
- **Deliverables**: Working authentication system, database schema migrated

**Week 3-4: Streaming Service Integration**
- Implement Spotify OAuth flow
- Create Spotify API client wrapper
- Build token refresh mechanism
- Implement listening history fetching from Spotify
- Create data synchronization service
- Set up background job processing (SQS workers)
- **Deliverables**: Spotify integration working, listening history syncing

**Week 5-6: Listening History & Basic Stats**
- Build listening history recording system
- Implement deduplication logic
- Create manual entry functionality
- Build basic statistics calculation (total time, tracks, streak)
- Create listening history API endpoints
- Implement basic dashboard UI
- **Deliverables**: Core tracking functional, basic dashboard visible

### Phase 2: Analytics & Insights (Weeks 7-10)
**Goal**: Comprehensive statistics and analytics

**Week 7-8: Advanced Statistics**
- Implement top artists/tracks/genres calculations
- Build time-range filtering (week, month, year, custom)
- Create statistics caching layer
- Build trend comparison algorithms
- Implement listening pattern analysis (time of day, day of week)
- **Deliverables**: Comprehensive statistics system operational

**Week 9-10: Visualization & Export**
- Build chart/graph components (using Chart.js or Recharts)
- Implement statistics visualization UI
- Create shareable statistics images
- Build statistics export functionality
- Optimize statistics queries for performance
- **Deliverables**: Full analytics dashboard with visualizations

### Phase 3: Discovery & Recommendations (Weeks 11-15)
**Goal**: Music discovery and recommendation engine

**Week 11-12: Recommendation Engine**
- Implement collaborative filtering algorithm
- Build content-based filtering algorithm
- Create hybrid recommendation system
- Implement recommendation scoring and ranking
- Build recommendation refresh jobs
- **Deliverables**: Recommendation engine generating personalized suggestions

**Week 13-14: Discovery Features**
- Build similar artists discovery
- Implement trending music discovery
- Create genre exploration features
- Build discovery UI with preview functionality
- Implement recommendation interaction (like, hide)
- **Deliverables**: Full discovery experience operational

**Week 15: Optimization**
- Optimize recommendation generation performance
- Implement recommendation caching
- Fine-tune recommendation algorithms
- Performance testing and optimization
- **Deliverables**: Optimized recommendation system

### Phase 4: Playlists & Social (Weeks 16-19)
**Goal**: Playlist management and social features

**Week 16-17: Playlist Management**
- Build playlist CRUD operations
- Implement track search and addition
- Create playlist sharing functionality
- Build playlist import/export
- Implement playlist templates and smart playlists
- **Deliverables**: Complete playlist management system

**Week 18-19: Social Features**
- Implement friend/follow system
- Build activity feed
- Create music taste comparison algorithm
- Implement sharing functionality
- Build social discovery features
- **Deliverables**: Social platform features operational

### Phase 5: Polish & Production (Weeks 20-22)
**Goal**: Production-ready application

**Week 20: Responsive Design & Accessibility**
- Implement responsive design for all screen sizes
- Add accessibility features (WCAG 2.1 AA compliance)
- Implement keyboard navigation
- Add screen reader support
- **Deliverables**: Fully accessible, responsive application

**Week 21: Security & Performance**
- Security audit and hardening
- Performance optimization
- Load testing and optimization
- Implement monitoring and alerting
- **Deliverables**: Secure, performant application

**Week 22: Deployment & Launch**
- Set up production infrastructure
- Deploy to production
- Create backup and disaster recovery procedures
- Document operational procedures
- Launch preparation and go-live
- **Deliverables**: Application live in production

## Risk Management

### Technical Risks

**Risk 1: Streaming Service API Limitations**
- **Probability**: Medium
- **Impact**: High
- **Mitigation**: 
  - Implement fallback mechanisms for when APIs are unavailable
  - Use multiple data sources (Last.fm, MusicBrainz) as fallbacks
  - Implement robust error handling and retry logic
  - Cache API responses to reduce dependency
  - Monitor API rate limits and implement queuing

**Risk 2: Performance Issues with Large Datasets**
- **Probability**: Medium
- **Impact**: High
- **Mitigation**:
  - Implement proper database indexing from start
  - Use pagination and lazy loading throughout
  - Implement multi-layer caching strategy
  - Optimize queries with query plan analysis
  - Consider database partitioning for listening_history table
  - Implement read replicas for read-heavy operations

**Risk 3: Recommendation Algorithm Complexity**
- **Probability**: Medium
- **Impact**: Medium
- **Mitigation**:
  - Start with simple collaborative filtering
  - Iterate and improve algorithm based on user feedback
  - Use proven algorithms from research
  - Implement fallback to simple popularity-based recommendations
  - Monitor recommendation quality metrics

**Risk 4: OAuth Token Management**
- **Probability**: Low
- **Impact**: High
- **Mitigation**:
  - Implement robust token refresh logic
  - Handle token expiration gracefully
  - Provide clear re-authentication flows
  - Monitor token expiration and refresh proactively
  - Store tokens securely (encrypted)

**Risk 5: Data Privacy & GDPR Compliance**
- **Probability**: Low
- **Impact**: High
- **Mitigation**:
  - Implement privacy controls from day one
  - Build data export functionality early
  - Implement account deletion with data cleanup
  - Regular security audits
  - Clear privacy policy and terms of service
  - Data encryption at rest and in transit

### Business Risks

**Risk 6: Low User Adoption**
- **Probability**: Medium
- **Impact**: High
- **Mitigation**:
  - Focus on core value proposition (music insights)
  - Easy onboarding experience
  - Social sharing features to drive organic growth
  - Regular feature updates based on user feedback
  - Marketing and community building

**Risk 7: Streaming Service Policy Changes**
- **Probability**: Low
- **Impact**: High
- **Mitigation**:
  - Diversify supported services
  - Support manual entry as fallback
  - Monitor API changes and adapt quickly
  - Build flexible integration architecture
  - Maintain good relationships with API providers

**Risk 8: Scaling Costs**
- **Probability**: Medium
- **Impact**: Medium
- **Mitigation**:
  - Implement efficient caching to reduce database load
  - Use cost-effective infrastructure (spot instances, reserved capacity)
  - Monitor and optimize costs regularly
  - Implement usage-based pricing if needed
  - Archive old data to cold storage

## Success Metrics

### Technical Metrics
- **API Response Time**: < 2 seconds for 95th percentile
- **Uptime**: > 99.9% availability
- **Error Rate**: < 1% of requests
- **Database Query Performance**: < 2 seconds for statistics queries
- **Cache Hit Rate**: > 70% for frequently accessed data
- **Test Coverage**: > 80% code coverage

### Product Metrics
- **User Registration**: Target 1000 users in first month
- **Active Users**: Target 60% monthly active users
- **Streaming Service Connections**: Target 80% connection rate
- **Listening Events Tracked**: Target 1M events in first month
- **Playlists Created**: Target 5000 playlists in first month
- **Recommendation Engagement**: Target 30% click-through rate

### Business Metrics
- **User Retention**: Target 40% retention after 30 days
- **Feature Adoption**: Target 50% of users use statistics feature
- **Social Engagement**: Target 20% of users follow at least one friend
- **Data Export Requests**: < 5% of users (indicator of privacy concerns)
- **User Satisfaction**: Target 4.0+ star rating

## Maintenance & Operations

### Daily Operations
- Monitor error rates and respond to alerts
- Check database performance and query times
- Monitor API rate limits for external services
- Review user feedback and support tickets
- Check backup completion status

### Weekly Operations
- Review performance metrics and trends
- Analyze user behavior and feature usage
- Review and optimize slow queries
- Check security logs for anomalies
- Update dependencies (security patches)

### Monthly Operations
- Performance optimization review
- User satisfaction survey analysis
- Feature usage analysis and roadmap planning
- Security audit
- Cost optimization review
- Database maintenance (VACUUM, ANALYZE)

### Quarterly Operations
- Comprehensive security audit
- Infrastructure cost review and optimization
- User research and feedback synthesis
- Technology stack evaluation
- Disaster recovery testing
- Performance benchmarking

## Documentation Requirements

### Technical Documentation
- **API Documentation**: Complete OpenAPI/Swagger documentation
- **Database Schema Documentation**: ERD and table descriptions
- **Architecture Documentation**: System design and component descriptions
- **Deployment Documentation**: Step-by-step deployment procedures
- **Configuration Documentation**: Environment variables and configuration options
- **Integration Documentation**: Streaming service API integration guides

### User Documentation
- **User Guide**: How to use all features
- **FAQ**: Common questions and answers
- **Privacy Policy**: Data handling and privacy information
- **Terms of Service**: Legal terms and conditions
- **Support Documentation**: Troubleshooting guides

### Developer Documentation
- **Contributing Guide**: How to contribute to the project
- **Development Setup**: Local development environment setup
- **Code Style Guide**: Coding standards and conventions
- **Testing Guide**: How to write and run tests
- **Release Process**: How to release new versions

## Plan Completeness Validation

### Status: ✅ ENHANCED & COMPLETE FOR FOUNDATION FRAMEWORK PHASE 1

This plan document has been fully completed and enhanced with all sections populated and no [TBD] placeholders remaining. The document has been specifically enhanced for Foundation Framework Phase 1 implementation with detailed wave decomposition guidance, testing specifications, and Phase 1-specific acceptance criteria. All sections include:

- ✅ **Detailed Requirements**: Functional and non-functional requirements fully specified
- ✅ **Complete Architecture**: System architecture, technology stack, and integration points documented
- ✅ **User Flows**: All 5 primary user flows detailed with step-by-step processes
- ✅ **Business Logic**: Complete business rules for listening history, statistics, and recommendations
- ✅ **Database Schema**: All tables, indexes, and relationships defined with SQL including:
  - Core tables: users, listening_history, playlists, playlist_tracks, artists, tracks, user_streaming_connections, recommendations, friends
  - Enhanced tables: sessions, activity_feed, notifications, user_preferences, sync_jobs
- ✅ **API Specification**: Complete REST API endpoints with request/response examples including:
  - Authentication endpoints
  - Listening history endpoints
  - Playlist endpoints
  - Discovery endpoints
  - Streaming service integration endpoints
  - User profile & preferences endpoints
  - Social features endpoints
  - Notifications endpoints
  - Data export & deletion endpoints
- ✅ **Input Validation Rules**: Comprehensive validation rules for all input types:
  - Email, password, display name validation
  - URL, date/time, numeric validation
  - Enum, JSON schema, array validation
  - Pagination and file upload validation
  - UUID and track/artist/playlist name validation
- ✅ **Security Specifications**: Complete security specifications covering:
  - Authentication security (JWT, session management, token rotation)
  - API security (CORS, CSRF, rate limiting)
  - Data security (encryption at rest/in transit)
  - OAuth security (PKCE, token management)
  - Input sanitization (XSS, SQL injection prevention)
  - Security headers and monitoring
- ✅ **Implementation Roadmap**: 22-week detailed timeline with deliverables
- ✅ **Risk Management**: 8 identified risks with mitigation strategies
- ✅ **Success Metrics**: Technical, product, and business metrics defined
- ✅ **Test Requirements**: Unit, integration, E2E, performance, and security tests specified
- ✅ **Deployment Strategy**: Development, staging, and production environments documented
- ✅ **Operations & Maintenance**: Daily, weekly, monthly, and quarterly procedures defined
- ✅ **Documentation Requirements**: Technical, user, and developer documentation specified

### Enhancements Made

**1. Additional Database Tables:**
- `sessions` — Session management and token tracking
- `activity_feed` — Social activity feed
- `notifications` — User notification system
- `user_preferences` — User preferences and settings
- `sync_jobs` — Background sync job tracking

**2. Additional API Endpoints:**
- User Profile & Preferences: GET/PUT `/users/me`, GET/PUT `/users/me/preferences`
- Social Features: Friends management (GET, POST, PUT, DELETE), activity feed (GET)
- Notifications: GET, mark as read (PUT), mark all as read (PUT), delete (DELETE)
- Data Export & Deletion: GDPR-compliant data export (POST, GET) and account deletion (DELETE)

**3. Input Validation Rules:**
- Email, password, display name validation
- URL, date/time, numeric validation
- Enum, JSON schema, array validation
- Pagination and file upload validation
- UUID and track/artist/playlist name validation

**4. Security Enhancements:**
- Authentication security (JWT, session management, token rotation)
- API security (CORS, CSRF, rate limiting)
- Data security (encryption at rest/in transit)
- OAuth security (PKCE, token management)
- Input sanitization (XSS, SQL injection prevention)
- Security headers (CSP, HSTS, etc.)

**5. Foundation Framework Phase 1 Alignment (NEW):**
- **Phase 1 Scope Definition**: Clear inclusion/exclusion criteria for Phase 1
- **Wave Decomposition Strategy**: 3-wave breakdown (Foundation & Authentication, Streaming Integration, Tracking & Dashboard)
- **Testing Strategy**: TDD approach with unit, integration, and E2E test requirements
- **Enhanced Acceptance Criteria**: Detailed checklists for each Phase 1 component
- **Phase 1 Success Metrics**: Technical, functional, and UX metrics defined
- **Phase 1 Risk Mitigation**: Specific risks and mitigation strategies for Phase 1
- **Phase 1 Deliverables Checklist**: Week-by-week deliverables with test requirements
- **Phase 1 Definition of Done**: 14-point checklist for feature completion

### Ready for Wave Decomposition

This plan is ready for Foundation Framework Phase 1 wave decomposition. All information needed to create detailed subplans, subtests, and unit tests is present and actionable.

**Key additions:**
- 5 new database tables with indexes
- 15+ new API endpoints with request/response examples
- Comprehensive validation rules for all input types
- Security specifications covering authentication, API, data, and OAuth
- **Foundation Framework Phase 1 Alignment section** with wave decomposition, testing strategy, and Phase 1-specific acceptance criteria

The plan now provides a complete foundation for implementation.

### Key Implementation Notes

- **Priority**: Focus on Phase 1 (Core Functionality) first - authentication, Spotify integration, basic tracking
- **Dependencies**: Streaming service API integrations are critical path items
- **Performance**: Database indexing and caching strategies must be implemented from the start
- **Testing**: TDD approach required - all code must have corresponding tests
- **Security**: OAuth token management and data encryption are non-negotiable requirements
- **Validation**: All input validation rules must be implemented before accepting user data
- **Security**: Security specifications must be implemented from Phase 1, not added later

## Foundation Framework Phase 1 Alignment

### Phase 1 Scope Definition

**Core Focus**: Establish the foundation for music listening tracking with minimal viable feature set.

**Included in Phase 1:**
- User authentication and account management
- Spotify OAuth integration (primary streaming service)
- Basic listening history tracking and storage
- Manual listening entry functionality
- Basic statistics calculation (total time, tracks, streak)
- Simple dashboard UI displaying core metrics
- Core API endpoints for authentication and listening history

**Excluded from Phase 1 (Deferred to Later Phases):**
- Apple Music and YouTube Music integrations (Phase 2+)
- Advanced analytics and visualizations (Phase 2)
- Recommendation engine (Phase 3)
- Playlist management (Phase 4)
- Social features (Phase 4)
- Mobile applications (Phase 5+)

### Wave Decomposition Strategy

Phase 1 will be decomposed into **3 waves** for incremental development and testing:

**Wave 1: Foundation & Authentication (Weeks 1-2)**
- Project setup and infrastructure
- Database schema implementation
- User authentication (email/password + OAuth)
- User registration and login flows
- Session management
- **Success Criteria**: Users can register, login, and maintain authenticated sessions

**Wave 2: Streaming Integration (Weeks 3-4)**
- Spotify OAuth flow implementation
- Spotify API client wrapper
- Token management and refresh
- Listening history fetching from Spotify
- Background sync job processing
- **Success Criteria**: Users can connect Spotify and system fetches listening history

**Wave 3: Tracking & Dashboard (Weeks 5-6)**
- Listening history recording and storage
- Deduplication logic
- Manual entry functionality
- Basic statistics calculation (total time, tracks, streak)
- Dashboard UI with core metrics
- **Success Criteria**: Users can view their listening history and basic statistics

### Testing Strategy for Phase 1

**Test-Driven Development Approach:**
- All code must be written alongside corresponding tests
- Tests written before or simultaneously with implementation
- Minimum 80% code coverage for Phase 1 components
- All tests must pass before proceeding to next component

**Test Types Required:**

1. **Unit Tests** (Required for all business logic):
   - Authentication logic (password hashing, JWT generation)
   - Listening history deduplication logic
   - Statistics calculation algorithms
   - Input validation functions
   - Token refresh logic

2. **Integration Tests** (Required for all API endpoints):
   - Authentication endpoints (register, login, logout, refresh)
   - Listening history endpoints (GET, POST)
   - Statistics endpoints (GET stats, top artists/tracks)
   - Spotify OAuth flow (end-to-end)
   - Database operations (CRUD for all Phase 1 tables)

3. **End-to-End Tests** (Required for critical user flows):
   - User registration → email verification → login flow
   - Spotify connection → listening history sync → dashboard display
   - Manual entry → statistics update → dashboard display

**Test Execution Requirements:**
- All tests must pass before code merge
- Tests run automatically on every commit
- Test coverage reports generated and reviewed
- Failed tests block deployment

### Acceptance Criteria Enhancements for Phase 1

**Enhanced Phase 1 Acceptance Criteria:**

1. **Authentication System:**
   - ✅ User can register with valid email (RFC 5322 compliant) and password (meets strength requirements)
   - ✅ User receives email verification link after registration
   - ✅ User can verify email and complete registration
   - ✅ User can login with email/password credentials
   - ✅ User can login with OAuth providers (Google, Apple)
   - ✅ User session persists across browser sessions (refresh token)
   - ✅ User can logout and session is invalidated
   - ✅ Password reset flow works correctly
   - ✅ Failed login attempts are rate-limited (5 attempts per 15 minutes)
   - ✅ Account lockout after 5 failed attempts for 30 minutes

2. **Spotify Integration:**
   - ✅ User can initiate Spotify OAuth connection from dashboard
   - ✅ OAuth flow completes successfully and tokens are stored securely
   - ✅ System can refresh Spotify access tokens automatically
   - ✅ System fetches listening history from Spotify API
   - ✅ Listening history syncs within 5 minutes of music playback
   - ✅ Historical listening data can be imported (up to 50 tracks per sync)
   - ✅ Sync errors are logged and user is notified
   - ✅ User can disconnect Spotify connection

3. **Listening History Tracking:**
   - ✅ Listening events are recorded with timestamp, duration, and track metadata
   - ✅ Duplicate events are detected and deduplicated (same track within 30 seconds)
   - ✅ Partial listens (skipped tracks) are tracked correctly
   - ✅ Manual entries can be added with track name, artist, album, duration
   - ✅ Listening history is queryable by date range and source
   - ✅ Pagination works correctly (50 items per page default)
   - ✅ Listening history is private by default (respects privacy settings)

4. **Basic Statistics:**
   - ✅ Total listening time calculated correctly (sum of all durations)
   - ✅ Total tracks played counted correctly (unique tracks)
   - ✅ Listening streak calculated correctly (consecutive days with plays)
   - ✅ Statistics update in real-time as new events are recorded
   - ✅ Statistics are cached appropriately (5-minute cache for performance)
   - ✅ Statistics API endpoints respond within 2 seconds

5. **Dashboard UI:**
   - ✅ Dashboard displays total listening time (formatted as "X hours Y minutes")
   - ✅ Dashboard displays total tracks played
   - ✅ Dashboard displays current listening streak
   - ✅ Dashboard displays recent listening history (last 10 tracks)
   - ✅ Dashboard is responsive (mobile, tablet, desktop)
   - ✅ Dashboard loads within 3 seconds on 3G connection
   - ✅ Dashboard shows loading states during data fetch
   - ✅ Dashboard handles error states gracefully

6. **API & Technical:**
   - ✅ All API endpoints return proper HTTP status codes
   - ✅ All API endpoints return proper error messages for failures
   - ✅ All API endpoints validate input according to validation rules
   - ✅ All database operations are transactional
   - ✅ Database indexes are created for optimal query performance
   - ✅ API responses include appropriate CORS headers
   - ✅ Rate limiting is implemented (100 requests per minute per user)

### Phase 1 Success Metrics

**Technical Metrics:**
- Test coverage: ≥ 80% for Phase 1 code
- API response time: < 2 seconds for 95th percentile
- Database query time: < 500ms for statistics queries
- Uptime: ≥ 99% during Phase 1 development
- Error rate: < 1% of API requests

**Functional Metrics:**
- User registration success rate: ≥ 95%
- Spotify connection success rate: ≥ 90%
- Listening history sync accuracy: ≥ 99% (no missing tracks)
- Statistics calculation accuracy: 100% (matches manual calculation)

**User Experience Metrics:**
- Dashboard load time: < 3 seconds
- Time to first listening history sync: < 5 minutes after connection
- User satisfaction: ≥ 4/5 stars (internal testing)

### Phase 1 Risk Mitigation

**Specific Phase 1 Risks:**

1. **Spotify API Rate Limits:**
   - **Risk**: Exceeding Spotify API rate limits during bulk sync
   - **Mitigation**: Implement exponential backoff, limit sync to 50 tracks per request, add delays between requests
   - **Fallback**: Manual entry option always available

2. **Token Expiration During Sync:**
   - **Risk**: Spotify tokens expire during long-running sync operations
   - **Mitigation**: Check token expiration before each API call, auto-refresh tokens proactively
   - **Fallback**: Queue failed syncs for retry after token refresh

3. **Database Performance with Large Datasets:**
   - **Risk**: Statistics queries slow down as listening history grows
   - **Mitigation**: Implement database indexes from start, add query result caching, use read replicas
   - **Fallback**: Limit statistics calculations to last 30 days initially

4. **OAuth Flow Failures:**
   - **Risk**: Users unable to complete Spotify OAuth connection
   - **Mitigation**: Clear error messages, retry mechanism, fallback to manual entry
   - **Fallback**: Manual entry remains available throughout Phase 1

### Phase 1 Deliverables Checklist

**Week 1-2 Deliverables:**
- Project repository initialized with Next.js + Express.js
- Development environment setup (Docker Compose)
- PostgreSQL database configured with Prisma
- Database schema migrated (users, sessions, listening_history, artists, tracks tables)
- User authentication API endpoints implemented
- User registration and login flows working
- Email verification implemented
- JWT token management implemented
- Unit tests written for authentication logic (≥ 80% coverage)
- Integration tests written for auth endpoints
- E2E test for registration → verification → login flow

**Week 3-4 Deliverables:**
- Spotify OAuth flow implemented
- Spotify API client wrapper created
- Token refresh mechanism working
- Listening history fetching from Spotify API
- Background sync job processing (SQS workers)
- User_streaming_connections table populated
- Unit tests written for Spotify integration logic
- Integration tests written for Spotify OAuth flow
- E2E test for Spotify connection → sync → dashboard display

**Week 5-6 Deliverables:**
- Listening history recording system implemented
- Deduplication logic working correctly
- Manual entry functionality implemented
- Basic statistics calculation (total time, tracks, streak)
- Listening history API endpoints implemented
- Statistics API endpoints implemented
- Basic dashboard UI implemented
- Responsive design implemented (mobile, tablet, desktop)
- Unit tests written for statistics calculations
- Integration tests written for listening history endpoints
- E2E test for complete user journey (register → connect → view stats)
- Performance testing completed (API response times meet requirements)
- Security testing completed (authentication, authorization, input validation)

### Phase 1 Definition of Done

A Phase 1 feature is considered "Done" when:

1. ✅ Code is implemented according to specifications
2. ✅ All unit tests written and passing (≥ 80% coverage)
3. ✅ All integration tests written and passing
4. ✅ All E2E tests written and passing for critical flows
5. ✅ Code reviewed and approved by team
6. ✅ Documentation updated (API docs, README)
7. ✅ Security requirements met (authentication, authorization, input validation)
8. ✅ Performance requirements met (response times, query times)
9. ✅ Accessibility requirements met (WCAG 2.1 AA for UI components)
10. ✅ Error handling implemented and tested
11. ✅ Logging and monitoring implemented
12. ✅ Deployed to staging environment
13. ✅ Manual testing completed by QA
14. ✅ Product owner approval received

---

## Enhanced Implementation Details

### Development Environment Setup

**Required Tools:**
- Node.js 20+ LTS
- PostgreSQL 15+
- Redis 7+
- Docker & Docker Compose
- Git
- VS Code (recommended) or preferred IDE

**Project Structure:**
```
music-tracker/
├── apps/
│   ├── web/                 # Next.js frontend
│   │   ├── app/
│   │   ├── components/
│   │   ├── lib/
│   │   └── tests/
│   └── api/                  # Express.js backend
│       ├── src/
│       │   ├── routes/
│       │   ├── controllers/
│       │   ├── services/
│       │   ├── middleware/
│       │   └── utils/
│       └── tests/
├── packages/
│   ├── shared/              # Shared types and utilities
│   ├── database/            # Prisma schema and migrations
│   └── ui/                  # Shared UI components
├── infrastructure/
│   ├── docker/
│   ├── kubernetes/
│   └── terraform/
├── docs/
│   ├── api/
│   ├── architecture/
│   └── deployment/
└── tests/
    ├── unit/
    ├── integration/
    └── e2e/
```

**Docker Compose Development Setup:**
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: music_tracker_dev
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  redis:
    image: redis:7
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
  
  api:
    build: ./apps/api
    ports:
      - "3001:3001"
    environment:
      DATABASE_URL: postgresql://dev:dev_password@postgres:5432/music_tracker_dev
      REDIS_URL: redis://redis:6379
      JWT_SECRET: dev_jwt_secret_change_in_production
    depends_on:
      - postgres
      - redis
  
  web:
    build: ./apps/web
    ports:
      - "3000:3000"
    environment:
      NEXT_PUBLIC_API_URL: http://localhost:3001
    depends_on:
      - api

volumes:
  postgres_data:
  redis_data:
```

### Database Migration Strategy

**Prisma Schema Location:** `packages/database/prisma/schema.prisma`

**Migration Workflow:**
1. Make schema changes in `schema.prisma`
2. Generate migration: `npx prisma migrate dev --name migration_name`
3. Review generated SQL migration files
4. Test migration on development database
5. Commit migration files to version control
6. Apply migrations to staging/production: `npx prisma migrate deploy`

**Migration Best Practices:**
- Never modify existing migration files (create new migrations instead)
- Test migrations on copy of production data before applying
- Keep migrations small and focused (one logical change per migration)
- Document breaking changes in migration comments
- Use transactions for multi-step migrations

### API Development Standards

**Endpoint Naming Conventions:**
- Use RESTful conventions: `GET /api/v1/resource`, `POST /api/v1/resource`, `PUT /api/v1/resource/:id`, `DELETE /api/v1/resource/:id`
- Use kebab-case for resource names: `listening-history`, `user-preferences`
- Use plural nouns for collections: `users`, `tracks`, `playlists`

**Error Response Format:**
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": {
      "field": "Specific field error details"
    },
    "request_id": "uuid-for-tracing"
  }
}
```

**Success Response Format:**
```json
{
  "data": {
    // Response data
  },
  "meta": {
    "request_id": "uuid",
    "timestamp": "2024-01-15T10:30:00Z"
  }
}
```

**Request Validation Middleware:**
- All endpoints must validate input using Zod schemas
- Validation errors return 422 Unprocessable Entity
- Invalid format errors return 400 Bad Request

### Testing Implementation Details

**Unit Test Structure:**
```typescript
// Example: tests/unit/services/statistics.service.test.ts
import { describe, it, expect, beforeEach } from '@jest/globals';
import { StatisticsService } from '@/services/statistics.service';

describe('StatisticsService', () => {
  let service: StatisticsService;
  
  beforeEach(() => {
    service = new StatisticsService();
  });
  
  describe('calculateTotalListeningTime', () => {
    it('should calculate total time correctly for valid entries', () => {
      const entries = [
        { duration_listened: 180 },
        { duration_listened: 240 },
        { duration_listened: 120 }
      ];
      
      const result = service.calculateTotalListeningTime(entries);
      
      expect(result).toBe(540);
    });
    
    it('should handle empty entries array', () => {
      const result = service.calculateTotalListeningTime([]);
      expect(result).toBe(0);
    });
  });
});
```

**Integration Test Structure:**
```typescript
// Example: tests/integration/routes/listening-history.test.ts
import request from 'supertest';
import { app } from '@/app';
import { createTestUser, generateAuthToken } from '@/tests/helpers';

describe('GET /api/v1/listening-history', () => {
  let authToken: string;
  
  beforeEach(async () => {
    const user = await createTestUser();
    authToken = generateAuthToken(user.id);
  });
  
  it('should return listening history for authenticated user', async () => {
    const response = await request(app)
      .get('/api/v1/listening-history')
      .set('Authorization', `Bearer ${authToken}`)
      .expect(200);
    
    expect(response.body.data).toHaveProperty('history');
    expect(response.body.data).toHaveProperty('pagination');
  });
  
  it('should return 401 for unauthenticated requests', async () => {
    await request(app)
      .get('/api/v1/listening-history')
      .expect(401);
  });
});
```

**E2E Test Structure:**
```typescript
// Example: tests/e2e/user-registration-flow.test.ts
import { test, expect } from '@playwright/test';

test.describe('User Registration Flow', () => {
  test('should complete full registration flow', async ({ page }) => {
    // Navigate to registration page
    await page.goto('/register');
    
    // Fill registration form
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="password"]', 'SecurePass123!');
    await page.fill('[name="displayName"]', 'Test User');
    
    // Submit form
    await page.click('button[type="submit"]');
    
    // Verify email verification prompt
    await expect(page.locator('text=Check your email')).toBeVisible();
    
    // Simulate email verification (in test environment)
    // ... verification logic
    
    // Verify redirect to dashboard
    await expect(page).toHaveURL('/dashboard');
  });
});
```

**Test Coverage Requirements:**
- Unit tests: ≥ 80% coverage for business logic
- Integration tests: 100% coverage for all API endpoints
- E2E tests: Coverage for all critical user flows

**Test Execution:**
- Run unit tests: `npm run test:unit`
- Run integration tests: `npm run test:integration`
- Run E2E tests: `npm run test:e2e`
- Run all tests: `npm run test`
- Generate coverage report: `npm run test:coverage`

### Error Handling Standards

**Error Types:**
1. **ValidationError** (400/422): Invalid input data
2. **AuthenticationError** (401): Missing or invalid authentication
3. **AuthorizationError** (403): Insufficient permissions
4. **NotFoundError** (404): Resource not found
5. **ConflictError** (409): Resource conflict
6. **RateLimitError** (429): Rate limit exceeded
7. **ExternalServiceError** (502/503): External API failure
8. **InternalServerError** (500): Unexpected server error

**Error Handling Middleware:**
```typescript
// Example error handling middleware
export const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction) => {
  const requestId = req.headers['x-request-id'] || generateUUID();
  
  // Log error with context
  logger.error({
    error: err.message,
    stack: err.stack,
    requestId,
    userId: req.user?.id,
    path: req.path,
    method: req.method
  });
  
  // Return appropriate error response
  if (err instanceof ValidationError) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: err.message,
        details: err.details,
        request_id: requestId
      }
    });
  }
  
  // ... handle other error types
  
  // Default 500 error
  return res.status(500).json({
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'An unexpected error occurred',
      request_id: requestId
    }
  });
};
```

### Logging Standards

**Structured Logging Format:**
```typescript
// Example logging usage
logger.info({
  message: 'User registered successfully',
  userId: user.id,
  email: user.email,
  requestId: req.headers['x-request-id'],
  timestamp: new Date().toISOString()
});

logger.error({
  message: 'Failed to fetch Spotify listening history',
  error: err.message,
  userId: user.id,
  spotifyUserId: spotifyConnection.user_id,
  requestId: req.headers['x-request-id'],
  timestamp: new Date().toISOString()
});
```

**Log Levels:**
- `ERROR`: Errors requiring immediate attention
- `WARN`: Warning conditions (e.g., approaching rate limits)
- `INFO`: Informational messages (e.g., user actions)
- `DEBUG`: Detailed debug information (development only)

### Deployment Pipeline

**CI/CD Workflow:**
1. **Pre-commit hooks:**
   - Run linter (ESLint)
   - Run formatter (Prettier)
   - Run type checker (TypeScript)

2. **On Pull Request:**
   - Run all tests (unit, integration, E2E)
   - Generate coverage report
   - Run security scans
   - Build Docker images

3. **On Merge to Main:**
   - Run all tests
   - Build production Docker images
   - Deploy to staging environment
   - Run smoke tests

4. **On Production Release:**
   - Tag release version
   - Deploy to production
   - Run health checks
   - Monitor for errors

**Deployment Checklist:**
- All tests passing
- Code review approved
- Security scan passed
- Performance benchmarks met
- Database migrations tested
- Environment variables configured
- Backup strategy verified
- Rollback plan documented

### Performance Benchmarks

**API Response Time Targets:**
- Authentication endpoints: < 500ms (p95)
- Listening history endpoints: < 1000ms (p95)
- Statistics endpoints: < 2000ms (p95)
- Spotify integration endpoints: < 3000ms (p95)

**Database Query Performance:**
- User lookup: < 10ms
- Listening history query (50 items): < 100ms
- Statistics calculation (daily): < 500ms
- Statistics calculation (monthly): < 2000ms

**Frontend Performance:**
- First Contentful Paint: < 1.5s
- Time to Interactive: < 3s
- Largest Contentful Paint: < 2.5s
- Cumulative Layout Shift: < 0.1

### Security Checklist

**Authentication Security:**
- JWT tokens use strong secret (min 32 characters)
- Passwords hashed with bcrypt (cost factor 12)
- Rate limiting on authentication endpoints
- Account lockout after failed attempts
- Session management with secure cookies

**API Security:**
- CORS configured correctly
- CSRF protection enabled
- Rate limiting implemented
- Input validation on all endpoints
- SQL injection prevention (parameterized queries)

**Data Security:**
- Sensitive data encrypted at rest
- TLS 1.3 for data in transit
- OAuth tokens encrypted in database
- Secrets stored in environment variables (not code)

---

## Phase 1 Quick Reference Guide

### Critical Path Items (Must Complete First)

1. **Week 1-2: Authentication Foundation**
   - Database schema: `users`, `sessions` tables
   - API endpoints: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/refresh`
   - Tests: Unit tests for password hashing, JWT generation; Integration tests for all auth endpoints
   - Deliverable: Users can register, login, and maintain authenticated sessions

2. **Week 3-4: Spotify Integration**
   - Database schema: `user_streaming_connections` table
   - API endpoints: `/api/v1/integrations/spotify/connect`, `/api/v1/integrations/spotify/callback`
   - Background jobs: Spotify listening history sync worker
   - Tests: Integration tests for OAuth flow; E2E test for connection → sync flow
   - Deliverable: Users can connect Spotify and system fetches listening history

3. **Week 5-6: Core Tracking & Dashboard**
   - Database schema: `listening_history`, `artists`, `tracks` tables with indexes
   - API endpoints: `/api/v1/listening-history`, `/api/v1/stats`, `/api/v1/stats/top-artists`
   - Frontend: Dashboard component with statistics display
   - Tests: Unit tests for deduplication and statistics; Integration tests for all endpoints
   - Deliverable: Users can view listening history and basic statistics

### Essential Database Indexes (Create During Migration)

```sql
-- Critical indexes for Phase 1 performance
CREATE INDEX idx_listening_history_user_id_played_at ON listening_history(user_id, played_at DESC);
CREATE INDEX idx_listening_history_user_id_track_id ON listening_history(user_id, track_id);
CREATE INDEX idx_user_streaming_connections_user_id ON user_streaming_connections(user_id);
CREATE INDEX idx_sessions_user_id_expires_at ON sessions(user_id, expires_at);
```

### Required Environment Variables (Phase 1)

```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/music_tracker

# Authentication
JWT_SECRET=<32+ character random string>
JWT_REFRESH_SECRET=<32+ character random string>
JWT_EXPIRES_IN=1h
JWT_REFRESH_EXPIRES_IN=30d

# Spotify Integration
SPOTIFY_CLIENT_ID=<spotify_client_id>
SPOTIFY_CLIENT_SECRET=<spotify_client_secret>
SPOTIFY_REDIRECT_URI=http://localhost:3000/api/auth/spotify/callback

# Redis (for caching and sessions)
REDIS_URL=redis://localhost:6379

# API Configuration
API_PORT=3001
NODE_ENV=development

# Email (for verification)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=<email_user>
SMTP_PASSWORD=<email_password>
```

### Phase 1 Test Coverage Targets

- **Unit Tests**: ≥ 80% coverage for:
  - Authentication logic (`apps/api/src/services/auth.ts`)
  - Statistics calculations (`apps/api/src/services/statistics.ts`)
  - Deduplication logic (`apps/api/src/services/listening-history.ts`)
  - Spotify API client (`apps/api/src/services/spotify.ts`)

- **Integration Tests**: 100% coverage for:
  - All authentication endpoints (`/api/v1/auth/*`)
  - All listening history endpoints (`/api/v1/listening-history/*`)
  - All statistics endpoints (`/api/v1/stats/*`)
  - Spotify OAuth flow (`/api/v1/integrations/spotify/*`)

- **E2E Tests**: Complete coverage for:
  - User registration → email verification → login flow
  - Spotify connection → listening history sync → dashboard display
  - Manual entry → statistics update → dashboard display

### Phase 1 API Endpoints Summary

**Authentication:**
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/refresh` - Refresh access token
- `POST /api/v1/auth/logout` - User logout
- `POST /api/v1/auth/forgot-password` - Request password reset
- `POST /api/v1/auth/reset-password` - Reset password with token

**Spotify Integration:**
- `GET /api/v1/integrations/spotify/connect` - Initiate OAuth flow
- `GET /api/v1/integrations/spotify/callback` - OAuth callback handler
- `POST /api/v1/integrations/spotify/disconnect` - Disconnect Spotify
- `POST /api/v1/integrations/spotify/sync` - Manual sync trigger

**Listening History:**
- `GET /api/v1/listening-history` - Get listening history (paginated)
- `POST /api/v1/listening-history` - Add manual entry
- `GET /api/v1/listening-history/:id` - Get specific entry
- `DELETE /api/v1/listening-history/:id` - Delete entry

**Statistics:**
- `GET /api/v1/stats` - Get basic statistics (total time, tracks, streak)
- `GET /api/v1/stats/top-artists` - Get top artists
- `GET /api/v1/stats/top-tracks` - Get top tracks

### Phase 1 Definition of Done Checklist

Before marking Phase 1 complete, verify:

- All Phase 1 acceptance criteria met (see Acceptance Criteria section)
- All database tables created with proper indexes
- All API endpoints implemented and tested
- Test coverage ≥ 80% for all Phase 1 code
- All integration tests passing
- All E2E tests passing
- Security requirements implemented (JWT, input validation, rate limiting)
- Performance requirements met (API < 2s, queries < 500ms)
- Dashboard UI responsive and accessible
- Documentation complete (API docs, README, deployment guide)
- Deployed to staging environment
- Manual QA testing completed
- Code reviewed and approved

### Next Steps After Phase 1

Once Phase 1 is complete, proceed to Phase 2:
- Advanced analytics and visualizations
- Additional streaming service integrations (Apple Music, YouTube Music)
- Enhanced statistics (genres, trends, comparisons)
- Chart/graph visualizations
- Statistics export functionality

---

*This plan document serves as the foundation for wave decomposition in Foundation Framework Phase 1.*

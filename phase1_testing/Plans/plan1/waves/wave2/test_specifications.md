# Wave 2: Core Features - Test Specifications

## Test Coverage Overview

### Unit Tests (Core Functions)

1. **Database Schema Models** (`packages/database/schema.prisma`)
   - User model: Creates user with required fields, validates email uniqueness, handles privacy settings
   - ListeningHistory model: Creates record with track/artist/album references, validates timestamp
   - Track model: Creates track with metadata, handles duplicate track names
   - Artist model: Creates artist with name, handles duplicate artist names
   - Album model: Creates album with artist reference, validates foreign key constraints
   - Index performance: Verifies indexes on user_id, timestamp, track_id, artist_id exist and improve query speed

2. **Password Hashing Service** (`apps/auth-service/src/services/password.ts`)
   - `hashPassword()`: Creates bcrypt hash with salt rounds 10
   - `comparePassword()`: Verifies correct password, rejects incorrect password
   - Password validation: Enforces minimum 8 characters, rejects common passwords

3. **Database Migration Utilities** (`packages/database/migrations/`)
   - Migration up: Creates all tables (users, listening_history, tracks, artists, albums) with indexes
   - Migration down: Drops tables in correct order respecting foreign keys
   - Foreign key constraints: Cascading delete rules work correctly (delete user ? delete listening history)

### Integration Tests (API Endpoints)

4. **POST /api/v1/auth/register** (`apps/auth-service/src/routes/auth.ts`)
   - Valid registration: Creates user, returns 201 with user data (password excluded)
   - Duplicate email: Returns 409 conflict with error message
   - Invalid email format: Returns 400 validation error
   - Weak password (<8 chars): Returns 400 validation error
   - Missing required fields: Returns 400 validation error

5. **POST /api/v1/auth/login** (`apps/auth-service/src/routes/auth.ts`)
   - Valid credentials: Returns 200 with accessToken and refreshToken
   - Invalid email: Returns 401 unauthorized
   - Invalid password: Returns 401 unauthorized
   - Non-existent user: Returns 401 unauthorized

6. **POST /api/v1/auth/refresh** (`apps/auth-service/src/routes/auth.ts`)
   - Valid refresh token: Returns 200 with new accessToken
   - Expired refresh token: Returns 401 unauthorized
   - Invalid refresh token: Returns 401 unauthorized
   - Missing token header: Returns 400 validation error

7. **POST /api/v1/listening-history** (`apps/api-service/src/routes/listening-history.ts`)
   - Valid record: Creates listening history entry, returns 201 with created record
   - Invalid user_id: Returns 401 (unauthorized) or 400 (invalid)
   - Missing required fields (track_id, timestamp): Returns 400 validation error
   - Non-existent track_id: Returns 404 not found
   - Duplicate record (same user/track/timestamp): Returns 409 conflict or updates existing

8. **POST /api/v1/listening-history/batch** (`apps/api-service/src/routes/listening-history.ts`)
   - Valid batch (10 records): Creates all records, returns 201 with array of created records
   - Partial success: Handles mix of valid/invalid records, returns 207 Multi-Status
   - Large batch (1000+ records): Processes successfully, completes within timeout
   - Empty batch: Returns 400 validation error
   - Invalid format: Returns 400 validation error

9. **GET /api/v1/listening-history** (`apps/api-service/src/routes/listening-history.ts`)
   - Get user's history: Returns paginated list (default 20 per page)
   - Pagination: Query params `page` and `limit` work correctly
   - Filter by date range: Query params `start_date` and `end_date` filter correctly
   - Filter by artist/track: Query params filter correctly
   - Unauthorized access: Returns 401 if token missing/invalid
   - Empty history: Returns 200 with empty array

10. **PUT /api/v1/listening-history/:id** (`apps/api-service/src/routes/listening-history.ts`)
    - Valid update: Updates listening record, returns 200 with updated record
    - Unauthorized update (different user): Returns 403 forbidden
    - Non-existent record: Returns 404 not found
    - Invalid data: Returns 400 validation error

11. **DELETE /api/v1/listening-history/:id** (`apps/api-service/src/routes/listening-history.ts`)
    - Valid delete: Deletes record, returns 204 no content
    - Unauthorized delete (different user): Returns 403 forbidden
    - Non-existent record: Returns 404 not found

12. **GET/PUT /api/v1/users/:id** (`apps/api-service/src/routes/users.ts`)
    - Get own profile: Returns 200 with user data (password excluded)
    - Get other user's profile: Returns 200 with public fields only (respects privacy settings)
    - Update own profile: Returns 200 with updated data
    - Update other user's profile: Returns 403 forbidden
    - Privacy settings: Hidden profile returns 404 for other users

### E2E Tests (User Flows)

13. **Complete Listening History Flow**
    - User registers ? logs in ? creates listening record ? retrieves history ? updates record ? deletes record

14. **Batch Import Flow**
    - User authenticates ? imports 100 Spotify records via batch endpoint ? verifies all records created ? queries with filters

15. **Authentication Middleware Protection**
    - Protected route with valid token: Returns 200
    - Protected route without token: Returns 401
    - Protected route with expired token: Returns 401, refresh token works

## Test Implementation Priority

**Phase 1 (Critical Path):**
- Tests #1, #2 (Database models & password service)
- Tests #4, #5 (Register & Login endpoints)
- Test #7 (Create listening history)

**Phase 2 (Core Functionality):**
- Tests #8, #9 (Batch import & GET endpoints)
- Tests #10, #11 (Update & Delete endpoints)
- Test #12 (User profile endpoints)

**Phase 3 (E2E Validation):**
- Tests #13, #14 (Complete user flows)
- Test #15 (Middleware protection)

## Test Environment Requirements

- Test database: PostgreSQL instance (Docker container)
- Test utilities: `packages/shared/src/test-helpers/`
- Mock services: Spotify/Apple Music/YouTube Music APIs mocked
- Test data: Seed scripts in `packages/database/tests/fixtures/`
- Performance testing: Measure query performance with indexes vs without

---

*Generated for Wave 2: Core Features*

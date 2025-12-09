# Wave 1: Foundation & Setup - Test Specifications

## Test Coverage Overview

### Unit Tests (Core Functions)
1. **JWT Token Service Tests** (`apps/auth-service/src/services/jwt.ts`)
   - `generateToken()`: Creates valid JWT with userId, expires correctly
   - `validateToken()`: Validates correct tokens, rejects expired/invalid tokens
   - `refreshToken()`: Generates new access token from refresh token

2. **Password Service Tests** (`apps/auth-service/src/services/password.ts`)
   - `hashPassword()`: Creates bcrypt hash, different hash for same password
   - `comparePassword()`: Verifies correct password, rejects incorrect password
   - Password strength validation: Rejects weak passwords (<8 chars, no numbers)

3. **Prisma Model Tests** (`packages/database/`)
   - User model: Creates user with required fields, validates email uniqueness
   - OAuthProvider model: Links to user, stores provider credentials correctly
   - Session model: Creates session with token, expiresAt validation

### Integration Tests (API Endpoints)

4. **POST /auth/register** (`apps/auth-service/src/routes/auth.ts`)
   - Valid registration: Creates user, returns 201 with user data (no password)
   - Duplicate email: Returns 409 conflict
   - Invalid email format: Returns 400 validation error
   - Weak password: Returns 400 validation error
   - Missing fields: Returns 400 validation error

5. **POST /auth/login** (`apps/auth-service/src/routes/auth.ts`)
   - Valid credentials: Returns 200 with accessToken and refreshToken
   - Invalid email: Returns 401 unauthorized
   - Invalid password: Returns 401 unauthorized
   - Non-existent user: Returns 401 unauthorized

6. **POST /auth/refresh** (`apps/auth-service/src/routes/auth.ts`)
   - Valid refresh token: Returns 200 with new accessToken
   - Expired refresh token: Returns 401 unauthorized
   - Invalid refresh token: Returns 401 unauthorized
   - Missing token: Returns 400 validation error

### E2E Tests (User Flows)

7. **Complete Registration Flow**
   - User registers ? receives tokens ? can access protected routes
   - Registration ? email verification (if implemented) ? login

8. **Complete Login Flow**
   - User logs in ? receives tokens ? refreshes token ? continues session
   - Login ? token expires ? refresh ? new access token works

9. **API Gateway Authentication** (`apps/gateway/src/middleware/auth.ts`)
   - Protected route with valid token: Returns 200
   - Protected route without token: Returns 401
   - Protected route with expired token: Returns 401
   - Rate limiting: Blocks after threshold (e.g., 100 req/min)

10. **Database Migration Tests** (`packages/database/`)
    - Initial migration: Creates User, OAuthProvider, Session tables
    - Migration rollback: Reverts schema changes correctly
    - Connection pooling: Handles concurrent connections

## Test Implementation Priority

**Phase 1 (Critical Path):**
- Tests #1, #2 (JWT & Password services)
- Tests #4, #5 (Register & Login endpoints)

**Phase 2 (Core Functionality):**
- Test #6 (Token refresh)
- Test #9 (Gateway auth & rate limiting)

**Phase 3 (E2E Validation):**
- Tests #7, #8 (Complete user flows)
- Test #10 (Database migrations)

## Test Environment Requirements

- Test database: PostgreSQL instance (Docker container)
- Test utilities: `packages/shared/src/test-helpers/`
- Mock services: OAuth providers mocked for unit tests
- Test data: Seed scripts in `packages/database/tests/fixtures/`

---

*Generated for Wave 1: Foundation & Setup*

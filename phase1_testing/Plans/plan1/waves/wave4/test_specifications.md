# Wave 4: Integration & Polish - Test Specifications

## Test Coverage Overview

### Unit Tests (Core Functions)

1. **Service Discovery Service** (`src/services/integration/ServiceDiscovery.swift`)
   - `registerService()`: Registers service with health check endpoint, stores metadata correctly
   - `discoverService()`: Returns available service instances, handles service unavailability gracefully
   - `healthCheck()`: Pings service health endpoint, updates service status (healthy/unhealthy)
   - Edge cases: Service timeout, network failure, duplicate service registration

2. **Circuit Breaker Service** (`src/services/resilience/CircuitBreakerService.swift`)
   - `execute()`: Opens circuit after failure threshold (5 failures), blocks requests in open state
   - `halfOpen()`: Transitions to half-open after timeout, allows single test request
   - `close()`: Closes circuit after successful request, resets failure count
   - Configuration: Verifies failure threshold, timeout duration, success threshold from config

3. **Inter-Service Communication Client** (`src/services/integration/InterServiceClient.swift`)
   - `sendRequest()`: Routes request to correct service via API Gateway, includes authentication headers
   - `retry()`: Implements exponential backoff retry logic (max 3 retries)
   - `handleResponse()`: Parses response, handles HTTP errors (4xx, 5xx) appropriately
   - Service-to-service auth: Includes service token in Authorization header

4. **OAuth Token Refresh Services** (`src/services/integration/spotify/SpotifyOAuthService.swift`, etc.)
   - `refreshAccessToken()`: Exchanges refresh token for new access token, updates stored credentials
   - `isTokenExpired()`: Checks token expiration correctly, handles missing expiry time
   - `handleTokenRefreshFailure()`: Logs out user, clears stored credentials on refresh failure
   - All three services (Spotify, Apple Music, YouTube Music): Token refresh works identically

5. **Error Recovery Service** (`src/services/errors/ErrorRecoveryService.swift`)
   - `attemptRecovery()`: Retries failed operation with exponential backoff, returns success/failure
   - `generateRecoveryOptions()`: Provides user-friendly recovery actions (retry, contact support, refresh)
   - Error categorization: Classifies errors as retryable vs non-retryable correctly

### Integration Tests (API Endpoints)

6. **API Gateway Routing** (`src/gateway/RoutingService.swift`)
   - Route to auth-service: `/api/v1/auth/*` routes correctly, returns 200 for valid requests
   - Route to api-service: `/api/v1/listening-history/*` routes correctly, respects authentication
   - Route to discovery-service: `/api/v1/discovery/*` routes correctly, handles service unavailability
   - Service discovery integration: Routes to healthy service instances only, fails over to backup

7. **Streaming Service OAuth Endpoints** (`src/api/routes/streamingRoutes.swift`)
   - POST `/api/v1/streaming/spotify/connect`: Initiates OAuth flow, returns redirect URL
   - GET `/api/v1/streaming/spotify/callback`: Handles OAuth callback, stores tokens securely
   - POST `/api/v1/streaming/spotify/refresh`: Refreshes expired token, returns new access token
   - All three services: Spotify, Apple Music, YouTube Music OAuth flows work identically
   - Error handling: Invalid callback code returns 400, expired refresh token returns 401

8. **Circuit Breaker Protected Endpoints**
   - GET `/api/v1/streaming/spotify/listening-history`: Fails after 5 errors, returns 503 when circuit open
   - Circuit breaker recovery: Half-open state allows test request, closes on success
   - Fallback handlers: Returns cached data or graceful degradation message when circuit open
   - Response time: Circuit breaker decisions complete within 10ms

9. **Health Check Endpoints** (`src/api/routes/healthRoutes.swift`)
   - GET `/health`: Returns 200 with service status, checks database connectivity
   - GET `/health/ready`: Returns 200 when service ready, 503 when not ready
   - GET `/health/live`: Returns 200 for liveness probe, responds within 100ms
   - Service discovery integration: Health status reported to discovery service

### E2E Tests (User Flows)

10. **Complete OAuth Integration Flow**
    - User clicks "Connect Spotify" ? redirects to Spotify ? authorizes ? returns to app ? tokens stored ? listening history syncs ? UI shows connected status
    - All three services: Spotify, Apple Music, YouTube Music flows work end-to-end
    - Token refresh: Access token expires ? automatically refreshes ? sync continues uninterrupted

11. **Service Failure and Recovery Flow**
    - Spotify API fails ? circuit breaker opens ? fallback handler activates ? user sees graceful degradation message ? API recovers ? circuit closes ? normal operation resumes
    - User can retry failed operations via UI retry button

12. **End-to-End Service Communication Flow**
    - User request ? API Gateway ? routes to api-service ? api-service calls discovery-service ? discovery-service calls external API ? response flows back ? user receives data
    - Inter-service authentication: All service-to-service calls include valid service tokens
    - Service discovery: Failed service automatically fails over to healthy instance

## Test Implementation Priority

**Phase 1 (Critical Path):**
- Tests #1, #2 (Service Discovery & Circuit Breaker)
- Test #6 (API Gateway Routing)
- Test #4 (OAuth Token Refresh)

**Phase 2 (Core Functionality):**
- Tests #3, #5 (Inter-Service Client & Error Recovery)
- Tests #7, #8 (Streaming OAuth & Circuit Breaker Endpoints)
- Test #9 (Health Check Endpoints)

**Phase 3 (E2E Validation):**
- Tests #10, #11, #12 (Complete user flows)
- Performance validation (response times, circuit breaker latency)

## Test Environment Requirements

- Test microservices: All services running in Docker containers with health endpoints
- API Gateway: Test gateway instance routing to test services
- Mock external APIs: Spotify/Apple Music/YouTube Music API mocks with failure simulation
- Circuit breaker state: Redis instance for circuit breaker state storage
- Test OAuth credentials: Sandbox credentials for all three streaming services
- Service discovery: Test Consul/etcd instance for service registration
- Monitoring: Test Prometheus/Datadog instance for metrics collection

## Accessibility Testing Requirements

All UI components must include:
- Accessibility identifiers for all interactive elements
- Descriptive accessibility labels
- Helpful accessibility hints for actions
- Appropriate accessibility traits
- VoiceOver testing for all flows
- XCUITest coverage for UI interactions

---

*Generated for Wave 4: Integration & Polish*

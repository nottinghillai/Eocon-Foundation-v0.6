---
**Implementation Instructions:**
Follow this plan verbatim. Trust the files and references. Do not re-verify. Implement all changes, then review together.
---
# Wave 1: Foundation & Setup
## Objectives
1. Set up project structure with microservices architecture, API Gateway, and database-per-service pattern
2. Configure Prisma 5+ ORM with initial schema for user authentication and core services
3. Implement authentication foundation with JWT tokens, email/password, and OAuth providers (Google, Apple)
## Tasks
1. **Project Structure Setup**: Initialize monorepo structure with service separation
   - Create `apps/` directory: `gateway`, `auth-service`, `history-service`, `stats-service`
   - Create `packages/` directory: `shared`, `database`, `auth`
   - Create `infrastructure/` directory: `docker`, `kubernetes`, `terraform`
   - Set up root `package.json` with workspace configuration
   - Create `tsconfig.json` base configuration and service-specific extends
2. **Database Foundation**: Configure Prisma 5+ with initial schemas
   - Initialize Prisma in `packages/database/` with `schema.prisma`
   - Create `User` model: `id`, `email`, `passwordHash`, `createdAt`, `updatedAt`
   - Create `OAuthProvider` model: `id`, `userId`, `provider`, `providerId`, `accessToken`, `refreshToken`, `expiresAt`
   - Create `Session` model: `id`, `userId`, `token`, `expiresAt`, `createdAt`
   - Configure PostgreSQL connection with connection pooling settings
   - Set up database migration scripts in `packages/database/scripts/`
3. **Authentication Service Foundation**: Build core authentication service
   - Create `apps/auth-service/src/` structure: `routes/`, `controllers/`, `services/`, `middleware/`
   - Implement JWT token generation and validation in `apps/auth-service/src/services/jwt.ts`
   - Implement password hashing with bcrypt in `apps/auth-service/src/services/password.ts`
   - Create email/password registration endpoint: `POST /auth/register`
   - Create email/password login endpoint: `POST /auth/login`
   - Create token refresh endpoint: `POST /auth/refresh`
   - Add request validation middleware using Zod schemas
4. **OAuth Integration Setup**: Configure OAuth providers
   - Create OAuth service abstraction in `packages/auth/src/oauth/base.ts`
   - Implement Google OAuth flow: `packages/auth/src/oauth/google.ts`
   - Implement Apple OAuth flow: `packages/auth/src/oauth/apple.ts`
   - Create OAuth callback handler: `POST /auth/oauth/:provider/callback`
   - Store OAuth tokens securely in database with encryption
   - Add OAuth provider configuration to environment variables
5. **API Gateway Setup**: Create single entry point with authentication and rate limiting
   - Initialize Express/Fastify gateway in `apps/gateway/src/`
   - Configure route forwarding to microservices
   - Implement authentication middleware: validate JWT tokens from `Authorization` header
   - Implement rate limiting middleware: use `express-rate-limit` or `@upstash/ratelimit`
   - Configure SSL/TLS termination
   - Add request logging and error handling middleware
   - Set up health check endpoint: `GET /health`
6. **Development Environment**: Configure local development setup
   - Create `docker-compose.yml` with PostgreSQL, Redis services
   - Set up environment variable templates: `.env.example` files per service
   - Configure Prisma Studio for database inspection
   - Create development scripts: `dev:gateway`, `dev:auth`, `dev:all`
   - Set up hot-reload configuration for each service
   - Configure logging: structured logging with Winston or Pino
7. **Shared Package Setup**: Create shared utilities and types
   - Create `packages/shared/src/types/` with TypeScript interfaces
   - Define `User`, `Session`, `OAuthProvider` types
   - Create `packages/shared/src/utils/` with common utilities
   - Set up error handling utilities: `AppError`, `ErrorHandler`
   - Create response formatting utilities: standardized API responses
8. **Testing Foundation**: Set up testing infrastructure
   - Configure Vitest/Jest for unit tests
   - Set up test database configuration in `packages/database/tests/`
   - Create authentication test utilities: `test-helpers/auth.ts`
   - Write tests for password hashing service
   - Write tests for JWT token generation and validation
   - Configure test coverage reporting
## Dependencies
- Node.js 20+ and npm/pnpm/yarn
- PostgreSQL 15+ database
- Docker and Docker Compose for local development
- OAuth credentials: Google OAuth client ID/secret, Apple OAuth credentials
## Acceptance Criteria
- [ ] All services start successfully with `npm run dev:all`
- [ ] Database migrations run successfully: `npx prisma migrate dev`
- [ ] User registration endpoint accepts email/password and creates user in database
- [ ] User login endpoint returns valid JWT token
- [ ] API Gateway authenticates requests using JWT tokens
- [ ] Rate limiting prevents excessive requests (tested with load testing)
- [ ] OAuth callback endpoints handle Google and Apple OAuth flows
- [ ] Prisma Studio connects to database and displays all tables
- [ ] All unit tests pass: `npm test`
---
*Generated by Foundation Framework Phase 1*

# Rails Hackathon Starter Kit

## Overview
A Rails 8.1.1 application providing both a web interface and JSON API for user management. Originally created as a hackathon starter template.

## Tech Stack
- **Framework**: Rails 8.1.1
- **Ruby**: 3.2.4
- **Database**: SQLite3 (development/test), PostgreSQL (production)
- **Frontend**: Tailwind CSS, Hotwire (Turbo + Stimulus)
- **Authentication**:
  - Web: Session-based with `has_secure_password`
  - API: JWT tokens
- **Server**: Puma
- **Deployment**: Render

## Project Structure

### Models
- `User` (app/models/user.rb)
  - Fields: email, name, password_digest
  - Validations: email presence/uniqueness, password minimum 7 characters
  - Uses bcrypt for password hashing

### Controllers

#### Web Controllers
- `ApplicationController` - Base controller with session authentication
- `SessionsController` - Login/logout for web interface
- `UsersController` - User signup and profile management

#### API Controllers (app/controllers/api/v1/)
- `Api::V1::ApiController` - Base API controller with JWT authentication
- `Api::V1::AuthController` - JWT login and token refresh
- `Api::V1::UsersController` - User CRUD operations

### Authentication

**Web (Session-based):**
- Uses `session[:user_id]`
- `current_user` helper available in controllers/views
- `require_authenticated_user` before_action protects routes

**API (JWT-based):**
- Login: `POST /api/v1/auth/login` with email/password
- Returns JWT token valid for 24 hours
- Include in requests: `Authorization: Bearer <token>`
- Tokens signed with `Rails.application.credentials.secret_key_base`

## API Endpoints

```
POST   /api/v1/auth/login      - Login (returns JWT + user)
POST   /api/v1/auth/refresh    - Refresh token (requires JWT)
GET    /api/v1/users/:id       - Get user details (requires JWT)
POST   /api/v1/users           - Create user (returns JWT + user)
PATCH  /api/v1/users/:id       - Update user (requires JWT, own profile only)
```

## Running the Application

**Local:**
```bash
bundle install
bin/rails db:migrate
bin/rails server
```

**Docker:**
```bash
docker compose build  # Required after Gemfile changes
docker compose up
```

## Key Configuration

- **CORS**: Configured in `config/initializers/cors.rb` (currently allows all origins for development)
- **Routes**: Web and API routes separated in `config/routes.rb`
- **Database**: SQLite schema in `db/schema.rb`

## Deployment to Render

This application is configured for deployment to Render using the `render.yaml` blueprint.

**Prerequisites:**
1. A Render account (sign up at https://render.com)
2. Your `config/master.key` file (needed for Rails credentials)

**Deployment Steps:**

1. **Push your code to GitHub** (if not already done)

2. **Create new Web Service on Render:**
   - Go to https://dashboard.render.com
   - Click "New +" → "Blueprint"
   - Connect your GitHub repository
   - Render will automatically detect `render.yaml` and create:
     - PostgreSQL database (free tier)
     - Web service (free tier)

3. **Set Environment Variables:**
   - In the Render dashboard, go to your web service
   - Navigate to "Environment" tab
   - Add `RAILS_MASTER_KEY` with the value from your `config/master.key` file
   - The `DATABASE_URL` is automatically set from the database connection

4. **Deploy:**
   - Render will automatically deploy on every push to your main branch
   - First deployment may take 5-10 minutes
   - View logs in the Render dashboard to monitor deployment

**Configuration Files:**
- `render.yaml` - Render blueprint defining database and web service
- `bin/render-build.sh` - Build script (runs migrations, precompiles assets)
- `config/database.yml` - Configured for PostgreSQL in production
- `Gemfile` - Includes `pg` gem for PostgreSQL in production

**Free Tier Limitations:**
- Web service spins down after 15 minutes of inactivity
- First request after spin-down may take 30-60 seconds
- Database limited to 1GB storage
- Sufficient for hackathons and prototypes

## Important Notes

- JWT secret uses Rails' `secret_key_base` - do not expose in production
- CORS is currently set to `origins '*'` - configure appropriately for production
- API controllers skip CSRF protection with `skip_before_action :verify_authenticity_token`
- Docker requires rebuild after Gemfile changes to install new gems
- Keep your `config/master.key` secure and never commit it to version control

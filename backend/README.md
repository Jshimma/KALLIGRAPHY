# KALLYGRAPHY Backend

The KALLYGRAPHY backend will provide the API and business logic for:

- Authentication
- Photographer accounts
- Clients
- Portfolio management
- Photography uploads
- Private client galleries
- Favorites
- Downloads
- Bookings
- Packages
- Payments
- Messaging
- Notifications

## Architecture

Flutter
↓
KALLYGRAPHY API
↓
PostgreSQL + KALLYGRAPHY controlled file storage

The backend must not depend on third-party managed photo-storage services.

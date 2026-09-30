# KALLIGRAPHY Backend

The KALLIGRAPHY backend will provide the API and business logic for:

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
KALLIGRAPHY API
↓
PostgreSQL + KALLIGRAPHY controlled file storage

The backend must not depend on third-party managed photo-storage services.

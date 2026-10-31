# delivery_app

The DRS rider app. Uses the same `DrsTheme` and `drs_api` client as the
customer app.

## Milestone 1 scope (scaffold)

- **Login** — phone OTP (`request_otp` / `verify_otp` / `get_me`). Only
  `delivery` and `admin` roles are admitted; anyone else is signed out with a
  message pointing them to the customer app.
- **Today's deliveries** — calls `list_delivery_orders` for the current
  **IST** date (the backend defaults to tomorrow if no date is sent) and shows
  loading / empty / error states with pull-to-refresh.

Not yet: stop details, proof of delivery, cash collection, maps, offline
queue. The Android Maps key is already plumbed as a manifest placeholder
(`DRS_GOOGLE_MAPS_API_KEY` env var or Gradle property; empty by default).

## Run

```bash
flutter run --dart-define-from-file=../../env/dev.json
```

You need a backend user with role `delivery` to get past login.

```bash
flutter test
```

> Android `applicationId` / iOS bundle id are placeholders
> (`com.drsdairy.delivery_app`) — confirm before store setup.

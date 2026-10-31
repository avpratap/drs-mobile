# delivery_app

The DRS rider app. Same `DrsTheme`, `drs_api` client and shared sign-in
(`DrsOtpSignIn` in drs_ui) as the customer app.

## Features (milestone 3)

- **Login** — shared phone-OTP flow; only `delivery` / `admin` roles are
  admitted (others are signed out with a message).
- **Today's deliveries** — `delivery_route` for the current **IST** date
  (the backend defaults to tomorrow), across every shop the rider is
  assigned to, grouped by shop in route order, with a day summary and
  pull-to-refresh. Status mapping from the backend:

  | backend | shown as |
  |---|---|
  | `generated` | Pending |
  | `frozen` (locked by the nightly cutoff, on today's route) | Out for delivery |
  | `delivered` / `partially_delivered` | Delivered / Partly delivered |
  | `failed` | Failed (with reason) |

- **Stop detail** — items with product names, quantities, amount due, contact
  (phone masked on screen), address; **Navigate** (Apple Maps on iOS, Google
  Maps elsewhere — a URL hand-off, no API key needed) and **Call**.
- **Map** — the day's stops with markers and a route polyline using
  `google_maps_flutter`, **only when a key is configured**. Without a key (the
  default) or without coordinates it degrades to a route sketch plus "Open
  route in Google Maps" (multi-stop URL, no key). On tablets / wide
  landscape the map sits beside the list.
- **Proof of delivery** — confirm items (unticked = 0, every planned line is
  reported as the backend requires), take a doorstep photo (required), optional
  note; or **Couldn't deliver** with a reason.

## Offline-first sync

Every rider action is written to Drift first (`PendingActions`) and synced
by `SyncEngine` — immediately, on reconnect, on app resume, every minute, and
on pull-to-refresh.

- **Idempotent**: the action id is sent as `Idempotency-Key`; the backend
  middleware replays a stored 2xx, so a retry after a lost response is never
  applied twice.
- **Photo uploaded once**: the `media:` reference from `upload_pod_asset` is
  saved on the action before the status update, so retries skip the upload
  (multipart bodies can't use idempotency keys — the boundary differs).
- **409** (stop no longer open) is checked against the server route: already
  delivered/failed → done; otherwise the action needs the rider's attention.
- Validation errors (4xx) mark the action "needs attention" with the server
  message; the rider can retry or discard it. Connectivity / 5xx / 429 keep it
  queued.
- The list shows local actions immediately ("Delivered · syncing") with a
  banner of pending / failed updates.

## Privacy (DPDP)

- POD photos are copied into app-private storage only until uploaded, then
  deleted. The backend strips EXIF/GPS and stores them in a private bucket.
- The cached route (which holds names/addresses/phones), the queue and any
  unsent photos are wiped on log out — the rider is warned if unsynced updates
  would be lost.
- `toString()` of stops/accounts is redacted; phone numbers are masked on
  screen and only passed to the dialer.

## Configuration

| define | |
|---|---|
| `DRS_API_BASE_URL` | backend origin (default: Android emulator → `http://10.0.2.2:8000`) |
| `DRS_GOOGLE_MAPS_API_KEY` | optional; enables the in-app map. One define serves both platforms: Gradle decodes it from `dart-defines` into the manifest; on iOS Dart passes it to `GMSServices.provideAPIKey` over the `drs/maps` channel. Never committed. |

Smoke-test against a deployed dev backend without changing defaults:

```bash
flutter run --dart-define=DRS_API_BASE_URL=https://<your-dev-backend>
```

The seeded rider is `9999900003`; dev backends return the OTP, shown as
"Use dev code …" on non-prod builds.

## Platforms

Android `in.drsdairy.delivery` (min SDK 24, target 36) · iOS
`in.drsdairy.delivery` (iOS 15.0+). Permissions: notifications, foreground
location, camera (POD), photo library (gallery fallback when no camera).
Background location is not requested.

## Tests

```bash
flutter test                        # flows, device matrix, goldens
flutter test --update-goldens --tags golden
```

`FakeDeliveryServer` models the backend rules (rider scope, every-line
reporting, POD required, 409 on closed stops, idempotent replay, lost
responses). Device matrix: 320 dp, 1.5× text, notched iPhone, Pixel, iPhone
landscape, iPad × Android/iOS.

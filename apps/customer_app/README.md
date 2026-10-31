# customer_app

The DRS customer app.

## Milestone 1 scope

- **Shell** — `go_router` `StatefulShellRoute` with bottom navigation:
  Home · Shop · Subscriptions · Account. Auth-aware redirects
  (splash → sign-in → home).
- **Phone-OTP sign-in** — `request_otp` → `verify_otp` (JWT pair saved to
  secure storage) → `get_me`. In non-prod builds the backend's `dev_otp` is
  offered as a one-tap fill. Refresh-on-401 is handled by `drs_api`; if the
  refresh fails the app returns to sign-in.
- **Catalogue** — Home ("Today's essentials", milk line first) and Shop
  (search + category chips) read `list_products` through
  `ProductRepository`: network → Drift cache; on failure the last good
  snapshot is shown with an offline banner. The cache is shown instantly on
  launch while the network refresh runs (stale-while-revalidate).
- Subscriptions and Account sub-pages are placeholders for the next milestones.

## Layout

```
lib/
  main.dart                        ProviderScope + app
  src/app.dart                     MaterialApp.router with DrsTheme
  src/core/                        env / token store / DrsApi / Drift providers
  src/data/local/app_database.dart Drift schema (catalogue cache only)
  src/routing/                     go_router config + route names
  src/features/
    auth/          data → application (AuthController) → presentation
    catalogue/     ProductRepository, catalogue stream, Home & Shop
    subscriptions/ placeholder
    account/       profile summary + sign out
    shell/         bottom-nav shell, splash
```

## Run

```bash
flutter run --dart-define-from-file=../../env/dev.json
# or
flutter run --dart-define=DRS_API_BASE_URL=http://10.0.2.2:8000
```

iOS simulator: use `http://localhost:8000`. A physical device needs your
machine's LAN IP. Release builds refuse cleartext HTTP; prod (`DRS_ENV=prod`)
additionally requires an `https` base URL.

## Codegen & tests

```bash
dart run build_runner build --delete-conflicting-outputs   # riverpod + drift
flutter test
```

Tests use an in-memory Drift database and a scripted HTTP adapter — no
network or device needed.

> Android `applicationId` / iOS bundle id are placeholders
> (`com.drsdairy.customer_app`) — confirm the final ids before store setup.

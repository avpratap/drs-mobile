# drs-mobile

Flutter monorepo for **DRS** — premium Indian dairy (milk, ghee, buttermilk,
curd, paneer). Managed with **Melos 8** on top of **pub workspaces**.

| Path | What |
|---|---|
| `apps/customer_app` | Customer app — shop, subscribe, account ([README](apps/customer_app/README.md)) |
| `apps/delivery_app` | Rider app — login + today's route ([README](apps/delivery_app/README.md)) |
| `packages/drs_ui` | **The one shared `ThemeData`** + brand widgets ([README](packages/drs_ui/README.md)) |
| `packages/drs_api` | Typed dart-dio client generated from the backend OpenAPI contract ([README](packages/drs_api/README.md)) |
| `packages/drs_core` | Domain models (`Product`, `Order`, `Subscription`, `Account`, `Money`), `--dart-define` config, utils ([README](packages/drs_core/README.md)) |
| `openapi/` | API contract + generator config |

Backend: [`avpratap/drs-backend`](https://github.com/avpratap/drs-backend) (FastAPI) ·
Web: [`avpratap/drs-web`](https://github.com/avpratap/drs-web) (Next.js).

## Stack (locked)

Flutter 3.47 / Dart 3.13 · Melos · Riverpod 3 (`hooks_riverpod` +
`riverpod_generator`) · Drift (offline-first) · go_router · dio +
openapi-generator `dart-dio`.

## Getting started

```bash
dart pub global activate melos
melos bootstrap                     # one `pub get` for the whole workspace
melos run analyze                   # must report zero issues
melos run test
```

Run an app against a local backend (`uvicorn app.main:app` in drs-backend):

```bash
cp env/dev.example.json env/dev.json   # git-ignored; fill in what you need
cd apps/customer_app
flutter run --dart-define-from-file=../../env/dev.json
```

## Configuration — no secrets in the repo

All environment-specific values are compile-time `--dart-define`s read by
`DrsEnv` (`packages/drs_core`). Every key defaults to empty; features that
need a missing key stay disabled.

| Define | Purpose |
|---|---|
| `DRS_ENV` | `dev` (default) · `staging` · `prod` — prod hides the dev-OTP hint and requires `https` |
| `DRS_API_BASE_URL` | Backend origin. Default `http://10.0.2.2:8000` (Android emulator → host) |
| `DRS_RAZORPAY_KEY_ID` | Razorpay **publishable** key id (checkout milestone) |
| `DRS_FCM_SENDER_ID` | Firebase Cloud Messaging (push milestone) |
| `DRS_GOOGLE_MAPS_API_KEY` | Maps (delivery app). Android also reads it from the `DRS_GOOGLE_MAPS_API_KEY` env var / Gradle property into a manifest placeholder |

`env/*.json` (except `*.example.json`), `google-services.json`,
`GoogleService-Info.plist`, keystores and `key.properties` are git-ignored.
In CI, pass values from repository secrets.

## Privacy (DPDP)

- JWTs live only in platform secure storage (`flutter_secure_storage`).
- The Drift database caches the **public catalogue only** — no names, phones
  or addresses.
- Phone numbers are masked in the UI (`+91 98•••••210`), passed between
  screens via route `extra` (never in URLs), and `Account`/`OtpArgs`/
  `SessionTokens` redact themselves in `toString()`. Use `Pii.redact()` before
  logging any free text.
- `DrsApiError` messages come from status codes and the backend `detail` only —
  never from request bodies or headers.

## API client

`packages/drs_api` is generated from `openapi/drs-core.openapi.yaml`, a mobile
subset of the backend contract. The backend repo does not commit an OpenAPI
file, so this subset was derived from its FastAPI routes; **every
`operationId` is copied verbatim** (`request_otp`, `verify_otp`,
`list_products`, `get_cart`, `checkout_cart`, `list_subscriptions`,
`my_billing`, `list_orders`, `list_delivery_orders`, …).

```bash
make api-spec BACKEND_DIR=../drs-backend          # export the real spec (needs uv + backend env)
make api-gen SPEC=openapi/drs-backend.openapi.json  # regenerate client + build_runner + tests
make api-gen                                         # regenerate from the subset
```

Hand-written session code (`lib/drs_api_session.dart`, `lib/src/session/**`)
is protected by `.openapi-generator-ignore`.

## Melos scripts

| Script | Does |
|---|---|
| `melos run analyze` | `flutter analyze` in every package |
| `melos run test` | `flutter test` in every package with a `test/` dir |
| `melos run gen` | `build_runner` (json_serializable, drift, riverpod_generator) |
| `melos run format` | Formatting check (generated client excluded) |

Generated `*.g.dart` files are committed so a fresh checkout analyzes
immediately; CI fails if they are stale.

## CI

`.github/workflows/ci.yaml`: bootstrap → codegen-is-fresh check → analyze → test.

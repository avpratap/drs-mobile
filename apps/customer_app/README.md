# customer_app

The DRS customer app.

## Features

**Milestone 1** — adaptive shell (Home · Shop · Subscriptions · Account),
phone-OTP sign-in, offline-first catalogue (Drift).

**Milestone 2** — shopping and standing orders, all server-priced:

- **Cart** — quick-add from catalogue cards (pack-size sheet) or the product
  page (`get_product_full` variants: pack chips with `selling_price`, MRP
  strike-through). The backend keeps one line per product with qty in the
  product's unit, so a 1 L pack adds `qty 1`, two 500 ml packs add `qty 1`.
  Header badge, per-line stepper (base packs), swipe to remove. Totals are
  exactly what the server returns (`get_cart` + `cart_quote` for the GST
  inside the GST-inclusive total) — the app never computes money.
- **Checkout** — saved / new address (GST state list, PIN validation),
  review with serviceability + ETA, `checkout_cart` with an
  `Idempotency-Key` reused on retry, then `create_payment` →
  Razorpay → `verify_payment`. Handles success, failure/cancel (order kept,
  retry pays the same order), and pending (UPI app / lost connection while
  verifying → "Check status", never shown as failed).
- **Standing orders** — browse subscribable products, configure pack ×
  count and cadence (daily / every N days / chosen weekdays), create the
  home subscription (`create_subscription` + `set_subscription_items`),
  tomorrow's plan, pause / resume / cancel, and skip a day
  (`set_override` qty 0, date picker starts after the 23:00 IST cutoff).
- **Wallet & orders** — balance + signed ledger; order history (Drift-cached
  for offline), order detail with GST lines, tracking timeline + courier
  events, pay-now for unpaid orders, cancel when the backend allows it.

### Payments (Razorpay) — test mode only, no secrets

The key used is the **publishable** key id (`rzp_test_…`); the secret
never leaves the backend.

| Build | Key used | Behaviour |
|---|---|---|
| `--dart-define=DRS_RAZORPAY_KEY_ID=rzp_test_…` | that key | Razorpay Standard Checkout (test mode) |
| no define, backend has keys | backend `key_id` from `create_payment` | Razorpay checkout |
| no define, backend in dev-stub mode, `DRS_ENV≠prod` | — | "Test payment" screen: simulate success / failure / pending against the backend stub (`signature: dev`) |
| `DRS_ENV=prod` with no key anywhere | — | payment unavailable message; order kept |

### Privacy

The Drift cache stores the public catalogue plus order history and standing
orders (for offline viewing); those two are wiped on sign-out. Wallet data
and addresses are never cached. Razorpay checkout is opened without
prefilled contact details.

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
    cart/          CartController (serialised mutations), badge, pack picker
    checkout/      addresses, CheckoutController state machine, Razorpay
    orders/        history (cached), detail, tracking
    wallet/        balance + ledger
    subscriptions/ standing orders, cadence editor, skip/pause/resume
    account/       profile, addresses, sign out
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

Tests use an in-memory Drift database and `FakeDrsServer`, an in-memory
model of the backend rules (server re-pricing, idempotent checkout, dev-stub
payments, subscription templates/overrides) — no network or device needed.

- `cart_flow_test`, `checkout_flow_test`, `subscription_flow_test`,
  `wallet_orders_test` — end-to-end widget flows.
- `responsive_test`, `commerce_responsive_test` — 6 devices (320 dp phone,
  1.5× text, notched iPhone, Pixel, iPhone landscape, iPad) × Android/iOS:
  no overflow, toolbars below the notch, sticky buttons above the home
  indicator.
- `goldens_test` (tag `golden`) — pixel snapshots with the real brand
  fonts. After an intended UI change: `flutter test --update-goldens --tags golden`.

## Platforms

Android `in.drsdairy.customer` (min SDK 24, target 36) · iOS
`in.drsdairy.customer` (iOS 15.0+). Permissions: notifications only.
See the root README for build toolchain and signing.

```bash
flutter build apk --debug                 # Android (needs Android SDK)
flutter build ios --debug --no-codesign   # iOS (needs macOS + Xcode)
```

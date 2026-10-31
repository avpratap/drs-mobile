# Push notifications (FCM)

Both apps share one notifications service (`drs_ui`: `NotificationsController`,
`FirebasePushPlatform`; `drs_core`: payload contract + `DeviceTokenRegistrar`).

## How it is configured — no Firebase files in the repo

Firebase is initialised **from `--dart-define` values**, the same pattern as
Maps and Razorpay. There is no `google-services.json` or
`GoogleService-Info.plist` in git and the Google Services Gradle plugin is not
used. When any value is missing (CI, local dev, tests) the apps run with a
no-op push platform: no Firebase init, no prompts, no crashes — the
notifications switch reads "Not available in this build".

| define | where to find it (Firebase console → Project settings) |
|---|---|
| `DRS_FIREBASE_PROJECT_ID` | General → Project ID |
| `DRS_FCM_SENDER_ID` | Cloud Messaging → Sender ID (= project number) |
| `DRS_FIREBASE_API_KEY` | General → Web API key (restrict it in Google Cloud to the Android/iOS apps) |
| `DRS_FIREBASE_APP_ID_ANDROID` | Your apps → Android app → App ID (`1:…:android:…`) |
| `DRS_FIREBASE_APP_ID_IOS` | Your apps → iOS app → App ID (`1:…:ios:…`) |

These are client identifiers, not secrets, but keep them out of git anyway:
put them in a git-ignored `env/<flavor>.json` (copy `env/dev.example.json`)
and build with `--dart-define-from-file=env/<flavor>.json`; in CI, inject them
from repository secrets.

## What you need to drop in

1. **Firebase project** with four apps registered:
   `in.drsdairy.customer` and `in.drsdairy.delivery`, each for Android and iOS.
   Copy the values above into your env file(s). (One project for both apps is
   fine; each app gets its own app ID — use separate env files per app.)
2. **iOS APNs auth key**: Apple Developer → Keys → create a key with *Apple
   Push Notifications service (APNs)*; download the `.p8`. Firebase console →
   Cloud Messaging → Apple app configuration → upload the `.p8` with its Key ID
   and your Team ID (for both iOS apps).
3. **iOS capability** (needs your Apple team, so it is not committed): in Xcode
   open `ios/Runner.xcworkspace` for each app → Runner target → Signing &
   Capabilities → **+ Push Notifications** (adds `Runner.entitlements` with
   `aps-environment`). *Background Modes → Remote notifications* is already
   enabled in `Info.plist`.
4. **Backend**: set `FCM_PROJECT_ID` and `FCM_CREDENTIALS_JSON` (service
   account) on drs-backend, and apply the backend changes below.
5. Optional: a monochrome notification icon for Android
   (`com.google.firebase.messaging.default_notification_icon`); the launcher
   icon is used until then.

No Firebase config file is needed. If you prefer files, `flutterfire configure`
works too — but then keep `google-services.json` / `GoogleService-Info.plist`
git-ignored (they already are) and the dart-defines remain the switch that
turns push on.

## Consent, permission and the token (DPDP)

- Nothing is asked at launch. Signed-in users see an in-app card explaining
  what they'll receive and that a device token is stored; **Allow** shows the
  OS prompt (iOS APNs alert; Android 13+ `POST_NOTIFICATIONS`), **Not now**
  records an opt-out. Denial is handled: the app works normally and the
  Account (customer) / bell sheet (rider) switch explains how to re-enable.
- The FCM token is personal data. It is registered (`register_device_token`)
  only when signed in **and** opted in, re-registered on token refresh,
  deactivated on opt-out (`unregister_device_token_body`, token in the body,
  never a URL) and on sign-out **before** the session is revoked. Consent is
  cleared on sign-out so the next person on the device is asked again. Token
  and consent live in Keychain / Keystore-backed storage and are never logged.

## Payload contract (tap-to-open)

Send a `notification` (title/body) **plus a `data` map**; only these keys are
read, ids must be positive integers, and free-form links are ignored:

| `data.type` (aliases) | customer_app opens | delivery_app opens |
|---|---|---|
| `order.confirmed` (`payment.success`) + `order_id` | order detail | — |
| `order.out_for_delivery` (`shipment.out_for_delivery`) + `order_id` | order detail | — |
| `order.delivered` (`shipment.delivered`, `delivery.completed`) + `order_id` | order detail | — |
| `subscription.*`, `order.generated` | Subscriptions | — |
| `wallet.low` | Wallet | — |
| `promo` (`marketing.promo`), optional `product_id` | product / Shop | — |
| `route.assigned`, `route.changed`, `cutoff.ready` (`delivery.cutoff_ready`) | — | Today's deliveries (route refetched; also refreshed when received in the foreground) |

Without an `order_id` the order kinds open the order list; unknown types just
open the app. Taps work from foreground (local notification on Android,
native banner on iOS), background and terminated states; a tap that arrives
before sign-in is kept until the session is restored.

## Backend follow-ups (for the drs-backend session)

1. `send_push` currently sends only `notification {title, body}`. Add
   `"data": {"type": <event_type>, "order_id": "<id>", …}` (string values) so
   taps can deep-link; the app already accepts the backend's event names.
2. Emit the rider events (`route.assigned`, `route.changed`, `cutoff.ready`)
   from the cutoff/assignment jobs, and `order.out_for_delivery` when a
   shipment leaves.
3. The apps register the classic FCM registration token (HTTP v1
   `message.token`). firebase_messaging 17 also offers Firebase Installation
   ID registration; adopting it needs the backend to accept FIDs (currently
   `min_length=64` rejects them) — migrate both sides together.

# drs_api

Typed Dart client for the DRS FastAPI backend.

- `lib/src/api/**`, `lib/src/model/**`, `lib/drs_api.dart`, `doc/**` are
  **generated** by [openapi-generator](https://openapi-generator.tech) `dart-dio`
  (json_serializable) from `openapi/drs-core.openapi.yaml`. Do not edit them —
  run `make api-gen` from the repo root.
- `lib/drs_api_session.dart` + `lib/src/session/**` are **hand-written** and
  protected by `.openapi-generator-ignore`:
  - `TokenStore` — persistence contract for the JWT pair (apps back it with
    secure storage).
  - `DrsSessionInterceptor` — adds `Authorization: Bearer` to operations whose
    OpenAPI security includes `HTTPBearer`; on 401 calls `refresh_token` once
    and retries.
  - `buildDrsApi(baseUrl:, tokenStore:)` — wires the above.
  - `DrsApiError` — PII-safe error mapping for the UI.

Every method maps 1:1 to a backend `operationId`
(`request_otp` → `AuthApi.requestOtp`, `list_products` → `ProductsApi.listProducts`, …).

## Regenerating

```bash
make api-spec BACKEND_DIR=../drs-backend   # optional: export the full spec from the backend
make api-gen                                # openapi-generator + build_runner
```

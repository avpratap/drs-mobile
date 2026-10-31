# drs_core

Pure-Dart shared domain layer for the DRS apps.

- `DrsEnv` — compile-time config via `--dart-define` (no secrets in source).
- Models: `Money` (integer paise, `en_IN` formatting), `Product` + `ProductLine`,
  `Order`, `Subscription`, `Account`.
- Utils: `IndianPhone` (mirrors backend normalisation), `Pii` (DPDP-friendly
  masking/redaction for anything that might reach logs).

```bash
dart test
```

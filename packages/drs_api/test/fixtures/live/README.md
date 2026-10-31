Public catalogue responses captured from the live backend
(`drs-backend-zvb1.onrender.com`, 2026-10-31) with anonymous requests.
They contain no personal data (reviews are anonymous; `user_id` is null).
`live_contract_test.dart` decodes them with the generated models so a
backend shape change is caught without network access. Refresh with
`tool/smoke_live.dart` + curl when the backend contract changes.

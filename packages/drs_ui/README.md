# drs_ui

The DRS design system. **One** `ThemeData` (`DrsTheme.light`, optional
`DrsTheme.dark`) shared by `customer_app` and `delivery_app`.

| Token | Hex | Role |
|---|---|---|
| green | `#0D4C3C` | `primary` |
| maroon | `#3B0A1E` | `secondary` |
| gold | `#C5A253` | `tertiary` — accent, use sparingly |
| cream | `#F4EADE` | `surface`, `onPrimary` |
| ink | `#1E1A1E` | `onSurface` |
| sky | `#6FC5F4` | `DrsColors.sky` — **milk / buttermilk line only** (`DrsColors.accentFor`) |

Fonts are bundled (OFL): **Poppins** 400–700 for UI/body, **Montserrat
ExtraBold** for the `DrsLogo` wordmark only. No runtime font fetching.

Widgets: `DrsButton`, `DrsAppBar`, `DrsScaffold`, `DrsLogo`, `DrsPrice`,
`DrsQuantityStepper`, `DrsProductCard`, `DrsLoading`, `DrsEmptyState`
(+ `.error`), `DrsOfflineBanner`, `DrsPhoneField`, `DrsOtpField`.

Accessibility: 48dp minimum targets, semantics labels on price/stepper, and
nothing clamps `textScaler` — layouts are tested at 2× text.

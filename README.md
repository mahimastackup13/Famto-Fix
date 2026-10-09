# Famto Mini — Service Booking Flow

A small, production-style Flutter demo that walks a customer through the complete flow:

**Login → Home → Service Category → Service List → Service Details → Booking → Confirmation**

All data is local/mock (no backend). The code is structured so the mock repository can be swapped for a real API without touching any UI.

---

## Features

| Requirement | Where it lives |
|---|---|
| Login (phone + guest, mock) | `screens/login_screen.dart`, app name in `core/app_config.dart` |
| Home with service categories | `screens/home_screen.dart`, `widgets/category_card.dart` |
| Service list per category (search) | `screens/service_list_screen.dart`, `widgets/service_card.dart` |
| Details: name, image, price, rating, duration, description | `screens/service_details_screen.dart` |
| Date + time-slot selection | `widgets/date_selector.dart`, `widgets/time_slot_picker.dart` |
| Customer form with validation | `screens/booking_screen.dart`, `core/validators.dart` |
| Booking confirmation | `screens/confirmation_screen.dart` |
| Loading / empty / error states | `providers/async_state.dart`, `widgets/state_views.dart`, `widgets/skeleton.dart` |
| Reusable widgets | `lib/widgets/*` |
| Clean navigation | `core/router.dart` (named routes + typed arguments) |
| Responsive UI | `ResponsiveCenter`, `SliverGridDelegateWithMaxCrossAxisExtent`, scrollable layouts |

## Setup

Requirements: Flutter **3.22+** (Dart 3.3+).

```bash
cd famto_mini_booking
flutter create .          # generates android/ios/web/etc. platform folders (keeps lib/ and pubspec.yaml)
flutter pub get
flutter run               # pick any device/emulator/Chrome
flutter test              # unit tests
flutter analyze
```

## Try the states (demo tips)

- **Loading**: skeleton placeholders show for ~0.8 s on every fetch.
- **Empty**: open the **Painting** category — it intentionally has no services. Also search for something like "zzz" in any list.
- **Error**: tap the **⋮ menu** in the Home banner → *Simulate network error*, then pull to refresh or open a category. Use **Try again** after switching it off. The same switch makes *Confirm Booking* fail with a Retry action.
- **Slots**: some slots are struck-through (already booked or less than an hour away) and cannot be selected.
- **Validation**: submit the empty form, or enter a 9-digit phone number.

## Architecture

```
lib/
├── main.dart / app.dart        # entry point, dependency wiring, MaterialApp
├── core/                       # theme, router, validators, formatters
├── models/                     # ServiceCategory, Service, TimeSlot, Booking
├── data/                       # MockData + ServiceRepository (simulated latency/errors)
├── providers/                  # CatalogProvider, BookingProvider, AsyncState
├── screens/                    # one file per step of the flow
└── widgets/                    # reusable UI building blocks
```

Layering is one-directional: **screens → providers → repository → mock data**. Widgets never talk to the repository directly.

### State management: Provider (`ChangeNotifier`)

Why I chose it:

1. **Right-sized.** Two small pieces of state (catalogue loading, in-progress booking) don't justify the ceremony of Bloc or the codegen/learning curve of Riverpod.
2. **Official and familiar.** It's the Flutter-team-recommended starting point, so any Flutter dev can read the code immediately.
3. **Testable.** Providers depend on an injected `ServiceRepository`, so they're unit-testable without any widgets.
4. **Scoped state.** `CatalogProvider` (browse) and `BookingProvider` (checkout) have separate responsibilities; form text stays local in the screen's controllers because it's ephemeral UI state.

If the app grew (auth, payments, offline cache, many async sources) I would move to **Riverpod** or **Bloc** for compile-time safety, easier async composition and stricter event/state modelling. The `AsyncState<T>` abstraction would carry over almost unchanged.

### Navigation

Named routes live in `AppRoutes`; `AppRouter.onGenerateRoute` validates the argument type for each route and shows a friendly page on bad input. After a successful booking, `pushNamedAndRemoveUntil` clears the stack back to Home, and the confirmation screen uses `PopScope` so the system back button returns Home instead of back into the finished form. A `Hero` animation connects the list thumbnail to the details header.

### Loading / empty / error

Every async screen switches on one `AsyncState<T>` (`loading | loaded | empty | error`):

- loading → skeleton placeholders
- empty → `EmptyView` with a helpful action
- error → `ErrorView` with **Try again**
- booking submission → button spinner, double-submit guard, error snackbar with **Retry**

### Booking & validation rules

| Field | Rule |
|---|---|
| Name | required, ≥ 3 chars, letters/spaces/`.'-` only |
| Phone | required, Indian mobile: 10 digits starting 6–9 (digits-only keyboard/formatter) |
| Address | required, ≥ 10 chars (house no., street, landmark) |
| Date | next 7 days; first day with an open slot is pre-selected |
| Time slot | required; slots < 1 hour away or "booked" are disabled; changing the date clears an invalid selection |

Fields validate as the user interacts, and again on submit.

### Images

`Service.imageUrl` is optional. When set, `ServiceImage` loads it over the network and falls back gracefully on error; when `null` (default) it renders a themed gradient illustration using the category icon/colour, so the demo works fully offline with zero assets. To use real photos, set `imageUrl` in `data/mock_data.dart` (or swap in `Image.asset`).

## Assumptions & trade-offs

- Mock availability is deterministic (not real inventory); booking IDs are generated locally.
- Bookings aren't persisted; killing the app clears them (a repository + local DB/API would be the next step).
- Currency is INR; phone validation targets Indian mobiles.
- Material 3 with a single custom theme (`core/theme.dart`); no dark theme yet.

## Possible next steps

Persisted booking history, real API + auth, address autofill/maps, payment, push notifications, dark mode, localisation (`intl` is already in place), widget/integration tests.

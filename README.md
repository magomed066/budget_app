# Budget App

A small Flutter budget app using manually declared Riverpod 3 providers.

## Structure

- `lib/main.dart`: starts the app inside `ProviderScope`.
- `lib/app/`: app widget, theme and palettes, route creation, and tab shell.
- `lib/core/network/`: shared HTTP transport, response parsing, errors, and the
  provider that owns and closes the API client.
- `lib/core/utils/`: shared logging.
- `lib/features/auth/data/`: auth repository and the existing user/response model.
- `lib/features/auth/presentation/`: welcome/login screens, login form, and
  Riverpod repository wiring and login controller.
- `lib/features/home/presentation/`: dashboard and its balance/header widgets.
- `lib/shared/widgets/`: reusable text field, app bar, loading indicator, and toast
  overlay.

Login requests go through `AuthRepository`. `LoginController` owns the asynchronous
loading, result, and error state; the screen listens for errors to show toasts.
Text controllers, tab selection, and balance visibility remain widget-local.
The controller is disposed when login is no longer used and ignores late results.
There is no domain layer or generated code because the current logic does not
require it.

The existing behavior is preserved: welcome pushes login, successful login stays
on the login page, and the tab shell retains its existing placeholder pages.
The dashboard still uses static data. There is no local database or token
persistence. The API remains `http://127.0.0.1:3000` with a 20-second timeout.
The auth and dashboard palettes intentionally retain their different colors;
the active app theme remains the original Inter text theme.

## Verification

```sh
dart format lib test
flutter analyze
flutter test
```

Tests use a mock HTTP client to cover login requests, loading, errors, retry,
duplicate submissions, and disposal, alongside widget navigation and toast tests.

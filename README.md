# Rionydo — Swiss Car Exchange

![Flutter](https://img.shields.io/badge/Flutter-v3.22+-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green)
![Stripe](https://img.shields.io/badge/Payments-Stripe-6772E5?logo=stripe&logoColor=white)

Swiss Car Exchange is a premium digital marketplace for car auctions in Switzerland. Built with Flutter, it delivers a high-performance, secure, and intuitive experience for private buyers and commercial companies.

---

## Key Features

- **Secure Authentication**: Login with 2FA and email verification
- **Subscription Plans**: Tiered Basic & Premium plans via Stripe
- **Real-time Bidding**: Live auction system with WebSocket updates
- **Role-based Access**: Distinct flows for Private & Company users
- **Premium UI**: Glassmorphism, vibrant aesthetics, smooth micro-animations

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Android & iOS) |
| State Management | Provider |
| HTTP Client | Dio (centralized ApiClient with interceptors) |
| Secure Storage | flutter_secure_storage |
| Payments | Stripe Checkout (WebView) |
| Connectivity | connectivity_plus |
| Responsive UI | flutter_screenutil |
| Environment | flutter_dotenv |

## Architecture

### Clean Architecture — Layer Flow

```
UI (Screens / Widgets)
    ↓  context.read / watch / select
Provider (State Management)
    ↓  calls
Service (Business Logic)
    ↓  calls
Repository (Data Validation & Aggregation)
    ↓  calls
ApiClient (Dio HTTP Client)
```

**Strict rules:**
- No layer skips another (UI never imports Repository/ApiClient directly)
- Provider never calls Dio or ApiClient
- Service contains all business logic; Provider only holds state
- JSON parsing only inside model `fromJson()` factories
- Validators live in `core/utils/validators.dart` only
- Connectivity checks live in `core/network/connectivity_service.dart` only
- Empty/null validation lives in the Repository layer only

### Folder Structure

```
lib/
├── main.dart
├── app.dart
├── app_router.dart
├── firebase_options.dart
│
├── core/                        # Shared infrastructure
│   ├── api/                     # Dio client, interceptors, endpoints
│   ├── constants/               # Colors, text styles, spacing, strings, etc.
│   ├── errors/                  # Exceptions, error handler
│   ├── network/                 # Connectivity service
│   ├── theme/                   # App theme definition
│   ├── utils/                   # Validators, helpers
│   └── widgets/                 # Reusable UI components (shimmer, skeleton, offline banner, etc.)
│
├── features/                    # Feature-based modules
│   ├── auth/
│   ├── auctions/
│   ├── bidding/
│   ├── profile/
│   ├── subscription/
│   ├── payment/
│   ├── home/
│   ├── search/
│   ├── notification/
│   ├── settings/
│   ├── premium/
│   └── won_auction/
│       └── Each feature: data/ → models/, repositories/
│                       services/
│                       providers/
│                       ui/ → screens/, widgets/
│
├── services/                    # App-wide services (socket, firebase)
└── helpers/                     # S3 upload, secure storage helpers
```

## UI/UX Standards

- **Responsive**: All dimensions use flutter_screenutil (`.w`, `.h`, `.sp`, `.r`)
- **States**: Every screen handles loading (shimmer/skeleton), empty, error, retry, and success states
- **No blank screens**: Loading states are always visible during API calls
- **Design system**: Consistent spacing, typography, colors via centralized constants

## Connectivity

- Monitored via `connectivity_plus` (dedicated `ConnectivityService`)
- Persistent top banner when offline — dismissible only after connection restores
- All API calls check connectivity first; `NoInternetException` thrown if offline
- Auto-retry last failed request on reconnection

## Code Quality

- Max 200 lines per file; split by responsibility
- Max ~60 lines per build method; extract sub-widgets
- `const` widgets everywhere; `context.select()` over `context.watch()` for partial state
- `ListView.builder` for dynamic lists — never `ListView(children: [...])`
- Controllers properly disposed
- No hardcoded values, magic numbers, or inline validation
- All debug prints guarded with `kDebugMode`

## Security

- Secrets via `flutter_dotenv` (no hardcoded tokens/keys)
- Tokens and sensitive data in `flutter_secure_storage`
- Auth, logging, and retry interceptors on Dio

## Getting Started

### Prerequisites
- Flutter SDK 3.22+
- Android Studio / VS Code
- CocoaPods (iOS)

### Installation

```bash
git clone https://github.com/Ismail554/SwissCarExchange.git
cd rionydo
flutter pub get
flutter run
```

## Documentation

Detailed API specs and flows are in `api_doc/`:

- [Folder Structure Preview](api_doc/folder_structure_preview.md)
- [Authentication & Subscription Flow](api_doc/flow.md)
- [User Profile API](api_doc/user_profile.md)
- [Project Constants](api_doc/constants.md)

## Testing

- Provider, Repository, and Validator tests
- Critical widget tests
- Connectivity handling tests (offline banner, API blocking)
- Plan: `flutter test`

---

&copy; 2026 Rionydo. All rights reserved.
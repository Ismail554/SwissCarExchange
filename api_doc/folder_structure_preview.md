# Rionydo - Target Folder Structure (Clean Architecture)

```
lib/
├── main.dart
├── app.dart
├── app_router.dart
├── firebase_options.dart
│
├── core/
│   ├── api/
│   │   ├── api_client.dart              # Centralized Dio instance
│   │   ├── api_interceptors.dart        # Auth, logging, retry interceptors
│   │   └── api_endpoints.dart           # All API endpoint constants
│   │
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_spacing.dart
│   │   ├── app_dimensions.dart
│   │   ├── app_strings.dart
│   │   ├── app_durations.dart
│   │   └── app_assets.dart
│   │
│   ├── errors/
│   │   ├── exceptions.dart              # Custom exception classes
│   │   └── error_handler.dart           # Centralized error handling
│   │
│   ├── network/
│   │   └── connectivity_service.dart    # connectivity_plus wrapper
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   ├── validators.dart              # All validation logic
│   │   └── helpers.dart
│   │
│   └── widgets/                         # Shared/reusable widgets
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── shimmer_loader.dart
│       ├── skeleton_loader.dart
│       ├── offline_banner.dart
│       ├── empty_state_widget.dart
│       ├── error_state_widget.dart
│       └── loading_overlay.dart
│
├── features/                            # Feature-based modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── login_request.dart
│   │   │   │   ├── login_response.dart
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   ├── services/
│   │   │   └── auth_service.dart        # Business logic
│   │   ├── providers/
│   │   │   └── auth_provider.dart       # State management
│   │   └── ui/
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── register_screen.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── register_form.dart
│   │
│   ├── auctions/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── auction_model.dart
│   │   │   │   └── auction_filter.dart
│   │   │   └── repositories/
│   │   │       └── auction_repository.dart
│   │   ├── services/
│   │   │   └── auction_service.dart
│   │   ├── providers/
│   │   │   ├── auction_list_provider.dart
│   │   │   └── auction_detail_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   ├── auction_list_screen.dart
│   │       │   └── auction_detail_screen.dart
│   │       └── widgets/
│   │           ├── auction_card.dart
│   │           ├── auction_filter_bar.dart
│   │           └── bid_timer_widget.dart
│   │
│   ├── bidding/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── bid_model.dart
│   │   │   └── repositories/
│   │   │       └── bid_repository.dart
│   │   ├── services/
│   │   │   └── bid_service.dart
│   │   ├── providers/
│   │   │   └── bid_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── bidding_screen.dart
│   │       └── widgets/
│   │           ├── bid_plate.dart
│   │           └── bid_history_list.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── profile_model.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository.dart
│   │   ├── services/
│   │   │   └── profile_service.dart
│   │   ├── providers/
│   │   │   └── profile_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── profile_screen.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           └── profile_menu_item.dart
│   │
│   ├── subscription/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── subscription_model.dart
│   │   │   └── repositories/
│   │   │       └── subscription_repository.dart
│   │   ├── services/
│   │   │   └── subscription_service.dart
│   │   ├── providers/
│   │   │   └── subscription_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── subscription_screen.dart
│   │       └── widgets/
│   │           ├── plan_card.dart
│   │           └── payment_webview.dart
│   │
│   ├── payment/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── payment_model.dart
│   │   │   └── repositories/
│   │   │       └── payment_repository.dart
│   │   ├── services/
│   │   │   └── payment_service.dart
│   │   ├── providers/
│   │   │   └── payment_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── payment_screen.dart
│   │       └── widgets/
│   │           └── payment_method_card.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── home_stats_model.dart
│   │   │   └── repositories/
│   │   │       └── home_repository.dart
│   │   ├── services/
│   │   │   └── home_service.dart
│   │   ├── providers/
│   │   │   └── home_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       └── widgets/
│   │           ├── stats_card.dart
│   │           └── featured_auctions.dart
│   │
│   ├── search/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── search_model.dart
│   │   │   └── repositories/
│   │   │       └── search_repository.dart
│   │   ├── services/
│   │   │   └── search_service.dart
│   │   ├── providers/
│   │   │   └── search_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── search_screen.dart
│   │       └── widgets/
│   │           ├── search_bar_widget.dart
│   │           └── search_result_card.dart
│   │
│   ├── notification/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── notification_model.dart
│   │   │   └── repositories/
│   │   │       └── notification_repository.dart
│   │   ├── services/
│   │   │   └── notification_service.dart
│   │   ├── providers/
│   │   │   └── notification_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── notification_screen.dart
│   │       └── widgets/
│   │           └── notification_tile.dart
│   │
│   ├── settings/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── settings_repository.dart
│   │   ├── services/
│   │   │   └── settings_service.dart
│   │   ├── providers/
│   │   │   └── settings_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │           └── settings_tile.dart
│   │
│   ├── premium/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── premium_analytics_model.dart
│   │   │   └── repositories/
│   │   │       └── premium_repository.dart
│   │   ├── services/
│   │   │   └── premium_service.dart
│   │   ├── providers/
│   │   │   └── premium_provider.dart
│   │   └── ui/
│   │       ├── screens/
│   │       │   └── premium_analytics_screen.dart
│   │       └── widgets/
│   │           └── analytics_chart.dart
│   │
│   └── won_auction/
│       ├── data/
│       │   ├── models/
│       │   │   └── won_auction_model.dart
│       │   └── repositories/
│       │       └── won_auction_repository.dart
│       ├── services/
│       │   └── won_auction_service.dart
│       ├── providers/
│       │   └── won_auction_provider.dart
│       └── ui/
│           ├── screens/
│           │   └── won_auction_screen.dart
│           └── widgets/
│               └── won_auction_card.dart
│
├── services/                            # App-wide services
│   ├── socket_service.dart
│   └── firebase_service.dart
│
└── helpers/                             # Utility helpers
    ├── s3_upload_helper.dart
    └── secure_storage_helper.dart
```

## Layer Architecture Flow

```
UI (Screens/Widgets)
    ↓  context.read/watch/select
Provider (State Management)
    ↓  calls
Service (Business Logic)
    ↓  calls
Repository (Data Validation & Aggregation)
    ↓  calls
ApiClient (Dio HTTP Client)
```

### Strict Rules:
- **UI → Provider → Service → Repository → ApiClient** — no layer skipping
- UI never imports Repository or ApiClient
- Provider never calls Dio or ApiClient directly
- Service contains all business logic; Provider only holds state
- JSON parsing only inside model `fromJson()` factories
- Validators only in `core/utils/validators.dart`
- Connectivity checks only in `core/network/connectivity_service.dart`
- Empty/null response validation only in Repository layer
- Each file ≤ 200 lines; each build method ≤ ~60 lines
- Use `const` widgets; use `context.select()` over `context.watch()` for partial state
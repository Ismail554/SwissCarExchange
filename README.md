# Swiss Car Exchange - Rionydo

![Rionydo Header](https://img.shields.io/badge/Flutter-v3.22+-02569B?logo=flutter&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-green)
![Stripe](https://img.shields.io/badge/Payments-Stripe-6772E5?logo=stripe&logoColor=white)

Swiss Car Exchange is a premium digital marketplace for car auctions in Switzerland. Built with Flutter, it offers a high-performance, secure, and intuitive experience for both private buyers and commercial companies.

## 🚀 Key Features

- **Advanced Authentication**: Secure login with Two-Factor Authentication (2FA) and email verification.
- **Subscription Management**: Tiered subscription plans (Basic & Premium) integrated with Stripe for seamless checkouts.
- **Real-time Bidding**: Dynamic car auction system with live status updates.
- **Role-based Access**: Specialized flows for Private and Company user types.
- **Premium UI/UX**: Glassmorphism design elements, vibrant aesthetics, and smooth micro-animations.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Dio](https://pub.dev/packages/dio) with centralized interceptors.
- **Secure Storage**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for token management.
- **Payments**: Integrated Stripe Checkout via WebView.

## 📂 Project Structure

```bash
lib/
├── app_utils/      # Networking, Constants, Theme & Helpers
├── controllers/    # Provider State Classes
├── core/           # Reusable Widgets & Base Components
├── models/         # API Request/Response Data Models
└── views/          # Screen Implementations (Auth, Home, Profile, etc.)
```

## 📖 Documentation

Detailed technical flows and API specifications are located in the `api_doc/` directory:
- [Authentication & Subscription Flow](file:///d:/Ismail_flutter/Rionydo/api_doc/flow.md)
- [User Profile API](file:///d:/Ismail_flutter/Rionydo/api_doc/user_profile.md)
- [Project Constants](file:///d:/Ismail_flutter/Rionydo/api_doc/constants.md)

## 🏁 Getting Started

### Prerequisites
- Flutter SDK (v3.22 or higher)
- Android Studio / VS Code
- CocoaPods (for iOS)

### Installation
1. **Clone the repository**:
   ```bash
   git clone https://github.com/Ismail554/SwissCarExchange.git
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the app**:
   ```bash
   flutter run
   ```

## 🔐 Security & Architecture
- **Token Manager**: Centralized logic for access/refresh token lifecycle.
- **Global State**: Reactive state for premium status and user roles.
- **Gated Navigation**: Automatic redirection based on approval status and active subscriptions.

---
© 2024 Rionydo. All rights reserved.

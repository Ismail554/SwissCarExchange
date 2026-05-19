**✅ authProviderDocumentation.md**

```markdown
# AuthProvider Documentation

## Overview

`AuthProvider` is a Flutter `ChangeNotifier` class responsible for handling all authentication-related operations in the Rionydo app. It manages login flows (including 2FA), OTP verification, password management, account status checks, and logout functionality.

It integrates with:
- Backend APIs via `DioManager`
- Secure storage (`SecureStorageHelper`)
- Token management (`TokenManager`)
- Global app state (`GlobalState`)
- Firebase (FCM initialization after successful login)
- GoRouter for navigation

---

## Class Properties

| Property       | Type    | Description                          |
|----------------|---------|--------------------------------------|
| `isLoading`    | `bool`  | Indicates whether an auth operation is in progress. Notifies listeners on change. |

---

## Methods

### 1. `login()`

**Purpose**: Primary login method with comprehensive flow handling.

**Signature**:
```dart
Future<void> login(
  BuildContext context, {
  required String email,
  required String password,
})
```

**Flow**:
1. Calls `/login` API
2. Handles different account states:
   - **Suspended** → Shows error
   - **Pending approval** → Saves tokens and navigates to `/pending`
   - **2FA Required** → Navigates to `/verify-otp`
   - **Approved + Has Subscription** → Saves tokens, initializes Firebase, navigates to `/home`
   - **Approved + No Subscription** → Navigates to `/before-subscription`

**Special Handling**:
- Unverified email → Automatically triggers `resendOtp()` and navigates to verification.

---

### 2. `verify2fa()`

**Purpose**: Completes Two-Factor Authentication.

**Signature**:
```dart
Future<void> verify2fa(
  BuildContext context, {
  required String email,
  required String twoFactorToken,
  required String code,
})
```

**Flow**: Verifies OTP → Saves tokens → Handles subscription check → Navigates accordingly.

---

### 3. `resendOtp()`

**Purpose**: Resends verification code to email.

**Signature**:
```dart
Future<bool> resendOtp(BuildContext context, {required String email})
```

**Returns**: `true` if successful.

---

### 4. `verifyOtp()`

**Purpose**: Verifies email during registration/signup flow.

**Signature**:
```dart
Future<void> verifyOtp(
  BuildContext context, {
  required String email,
  required String otp,
})
```

**Post-verification**:
- `approved` → Firebase init → `/home`
- `pending` → `/pending`
- Other → Back to `/login`

---

### 5. `logout()`

**Signature**:
```dart
Future<void> logout(BuildContext context)
```

Clears tokens via `DioManager.logout()` and navigates to login screen.

---

### 6. `checkApprovalStatus()`

**Purpose**: Polling method used in `PendingView`.

**Signature**:
```dart
Future<bool> checkApprovalStatus(BuildContext context)
```

**Returns**: `true` if timer should be cancelled (account approved or suspended).

---

### 7. `checkSubscriptionStatus()`

**Purpose**: Polling method used in `BeforeSubsView`.

**Signature**:
```dart
Future<bool> checkSubscriptionStatus(BuildContext context)
```

**Returns**: `true` if subscription is now active.

---

### Password Management

#### `requestPasswordReset()`
- Step 1 of Forgot Password
- Sends reset code to email

#### `verifyResetCode()`
- Step 2 of Forgot Password
- Returns `password_reset_token` on success

#### `resetPassword()`
- Step 3 of Forgot Password
- Completes password reset using token

#### `changePassword()`
- Used in Settings screen
- Requires current password

---

### Two-Factor Authentication Management

#### `toggle2FA()`

**Signature**:
```dart
Future<bool> toggle2FA(
  BuildContext context, {
  required bool enable,
})
```

Enables or disables 2FA for the authenticated user.

---

## Navigation Routes Used

- `/login`
- `/verify-otp`
- `/pending`
- `/before-subscription`
- `/home`

---

## Error Handling

- All methods use `response.fold()` pattern (Either pattern from DioManager)
- Shows user-friendly messages via `AppSnackBar`
- Loading state managed with `_isLoading` + `notifyListeners()`

---

## Security & Best Practices Implemented

- Tokens saved securely via `SecureStorageHelper`
- Token cache updated via `TokenManager`
- `skipAuth: true` for pre-auth endpoints
- Email trimming for consistency
- Context mounting checks before navigation
- Firebase initialized only after successful authenticated login

---

## Dependencies

- `provider`
- `go_router`
- `firebase_core`
- Custom network layer (`DioManager`, `TokenManager`)
- Models: `LoginResponse`, `SubscriptionPlan`
- Helpers: `SecureStorageHelper`, `AppSnackBar`

---

**Generated from**: `auth_provider.dart`  
**Last Updated**: May 2026

```
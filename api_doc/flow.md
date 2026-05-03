# Authentication and User Flow

## 1. Login Success Flow

### Condition

```json
{
  "approval_status": "approved",
  "is_two_factor_required": false,
  "is_email_verified": true
}
```

### Action

* Store access token for session validation
* Navigate to:

```
@lib/views/main_navigation/bottom_nav.dart
```

---

## 2. Two-Factor Authentication (2FA)

### Login Response (2FA Required)

```json
{
  "is_two_factor_required": true,
  "is_email_verified": true,
  "two_factor_token": "",
  "message": "Verification code sent to your email."
}
```

### Action

* Navigate to OTP verification screen

### Verify 2FA API

**POST**

```
{{baseUrl}}/api/auth/login/two-factor/verify/
```

#### Request Body

```json
{
  "email": "",
  "two_factor_token": "",
  "code": ""
}
```

#### Success Response (200)

```json
{
  "access": "",
  "refresh": "",
  "user_id": 13,
  "email": "",
  "role": "bidder",
  "approval_status": "approved",
  "user_type": "private",
  "company": "",
  "subscription": {
    "has_subscription": false,
    "plan": null,
    "status": null,
    "current_period_start": null,
    "current_period_end": null,
    "cancel_at_period_end": false
  }
}
```

---

## 3. Subscription Flow

### No Subscription

```json
{
  "has_subscription": false
}
```

### Action

* Navigate to:

```
@lib/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart
```

* Restrict access to the application
* Poll subscription status every 1 minute

### Check Subscription Status API

**GET**

```
{{base_url}}/api/subscriptions/me/
```

#### Response

```json
{
  "has_subscription": true,
  "plan": "basic",
  "status": "active",
  "current_period_start": "2026-05-03T21:23:21Z",
  "current_period_end": "2026-06-03T21:23:21Z",
  "cancel_at_period_end": false
}
```

### When Subscription Becomes Active

* Show message: "Now login again"
* Navigate to:

```
@lib/views/auth/login/login_views.dart
```

---

## 4. Subscription Plans

### Navigation

```
before_subs_view.dart → subs_view.dart
```

### Get Plans API

**GET**

```
{{base_url}}/api/subscriptions/plans/
```

#### Response

```json
[
  {
    "plan": "basic",
    "name": "Basic",
    "price": "150.00",
    "currency": "chf",
    "interval": "month"
  },
  {
    "plan": "premium",
    "name": "Premium",
    "price": "350.00",
    "currency": "chf",
    "interval": "month"
  }
]
```

### Plan Selection Rules

* `user_type = private` → only "basic"
* `user_type = company` → all plans

---

## 5. Checkout Flow

### API

**POST**

```
{{base_url}}/api/subscriptions/checkout/
```

#### Response

```json
{
  "checkout_url": "https://checkout.stripe.com/..."
}
```

### Action

* Open WebView using `checkout_url`
* On success:

  * Navigate to:

```
@lib/views/auth/login/login_views.dart
```

---

## 6. Approval Status Handling

### Enum

```dart
UserApprovalStatus {
  PENDING,
  APPROVED,
  SUSPENDED
}
```

### Approved

```json
{
  "approval_status": "approved"
}
```

* Navigate to:

```
@lib/views/main_navigation/bottom_nav.dart
```

### Pending

```json
{
  "approval_status": "pending"
}
```

* Navigate to:

```
@lib/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart
```

### Suspended

```json
{
  "approval_status": "suspended"
}
```

* Show error message:

```
Your account is suspended. Contact your owner.
Or try with another account.
```

* Navigate to:

```
@lib/views/auth/login/login_views.dart
```

---

## Flow Summary

* Approved + no 2FA → Main application
* 2FA required → OTP verification → Continue flow
* No subscription → Restricted screen → Poll until active
* Approval status determines final navigation
* Subscription required before accessing the main application
* Token must be stored after successful authentication

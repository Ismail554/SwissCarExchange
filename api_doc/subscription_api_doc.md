# Subscription API Documentation

Base URL: `{{base_url}}`

---

## 0. Plan List

### GET `/api/subscriptions/plans/`

Returns all available subscription plans.

### Response

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

---

## 1. My Subscription

### GET `/api/subscriptions/me/`

Returns the current user's subscription details.

### Response

```json
{
  "has_subscription": true,
  "plan": "premium",
  "status": "active",
  "current_period_start": "2026-05-04T00:43:30Z",
  "current_period_end": "2026-06-04T00:43:30Z",
  "cancel_at_period_end": false
}
```

---

## 2. Upgrade Subscription

### POST `/api/subscriptions/upgrade/`

Upgrade the current subscription plan.

### Request Body

```json
{
  "plan": "premium"
}
```

### Example Response

```json
{
  "message": "Subscription upgraded successfully."
}
```

---

## 3. Downgrade Subscription

### POST `/api/subscriptions/downgrade/`

Schedule a downgrade at the end of the current billing period.

### Request Body

```json
{
  "plan": "premium"
}
```

### Response

```json
{
  "message": "Downgrade scheduled for end of billing period."
}
```

---

## 4. Cancel Subscription

### POST `/api/subscriptions/cancel/`

Cancel the active subscription.

### Request Body

```json
{
  "plan": "premium"
}
```

### Response

```json
{
  "message": ""
}
```

---

## 5. Checkout Session

### POST `/api/subscriptions/checkout/`

Creates a Stripe checkout session.

### Response

```json
{
  "checkout_url": "https://checkout.stripe.com/c/pay/../"
}
```

---

## 6. Stripe Webhook

### POST `/api/subscriptions/webhook/stripe/`

Stripe webhook endpoint for subscription events.

### Example Payload

```json
{
  "plan": "premium"
}
```
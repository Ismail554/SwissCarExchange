# Subscription, Roles, and Access Control Flow

## Constants

### Users

```typescript id="k8w2xj"
UserRole {
  BIDDER = 'bidder',
  DEALER = 'dealer',
}

UserType {
  COMPANY = 'company',
  PRIVATE = 'private',
}
```

---

### Subscriptions

```typescript id="0m4x1n"
SubscriptionPlan {
  BASIC = 'basic',
  PREMIUM = 'premium',
}
```

---

# 1. Overview

The application supports:

* Two user types
* Two user roles
* Two subscription plans

Access and permissions depend on:

* User type
* Active subscription plan

---

# 2. User Types

## Private User

```json id="slm7xg"
{
  "user_type": "private"
}
```

### Subscription Access

* Can purchase only `Basic` plan
* Cannot purchase `Premium`

### Role Access

* `bidder` only

### Restrictions

* Cannot create auctions

---

## Company User

```json id="wyjv2j"
{
  "user_type": "company"
}
```

### Subscription Access

* Can purchase both `Basic` and `Premium`

---

# 3. Subscription Plan Behavior

## Basic Plan

```json id="r5t7w0"
{
  "plan": "basic"
}
```

### Allowed For

* Private users
* Company users

### Assigned Role

```typescript id="yq0h3x"
UserRole.BIDDER
```

### Permissions

* Can participate as bidder
* Cannot create auctions

---

## Premium Plan

```json id="9dyi6m"
{
  "plan": "premium"
}
```

### Allowed For

* Company users only

### Assigned Roles

```typescript id="26m0ph"
UserRole.BIDDER
UserRole.DEALER
```

### Permissions

* Can participate as bidder
* Can create and manage auctions

---

# 4. Role Assignment Rules

| User Type | Subscription Plan | Assigned Roles  |
| --------- | ----------------- | --------------- |
| Private   | Basic             | Bidder          |
| Company   | Basic             | Bidder          |
| Company   | Premium           | Bidder + Dealer |

---

# 5. Auction Creation Access

## Allowed

Auction creation is allowed only when:

```json id="trbq83"
{
  "user_type": "company",
  "subscription": {
    "plan": "premium",
    "has_subscription": true
  }
}
```

### Assigned Roles

```typescript id="ozb5pc"
['bidder', 'dealer']
```

### Result

* Enable create auction feature
* Allow auction management access

---

## Restricted Cases

### Private User

```json id="8ay0jc"
{
  "user_type": "private"
}
```

#### Result

* Auction creation not allowed

---

### Company User with Basic Plan

```json id="6fdm8g"
{
  "user_type": "company",
  "subscription": {
    "plan": "basic"
  }
}
```

#### Assigned Role

```typescript id="gh1t9o"
['bidder']
```

#### Result

* Auction creation not allowed

---

# 6. Subscription Plan UI Rules

## Private User

### Show

* Basic plan

### Hide

* Premium plan

---

## Company User

### Show

* Basic plan
* Premium plan

---

# 7. Feature Access Logic

## Create Auction Button

### Visible

```json id="w0qv1s"
{
  "user_type": "company",
  "subscription": {
    "plan": "premium",
    "has_subscription": true
  }
}
```

---

### Hidden or Disabled

For:

* Private users
* Users without subscription
* Company users with basic plan

---

# 8. Validation Rules

## Frontend Validation

Validate using:

* `user_type`
* `subscription.plan`
* `subscription.has_subscription`

---

## Backend Validation

Backend must validate:

* User type
* Active subscription
* Subscription plan
* User roles

before allowing auction creation APIs.

---

# 9. Access Matrix

| Feature               | Private Basic | Company Basic | Company Premium |
| --------------------- | ------------- | ------------- | --------------- |
| Access Application    | Yes           | Yes           | Yes             |
| Purchase Basic Plan   | Yes           | Yes           | Yes             |
| Purchase Premium Plan | No            | Yes           | Yes             |
| Bid in Auctions       | Yes           | Yes           | Yes             |
| Create Auctions       | No            | No            | Yes             |
| Dealer Access         | No            | No            | Yes             |

---

# 10. Summary

* Basic subscription is for bidder access only
* Premium subscription is available only for company users
* Company premium users receive both bidder and dealer roles
* Only company premium users can create auctions
* Private users can only purchase the basic plan

# Enums and Constants

## 1. Users 
```typescript

UserRole {
  BIDDER = 'bidder',
  DEALER = 'dealer',
}

UserType {
  COMPANY = 'company',
  PRIVATE = 'private',
}

UserApprovalStatus {
  PENDING = 'pending',
  APPROVED = 'approved',
  SUSPENDED = 'suspended',
}

SecurityTokenType {
  EMAIL_VERIFICATION = 'email_verification',
  PASSWORD_RESET = 'password_reset',
  TWO_FACTOR = 'two_factor',
}
```

## 2. Auctions
```typescript
AuctionStatus {
  ACTIVE = 'active',
  SOLD = 'sold',
  UNSOLD = 'unsold',
  WITHDRAWN = 'withdrawn',
  PAYMENT_EXPIRED = 'payment_expired',
  SHIPPING_EXPIRED = 'shipping_expired',
  REMOVED = 'removed',
}

TransactionStatus {
  PAYMENT_PENDING = 'payment_pending',
  PAYMENT_DONE = 'payment_done',
  SHIPPING_PENDING = 'shipping_pending',
  COMPLETED = 'completed',
  PAYMENT_EXPIRED = 'payment_expired',
  SHIPPING_EXPIRED = 'shipping_expired',
}

ShippingMethod {
  LOCAL_PICKUP = 'local_pickup',
  SHIPPING = 'shipping',
}

AuctionFuelType {
  PETROL = 'petrol',
  DIESEL = 'diesel',
  ELECTRIC = 'electric',
  HYBRID = 'hybrid',
  OTHER = 'other',
}

AuctionCategory {
  SPORTS_CAR = 'sports_car',
  SUV = 'suv',
  LUXURY_SEDAN = 'luxury_sedan',
  CLASSIC_CAR = 'classic_car',
}
```

## 3. Subscriptions
```typescript
SubscriptionPlan {
  BASIC = 'basic',
  PREMIUM = 'premium',
}

SubscriptionStatus {
  ACTIVE = 'active',
  PAST_DUE = 'past_due',
  CANCELED = 'canceled',
  INCOMPLETE = 'incomplete',
}
```

## 3. Chat
```typescript
ParticipantRole {
  USER = 'user',
  ADMIN = 'admin',
}

MessageType {
  TEXT = 'text',
  ATTACHMENT = 'attachment',
  TEXT_WITH_ATTACHMENT = 'text_with_attachment',
}
```

## 4. Notifications
```typescript
NotificationCategory {
  NEW_AUCTION = 'new_auction',
  AUCTION_UPDATE = 'auction_update',
  ADMIN_MESSAGE = 'admin_message',
}

NotificationType {
  NEW_AUCTION = 'new_auction',
  OUTBID = 'outbid',
  WON = 'won',
  AUCTION_COMPLETED = 'auction_completed',
  AUCTION_WITHDRAWN = 'auction_withdrawn',
  PAYMENT_MARKED = 'payment_marked',
  SHIPPING_REQUEST = 'shipping_request',
  SHIPPING_DONE = 'shipping_done',
  ADMIN_MESSAGE = 'admin_message',
}

DeviceType {
  ANDROID = 'android',
  IOS = 'ios',
}
```

## 5. Admin Panel
```typescript
AdminRole {
  SUPER_ADMIN = 'super_admin',
  MANAGER = 'manager',
  MODERATOR = 'moderator',
}
```

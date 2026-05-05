## 6. WebSocket Events
 
### Connection
- **URL**: `{{base_url}}/ws/auctions/<auction_id>/?token=<jwt_token>`
- **Auth**: Requires JWT authentication via `token` query parameter.
- **Groups**:
    - `auction.<auction_id>`: Broadcasts events for a specific auction.
    - `user.<user_id>`: Broadcasts private events for a specific user.
 
### Events
> [!NOTE]
> All monetary values (`amount`, `increment`, etc.) are sent as **strings** to preserve decimal precision.
 
#### `auction.new_bid`
Broadcasted to `auction.<auction_id>` group when a new bid is placed.
```typescript
{
  type: 'auction.new_bid',
  payload: {
    version: 1,
    auction_id: number,
    amount: string, // e.g. "1250.00"
    increment: string,
    bidder_alias: string,
    created_at: string (ISO 8601)
  }
}
```
 
#### `user.outbid`
Private event broadcasted to `user.<user_id>` group when the user is outbid.
```typescript
{
  type: 'user.outbid',
  payload: {
    version: 1,
    auction_id: number,
    new_amount: string
  }
}
```
 
#### `auction.completed`
Broadcasted to `auction.<auction_id>` group when an auction ends.
```typescript
{
  type: 'auction.completed',
  payload: {
    version: 1,
    auction_id: number,
    status: 'sold' | 'unsold',
    winner_id: number | null, // null if status is 'unsold'
    sold_at: string | null (ISO 8601) // null if status is 'unsold'
  }
}
```
 
#### `user.won`
Private event broadcasted to `user.<user_id>` group when the user wins an auction.
```typescript
{
  type: 'user.won',
  payload: {
    version: 1,
    auction_id: number,
    final_amount: string | null
  }
}
```
 
#### `auction.withdrawn`
Broadcasted to `auction.<auction_id>` group when an auction is withdrawn by the dealer.
```typescript
{
  type: 'auction.withdrawn',
  payload: {
    version: 1,
    auction_id: number,
    status: 'withdrawn',
    winner_id: null,
    sold_at: null
  }
}
```
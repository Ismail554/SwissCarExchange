App Navigation Flow

On app launch → show @Splash_Screen
During Splash (do async checks):
Check if UID exists
Check if auth token exists
Validate token (expiry / backend verification if needed)

Decision logic:

Case 1: No UID (first install / new device)

Generate UID
Save locally (secure storage)
Navigate → @Onboarding
Then → @Login_Screen

Case 2: UID exists, but NO token

Navigate → @Login_Screen

Case 3: Token exists

Check if token is valid (not expired)
✅ Valid → Navigate → @Home_Screen
❌ Expired:
Try refresh token
✅ Success → @Home_Screen
❌ Fail → @Login_Screen




@Splash
 ├─ No UID → Generate → @Onboarding → @Login
 ├─ UID + No Token → @Login
 └─ UID + Token
      ├─ Valid → @Home
      └─ Expired
           ├─ Refresh OK → @Home
           └─ Refresh Fail → @Login
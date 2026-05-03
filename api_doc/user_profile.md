
for UserType : private
{
"id": 13,
    "email": "",
    "role": "bidder",
    
    "phone": "",
    "address": "",
    "website": "",
    "created_at": "2026-05-03T00:35:14.360516Z",
    "is_two_factor_enabled": false,
    "subscription": {
        "has_subscription": false,
        "plan": null,
        "status": null,
        "current_period_start": null,
        "current_period_end": null,
        "cancel_at_period_end": false
    },
    "user_type": "private",
    "photo_url": "",
    "id_document_url": "",
    "full_name": ""
}

for UserType: company
{
 "id": 13,
    "email": "",
    "role": "bidder",
    
    "phone": "",
    "address": "",
    "website": "",
    "created_at": "2026-05-03T00:35:14.360516Z",
    "is_two_factor_enabled": false,
    "subscription": {
        "has_subscription": false,
        "plan": null,
        "status": null,
        "current_period_start": null,
        "current_period_end": null,
        "cancel_at_period_end": false
    },
  "user_type": "company",
  "company": "Acme AG",
  "uid": "CHE-143.477.781",
  "license_url": "https://your-bucket.s3.amazonaws.com/registration-docs/file.pdf"
	<!-- [no profile photo ] -->
}

Merged response with company commented out:
{
    "id": 13,
    "email": "",
    "role": "bidder",
    
    "phone": "",
    "address": "",
    "website": "",
    "created_at": "2026-05-03T00:35:14.360516Z",
    "is_two_factor_enabled": false,
    "subscription": {
        "has_subscription": false,
        "plan": null,
        "status": null,
        "current_period_start": null,
        "current_period_end": null,
        "cancel_at_period_end": false
    },

    "user_type": "private",
    "photo_url": "",
    "id_document_url": "",
    "full_name": "", 

  <!-- "user_type": "company",
  "company": "Acme AG",
  "uid": "CHE-143.477.781",
  "license_url": "https://your-bucket.s3.amazonaws.com/registration-docs/file.pdf"
	[no profile photo ] -->
}
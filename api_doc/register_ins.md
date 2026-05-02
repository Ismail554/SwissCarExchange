# API Integration – User Registration with File Upload

## How it works

```
1. Get pre-signed URL → 2. Upload file → 3. Get public URL → 4. Register user
```

---

## Step 1 — Get Pre-Signed URL

```
GET /api/auth/register/presigned-url/?content_type=image/png&file_name=photo.png
```

**Response:**
```json
{
  "presigned_url": "https://...temporary-upload-url",
  "public_url": "https://...public-file-url",
  "content_type": "image/png"
}
```

---

## Step 2 — Upload File

```
PUT {presigned_url}
Content-Type: image/png
Body: raw binary file
```

✅ Success = `HTTP 200 OK`

---

## Step 3 — Register User

```
POST /api/auth/register/
Content-Type: application/json
```

**Private user:**
```json
{
  "email": "user@email.com",
  "password": "StrongPass123",
  "phone": "+41791234567",
  "address": "Bahnhofstrasse 1, Zurich",
  "user_type": "private",
  "full_name": "Mehedi Hasan",
  "photo_url": "{public_url}",
  "id_document_url": "{public_url}"
}
```

**Company user:**
```json
{
  "email": "user@email.com",
  "password": "StrongPass123",
  "phone": "+41791234567",
  "address": "Bahnhofstrasse 1, Zurich",
  "user_type": "company",
  "company": "Acme AG",
  "uid": "CHE-123.446.781",
  "license_url": "{public_url}"
}
```

---

## ⚠️ Quick Reminders

- Upload uses `PUT`, not `POST`
- Body must be **raw binary** — no JSON, no multipart
- `Content-Type` must match exactly
- Pre-signed URL **expires fast** — upload immediately
- Always use `public_url` in registration, never `presigned_url`
## Endpoint 
POST /api/auctions/create/
## Body
``` json
{
  "title": "2021 BMW X5 M Competition",
  "description": "Single-owner SUV in excellent condition with full service history.",
  "vehicle_brand": "BMW",
  "vehicle_model": "X5 M Competition",
  "vehicle_category": "suv", 
  "vehicle_year": 2021,
  "vehicle_mileage": 28500,
  "vehicle_vin_number": "WBSJU0C06M9G12345",
  "vehicle_fuel_type": "petrol",
  "vehicle_location": "Dhaka, Bangladesh",
  "reserve_price": "85000.00",
  "buy_now_price": "92000.00",
  "starts_at": "2026-04-27T10:00:00Z",
  "ends_at": "2026-05-02T10:00:00Z",
  "image_urls": [
    "https://example.com/images/bmw-x5-front.jpg",
    "https://example.com/images/bmw-x5-side.jpg"
  ],
  "video_url": "https://example.com/videos/bmw-x5-walkthrough.mp4",
  "document_url": "https://example.com/docs/bmw-x5-inspection.pdf"
}
```
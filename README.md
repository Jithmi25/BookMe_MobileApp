# Book Me - Mobile App

Book Me is a service marketplace mobile app that connects customers with trusted local workers (plumbers, carpenters, electricians, cleaners, etc.) in Sri Lanka.

## Problem Statement

People struggle to find reliable service workers quickly because of:

- No trusted review and rating system
- Poor price transparency
- No clear safety verification
- Limited digital visibility for informal workers

## Vision

Build a simple, trusted, and location-aware platform where:

- Customers can discover, compare, and book service providers
- Service providers can create digital profiles, get bookings, and grow income

## User Types

### 1) Customers

Customers can:

- Sign up / log in
- Search by service category
- View nearby providers
- Compare provider details:
  - Rating
  - Reviews
  - Experience
  - Price range
- Book instantly or schedule for later
- Pay using cash or digital methods
- Leave a review after service completion

### 2) Service Providers

Service providers can:

- Create a professional profile
- Add skills, service areas, experience, and availability
- Set a price range
- Accept or reject bookings
- View earnings
- See customer ratings and feedback

## MVP Features (Version 1)

Keep the first version focused and fast to launch.

### Authentication

- Customer login/signup
- Service provider login/signup
- Phone number verification (OTP)

### Location-Based Search

- Show providers near customer location
- Filter by rating and price

### Booking System

- Select date and time
- Add booking note (problem description)
- Booking states:
  - Pending
  - Accepted
  - Completed

### Rating & Review

- 1 to 5 star rating
- Text review after completed job

## Trust & Safety

Safety is critical for home-based services.

- NIC verification
- Profile photo verification
- In-app chat (avoid direct phone sharing at first)

Future:

- Background checks

## Revenue Model

- Commission per booking (5% to 15%)
- Featured listings for providers
- Monthly subscription for providers
- Emergency booking surcharge

## Core Screens (MVP)

### Home Screen

- Search bar
- Category shortcuts (Plumber, Carpenter, Electrician, Cleaner)
- Nearby workers list

### Provider Profile Screen

- Photo
- Ratings and reviews
- Experience
- Price range
- Book button

### Booking Screen

- Select date
- Select time
- Add note
- Confirm booking

## Suggested Tech Stack

### Frontend

- Flutter

### Backend & Database

- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Messaging (optional notifications)

## High-Level Firestore Data Model (Draft)

```text
users/
	{userId}
		role: "customer" | "provider"
		name
		phone
		profilePhoto
		createdAt

providers/
	{providerId}
		userId
		skills: []
		serviceAreas: []
		experienceYears
		availability
		priceMin
		priceMax
		ratingAvg
		ratingCount
		nicVerified
		photoVerified

bookings/
	{bookingId}
		customerId
		providerId
		category
		date
		time
		note
		status: "pending" | "accepted" | "completed" | "cancelled"
		paymentMethod: "cash" | "digital"
		amount
		createdAt

reviews/
	{reviewId}
		bookingId
		customerId
		providerId
		stars: 1..5
		comment
		createdAt
```

## Booking Workflow (MVP)

1. Customer selects service category
2. App shows nearby providers
3. Customer views profile and books a slot
4. Provider accepts or rejects request
5. Service is completed
6. Customer submits rating and review

## Future Enhancements

- Emergency booking (within 30 minutes)
- Live tracking
- AI-based price estimation
- Service bundles/packages
- Worker skill certification badges

## Why This Product Is Strong

- Solves a real daily need in Sri Lanka
- Creates digital opportunity for informal workers
- Builds trust with transparent ratings and verification
- Can scale across cities and service categories

## Development Roadmap (Suggested)

### Phase 1 - Foundation

- Flutter app setup
- Firebase project setup
- Authentication + user roles

### Phase 2 - Marketplace Core

- Provider profile creation
- Category + location-based search
- Booking creation and status flow

### Phase 3 - Quality & Monetization

- Ratings/reviews
- Basic analytics
- Commission calculation

## Project Status

Planning / MVP Definition

## License

Private - Internal development

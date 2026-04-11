# Book Me - 2 Week MVP Plan

## Timeline

- Duration: 14 days (2 weeks)
- Start date: 2026-04-04
- Goal: Functional MVP foundation with core customer/provider booking journey and Firebase-ready structure

## Week 1 - Foundation + Core Flows

### Day 1 (Completed)

- Flutter project scaffolded in repository root
- Feature-first folder structure created (`app/`, `features/`)
- App shell and route map implemented
- Initial role selection screen added
- Customer and provider placeholder home screens added
- Baseline theme configured

### Day 2 (Completed)

- Define domain entities: User, Provider, Booking, Review
- Add model classes and JSON serialization strategy
- Add reusable constants for booking statuses and user roles

### Day 3 (Completed)

- Setup Firebase project linkage (dev)
- Integrate Firebase core package and bootstrapping
- Add environment configuration strategy (`dev` profile)

### Day 4 (Completed)

- Implement authentication UI (phone input + role selection)
- Add auth state handling skeleton
- Route guard behavior based on auth + role

### Day 5 (Completed)

- Build customer home: categories + simple search input
- Add static local mock provider list
- Provider card UI component baseline

### Day 6 (Completed)

- Provider profile screen (photo, rating, experience, price)
- CTA to initiate booking
- Reusable detail row widgets

### Day 7 (Completed)

- Booking screen UI (date, time, note, payment method)
- Create booking request flow using local mock repository
- End-to-end navigation sanity pass

## Week 2 - Data + Quality

### Day 8 (Completed)

- Firestore collections setup and repository interfaces
- Implement providers read flow from Firestore
- Replace local provider mocks with repository data

### Day 9

- Implement booking create and status update in Firestore
- Provider booking request list screen
- Accept/reject state updates

### Day 10

- Completed booking state transition
- Customer booking history screen
- Provider booking history screen

### Day 11

- Ratings and review submission after completed booking
- Provider rating aggregate update logic
- Display review list on provider profile

### Day 12

- Basic trust & safety fields in profile (NIC/photo verification status)
- Gate visibility badges on provider profile
- Validation and fallback states

### Day 13

- Error handling and loading states across all key screens
- Empty states and retry flows
- UX polish pass for MVP consistency

### Day 14

- Final QA pass on critical journeys
- Performance and lint cleanup
- MVP release checklist + deployment readiness notes

## Day 1 Output in Code

- `lib/main.dart`
- `lib/app/app.dart`
- `lib/app/router/app_router.dart`
- `lib/app/theme/app_theme.dart`
- `lib/features/auth/presentation/role_selection_screen.dart`
- `lib/features/customer/presentation/customer_home_screen.dart`
- `lib/features/provider/presentation/provider_home_screen.dart`

## Success Criteria by End of 2 Weeks

- Customer can discover provider, book service, and leave review
- Provider can manage profile and booking requests
- Data persists in Firebase Auth + Firestore
- Core flows validated for MVP launch readiness

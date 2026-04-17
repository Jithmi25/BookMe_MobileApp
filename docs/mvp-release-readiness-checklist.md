# MVP Release Readiness Checklist

Date: 2026-04-17

## Product Flows

- [x] Customer can discover providers from repository-backed list.
- [x] Customer can open provider profile and place booking requests.
- [x] Provider can view incoming requests and accept/reject.
- [x] Customer and provider can view booking history.
- [x] Customer can submit rating/review on completed booking.
- [x] Provider rating aggregate updates correctly.

## UX Quality

- [x] Loading states available on key async screens.
- [x] Empty states and retry affordances added.
- [x] Error messages shown for expected failures.
- [x] Basic trust badges/verification indicators present.

## Code Quality

- [x] `flutter analyze` passes.
- [x] `flutter test` passes.
- [x] Deprecated API usage cleaned from touched flow.

## Firebase Readiness

- [ ] Confirm Firebase project (`dev` and `prod`) exists and is accessible.
- [ ] Confirm required `--dart-define` values are provided by CI/CD or launch profile.
- [ ] Verify Firestore indexes/security rules for booking and review queries.

## Build & Distribution

- [ ] Android release signing config verified.
- [ ] iOS signing/provisioning verified.
- [ ] Version/build number bumped for release.
- [ ] Smoke test completed on at least one Android and one iOS device.

## Launch Ops

- [ ] Crash/error monitoring strategy decided (Firebase Crashlytics or equivalent).
- [ ] Support contact and rollback plan documented.
- [ ] Stakeholder sign-off captured.

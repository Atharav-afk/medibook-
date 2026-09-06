# MediBook — Doctor Appointment Booking App

A Flutter + Firebase college group assignment: browse doctors, book
appointments, manage bookings, all backed by Firebase Auth and Firestore.

## 1. Prerequisites

- Flutter SDK installed (`flutter --version` to check)
- A Google account to create a free Firebase project
- Node.js (only needed for the Firebase CLI)

## 2. Create the Firebase project

1. Go to https://console.firebase.google.com and click **Add project**.
2. Name it (e.g. `medibook-app`) and finish the wizard (Analytics is optional).
3. Once created, register your apps:
   - **Android**: Project settings → Add app → Android. Use package name
     `com.example.medibook` (or whatever you set in `android/app/build.gradle`).
   - **iOS**: similarly, add an iOS app if you plan to run on iOS/macOS.
   - **Web**: add a Web app if you want to run `flutter run -d chrome`.

## 3. Enable Firebase services

In the Firebase console for your project:

- **Authentication** → Sign-in method → enable **Email/Password**.
- **Firestore Database** → Create database → start in **test mode** for
  development (tighten rules before submitting/shipping — see below).

## 4. Connect Flutter to Firebase (FlutterFire CLI)

From the project root:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

- Select your Firebase project when prompted.
- Select the platforms you want (android/ios/web).
- This overwrites `lib/firebase_options.dart` with real project credentials.

Then fetch packages:

```bash
flutter pub get
```

## 5. Firestore security rules (for a real submission)

Test mode allows anyone to read/write, which is fine for building but not
for handing in. A reasonable rule set for this app:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    match /users/{userId} {
      allow read, update: if request.auth != null && request.auth.uid == userId;
      allow create: if request.auth != null && request.auth.uid == userId;
    }

    match /doctors/{doctorId} {
      allow read: if request.auth != null;
      allow write: if false; // seeded manually / via console
    }

    match /categories/{categoryId} {
      allow read: if request.auth != null;
      allow write: if false;
    }

    match /appointments/{appointmentId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

## 6. Seed sample data

The app reads doctors/categories from Firestore — nothing is hardcoded in
the UI. Add a few documents manually via the Firestore console:

### `categories` collection (document ID can be auto-generated)

```json
{ "name": "Cardiologist", "iconName": "favorite" }
{ "name": "Dentist", "iconName": "medical_services" }
{ "name": "Dermatologist", "iconName": "healing" }
{ "name": "Pediatrician", "iconName": "child_care" }
```

### `doctors` collection (document ID can be auto-generated)

```json
{
  "name": "Dr. Sarah Ahmed",
  "specialization": "Cardiologist",
  "experience": 10,
  "rating": 4.8,
  "location": "City Hospital",
  "fee": 500,
  "description": "Experienced cardiologist specializing in heart health and preventive care.",
  "imageUrl": "https://example.com/doctor1.jpg",
  "availableDays": ["Monday", "Wednesday", "Friday"],
  "timeSlots": ["09:00 AM", "10:00 AM", "11:00 AM", "02:00 PM", "03:00 PM"]
}
```

Add 4-6 doctors like this across a few specializations that match your
categories, so Search and category filtering have something to show.

> Tip: `imageUrl` can be left empty (`""`) — the app falls back to a clean
> placeholder avatar if the image is missing or fails to load.

## 7. Run the app

```bash
flutter pub get
flutter run
```

## 8. Project structure

```
lib/
├── core/
│   ├── constants/       # app-wide constants (collection names, statuses)
│   ├── routes/          # AppRoutes (names) + AppRouter (onGenerateRoute)
│   ├── theme/           # AppColors + Material 3 AppTheme
│   ├── utils/           # validators, date helpers, ID generator
│   └── widgets/         # CustomButton, CustomTextField, DoctorCard, states
├── data/
│   ├── models/          # UserModel, DoctorModel, CategoryModel, AppointmentModel
│   ├── repositories/    # AuthRepository, DoctorRepository, AppointmentRepository
│   └── services/        # FirebaseAuthService, FirestoreService
├── presentation/
│   ├── splash/
│   ├── auth/             (login, register, forgot_password, app-wide AuthCubit)
│   ├── home/              (home + search, each with its own Cubit)
│   ├── doctor_details/
│   ├── booking/           (select date -> time -> details -> confirmation,
│   │                        all sharing one BookingCubit instance)
│   ├── appointments/       (Upcoming / Completed / Cancelled tabs)
│   └── profile/            (view + edit profile, logout)
└── main.dart
```

## 9. Business rules implemented

- Cannot pick a past date (date picker `firstDate` + a cubit-level check).
- A doctor/date/time slot already booked is disabled in the UI and is
  re-validated inside a Firestore transaction at booking time, so two
  people can't win a race to book the same slot.
- Cancelling sets `status: "cancelled"`, which automatically frees the
  slot for others since booked-slot checks only look at
  `upcoming`/`completed` appointments.
- Users only ever query appointments where `userId == currentUser.uid`.
- Every booking gets a unique, human-readable ID like `MB-3F2A9C1B`.

## 10. Notes on `status: "completed"`

Marking an appointment "completed" (e.g. once its date/time has passed)
isn't performed automatically by any background job in this project —
that would need a Cloud Function/scheduled task, which is out of scope
for a college assignment. You can manually flip an appointment's
`status` field to `"completed"` in the Firestore console to see that
tab populated, or extend `AppointmentsCubit` later if you want to
compute it client-side by comparing the appointment date to "today".

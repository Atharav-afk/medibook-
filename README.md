# 🏥 MediBook — Doctor Appointment Booking App

MediBook is a Flutter-based Doctor Appointment Booking application built as a group project. It allows users to register/login, browse doctors by specialization, book appointments by selecting an available date and time slot, and manage their bookings — all through a clean, modern Material 3 interface.

> **Group Name:** Orbit

---

## 📱 About the Project

MediBook simplifies the process of finding and booking doctor appointments. Users can search for doctors by name or specialty, view detailed doctor profiles, pick a convenient date and time, and confirm their booking in a few simple steps. The app also lets users track their appointments (Upcoming / Completed / Cancelled) and manage their profile.

This project was built to demonstrate clean architecture in Flutter using the BLoC/Cubit state management pattern, with a clear separation between UI, business logic, and data layers.

### ✨ Key Features

- 🔐 User Authentication — Register, Login, Forgot Password
- 🏠 Home screen with categories and recommended doctors
- 🔍 Real-time doctor search with specialization filtering
- 👨‍⚕️ Detailed doctor profiles (experience, rating, fee, available slots)
- 📅 Step-by-step appointment booking (Date → Time → Details → Confirmation)
- 🚫 Business rules: no past-date bookings, no double-booking of the same slot
- 📋 Appointment management with Upcoming / Completed / Cancelled tabs
- ❌ Appointment cancellation with confirmation dialog
- 👤 Editable user profile
- 🎨 Clean Material 3 UI with reusable components

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc (Cubit) |
| UI | Material 3 |
| Architecture | Presentation → Cubit → Repository → Data Service |

---

## 🏗️ Architecture

```
Presentation/UI
      ↓
  Cubit/BLoC
      ↓
 Repository
      ↓
 Data Service
```

```
lib/
├── core/          # Constants, routes, theme, utils, reusable widgets
├── data/          # Models, repositories, services
├── presentation/  # Splash, auth, home, doctor details, booking,
│                  # appointments, profile — each with its own Cubit
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed
- An IDE (VS Code / Android Studio)

### Installation

```bash
git clone https://github.com/<your-username>/medibook.git
cd medibook
flutter pub get
flutter run
```

### Demo Login

```
Email:    demo@medibook.com
Password: demo123
```

---

## 📸 Screenshots

*(Add app screenshots here)*

---

## 👥 Team — Orbit

| Name |
|---|
| Atharav Mhaske |
| Arjun More |
| Sanskar Lasankar |
| Ajinkya Misal |
| Yash Nabade |
| Amruta Mirikar |
| Anushka Patil |
| Ishwari Mate |
| Sakshi Mahajan |
| Gauri Musmade |

---

## 📄 License

This project was developed for academic/educational purposes as part of a group assignment.

---

<p align="center">Made with ❤️ by Team Orbit</p>

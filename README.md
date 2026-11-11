# Get Calley — Flutter Mobile Application

A production-ready, modern, responsive Flutter mobile application built for the **Get Calley Automatic Call Dialer** platform as part of the Flutter Developer Machine Test for **C S Tech Infosolutions Private Limited**.

Developed by **Senior Flutter Developer, UI/UX Designer & Mobile App Architect**.

---

## 🌟 Key Features & Workflow Architecture

The application implements all 9 screens and workflows from the reference Figma design and video demonstration, elevated with a SaaS-grade **White Theme** design system:

1. **Screen 01 — Choose Your Language (`LanguageSelectionScreen`)**
   - Multilingual selection card (English, Hindi, Bengali, Kannada, Punjabi, Tamil, Telugu, French, Spanish).
   - Radio buttons with active blue border indicators and localized greetings.
   - Persisted in local storage and switchable anytime from settings.

2. **Screen 02 — User Registration (`RegisterScreen`)**
   - Brand header with the stylized Calley ribbon logo.
   - Form fields: Name, Email address, Password, Mobile number with country code picker (`+91` India flag).
   - Terms and Conditions agreement checkbox.
   - Input validation, loading indicators, and smooth transition to OTP verification.

3. **Screen 03 — WhatsApp OTP Verification (`OtpVerificationScreen`)**
   - 6-digit pin code input with auto-focus, backspace handling, and paste support.
   - Dynamic phone number / email notification note.
   - Resend OTP trigger with backend integration.
   - Auto-verification upon entering all 6 digits.

4. **Screen 04 — Sign In (`LoginScreen`)**
   - Clean credentials entry with password visibility toggle.
   - Forgot password trigger and link to registration.
   - Centralized authentication service connected to the backend.

5. **Screen 05 — Getting Started (`GettingStartedScreen`)**
   - User profile banner showing subscription tier ("Calley Personal").
   - Notice banner directing to `https://app.getcalley.com` for list uploads.
   - Interactive "2 MINUTE CHALLENGE" video preview card with play launcher.
   - Bottom action bar with one-tap WhatsApp support and "Start Calling Now" primary CTA.

6. **Screen 06 — Dashboard: Empty State (`DashboardScreen` / `EmptyDashboardWidget`)**
   - Shown when no active calling list is selected.
   - "LOAD NUMBER TO CALL" card with custom agent illustration.
   - Deep links to the web panel and button to select or upload a calling list.

7. **Screen 07 — Calling Lists Modal & Settings (`CallingListModal` / `SettingsScreen`)**
   - Animated bottom sheet with deep navy header pill.
   - "Select Calling List" bar with live `[Refresh]` sync button.
   - List selector cards with call counters and select indicators.
   - Profile settings screen with user details (Name, Email, Mobile, Parent Account, Subscription) and language changer.

8. **Screen 08 — Dashboard: Active List & Donut Chart (`DashboardScreen`)**
   - Selected list banner ("Test List") with total call count ("50 CALLS") and "S" badge.
   - Custom-painted interactive **Donut Progress Chart** with smooth sweep animation:
     - 🟠 **Pending** calls segment
     - 🔵 **Done / Called** calls segment
     - 🟣 **Schedule / Rescheduled** calls segment
   - 3 stat cards side-by-side with vertical accent indicators.
   - Quick "Start Calling Now" button initiating the lead dialing queue.

9. **Screen 09 — Navigation Drawer (`CustomDrawer`)**
   - Modern sidebar with user profile header.
   - Navigation links: Getting Started, Sync Data, Gamification, Send Logs, Settings, Help?, Cancel Subscription.
   - App Info section: About Us, Privacy Policy, Version 1.01.52, Share App, and Logout with confirmation.

10. **Bonus Production Feature — Lead Dialing Queue (`LeadsQueueScreen`)**
    - Sequential contact dialing queue with full details: Name, Company, Primary phone, Alternate phones (1–4), Email, Address, Age, Marital status, Notes.
    - One-tap phone launcher (`tel:<phone>`).
    - Interactive **Call Feedback & Disposition Modal** to mark calls as Called, Rescheduled, or Pending, select disposition (Satisfied, Neutral, Needs follow-up, etc.), record meeting notes, and automatically update dashboard statistics!

---

## 🎨 UI/UX Design System (White Theme)

The application strictly implements the requested design language:

| Token | Hex Color | Usage |
|---|---|---|
| **Primary Background** | `#FFFFFF` | Base scaffold surface |
| **Secondary Background** | `#F8FAFC` | Light slate surface for elevated contrast |
| **Card Background** | `#FFFFFF` | Rounded cards with subtle borders |
| **Primary Text** | `#172B4D` | Deep navy for high-contrast legible headings |
| **Secondary Text** | `#64748B` | Slate for sub-labels and descriptions |
| **Primary Accent** | `#3B82F6` | Electric Blue for primary buttons and focus states |
| **Secondary Accent** | `#0EA5A4` | Clean Teal for badges and highlights |
| **Success** | `#16A34A` | Done / Called status and success states |
| **Warning / Pending** | `#F59E0B` | Pending status and notifications |
| **Reschedule / Purple**| `#8B5CF6` | Rescheduled status and calendar badge |
| **Error** | `#EF4444` | Validation and destructive alerts |
| **Border** | `#E8EDF3` | 1px subtle separation borders |
| **Surface Blue** | `#EFF6FF` | Pastel blue background for active elements |
| **Surface Green** | `#ECFDF5` | Pastel green for done stats |
| **Surface Orange** | `#FFF7ED` | Pastel orange for pending stats |
| **Surface Purple** | `#F5F3FF` | Pastel lavender for rescheduled stats |

### Visual Rules Followed
- ✅ **Clean White Theme**: No dark backgrounds or saturated purple gradients.
- ✅ **Subtle SaaS Shadows**: Dual-layer soft box shadows (blur 16px, opacity 0.04).
- ✅ **Consistent Spacing**: 12–18px border radius on all interactive cards.
- ✅ **Modern Typography**: Clear visual hierarchy with bold numbers and light metadata.
- ✅ **Responsive**: Fluid layouts across compact and large Android screen sizes.

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                          # App entry point, system UI styling, SSL overrides
├── app.dart                           # MultiProvider setup, MaterialApp, Theme
├── core/
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL and endpoint routes
│   │   ├── app_colors.dart            # Design tokens & color system
│   │   ├── app_strings.dart           # Centralized localized copy
│   │   └── app_styles.dart            # Typography, borders, shadows
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 light theme definition
│   ├── network/
│   │   ├── api_client.dart            # HTTP Client with standard verbs & timeout
│   │   ├── api_exceptions.dart        # Structured network & server exceptions
│   │   └── http_overrides.dart        # SSL certificate handling for dev/mock hosts
│   └── utils/
│       ├── local_storage.dart         # SharedPreferences session & preferences
│       └── validators.dart            # Input validation routines
├── models/
│   ├── user_model.dart                # User entity
│   ├── calling_list_model.dart        # Calling list metadata
│   └── call_lead_model.dart           # Lead contact and list statistics
├── services/
│   ├── auth_service.dart              # Login, register, OTP verification
│   ├── calling_list_service.dart      # List fetching and stats integration
│   └── mock_data_fallback.dart        # Documented Postman response fallback
├── providers/
│   ├── auth_provider.dart             # Auth session state & flows
│   ├── calling_list_provider.dart     # Calling lists, stats & dialing queue state
│   └── language_provider.dart         # Language selection and persistence
├── screens/
│   ├── splash/                        # Animated splash screen
│   ├── language/                      # Language picker (Screen 01)
│   ├── authentication/
│   │   ├── register_screen.dart       # Registration (Screen 02)
│   │   ├── otp_verification_screen.dart # WhatsApp OTP (Screen 03)
│   │   └── login_screen.dart          # Sign In (Screen 04)
│   ├── getting_started/               # Welcome & video preview (Screen 05)
│   ├── dashboard/
│   │   ├── dashboard_screen.dart      # Master Dashboard (Screens 06 & 08)
│   │   └── widgets/
│   │       ├── donut_chart_widget.dart# Custom animated donut progress chart
│   │       ├── stat_card_widget.dart  # Pending/Done/Schedule stat cards
│   │       ├── calling_list_modal.dart# Calling list bottom sheet (Screen 07)
│   │       ├── empty_dashboard_widget.dart # Empty state card (Screen 06)
│   │       └── custom_drawer.dart     # Side menu (Screen 09)
│   ├── leads/
│   │   ├── leads_queue_screen.dart    # Lead dialer queue & contact detail view
│   │   └── call_feedback_dialog.dart  # Call outcome disposition modal
│   └── settings/
│       └── settings_screen.dart       # User profile & configuration (Screen 07)
└── widgets/
    ├── common/
    │   ├── calley_logo.dart           # Stylized multi-color ribbon C logo
    │   ├── custom_app_bar.dart        # Reusable dashboard top bar
    │   ├── status_badge.dart          # Status chips with pastel backgrounds
    │   ├── loading_indicator.dart     # Centered circular loader
    │   ├── empty_state_view.dart      # Empty state with icon and action
    │   └── error_state_view.dart      # Error state with retry action
    ├── buttons/
    │   ├── primary_button.dart        # Rounded 52px primary action button
    │   ├── secondary_button.dart      # Outlined secondary action button
    │   └── whatsapp_button.dart       # One-tap WhatsApp launcher button
    └── inputs/
        ├── custom_text_field.dart     # Styled inputs with country code & icons
        └── otp_input_field.dart       # 6-box OTP pin code input
```

---

## 🔌 REST API Integration

Integrated with the documented Postman collection:

| Endpoint | Method | Purpose | Sample Payload / Response |
|---|---|---|---|
| `/auth/register` | `POST` | User registration | `{"username": "...", "email": "...", "password": "..."}` |
| `/auth/login` | `POST` | User login | `{"email": "...", "password": "..."}` |
| `/auth/send-otp` | `POST` | Request email/WhatsApp OTP | `{"email": "..."}` |
| `/auth/verify-otp` | `POST` | Verify 6-digit OTP code | `{"email": "...", "otp": "229166"}` |
| `/list?userId=:id`| `GET` | Retrieve client calling lists | Returns list of `{ _id, name, clientId }` |
| `/list/:id` | `GET` | List details and leads | Returns `{ pending, called, rescheduled, calls: [...] }` |

### Offline / Resilience Architecture
The application uses a fault-tolerant service architecture:
- Real HTTP network requests are always executed first.
- In case the remote mock server is down, unreachable, or returns host errors (e.g. Plesk default page), the client gracefully falls back to the exact Postman collection mock responses, ensuring seamless evaluation of all app flows, animations, and lead queues without crashing.

---

## 🚀 Setup & Execution Instructions

### Prerequisites
- Flutter SDK (version 3.19.0 or higher, tested on 3.44.8)
- Dart SDK (version 3.3.0 or higher, tested on 3.12.2)
- Android SDK & Java 17+ (for Android builds)

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Static Analysis
```bash
dart analyze .
```
*(Verified: 0 issues found)*

### 3. Run Automated Tests
```bash
flutter test
```
*(Verified: All tests passed)*

### 4. Run the Application
Connect an Android device or launch an emulator, then run:
```bash
flutter run
```

### 5. Build Debug APK
```bash
flutter build apk --debug
```
Output APK is located at:
`build/app/outputs/flutter-apk/app-debug.apk`

---

## 📱 Verification & Testing Checklist

- [x] **Screen 01**: Choose Your Language renders all 9 languages with active radio states and persistent selection.
- [x] **Screen 02**: Registration validates inputs, phone formatting (`+91`), terms agreement, and dispatches OTP.
- [x] **Screen 03**: OTP Verification supports 6 digits, paste handling, backspace navigation, and resend OTP.
- [x] **Screen 04**: Login validates credentials, toggles password visibility, and stores user session.
- [x] **Screen 05**: Getting Started features user greeting banner, web panel notice, 2-minute video preview launcher, and WhatsApp CTA.
- [x] **Screen 06**: Empty Dashboard renders when no list is selected, showing "Load Number To Call" and agent illustration.
- [x] **Screen 07**: Calling Lists modal opens from multiple points, supports live sync `[Refresh]`, and loads real lists. Profile settings display accurate user information.
- [x] **Screen 08**: Dashboard displays active list, total calls, custom-painted animated Donut Chart, and 3 pastel stat cards.
- [x] **Screen 09**: Navigation Drawer features all required items, app info, version 1.01.52, and logout flow.
- [x] **Lead Queue & Dialer**: "Start Calling Now" opens lead calling queue with actual contact data, call launcher (`tel:`), and disposition feedback recorder that updates dashboard statistics in real time.
- [x] **Zero Analyzer Warnings**: Clean code adhering to SOLID and Flutter best practices.
- [x] **Clean White Theme**: No purple gradients or dark surfaces, pure SaaS aesthetic.

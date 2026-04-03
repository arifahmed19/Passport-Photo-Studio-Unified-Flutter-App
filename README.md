# 📸 Emerald Studio: Professional Passport Solutions

A professional-grade, unified Flutter application designed to automate the creation of official passport photos for any country. Built with a focus on high-end aesthetics (**Glassmorphism** & **Emerald Palette**) and cross-platform performance.

---

## 💎 Features

*   **⚡ Pro-Visuals**: Stunning dark-mode emerald theme with a modern translucent (glassmorphism) design across the entire user experience.
*   **📐 Precise Formatting**: Automated cropping and alignment based on international standards (US 2x2, UK 35x45mm, and more).
*   **🔐 AES-256 Cloud Security**: Your privacy matters. All synced history images are encrypted on your device using a unique AES-256 key before being securely stored on the cloud.
*   **✨ AI Background Eraser**: Remove background in one click with built-in AI processing to ensure perfect studio-white backgrounds every time.
*   **📱 Guided Intro**: Modern interactive walkthrough for mobile users to quickly learn the app's main features.
*   **🚀 Quick Start Dashboard**: Instantly start your project with the "Create New Passport" interactive tile—snap a photo or import from your gallery.
*   **📱 Unified Experience**: Fully responsive design that scales perfectly from small mobile screens to large desktop monitors.
*   **🖨️ One-Click Printing**: Generate high-resolution, printable A4 PDF templates with correctly sized and spaced photo sets.

---

## 📸 Screenshots

| Onboarding | Dashboard | Editor Studio |
| :---: | :---: | :---: |
| ![Intro Screen](https://via.placeholder.com/250x500?text=Intro+Page) | ![Dashboard](https://via.placeholder.com/250x500?text=Dashboard) | ![Editor](https://via.placeholder.com/250x500?text=Studio+Editor) |

| Cloud History | Profile & Settings |
| :---: | :---: |
| ![History](https://via.placeholder.com/250x500?text=Cloud+History) | ![Profile](https://via.placeholder.com/250x500?text=User+Profile) |

*(Replace with actual screenshots as they become available)*

---

## 🛠️ Technical Stack

*   **Frontend**: Flutter (Dart)
*   **Backend**: Supabase (Database, Auth, and Storage)
*   **Encryption**: AES-256 (via `encrypt` package)
*   **Architecture**: Provider (State Management)
*   **Design**: Vanilla CSS with custom Theme Extensions
*   **PDF Engine**: Printing & Pdf package for printable template generation
*   **UI Assets**: Google Fonts (Outfit) & Lucide-style icons

---

## 🚀 Getting Started

### 1. Prerequisites
*   Flutter SDK installed
*   A Supabase account (Free Tier)
*   (Optional) [Remove.bg](https://www.remove.bg) API Key for the AI eraser tool

### 2. Setup Backend
1. Create a project in [Supabase](https://app.supabase.com).
2. Create a public bucket in **Storage** named `photos`.
3. Create a **Table** named `history` with following columns:
    * `id`: uuid (primary key)
    * `user_id`: uuid (foreign key to auth.users)
    * `image_url`: text
    * `standard_name`: text
    * `created_at`: timestamptz (default: now())
4. Disable "Confirm Email" in **Authentication > Settings**.

### 3. Local Installation
```bash
git clone https://github.com/arifahmed19/Passport-Photo-Studio-Unified-Flutter-App.git
cd Passport-Photo-Studio-Unified-Flutter-App
flutter pub get
```

### 4. Configuration
Open `lib/main.dart` and paste your Supabase keys:
```dart
await Supabase.initialize(
  url: 'YOUR_PROJECT_URL',
  anonKey: 'YOUR_ANON_KEY',
);
```

### 5. Run the App
```bash
# For Web
flutter run -d chrome

# For Mobile
flutter run
```

---

## 📂 Project Structure

```text
lib/
├── core/         # Custom Emerald Theme, Crypto Service & Tokens
├── models/       # Passport Sizing Standards & Data Models
├── providers/    # Auth & Passport Processing State Management
├── screens/      # Glassmorphism UI Screens (Intro, Auth, Home, Editor)
└── main.dart     # App Entry Point & Initialization
```

---

---

## 👨‍💻 Created By
**Arif Ahmed**  
[*GitHub Portfolio*](https://github.com/arifahmed19)

### ☕ Support My Work
If you find this project useful, you can support me via Binance:
**UID: 1210563042** (Copy from the app's Profile section)

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

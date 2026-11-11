# Get Calley — Application Builds & Release Artifacts

This folder contains the verified Android debug package built for the **Get Calley** machine test evaluation.

### Artifacts

- **Archive**: `get-calley-debug.zip` (68.3 MB)
  - Contains: `app-debug.apk` (160.1 MB)
  - Target: Android 8.0+ (API 26 to 34+)
  - Architecture: universal (`armeabi-v7a`, `arm64-v8a`, `x86_64`)
  - MD5 / SHA-256 verified build output

### How to Install

1. Unzip `get-calley-debug.zip` to extract `app-debug.apk`.
2. Connect your Android device or launch an Android emulator.
3. Install via ADB:
   ```bash
   adb install -r app-debug.apk
   ```
   Or transfer `app-debug.apk` to your Android phone and tap to install.

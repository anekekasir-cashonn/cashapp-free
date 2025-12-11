# CashApp Free - Setup & Configuration Guide

## 🔧 Initial Setup

### Step 1: Install Flutter
```bash
# Download from https://flutter.dev/docs/get-started/install
# Add Flutter to your PATH

# Verify installation
flutter --version
dart --version
```

### Step 2: Clone/Setup Project
```bash
# If using Git
git clone <repository>
cd cashapp_free

# Or navigate to existing project directory
cd /workspaces/cashapp-free
```

### Step 3: Get Dependencies
```bash
flutter pub get
```

This downloads:
- Provider (state management)
- SQLite (database)
- Intl (localization)
- Google Mobile Ads (optional)
- CSV (data export)

### Step 4: Run the App
```bash
# Development build
flutter run

# Release build
flutter run --release

# Web (if enabled)
flutter run -d chrome

# Android device
flutter run -d <device-id>

# iOS device
flutter run -d <device-id>
```

## ⚙️ Configuration

### AdMob Setup

By default, the app uses Google AdMob **test IDs** to avoid account suspension.

#### Using Test IDs (Development)
Already configured in `lib/services/admob_helper.dart`:
```dart
const ADMOB_APP_ID = 'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy';
const BANNER_AD_UNIT_ID = 'ca-app-pub-3940256099942544/6300978111';
const INTERSTITIAL_AD_UNIT_ID = 'ca-app-pub-3940256099942544/1033173712';
```

#### Using Real Ad IDs (Production)
1. Go to [Google AdMob](https://admob.google.com/)
2. Sign in with Google account
3. Create new app
4. Create ad units (banner + interstitial)
5. Copy your real IDs
6. Update `lib/services/admob_helper.dart`:
```dart
const ADMOB_APP_ID = 'YOUR_REAL_APP_ID';
const BANNER_AD_UNIT_ID = 'YOUR_REAL_BANNER_ID';
const INTERSTITIAL_AD_UNIT_ID = 'YOUR_REAL_INTERSTITIAL_ID';
```

7. Uncomment initialization in `lib/main.dart`:
```dart
// Uncomment this line:
// AdMobHelper.initializeMobileAds();
```

### Language Customization

Edit language files in `assets/lang/`:
- `en.json` - English
- `id.json` - Indonesian

To add a new language:
1. Create `assets/lang/es.json` (for Spanish)
2. Copy structure from `en.json`
3. Translate all strings
4. Update `SettingsProvider` to support new language

Example:
```json
{
  "app_title": "Caja Libre",
  "bottom_nav": {
    "home": "Inicio",
    "products": "Productos",
    ...
  }
}
```

### Theme Customization

Edit primary color in `lib/theme.dart`:

Current: `Color(0xFF0066CC)` (Blue)

```dart
// Change seed color to customize theme
ColorScheme.fromSeed(
  seedColor: const Color(0xFF00B000), // Green theme
  brightness: Brightness.light,
)
```

Popular colors:
- Red: `#FF0000`
- Green: `#00B000`
- Purple: `#9C27B0`
- Orange: `#FF9800`

## 🗄️ Database Management

### View SQLite Database

#### Android/iOS
```bash
# Connect device/emulator
adb devices

# Access database
adb shell

# Navigate to app directory
cd /data/data/com.example.cashapp_free/databases/

# View database
sqlite3 cashapp.db
```

#### Commands
```sql
-- View all tables
.tables

-- View schema
.schema products

-- Query data
SELECT * FROM products;
SELECT * FROM transactions;
SELECT * FROM transaction_items;

-- Exit
.exit
```

### Export Database
```bash
# Pull database from device
adb pull /data/data/com.example.cashapp_free/databases/cashapp.db ./

# Push database to device
adb push ./cashapp.db /data/data/com.example.cashapp_free/databases/
```

### Reset Database
In settings screen or manually:
```bash
# Delete app data
adb shell pm clear com.example.cashapp_free

# Database will be recreated on next launch
```

## 🐛 Troubleshooting

### Issue: "flutter: command not found"
**Solution**: Add Flutter to PATH
```bash
# macOS/Linux
export PATH="$PATH:`pwd`/flutter/bin"

# Windows: Add flutter\bin to System Environment Variables
```

### Issue: "dependencies not resolving"
**Solution**: 
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter pub get
```

### Issue: "Gradle build failed"
**Solution**:
```bash
# Clear Gradle cache
cd android
./gradlew clean
cd ..

flutter clean
flutter run
```

### Issue: "CocoaPods error" (iOS)
**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..

flutter clean
flutter run
```

### Issue: "Cannot find SQLite plugin"
**Solution**:
```bash
flutter pub get
flutter clean
flutter run

# If still failing:
flutter pub remove sqflite
flutter pub add sqflite
```

### Issue: "App crashes on launch"
**Solution**:
```bash
# Check logs
flutter logs

# Common causes:
# 1. Missing permissions (Android)
# 2. SQLite initialization failed
# 3. Provider setup incomplete

# Try:
flutter clean
flutter run -v  # Verbose output
```

### Issue: "Dark mode not working"
**Solution**: Ensure `SettingsProvider` is initialized in `main.dart`:
```dart
ChangeNotifierProvider(create: (_) => SettingsProvider()),
```

### Issue: "Products list showing empty"
**Solution**:
1. Check database was created
2. Add sample products via UI
3. Check `ProductProvider.loadProducts()` is called

## 📱 Platform-Specific Setup

### Android
Requirements:
- Android SDK 21+
- Gradle 7.0+
- Java 11+

```bash
flutter doctor -v  # Verify setup

# Build APK
flutter build apk

# Build App Bundle (Play Store)
flutter build appbundle
```

### iOS
Requirements:
- Xcode 13+
- iOS 11+
- CocoaPods

```bash
# Setup
flutter run

# Build IPA
flutter build ios

# Run on simulator
open -a Simulator
flutter run -d emulator
```

### Web (Optional)
Enable web support:
```bash
flutter config --enable-web

flutter run -d chrome
```

## 🚀 Deployment

### Android Play Store

1. Create signing key:
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Copy key.jks to android/app/
```

2. Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=key.jks
```

3. Sign app:
```bash
flutter build appbundle --release
```

4. Upload to Play Console

### iOS App Store

1. Create developer account at [Apple Developer](https://developer.apple.com/)

2. Create certificates and provisioning profiles

3. Build:
```bash
flutter build ios --release
```

4. Open Xcode and submit:
```bash
open ios/Runner.xcworkspace
```

## 📊 Performance Optimization

### Database Optimization
```dart
// Add indexes for frequently searched columns
// In DatabaseHelper._onCreate():
await db.execute('CREATE INDEX idx_product_category ON products(category)');
```

### UI Performance
- Use `const` constructors
- Implement `shouldRebuild()` in providers
- Use `ListView.builder` instead of `ListView`
- Profile with DevTools:
```bash
flutter run --profile
```

### Memory Management
- Dispose controllers in `State.dispose()`
- Close database connections gracefully
- Use small, optimized images

## 🔐 Security Tips

### Data Security
1. Encrypt sensitive data before storing
2. Use secure file storage for sensitive files
3. Implement data backup

### Code Security
```bash
# Analyze code for issues
flutter analyze

# Check for vulnerabilities
pub audit
```

## 📚 Additional Resources

### Documentation
- [Flutter Docs](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Sqflite](https://pub.dev/packages/sqflite)
- [Material 3](https://material.io/blog/material-3-launches)

### Learning
- [Flutter Codelabs](https://flutter.dev/docs/codelabs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Pattern](https://pub.dev/packages/provider#resources)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools)
- [Android Studio](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/)
- [VS Code Extensions](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)

## 💬 Getting Help

1. **Flutter Issues**: `flutter doctor -v`
2. **App Crashes**: `flutter logs`
3. **Build Errors**: `flutter clean && flutter pub get`
4. **Plugin Issues**: Check platform-specific documentation

## ✅ Verification Checklist

After setup, verify:
- [ ] `flutter doctor` shows no errors
- [ ] `flutter pub get` completes successfully
- [ ] App runs without crashes
- [ ] Database creates on first launch
- [ ] Can add products
- [ ] Can create transactions
- [ ] Dark mode toggles
- [ ] Language switches
- [ ] No console errors

---

Happy developing! 🚀

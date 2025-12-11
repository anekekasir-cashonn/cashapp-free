# 🚀 Quick Start Guide - CashApp Free

Get up and running in 5 minutes!

## ⚡ 5-Minute Setup

### 1. Install Flutter (First Time Only)
```bash
# Download from https://flutter.dev/docs/get-started/install
# Then verify:
flutter doctor
```

### 2. Get Dependencies
```bash
cd /path/to/cashapp_free
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

That's it! The app will start on your device/emulator.

## 🎯 First Steps in the App

### Try These Features:
1. **Add a Product**
   - Go to "Products" tab
   - Click "Add Product"
   - Fill in: Name="Coffee", Price="25000", Stock="50", Category="Beverages"
   - Click "Add"

2. **Make a Sale**
   - Go to "POS" tab
   - Click on "Coffee" product
   - Enter quantity "2"
   - See it appear in cart on right
   - Click "Checkout"

3. **Check History**
   - Go to "History" tab
   - See your completed transaction
   - Click on it to see details

4. **Customize**
   - Go to "Settings" tab
   - Toggle dark mode
   - Change language to Indonesian

## 📱 Platform-Specific

### For Android
```bash
# Run on Android Emulator
flutter run -d emulator-5554

# Or connect Android phone via USB
adb devices  # List devices
flutter run
```

### For iOS
```bash
# Run on iOS Simulator
open -a Simulator
flutter run

# Or run on connected iPhone
flutter run
```

### For Web (Desktop Browser)
```bash
# Enable web support (one time)
flutter config --enable-web

# Run on Chrome
flutter run -d chrome
```

## 🎨 Code Structure Quick Reference

Want to add a feature? Here's where:

| Feature | File |
|---------|------|
| New product field | `lib/models/product.dart` |
| New transaction logic | `lib/providers/transaction_provider.dart` |
| New screen | `lib/screens/your_screen.dart` + `main.dart` |
| New colors | `lib/theme.dart` |
| New translation | `assets/lang/*.json` |
| Database query | `lib/services/database_helper.dart` |

## 🔥 Hot Tips

### Hot Reload (Keep App State)
Press `r` in terminal = reload without losing data

### Hot Restart (Reset App)
Press `R` in terminal = full restart, clears data

### Debug Output
```bash
# See all logs
flutter logs

# Verbose output
flutter run -v
```

### Device Selection
```bash
# List all devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

## ❌ Stuck? Try This

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### SQLite error
```bash
flutter clean
rm -rf build/
flutter run
```

### Dependency issue
```bash
flutter pub upgrade
flutter pub get
flutter run
```

## 📚 Next Steps

1. **Read** `README.md` for full documentation
2. **Read** `SETUP.md` for configuration details
3. **Explore** code comments in `lib/` folder
4. **Customize** colors, fonts, features to your needs
5. **Deploy** when ready using guides in `SETUP.md`

## 🎓 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package Guide](https://pub.dev/packages/provider)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material 3 Design](https://m3.material.io/)

## ✨ Features Quick Walkthrough

### Dashboard
Shows today's transactions, revenue, and all-time stats. Real-time updates.

### Products
Manage inventory. Add, edit, delete products with categories.

### POS
Interactive cart system. Add products, set quantities, automatic total calculation.

### History
View all past transactions. Filter by date range. See transaction details.

### Settings
Toggle dark mode, change language, view app info.

## 🔐 Important Notes

- **No Login**: Direct access to all features
- **Offline**: Everything works without internet
- **Local Database**: Data stored on device
- **No Cloud**: Data not synced to cloud (can add later)

## 💡 Pro Tips

1. **Keyboard Shortcuts**
   - `i` = iOS simulator
   - `a` = Android emulator
   - `w` = web browser
   - `q` = quit

2. **Save Bandwidth**
   - Disable hot reload in settings for faster builds
   - Use `--split-per-abi` for Android to reduce APK size

3. **Debugging**
   - Add `print()` to see debug output
   - Use `debugPrint()` for long messages
   - Check `flutter logs` for errors

## 🚢 Ready to Ship?

When you're ready to deploy:

1. **Android Play Store**
   ```bash
   flutter build appbundle --release
   ```
   See `SETUP.md` for signing details

2. **iOS App Store**
   ```bash
   flutter build ios --release
   ```
   See `SETUP.md` for provisioning setup

3. **Web**
   ```bash
   flutter build web --release
   ```

## 📞 FAQ

**Q: Can I use this as a template?**
A: Yes! Fork it and customize for your needs.

**Q: Can I add login?**
A: Yes! Add Firebase Auth or local user management.

**Q: Can I sell it?**
A: Read the license, but generally yes for derived works.

**Q: Can I use real AdMob?**
A: Yes! Update IDs in `lib/services/admob_helper.dart`

## 🎉 You're All Set!

Start with the POS tab and make your first transaction. Everything just works!

Need help? Check `SETUP.md` or the code comments.

**Happy selling! 💰**

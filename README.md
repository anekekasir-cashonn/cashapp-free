# CashApp Free - Offline POS Cashier Application

A complete Flutter-based offline Point of Sale (POS) application with no login requirement. Built with Material 3 design, SQLite database, and Provider state management.

## 🎯 Features

### Core POS Features
- ✅ **Dashboard** - Real-time statistics (today's transactions, revenue, all-time data)
- ✅ **Product Management** - CRUD operations for products with categories
- ✅ **POS Transaction** - Interactive cart system with real-time calculations
- ✅ **Transaction History** - Searchable transaction records with date filtering
- ✅ **CSV Export** - Export transaction and product data

### UI/UX Design
- ✅ **Material 3** - Modern Material Design with dynamic theming
- ✅ **Dark Mode** - Automatic dark/light mode toggle
- ✅ **Responsive Layout** - Mobile and desktop layouts
- ✅ **HCI Principles**:
  - **Fitts' Law**: Large touch targets (min 48px), buttons positioned in thumb-reach zones
  - **Hick's Law**: Clear navigation with only 5 main tabs, grouped actions
  - **Visual Hierarchy**: Typography, colors, and spacing guide user attention
  - **Smooth Animations**: Fade transitions and interactive feedback

### Database
- ✅ **SQLite** - Local offline database
- ✅ **Three Tables**: products, transactions, transaction_items
- ✅ **Full CRUD** - Complete query operations
- ✅ **Query Optimization** - Efficient searches and statistics

### State Management
- ✅ **Provider** - Simple, beginner-friendly state management
- ✅ **Separation of Concerns** - Clear provider structure
- ✅ **Real-time Updates** - Automatic UI refresh on data changes

### Multi-language Support
- ✅ **English & Indonesian** - Complete translation files
- ✅ **Easy Language Switching** - Available in settings

## 📁 Project Structure

```
cashapp_free/
├── lib/
│   ├── main.dart                 # App entry point & navigation
│   ├── theme.dart                # Material 3 themes
│   ├── models/
│   │   ├── product.dart          # Product model
│   │   ├── transaction.dart      # Transaction & TransactionItem models
│   │   └── index.dart            # Export all models
│   ├── providers/
│   │   ├── product_provider.dart     # Product state management
│   │   ├── transaction_provider.dart # Transaction state management
│   │   ├── settings_provider.dart    # Settings state management
│   │   └── index.dart                # Export all providers
│   ├── screens/
│   │   ├── home_screen.dart      # Dashboard
│   │   ├── products_screen.dart  # Product management
│   │   ├── pos_screen.dart       # POS transaction
│   │   ├── history_screen.dart   # Transaction history
│   │   ├── settings_screen.dart  # Settings
│   │   └── index.dart            # Export all screens
│   ├── services/
│   │   ├── database_helper.dart  # SQLite operations
│   │   ├── csv_helper.dart       # CSV export
│   │   ├── admob_helper.dart     # AdMob integration
│   │   └── index.dart            # Export all services
│   ├── widgets/
│   │   ├── custom_widgets.dart   # Reusable widgets
│   │   └── index.dart            # Export widgets
│   └── utils/
│       ├── currency_formatter.dart  # Number/date formatting
│       └── index.dart               # Export utilities
├── assets/
│   └── lang/
│       ├── en.json              # English translations
│       └── id.json              # Indonesian translations
├── pubspec.yaml                  # Dependencies
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android SDK or iOS SDK (for mobile testing)
- An IDE (VS Code, Android Studio, or Xcode)

### Installation

1. **Clone or create the project**
   ```bash
   cd /path/to/project
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   For specific platforms:
   ```bash
   flutter run -d chrome        # Web (requires web support enabled)
   flutter run -d emulator-5554 # Android
   flutter run -d ios           # iOS
   ```

## 💾 Database Schema

### Products Table
```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  stock INTEGER NOT NULL,
  category TEXT NOT NULL
)
```

### Transactions Table
```sql
CREATE TABLE transactions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dateTime TEXT NOT NULL,
  totalAmount REAL NOT NULL,
  itemCount INTEGER NOT NULL
)
```

### Transaction Items Table
```sql
CREATE TABLE transaction_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  transactionId INTEGER NOT NULL,
  productId INTEGER NOT NULL,
  productName TEXT NOT NULL,
  productPrice REAL NOT NULL,
  quantity INTEGER NOT NULL,
  subtotal REAL NOT NULL,
  FOREIGN KEY (transactionId) REFERENCES transactions(id),
  FOREIGN KEY (productId) REFERENCES products(id)
)
```

## 🏗️ Architecture

### State Management with Provider
The app uses **Provider** for state management - chosen for its simplicity and beginner-friendliness:

```dart
// ProductProvider manages:
- List of all products
- Search functionality
- CRUD operations

// TransactionProvider manages:
- Cart items
- Total calculations
- Transaction history
- Statistics

// SettingsProvider manages:
- Dark mode toggle
- Language selection
```

### Data Flow
1. **Screens** → User interactions
2. **Providers** → State updates & business logic
3. **Services** → Database & external API calls
4. **Models** → Data representation

## 🎨 UI/UX Design Principles

### Fitts' Law (Minimizing Distance)
- ✅ Large touch targets (48x48 minimum)
- ✅ FABs positioned in natural thumb reach (bottom-right)
- ✅ Navigation tabs at bottom for thumb access
- ✅ Spacious layout with 16px padding

### Hick's Law (Reducing Choices)
- ✅ Only 5 main navigation options
- ✅ Grouped related actions (e.g., edit/delete in menu)
- ✅ Clear visual hierarchy
- ✅ Consistent navigation patterns

### Visual Hierarchy
- ✅ Headlines: Bold, large (24-32px)
- ✅ Titles: Medium weight (18-20px)
- ✅ Body: Regular weight (14-16px)
- ✅ Color codes: Primary for actions, semantic colors for status

### Accessibility
- ✅ Minimum contrast ratios met
- ✅ Large font sizes for readability
- ✅ Icon + text labels
- ✅ Semantic HTML structure

## 📱 Responsive Design

### Mobile (< 600px)
- Bottom Navigation Bar
- Full-width screens
- Vertical layouts

### Tablet/Desktop (>= 600px)
- Left Navigation Rail
- Sidebar + Content layout
- Grid layouts for products

## 🔌 AdMob Integration

The app includes AdMob setup using test IDs:

```dart
// Banner Ad (Bottom of screens)
const BANNER_AD_UNIT_ID = 'ca-app-pub-3940256099942544/6300978111';

// Interstitial Ad (After transaction)
const INTERSTITIAL_AD_UNIT_ID = 'ca-app-pub-3940256099942544/1033173712';
```

### To Use Real Ads:
1. Sign up at [Google AdMob](https://admob.google.com/)
2. Create ad units for your app
3. Replace test IDs in `lib/services/admob_helper.dart`
4. Uncomment Google Mobile Ads initialization in `main.dart`

## 📦 Key Dependencies

```yaml
provider: ^6.0.0           # State management
sqflite: ^2.3.0            # SQLite database
intl: ^0.19.0              # Localization
google_mobile_ads: ^2.4.0  # AdMob ads
csv: ^6.0.0                # CSV export
google_fonts: ^6.1.0       # Font management
```

## 💡 How to Use

### Adding a Product
1. Navigate to **Products** tab
2. Click **Add Product** button
3. Fill in: Name, Price, Stock, Category
4. Click **Add**

### Creating a Transaction (POS)
1. Navigate to **POS** tab
2. Select category filter (optional)
3. Click on a product card to add
4. Enter quantity
5. Review cart on the right
6. Click **Checkout** to complete

### Viewing History
1. Navigate to **History** tab
2. Use date range selector to filter
3. Click on transaction to see items
4. Delete if needed

### Settings
1. Navigate to **Settings** tab
2. Toggle **Dark Mode**
3. Select language (**English** or **Indonesian**)

## 🎓 Beginner Tips

### Understanding Providers
```dart
// Watch a provider (rebuilds when data changes)
final products = context.watch<ProductProvider>().products;

// Read a provider (one-time access)
context.read<ProductProvider>().addProduct(product);

// Create a provider
ChangeNotifierProvider(create: (_) => ProductProvider())
```

### Adding Features
1. **New Screen?** Create in `lib/screens/`, add to navigation
2. **New Data?** Add model in `lib/models/`
3. **New Logic?** Add provider in `lib/providers/`
4. **Database?** Use `DatabaseHelper` in `lib/services/`

### Debugging
```bash
# Hot reload (keep state)
r

# Hot restart (reset state)
R

# View logs
flutter logs
```

## 📸 Example Usage

### Sample Product
- Name: Coffee
- Price: 25000 (IDR)
- Stock: 100
- Category: Beverages

### Sample Transaction
- 2 Coffee x 25,000 = 50,000
- 3 Tea x 15,000 = 45,000
- **Total: 95,000**

## 🐛 Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### Database issues
```bash
# Clear app data
adb shell pm clear com.example.cashapp_free
```

### Build issues
```bash
flutter doctor -v  # Check dependencies
```

## 📝 License

This project is open source and available for educational purposes.

## 🤝 Contributing

Feel free to fork and submit pull requests for improvements!

## 📞 Support

For issues or questions:
1. Check the code comments
2. Review the Flutter documentation
3. Post in Flutter community forums

## 🎯 Future Enhancements

- [ ] User accounts & login
- [ ] Cloud sync
- [ ] Receipt printing
- [ ] Inventory alerts
- [ ] Sales analytics
- [ ] Multi-store support
- [ ] Payment methods
- [ ] Barcode scanning

---

**Happy Selling! 🛍️**

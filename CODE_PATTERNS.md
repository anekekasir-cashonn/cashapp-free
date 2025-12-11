# 💻 CashApp Free - Code Patterns & Snippets

Common patterns used throughout the codebase. Reference these when adding features!

## 🏗️ Architecture Patterns

### Provider Pattern (State Management)

#### Reading State (No Rebuild)
```dart
// One-time read in event handler
final products = context.read<ProductProvider>().products;

// Or in async function
final provider = context.read<ProductProvider>();
await provider.addProduct(product);
```

#### Watching State (Rebuilds)
```dart
// Rebuild when provider changes
final products = context.watch<ProductProvider>().products;

// Use in build method
@override
Widget build(BuildContext context) {
  final provider = context.watch<ProductProvider>();
  return ListView.builder(
    itemCount: provider.products.length,
    ...
  );
}
```

#### Creating Provider
```dart
ChangeNotifierProvider(
  create: (_) => ProductProvider(),
  child: YourApp(),
)
```

### Database Pattern (CRUD Operations)

#### CREATE
```dart
Future<void> addProduct(Product product) async {
  await _databaseHelper.insertProduct(product);
  await loadProducts(); // Refresh UI
}
```

#### READ
```dart
Future<void> loadProducts() async {
  _products = await _databaseHelper.getAllProducts();
  notifyListeners(); // Update UI
}
```

#### UPDATE
```dart
Future<void> updateProduct(Product product) async {
  await _databaseHelper.updateProduct(product);
  await loadProducts(); // Refresh
}
```

#### DELETE
```dart
Future<void> deleteProduct(int id) async {
  await _databaseHelper.deleteProduct(id);
  await loadProducts(); // Refresh
}
```

### Dialog Pattern

#### Simple Alert
```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Title'),
    content: const Text('Message'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          // Do something
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    ],
  ),
);
```

#### Input Dialog
```dart
final controller = TextEditingController();

showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Enter Value'),
    content: TextField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Name'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          String value = controller.text;
          Navigator.pop(context);
        },
        child: const Text('Save'),
      ),
    ],
  ),
);
```

## 🎨 UI Patterns

### Card with Actions
```dart
Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(
    title: Text(product.name),
    subtitle: Text('Rp ${product.price}'),
    trailing: PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(child: Text('Edit')),
        PopupMenuItem(child: Text('Delete')),
      ],
    ),
  ),
)
```

### Grid Layout
```dart
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.75,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => Card(child: ...),
)
```

### Expandable List Item
```dart
ExpansionTile(
  title: Text('Header'),
  children: [
    Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Details here'),
          Text('More details'),
        ],
      ),
    ),
  ],
)
```

### Empty State
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.shopping_cart_outlined,
        size: 48,
        color: Colors.grey,
      ),
      const SizedBox(height: 16),
      Text(
        'No items found',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ],
  ),
)
```

### Loading State
```dart
if (isLoading)
  const Center(child: CircularProgressIndicator())
else
  ListView.builder(...)
```

## 📊 Data Patterns

### Model to JSON
```dart
// Product → JSON (for database)
final json = product.toMap();

// JSON → Product (from database)
final product = Product.fromMap(json);
```

### List Filtering
```dart
// Filter by search
List<Product> filtered = products
    .where((p) => p.name.toLowerCase().contains(query))
    .toList();

// Filter by category
List<Product> byCategory = products
    .where((p) => p.category == category)
    .toList();

// Filter by date range
List<Transaction> byDate = transactions
    .where((t) => 
      t.dateTime.isAfter(start) && 
      t.dateTime.isBefore(end)
    )
    .toList();
```

### Calculating Totals
```dart
// Sum all amounts
double total = transactions.fold<double>(
  0,
  (sum, transaction) => sum + transaction.totalAmount,
);

// Count items
int count = transactions.length;

// Find max
double maxAmount = transactions
    .reduce((a, b) => a.totalAmount > b.totalAmount ? a : b)
    .totalAmount;
```

### Formatting Data
```dart
// Currency
String formatted = 'Rp ${NumberFormat('#,###').format(price)}';

// Date
String dateStr = DateFormat('MMM d, yyyy').format(dateTime);

// DateTime
String dateTime = DateFormat('MMM d, yyyy • HH:mm')
    .format(transaction.dateTime);
```

## 🎯 Common Tasks

### Add to Cart
```dart
context.read<TransactionProvider>().addToCart(product, quantity);
```

### Complete Transaction
```dart
await context.read<TransactionProvider>().completeTransaction();
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Transaction completed')),
);
```

### Delete with Confirmation
```dart
final confirmed = await showDialog<bool>(
  context: context,
  builder: (_) => AlertDialog(
    title: const Text('Delete?'),
    content: const Text('This cannot be undone'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('Delete'),
      ),
    ],
  ),
);

if (confirmed == true) {
  provider.deleteItem(id);
}
```

### Show Success Message
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Success!'),
    backgroundColor: Colors.green,
    duration: const Duration(seconds: 2),
  ),
);
```

### Show Error Message
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('Error occurred'),
    backgroundColor: Colors.red,
  ),
);
```

## 🔄 Async Patterns

### Loading with Future
```dart
FutureBuilder<List<Product>>(
  future: productProvider.loadProducts(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    return ListView.builder(
      itemCount: snapshot.data?.length ?? 0,
      ...
    );
  },
)
```

### Fire and Forget (Don't wait)
```dart
// Good for non-critical operations
() async {
  await provider.updateProduct(product);
}();
```

### Wait for Result
```dart
// Good for critical operations
try {
  await provider.completeTransaction();
  showSuccessMessage();
} catch (e) {
  showErrorMessage(e.toString());
}
```

## 🎨 Styling Patterns

### Primary Button
```dart
FilledButton(
  onPressed: () { },
  child: const Text('Save'),
)
```

### Secondary Button
```dart
OutlinedButton(
  onPressed: () { },
  child: const Text('Cancel'),
)
```

### Icon Button
```dart
IconButton(
  onPressed: () { },
  icon: const Icon(Icons.edit),
)
```

### FAB (Floating Action Button)
```dart
FloatingActionButton.extended(
  onPressed: () { },
  label: const Text('Add Item'),
  icon: const Icon(Icons.add),
)
```

### Text Input
```dart
TextField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: 'Product Name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### Dropdown
```dart
DropdownButton<String>(
  value: selectedValue,
  items: ['Option 1', 'Option 2'].map((item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item),
    );
  }).toList(),
  onChanged: (value) {
    setState(() => selectedValue = value);
  },
)
```

## 🔧 Custom Widget Pattern

```dart
class MyCustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyCustomWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title),
        ),
      ),
    );
  }
}

// Usage
MyCustomWidget(
  title: 'Hello',
  onTap: () => print('Tapped'),
)
```

## 📱 Responsive Pattern

```dart
@override
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  
  if (isMobile) {
    return Column(children: [...]);
  } else {
    return Row(children: [...]);
  }
}
```

## 🧪 Testing Pattern

```dart
// In test file
test('Add product increases count', () {
  final provider = ProductProvider();
  final initialCount = provider.products.length;
  
  provider.addProduct(testProduct);
  
  expect(provider.products.length, initialCount + 1);
});
```

## ⚡ Performance Tips

### Use const constructors
```dart
// ✅ Good
const SizedBox(height: 16)

// ❌ Avoid
SizedBox(height: 16)
```

### Use ListView.builder (not ListView)
```dart
// ✅ Good - Only builds visible items
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(items[index]),
)

// ❌ Avoid - Builds all items at once
ListView(
  children: items.map((item) => ItemTile(item)).toList(),
)
```

### Cache expensive operations
```dart
class MyProvider extends ChangeNotifier {
  List<Product>? _cachedProducts;
  
  List<Product> get products {
    return _cachedProducts ??= _loadProducts();
  }
}
```

---

**Use these patterns as templates for consistent, maintainable code!**

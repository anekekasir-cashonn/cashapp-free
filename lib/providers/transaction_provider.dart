import 'package:flutter/material.dart';
import 'package:cashapp_free/models/index.dart';
import 'package:cashapp_free/services/index.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Transaction> _transactions = [];
  List<TransactionItem> _cartItems = [];
  double _totalAmount = 0.0;
  int _totalTransactions = 0;
  double _totalRevenue = 0.0;

  List<Transaction> get transactions => _transactions;
  List<TransactionItem> get cartItems => _cartItems;
  double get totalAmount => _totalAmount;
  int get cartItemCount => _cartItems.length;
  int get totalTransactions => _totalTransactions;
  double get totalRevenue => _totalRevenue;

  TransactionProvider() {
    loadTransactions();
    loadStatistics();
  }

  // ============= CART MANAGEMENT =============

  void addToCart(Product product, int quantity) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Product already in cart - update quantity
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = TransactionItem(
        id: existingItem.id,
        transactionId: existingItem.transactionId,
        productId: existingItem.productId,
        productName: existingItem.productName,
        productPrice: existingItem.productPrice,
        quantity: existingItem.quantity + quantity,
        subtotal:
            (existingItem.quantity + quantity) * existingItem.productPrice,
      );
    } else {
      // Add new product to cart
      final subtotal = product.price * quantity;
      _cartItems.add(
        TransactionItem(
          transactionId: 0, // Will be set when transaction is saved
          productId: product.id!,
          productName: product.name,
          productPrice: product.price,
          quantity: quantity,
          subtotal: subtotal,
        ),
      );
    }

    _calculateTotal();
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      _calculateTotal();
      notifyListeners();
    }
  }

  void updateCartItemQuantity(int index, int quantity) {
    if (index >= 0 && index < _cartItems.length && quantity > 0) {
      final item = _cartItems[index];
      _cartItems[index] = TransactionItem(
        id: item.id,
        transactionId: item.transactionId,
        productId: item.productId,
        productName: item.productName,
        productPrice: item.productPrice,
        quantity: quantity,
        subtotal: item.productPrice * quantity,
      );
      _calculateTotal();
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems = [];
    _totalAmount = 0.0;
    notifyListeners();
  }

  void _calculateTotal() {
    _totalAmount = 0.0;
    for (var item in _cartItems) {
      _totalAmount += item.subtotal;
    }
  }

  // ============= TRANSACTION MANAGEMENT =============

  Future<void> completeTransaction() async {
    if (_cartItems.isEmpty) return;

    final transaction = Transaction(
      dateTime: DateTime.now(),
      totalAmount: _totalAmount,
      itemCount: _cartItems.length,
      items: _cartItems,
    );

    await _databaseHelper.insertTransaction(transaction);
    clearCart();
    await loadTransactions();
    await loadStatistics();
  }

  Future<void> loadTransactions() async {
    _transactions = await _databaseHelper.getAllTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(int id) async {
    await _databaseHelper.deleteTransaction(id);
    await loadTransactions();
    await loadStatistics();
  }

  Future<void> loadStatistics() async {
    _totalRevenue = await _databaseHelper.getTotalRevenue();
    _totalTransactions = await _databaseHelper.getTotalTransactions();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getDailyStatistics(DateTime date) async {
    return await _databaseHelper.getDailyStatistics(date);
  }
}

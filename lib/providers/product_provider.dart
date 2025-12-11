import 'package:flutter/material.dart';
import 'package:cashapp_free/models/index.dart';
import 'package:cashapp_free/services/index.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  List<Product> get products => _filteredProducts.isEmpty && _searchQuery.isEmpty 
      ? _products 
      : _filteredProducts;
  
  List<Product> get allProducts => _products;

  ProductProvider() {
    loadProducts();
  }

  Future<void> loadProducts() async {
    _products = await _databaseHelper.getAllProducts();
    _filteredProducts = [];
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _databaseHelper.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _databaseHelper.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(int id) async {
    await _databaseHelper.deleteProduct(id);
    await loadProducts();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }

  Future<Product?> getProductById(int id) async {
    return await _databaseHelper.getProductById(id);
  }

  List<String> getCategories() {
    final Set<String> categories = {};
    for (var product in _products) {
      categories.add(product.category);
    }
    return categories.toList();
  }
}

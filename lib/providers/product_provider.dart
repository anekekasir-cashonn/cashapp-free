import 'package:flutter/material.dart';
import 'package:cashapp_free/models/index.dart';
import 'package:cashapp_free/services/index.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// dart:html is only available on web; import guarded by kIsWeb usage
// ignore: uri_does_not_exist
import 'dart:html' as html;

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
    if (kIsWeb) {
      try {
        final raw = html.window.localStorage['cashapp_products'];
        if (raw != null) {
          final List<dynamic> decoded = jsonDecode(raw);
          _products = decoded.map((e) => Product.fromMap(Map<String, dynamic>.from(e))).toList();
        } else {
          _products = await _databaseHelper.getAllProducts();
          // persist initial empty list
          html.window.localStorage['cashapp_products'] = jsonEncode(_products.map((p) => p.toMap()).toList());
        }
      } catch (e) {
        // Fallback to database helper if localStorage fails
        _products = await _databaseHelper.getAllProducts();
      }
    } else {
      _products = await _databaseHelper.getAllProducts();
    }
    _filteredProducts = [];
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (kIsWeb) {
      // use localStorage backup on web
      try {
        final raw = html.window.localStorage['cashapp_products'];
        List<dynamic> list = raw != null ? jsonDecode(raw) as List<dynamic> : [];
        final newId = DateTime.now().millisecondsSinceEpoch;
        final prodWithId = product.copyWith(id: newId);
        list.add(prodWithId.toMap());
        html.window.localStorage['cashapp_products'] = jsonEncode(list);
        _products.add(prodWithId);
        notifyListeners();
        return;
      } catch (e) {
        // fallthrough to DB insert
      }
    }

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

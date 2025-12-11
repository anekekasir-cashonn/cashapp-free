import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashapp_free/providers/index.dart';
import 'package:cashapp_free/models/index.dart';
import 'package:cashapp_free/utils/localization_helper.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: uri_does_not_exist
import 'dart:html' as html;

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _showAddProductDialog() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();
    _categoryController.clear();
    _imageController.clear();

    final lang = Provider.of<SettingsProvider>(context, listen: false).language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('products_screen.add_product', lang)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t('products_screen.product_name', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Image field (URL or pick file on web)
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: t('products_screen.image', lang),
                  border: const OutlineInputBorder(),
                  suffixIcon: kIsWeb
                      ? IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: () {
                            // web file picker
                            final input = html.FileUploadInputElement()..accept = 'image/*';
                            input.click();
                            input.onChange.listen((_) {
                              final file = input.files?.first;
                              if (file != null) {
                                final reader = html.FileReader();
                                reader.readAsDataUrl(file);
                                reader.onLoad.first.then((_) {
                                  _imageController.text = reader.result as String;
                                  setState(() {});
                                });
                              }
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              if (_imageController.text.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: Image.network(
                    _imageController.text,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('products_screen.price', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('products_screen.stock', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: t('products_screen.category', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('common.cancel', lang)),
          ),
          FilledButton(
            onPressed: () async {
              if (_nameController.text.isEmpty ||
                  _priceController.text.isEmpty ||
                  _stockController.text.isEmpty ||
                  _categoryController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t('products_screen.please_fill_all_fields', lang))),
                );
                return;
              }

              final product = Product(
                name: _nameController.text,
                price: double.parse(_priceController.text),
                stock: int.parse(_stockController.text),
                category: _categoryController.text,
                imageUrl: _imageController.text.isEmpty ? null : _imageController.text,
              );

              context.read<ProductProvider>().addProduct(product);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t('products_screen.product_added', lang))),
              );
            },
            child: Text(t('products_screen.add', lang)),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(Product product) {
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _categoryController.text = product.category;
    _imageController.text = product.imageUrl ?? '';

    final lang = Provider.of<SettingsProvider>(context, listen: false).language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('products_screen.edit_product', lang)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: t('products_screen.product_name', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              // Image field
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  labelText: t('products_screen.image', lang),
                  border: const OutlineInputBorder(),
                  suffixIcon: kIsWeb
                      ? IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: () {
                            final input = html.FileUploadInputElement()..accept = 'image/*';
                            input.click();
                            input.onChange.listen((_) {
                              final file = input.files?.first;
                              if (file != null) {
                                final reader = html.FileReader();
                                reader.readAsDataUrl(file);
                                reader.onLoad.first.then((_) {
                                  _imageController.text = reader.result as String;
                                  setState(() {});
                                });
                              }
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              if (_imageController.text.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: Image.network(
                    _imageController.text,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('products_screen.price', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t('products_screen.stock', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: t('products_screen.category', lang),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('common.cancel', lang)),
          ),
          FilledButton(
            onPressed: () async {
              final updatedProduct = product.copyWith(
                name: _nameController.text,
                price: double.parse(_priceController.text),
                stock: int.parse(_stockController.text),
                category: _categoryController.text,
              );

              context.read<ProductProvider>().updateProduct(updatedProduct);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(t('products_screen.product_updated', lang))),
              );
            },
            child: Text(t('products_screen.update', lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final lang = Provider.of<SettingsProvider>(context).language;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('products_screen.title', lang)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                productProvider.searchProducts(value);
              },
              decoration: InputDecoration(
                hintText: t('products_screen.search_hint', lang),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          productProvider.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Products List
          Expanded(
            child: productProvider.products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2,
                          size: 64,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t('products_screen.no_products', lang),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(product.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${t('products_screen.price', lang)}: Rp ${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${t('products_screen.stock', lang)}: ${product.stock} | ${t('products_screen.category', lang)}: ${product.category}',
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(t('products_screen.edit', lang)),
                                onTap: () {
                                  Future.microtask(
                                    () => _showEditProductDialog(product),
                                  );
                                },
                              ),
                              PopupMenuItem(
                                child: Text(t('products_screen.delete_product', lang)),
                                onTap: () {
                                  productProvider.deleteProduct(product.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(t('products_screen.product_deleted', lang)),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProductDialog,
        label: Text(t('products_screen.add_product', lang)),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

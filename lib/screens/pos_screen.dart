import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cashapp_free/providers/index.dart';
import 'package:cashapp_free/utils/localization_helper.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _showQuantityDialog(int productId) {
    _quantityController.clear();
    final lang = Provider.of<SettingsProvider>(context, listen: false).language;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('pos_screen.enter_quantity', lang)),
        content: TextField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: t('pos_screen.quantity', lang),
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('common.cancel', lang)),
          ),
          FilledButton(
            onPressed: () {
              final quantity = int.tryParse(_quantityController.text) ?? 0;
              if (quantity > 0) {
                final productProvider = context.read<ProductProvider>();
                final product = productProvider.allProducts
                    .firstWhere((p) => p.id == productId);
                context.read<TransactionProvider>().addToCart(product, quantity);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${product.name} x$quantity ${t('pos_screen.added_to_cart', lang)}'),
                    duration: const Duration(milliseconds: 800),
                  ),
                );
              }
            },
            child: Text(t('common.add', lang)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final lang = Provider.of<SettingsProvider>(context).language;

    final categories = [
      'All',
      ...productProvider.getCategories(),
    ];

    final filteredProducts = _selectedCategory == 'All'
        ? productProvider.allProducts
        : productProvider.allProducts
            .where((p) => p.category == _selectedCategory)
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Products Section
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Category Filter
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(category == 'All' ? t('common.all', lang) : category),
                                  selected: _selectedCategory == category,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCategory = category;
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),

                  // Products Grid
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () => _showQuantityDialog(product.id!),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.shopping_bag,
                                      size: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${NumberFormat('#,###').format(product.price)}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${t('pos_screen.stock', lang)}: ${product.stock}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
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
            ),

            // Cart Section
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Cart Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '${t('pos_screen.cart', lang)} (${transactionProvider.cartItemCount})',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  // Cart Items
                  Expanded(
                    child: transactionProvider.cartItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 48,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  t('pos_screen.cart_empty', lang),
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount:
                                transactionProvider.cartItems.length,
                            itemBuilder: (context, index) {
                              final item =
                                  transactionProvider.cartItems[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${NumberFormat('#,###').format(item.productPrice)}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'x${item.quantity}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                        children: [
                                          Text(
                                            'Rp ${NumberFormat('#,###').format(item.subtotal)}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  if (item.quantity > 1) {
                                                    transactionProvider
                                                        .updateCartItemQuantity(
                                                      index,
                                                      item.quantity - 1,
                                                    );
                                                  } else {
                                                    transactionProvider
                                                        .removeFromCart(
                                                      index,
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.remove),
                                                iconSize: 16,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  transactionProvider
                                                      .updateCartItemQuantity(
                                                    index,
                                                    item.quantity + 1,
                                                  );
                                                },
                                                icon: const Icon(Icons.add),
                                                iconSize: 16,
                                                padding: EdgeInsets.zero,
                                                constraints:
                                                    const BoxConstraints(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),

                  // Total & Checkout
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${t('common.total', lang)}:'),
                            Text(
                              'Rp ${NumberFormat('#,###').format(transactionProvider.totalAmount)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: transactionProvider.cartItems.isEmpty
                              ? null
                              : () async {
                                  await transactionProvider
                                      .completeTransaction();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text(t('pos_screen.transaction_completed', lang)),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.check),
                          label: Text(t('pos_screen.checkout', lang)),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: transactionProvider.cartItems.isEmpty
                              ? null
                              : () {
                                  transactionProvider.clearCart();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(t('pos_screen.cart_cleared', lang)),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.delete),
                          label: Text(t('pos_screen.clear_cart', lang)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

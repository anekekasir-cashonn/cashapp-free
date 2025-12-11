class Product {
  final int? id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String? imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    this.imageUrl,
  });

  // Convert Product to Map (for database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'image': imageUrl,
    };
  }

  // Create Product from Map (from database)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      stock: map['stock'],
      category: map['category'],
      imageUrl: map['image'],
    );
  }

  // Copy with
  Product copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    String? category,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

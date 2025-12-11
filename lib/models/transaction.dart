class Transaction {
  final int? id;
  final DateTime dateTime;
  final double totalAmount;
  final int itemCount;
  final List<TransactionItem> items;

  Transaction({
    this.id,
    required this.dateTime,
    required this.totalAmount,
    required this.itemCount,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'totalAmount': totalAmount,
      'itemCount': itemCount,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map, {List<TransactionItem>? items}) {
    return Transaction(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      itemCount: map['itemCount'],
      items: items ?? [],
    );
  }
}

class TransactionItem {
  final int? id;
  final int transactionId;
  final int productId;
  final String productName;
  final double productPrice;
  final int quantity;
  final double subtotal;

  TransactionItem({
    this.id,
    required this.transactionId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'],
      transactionId: map['transactionId'],
      productId: map['productId'],
      productName: map['productName'],
      productPrice: (map['productPrice'] as num).toDouble(),
      quantity: map['quantity'],
      subtotal: (map['subtotal'] as num).toDouble(),
    );
  }
}

import 'package:csv/csv.dart';

class CsvExportHelper {
  /// Export transactions to CSV format
  static String exportTransactionsToCSV(List<Map<String, dynamic>> transactions) {
    final List<List<dynamic>> rows = [
      ['Transaction ID', 'Date', 'Total Amount', 'Item Count'],
      ...transactions.map((t) => [
        t['id'],
        t['dateTime'],
        t['totalAmount'],
        t['itemCount'],
      ]),
    ];

    return const ListToCsvConverter().convert(rows);
  }

  /// Export products to CSV format
  static String exportProductsToCSV(List<Map<String, dynamic>> products) {
    final List<List<dynamic>> rows = [
      ['Product ID', 'Name', 'Price', 'Stock', 'Category'],
      ...products.map((p) => [
        p['id'],
        p['name'],
        p['price'],
        p['stock'],
        p['category'],
      ]),
    ];

    return const ListToCsvConverter().convert(rows);
  }
}

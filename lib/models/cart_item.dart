import 'item.dart';

/// Wraps a menu [Item] together with the quantity the user has selected
/// for their order.
///
/// Place this file at: lib/models/cart_item.dart
class CartItem {
  final Item item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});

  /// Price for this line = unit price × quantity.
  double get subtotal => item.sellingPrice * quantity;
}
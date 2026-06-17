import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/item.dart';

/// Holds the items the user has selected before checkout.
///
/// Keyed by [Item.prodCode] so the same product is never duplicated —
/// adding it again just increments the quantity.
///
/// Place this file at: lib/providers/cart_provider.dart
/// Remember to register it once in your provider tree (see main.dart note
/// in the chat reply).
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  int get itemCount => _items.values.fold(0, (sum, c) => sum + c.quantity);

  double get totalAmount =>
      _items.values.fold(0.0, (sum, c) => sum + c.subtotal);

  int quantityOf(String prodCode) => _items[prodCode]?.quantity ?? 0;

  void addItem(Item item) {
    final existing = _items[item.prodCode];
    if (existing != null) {
      existing.quantity++;
    } else {
      _items[item.prodCode] = CartItem(item: item);
    }
    notifyListeners();
  }

  void incrementQuantity(String prodCode) {
    final existing = _items[prodCode];
    if (existing == null) return;
    existing.quantity++;
    notifyListeners();
  }

  void decrementQuantity(String prodCode) {
    final existing = _items[prodCode];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _items.remove(prodCode);
    } else {
      existing.quantity--;
    }
    notifyListeners();
  }

  void removeItem(String prodCode) {
    _items.remove(prodCode);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // TODO: when the order API is ready, add a method here (e.g.
  // submitOrder()) that posts `items` to the backend and clears the cart
  // on a successful response.
}
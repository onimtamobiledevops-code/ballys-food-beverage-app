import 'package:flutter/material.dart';

/// Represents a single food or beverage item displayed on the Home screen.
class MenuItem {
  final String name;
  final String category;
  final String price;
  final IconData icon;

  const MenuItem({
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
  });
}

/// Mock data used to populate the Home screen menu grid.
final List<MenuItem> mockMenuItems = [
  const MenuItem(
    name: 'Classic Burger',
    category: 'Food',
    price: '\$12.99',
    icon: Icons.lunch_dining,
  ),
  const MenuItem(
    name: 'Margherita Pizza',
    category: 'Food',
    price: '\$15.50',
    icon: Icons.local_pizza,
  ),
  const MenuItem(
    name: 'Caesar Salad',
    category: 'Food',
    price: '\$9.75',
    icon: Icons.eco,
  ),
  const MenuItem(
    name: 'Grilled Steak',
    category: 'Food',
    price: '\$24.00',
    icon: Icons.set_meal,
  ),
  const MenuItem(
    name: 'Iced Coffee',
    category: 'Beverage',
    price: '\$4.50',
    icon: Icons.coffee,
  ),
  const MenuItem(
    name: 'Fresh Orange Juice',
    category: 'Beverage',
    price: '\$5.00',
    icon: Icons.local_bar,
  ),
  const MenuItem(
    name: 'Craft Cocktail',
    category: 'Beverage',
    price: '\$11.00',
    icon: Icons.local_drink,
  ),
  const MenuItem(
    name: 'Chocolate Milkshake',
    category: 'Beverage',
    price: '\$6.25',
    icon: Icons.icecream,
  ),
];

/// Represents a past order shown on the Orders tab.
class OrderItem {
  final String id;
  final String title;
  final String date;
  final String status;
  final String total;

  const OrderItem({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.total,
  });
}

/// Mock order history data.
final List<OrderItem> mockOrders = [
  const OrderItem(
    id: '#BFB-1042',
    title: 'Classic Burger, Iced Coffee',
    date: 'Jun 11, 2026 - 1:30 PM',
    status: 'Delivered',
    total: '\$17.49',
  ),
  const OrderItem(
    id: '#BFB-1039',
    title: 'Margherita Pizza, Craft Cocktail',
    date: 'Jun 09, 2026 - 7:15 PM',
    status: 'Delivered',
    total: '\$26.50',
  ),
  const OrderItem(
    id: '#BFB-1031',
    title: 'Caesar Salad, Fresh Orange Juice',
    date: 'Jun 05, 2026 - 12:05 PM',
    status: 'Cancelled',
    total: '\$14.75',
  ),
  const OrderItem(
    id: '#BFB-1022',
    title: 'Grilled Steak, Chocolate Milkshake',
    date: 'May 30, 2026 - 8:40 PM',
    status: 'Delivered',
    total: '\$30.25',
  ),
];

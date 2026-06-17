import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/quantity_stepper.dart';

/// Place this file at: lib/screens/checkout_screen.dart
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          if (cart.isNotEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.primaryRed),
              ),
            ),
        ],
      ),
      body: cart.isEmpty ? _buildEmptyState() : _buildCartList(context, cart),
      bottomNavigationBar: cart.isEmpty ? null : _OrderSummaryBar(cart: cart),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined,
                color: AppColors.greyText, size: 56),
            SizedBox(height: 16),
            Text(
              'Your cart is empty.',
              style: TextStyle(color: AppColors.greyText, fontSize: 15),
            ),
            SizedBox(height: 6),
            Text(
              'Add items from a category to get started.',
              style: TextStyle(color: AppColors.greyText, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartProvider cart) {
    final items = cart.items;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _CartItemTile(cartItem: items[index]),
    );
  }

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceBlack,
        title: const Text('Clear cart?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This will remove all items from your cart.',
          style: TextStyle(color: AppColors.greyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(dialogContext);
            },
            child:
                const Text('Clear', style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final item = cartItem.item;

    return Dismissible(
      key: ValueKey(item.prodCode),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          context.read<CartProvider>().removeItem(item.prodCode),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      // child: Material(
      //   color: AppColors.surfaceBlack,
      //   borderRadius: BorderRadius.circular(16),
      //   child: Padding(
      //     padding: const EdgeInsets.all(14),
      //     child: Row(
      //       children: [
      //         Container(
      //           width: 50,
      //           height: 50,
      //           decoration: BoxDecoration(
      //             gradient: AppColors.primaryGradient,
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           child: const Icon(Icons.fastfood_outlined,
      //               color: Colors.white, size: 24),
      //         ),
      //         const SizedBox(width: 12),
      //         Expanded(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 item.prodName,
      //                 style: const TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 14,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //                 maxLines: 1,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //               const SizedBox(height: 4),
      //               Text(
      //                 'Rs. ${item.sellingPrice.toStringAsFixed(2)} each',
      //                 style: const TextStyle(
      //                     color: AppColors.greyText, fontSize: 12),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(width: 8),
      //         QuantityStepper(
      //           quantity: cartItem.quantity,
      //           onIncrement: () => context
      //               .read<CartProvider>()
      //               .incrementQuantity(item.prodCode),
      //           onDecrement: () => context
      //               .read<CartProvider>()
      //               .decrementQuantity(item.prodCode),
      //         ),
      //         const SizedBox(width: 12),
      //         SizedBox(
      //           width: 64,
      //           child: Text(
      //             'Rs. ${cartItem.subtotal.toStringAsFixed(2)}',
      //             textAlign: TextAlign.right,
      //             style: const TextStyle(
      //               color: AppColors.primaryOrange,
      //               fontSize: 13,
      //               fontWeight: FontWeight.w700,
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      child: Material(
  color: AppColors.surfaceBlack,
  borderRadius: BorderRadius.circular(16),
  child: Padding(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Row 1: icon  |  name + unit price  |  quantity stepper ──
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood_outlined,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.prodName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.sellingPrice.toStringAsFixed(2)} each',
                    style: const TextStyle(
                        color: AppColors.greyText, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            QuantityStepper(
              quantity: cartItem.quantity,
              onIncrement: () => context
                  .read<CartProvider>()
                  .incrementQuantity(item.prodCode),
              onDecrement: () => context
                  .read<CartProvider>()
                  .decrementQuantity(item.prodCode),
            ),
          ],
        ),

        // ── Row 2: subtotal aligned to the right ──
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Rs. ${cartItem.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.primaryOrange,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}

// ── Bottom summary + place order ──────────────────────────────────────

class _OrderSummaryBar extends StatelessWidget {
  final CartProvider cart;
  const _OrderSummaryBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        decoration: const BoxDecoration(
          color: AppColors.surfaceBlack,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _summaryRow('Items (${cart.itemCount})',
                'Rs. ${cart.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 6),
            _mutedRow('Taxes & charges', 'Calculated at payment'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: AppColors.greyText, height: 1),
            ),
            _summaryRow(
              'Total',
              'Rs. ${cart.totalAmount.toStringAsFixed(2)}',
              isTotal: true,
            ),
            const SizedBox(height: 16),
            _PlaceOrderButton(cart: cart),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primaryOrange : Colors.white,
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _mutedRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(color: AppColors.greyText, fontSize: 12)),
        Text(value,
            style: const TextStyle(color: AppColors.greyText, fontSize: 12)),
      ],
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  final CartProvider cart;
  const _PlaceOrderButton({required this.cart});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _placeOrder(context),
            child: const Center(
              child: Text(
                'PLACE ORDER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context) {
    // TODO: replace with a real API call once the order endpoint is ready,
    // e.g. final orderId = await orderRepository.submitOrder(cart.items);
    // then cart.clear() and navigate to an order-confirmation screen.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placement will be wired up to the API soon.'),
        backgroundColor: AppColors.surfaceBlack,
      ),
    );
  }
}
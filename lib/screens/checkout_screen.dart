import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/member_profile_card.dart';
import '../widgets/quantity_stepper.dart';

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
              child: const Text('Clear', style: TextStyle(color: AppColors.primaryRed)),
            ),
        ],
      ),
      body: cart.isEmpty ? _buildEmptyState() : _buildContent(context, cart),
      bottomNavigationBar: cart.isEmpty ? null : _OrderSummaryBar(cart: cart),
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, color: AppColors.greyText, size: 56),
            SizedBox(height: 16),
            Text('Your cart is empty.',
                style: TextStyle(color: AppColors.greyText, fontSize: 15)),
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

  // ── Main content: login user → member card → cart items ───────────────────

  Widget _buildContent(BuildContext context, CartProvider cart) {
    final user = context.watch<AuthProvider>().currentUser;

    return ListView(
      children: [
        // ── 1. Logged-in staff user strip ──────────────────────
        _LoggedInUserStrip(name: user?.name ?? 'Staff'),

        // ── 2. Member profile card (hardcoded) ─────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Text(
            'MEMBER',
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const MemberProfileCard(),

        // ── 3. Cart items ───────────────────────────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Text(
            'ORDER ITEMS',
            style: TextStyle(
              color: AppColors.greyText,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
          itemCount: cart.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _CartItemTile(cartItem: cart.items[index]),
        ),
      ],
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
            child: const Text('Clear', style: TextStyle(color: AppColors.primaryRed)),
          ),
        ],
      ),
    );
  }
}

// ── Logged-in staff user strip ────────────────────────────────────────────────

class _LoggedInUserStrip extends StatelessWidget {
  final String name;
  const _LoggedInUserStrip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.30),
          width: 1.1,
        ),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LOGGED IN AS',
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryOrange.withOpacity(0.4),
                width: 0.8,
              ),
            ),
            child: const Text(
              'Staff',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cart item tile ─────────────────────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  const _CartItemTile({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final item = cartItem.item;

    return Dismissible(
      key: ValueKey(item.prodCode),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<CartProvider>().removeItem(item.prodCode),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryRed,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Material(
        color: AppColors.surfaceBlack,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

// ── Bottom summary bar ─────────────────────────────────────────────────────────

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
            _row('Items (${cart.itemCount})',
                'Rs. ${cart.totalAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 6),
            _mutedRow('Taxes & charges', 'Calculated at payment'),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(color: AppColors.greyText, height: 1),
            ),
            _row('Total', 'Rs. ${cart.totalAmount.toStringAsFixed(2)}',
                isTotal: true),
            const SizedBox(height: 16),
            _PlaceOrderButton(cart: cart),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool isTotal = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTotal ? 16 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              )),
          Text(value,
              style: TextStyle(
                color: isTotal ? AppColors.primaryOrange : Colors.white,
                fontSize: isTotal ? 16 : 13,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              )),
        ],
      );

  Widget _mutedRow(String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(color: AppColors.greyText, fontSize: 12)),
          Text(value,
              style:
                  const TextStyle(color: AppColors.greyText, fontSize: 12)),
        ],
      );
}

// ── Place order button ─────────────────────────────────────────────────────────

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
            onTap: () => _showOrderTypeDialog(context),
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

  void _showOrderTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceBlack,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryOrange.withOpacity(0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryOrange.withOpacity(0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.receipt_long_outlined,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Order Type',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Rs. ${cart.totalAmount.toStringAsFixed(2)} · ${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'}',
                style: const TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _DialogButton(
                      label: 'Order',
                      icon: Icons.local_dining_outlined,
                      isPrimary: true,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _handleOrder(context, isOrder: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DialogButton(
                      label: 'Piaza',
                      icon: Icons.shopping_bag_outlined,
                      isPrimary: false,
                      onTap: () {
                        Navigator.pop(dialogContext);
                        _handleOrder(context, isOrder: false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.greyText, fontSize: 13)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOrder(BuildContext context, {required bool isOrder}) {
    final type = isOrder ? 'Order' : 'Purchase';
    // TODO: wire to real API — e.g. orderRepository.submitOrder(cart.items, type: type)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type will be wired up to the API soon.'),
        backgroundColor: AppColors.surfaceBlack,
      ),
    );
  }
}

// ── Dialog action button ───────────────────────────────────────────────────────

class _DialogButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DialogButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Container(
      height: 62,
      decoration: BoxDecoration(
        gradient: isPrimary ? AppColors.primaryGradient : null,
        borderRadius: borderRadius,
        border: isPrimary
            ? null
            : Border.all(color: AppColors.primaryOrange, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isPrimary ? Colors.white : AppColors.primaryOrange,
                  size: 22),
              const SizedBox(height: 5),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : AppColors.primaryOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/menu_item.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/menu_card.dart';

/// "Home" tab - dashboard with greeting, promo banner and featured items.
class HomeTab extends StatelessWidget {
  final VoidCallback onViewMenu;

  const HomeTab({super.key, required this.onViewMenu});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final featured = mockMenuItems.take(4).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome${user != null ? ', ${user.name}' : ''} 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Great food & drinks, delivered fast.',
            style: TextStyle(color: AppColors.greyText, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Promo banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '20% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'On your first order today',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton(
                        onPressed: onViewMenu,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Order Now'),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.local_fire_department, color: Colors.white, size: 56),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Featured Items',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewMenu,
                child: const Text('See all'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featured.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = featured[index];
              return MenuCard(
                item: item,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} added to cart'),
                      backgroundColor: AppColors.surfaceBlackLight,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

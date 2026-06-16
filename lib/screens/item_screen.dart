import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/item.dart';
import '../providers/menu_data_provider.dart';
import '../theme/app_theme.dart';

class ItemScreen extends StatelessWidget {
  final Category category;

  const ItemScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final menuData = context.watch<MenuDataProvider>();
    final items = menuData.itemsOf(category.catCode);

    return Scaffold(
      appBar: AppBar(title: Text(category.catName)),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/itemscreenbackground.png',
            fit: BoxFit.cover,
          ),
          _buildBody(context, menuData, items),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MenuDataProvider menuData,
    List<Item> items,
  ) {
    if (menuData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    if (menuData.status == MenuDataStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: AppColors.greyText, size: 48),
              const SizedBox(height: 16),
              Text(
                menuData.errorMessage ?? 'Something went wrong.',
                style: const TextStyle(color: AppColors.greyText),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: menuData.loadAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOrange,
                  side: const BorderSide(color: AppColors.primaryOrange),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No items found.',
          style: TextStyle(color: AppColors.greyText),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) => _ItemCard(item: items[index]),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;

  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceBlack.withOpacity(0.9),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: navigate to item detail or add to order
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.fastfood_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.prodName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Code: ${item.prodCode}',
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Rs. ${item.sellingPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: AppColors.primaryOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
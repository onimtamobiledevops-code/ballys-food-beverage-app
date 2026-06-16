import 'package:flutter/material.dart';

import '../../models/menu_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/menu_card.dart';

/// "Menu" tab - browse food & beverage items by category.
class MenuTab extends StatefulWidget {
  const MenuTab({super.key});

  @override
  State<MenuTab> createState() => _MenuTabState();
}

class _MenuTabState extends State<MenuTab> {
  String _selectedCategory = 'All';

  List<MenuItem> get _filteredItems {
    if (_selectedCategory == 'All') return mockMenuItems;
    return mockMenuItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 8),
        // _buildCategoryTabs(),
        // const SizedBox(height: 8),
        // Expanded(
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: GridView.builder(
        //       padding: const EdgeInsets.only(bottom: 16),
        //       itemCount: _filteredItems.length,
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         mainAxisSpacing: 14,
        //         crossAxisSpacing: 14,
        //         childAspectRatio: 0.85,
        //       ),
        //       itemBuilder: (context, index) {
        //         final item = _filteredItems[index];
        //         return MenuCard(
        //           item: item,
        //           onTap: () {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               SnackBar(
        //                 content: Text('${item.name} added to cart'),
        //                 backgroundColor: AppColors.surfaceBlackLight,
        //               ),
        //             );
        //           },
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['All', 'Food', 'Beverage'];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => setState(() => _selectedCategory = category),
            backgroundColor: AppColors.surfaceBlack,
            selectedColor: AppColors.primaryRed,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.greyText,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected
                    ? AppColors.primaryOrange
                    : AppColors.surfaceBlackLight,
              ),
            ),
          );
        },
      ),
    );
  }
}

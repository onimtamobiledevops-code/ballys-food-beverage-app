import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/department.dart';
import '../providers/menu_data_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class CategoryScreen extends StatefulWidget {
  final Department department;

  const CategoryScreen({super.key, required this.department});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuData = context.watch<MenuDataProvider>();
    final categories = menuData.categoriesOf(widget.department.deptCode);
    final filteredCategories = _searchQuery.isEmpty
        ? categories
        : categories
            .where((c) =>
                c.catName.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return AppScaffold(
      title: widget.department.deptName,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/categoryscreenbackground.png',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search categories...',
                    hintStyle: const TextStyle(color: AppColors.greyText),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.greyText),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: AppColors.greyText),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceBlack,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(context, menuData, filteredCategories),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MenuDataProvider menuData,
    List<Category> categories,
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

    if (categories.isEmpty) {
      return Center(
        child: Text(
          _searchQuery.isEmpty
              ? 'No categories found.'
              : 'No categories match "$_searchQuery".',
          style: const TextStyle(color: AppColors.greyText),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) =>
          _CategoryCard(category: categories[index]),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Category category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceBlack,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, '/items', arguments: category);
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
                  Icons.category_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.catName,
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
                'Code: ${category.catCode}',
                style: const TextStyle(color: AppColors.greyText, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
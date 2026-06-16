import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/department.dart';
import '../../models/category.dart';
import '../../models/item.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_data_provider.dart';
import '../../theme/app_theme.dart';
import '../category_screen.dart';
import '../item_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final menuData = context.read<MenuDataProvider>();
      if (menuData.status == MenuDataStatus.idle) {
        menuData.loadAll();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final menuData = context.watch<MenuDataProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                'Select a department to get started.',
                style: TextStyle(color: AppColors.greyText, fontSize: 13),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search departments, categories, items...',
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
              const SizedBox(height: 20),
              if (_searchQuery.isEmpty)
                const Text(
                  'Departments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: _searchQuery.isNotEmpty
              ? _GlobalSearchResults(query: _searchQuery, menuData: menuData)
              : _buildBody(menuData),
        ),
      ],
    );
  }

  Widget _buildBody(MenuDataProvider provider) {
    switch (provider.status) {
      case MenuDataStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case MenuDataStatus.error:
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
                  provider.errorMessage ?? 'Something went wrong.',
                  style: const TextStyle(color: AppColors.greyText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: provider.loadAll,
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

      case MenuDataStatus.loaded:
        final items = provider.departments;
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No departments available.',
              style: TextStyle(color: AppColors.greyText),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) =>
              _DepartmentCard(dept: items[index]),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Global search results ────────────────────────────────────────────────

class _GlobalSearchResults extends StatelessWidget {
  final String query;
  final MenuDataProvider menuData;

  const _GlobalSearchResults({required this.query, required this.menuData});

  @override
  Widget build(BuildContext context) {
    if (menuData.status != MenuDataStatus.loaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryOrange),
      );
    }

    final q = query.toLowerCase();

    final deptResults = menuData.departments
        .where((d) => d.deptName.toLowerCase().contains(q))
        .toList();
    final catResults = menuData.allCategories
        .where((c) => c.catName.toLowerCase().contains(q))
        .toList();
    final itemResults = menuData.allItems
        .where((i) => i.prodName.toLowerCase().contains(q))
        .toList();

    if (deptResults.isEmpty && catResults.isEmpty && itemResults.isEmpty) {
      return Center(
        child: Text(
          'No results for "$query".',
          style: const TextStyle(color: AppColors.greyText),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        if (deptResults.isNotEmpty) ...[
          const _SectionHeader(title: 'Departments'),
          ...deptResults.map((d) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SizedBox(
                  width: 32,
                  height: 32,
                  child: _DeptLottieIcon(dept: d),
                ),
                title: Text(d.deptName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text('Code: ${d.deptCode}',
                    style: const TextStyle(color: AppColors.greyText)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CategoryScreen(department: d)),
                ),
              )),
        ],
        if (catResults.isNotEmpty) ...[
          const _SectionHeader(title: 'Categories'),
          ...catResults.map((c) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.category_outlined,
                    color: AppColors.primaryOrange),
                title: Text(c.catName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text('Code: ${c.catCode}',
                    style: const TextStyle(color: AppColors.greyText)),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ItemScreen(category: c)),
                ),
              )),
        ],
        if (itemResults.isNotEmpty) ...[
          const _SectionHeader(title: 'Items'),
          ...itemResults.map((i) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.fastfood_outlined,
                    color: AppColors.primaryOrange),
                title: Text(i.prodName,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text('Rs. ${i.sellingPrice.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppColors.primaryOrange)),
              )),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}

// ── Department Lottie resolver ───────────────────────────────────────────

/// Resolves which Lottie asset to use based on department name, with a
/// fallback to a generic store icon if no asset matches.
String? _deptLottieAsset(Department dept) {
  final name = dept.deptName.toLowerCase();
  if (name.contains('beverage') || name.contains('drink') || name.contains('coffee')) {
    return 'assets/lottie/CoffeeCup.json';
  }
  if (name.contains('food')) {
    return 'assets/lottie/Food.json';
  }
  if (name.contains('desert') || name.contains('dessert') || name.contains('ice cream') || name.contains('icecream')) {
    return 'assets/lottie/IceCream.json';
  }
  if (name.contains('cigarette') || name.contains('tobacco')) {
    return 'assets/lottie/cigarette.json';
  }
  return null;
}

class _DeptLottieIcon extends StatelessWidget {
  final Department dept;
  const _DeptLottieIcon({required this.dept});

  IconData _fallbackIcon() {
    final name = dept.deptName.toLowerCase();
    if (name.contains('beverage') || name.contains('drink')) {
      return Icons.local_bar_outlined;
    }
    if (name.contains('food')) return Icons.restaurant_outlined;
    if (name.contains('desert') || name.contains('dessert')) {
      return Icons.icecream_outlined;
    }
    if (name.contains('cigarette') || name.contains('tobacco')) {
      return Icons.smoking_rooms_outlined;
    }
    return Icons.store_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final asset = _deptLottieAsset(dept);
    if (asset == null) {
      return Icon(_fallbackIcon(), color: AppColors.primaryOrange);
    }
    return Lottie.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          Icon(_fallbackIcon(), color: AppColors.primaryOrange),
    );
  }
}

// ── Department card ──────────────────────────────────────────────────────

class _DepartmentCard extends StatelessWidget {
  final Department dept;
  const _DepartmentCard({required this.dept});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceBlack,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primaryOrange, width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.pushNamed(context, '/categories', arguments: dept);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
    //           Container(
    //             width: 80,
    //             height: 80,
    //             decoration: BoxDecoration(
    //               gradient: AppColors.primaryGradient,
    //               borderRadius: BorderRadius.circular(14),
    //                border: Border.all(              // ✅ orange border
    //   color: AppColors.primaryOrange,
    //   width: 2.0,
    // ),
    //             ),
    //             padding: const EdgeInsets.all(10),
    //             child: _DeptLottieIcon(dept: dept),
    //           ),
    SizedBox(
  width: 80,
  height: 80,
  child: _DeptLottieIcon(dept: dept),
),
              const SizedBox(height: 12),
              Text(
                dept.deptName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Code: ${dept.deptCode}',
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
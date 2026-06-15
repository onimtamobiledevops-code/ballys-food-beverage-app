import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/department.dart';
import '../../providers/auth_provider.dart';
import '../../providers/menu_data_provider.dart'; // ← changed
import '../../theme/app_theme.dart';

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
      // Only load if not already loaded
      final menuData = context.read<MenuDataProvider>();
      if (menuData.status == MenuDataStatus.idle) {
        menuData.loadAll(); // ← changed
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Department> _filtered(List<Department> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all.where((d) => d.deptName.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final menuData = context.watch<MenuDataProvider>(); // ← changed

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
                  hintText: 'Search departments...',
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
        Expanded(child: _buildBody(menuData)), // ← changed
      ],
    );
  }

  Widget _buildBody(MenuDataProvider provider) { // ← changed
    switch (provider.status) {
      case MenuDataStatus.loading: // ← changed
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case MenuDataStatus.error: // ← changed
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
                  onPressed: provider.loadAll, // ← changed
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

      case MenuDataStatus.loaded: // ← changed
        final items = _filtered(provider.departments);
        if (items.isEmpty) {
          return Center(
            child: Text(
              'No departments match "$_searchQuery".',
              style: const TextStyle(color: AppColors.greyText),
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

// ── Department card (unchanged) ──────────────────────────────────────────────

class _DepartmentCard extends StatelessWidget {
  final Department dept;
  const _DepartmentCard({required this.dept});

  IconData _icon() {
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
    return Material(
      color: AppColors.surfaceBlack,
      borderRadius: BorderRadius.circular(16),
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
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon(), color: Colors.white, size: 28),
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
    );
  }
}
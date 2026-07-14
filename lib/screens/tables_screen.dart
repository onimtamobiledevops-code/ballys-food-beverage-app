import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../providers/table_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class TablesScreen extends StatefulWidget {
  final String pitName;

  const TablesScreen({super.key, required this.pitName});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TableProvider>().loadTables(widget.pitName);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TableProvider>();

    return AppScaffold(
      title: 'Pit ${widget.pitName}',
      backgroundColor: AppColors.black,
      showDrawer: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search table...',
                hintStyle: const TextStyle(color: AppColors.greyText),
                prefixIcon: const Icon(Icons.search, color: AppColors.greyText),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColors.greyText),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TableProvider provider) {
    switch (provider.status) {
      case TableStatus.idle:
      case TableStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case TableStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.primaryRed, size: 40),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.greyText),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => provider.loadTables(widget.pitName),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case TableStatus.loaded:
        final query = _searchQuery.trim().toLowerCase();
        final tables = query.isEmpty
            ? provider.tables
            : provider.tables
                .where((t) => t.tblCode.toLowerCase().contains(query))
                .toList();

        if (tables.isEmpty) {
          return Center(
            child: Text(
              query.isEmpty
                  ? 'No tables found for this pit.'
                  : 'No tables match "$_searchQuery".',
              style: const TextStyle(color: AppColors.greyText),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryOrange,
          backgroundColor: AppColors.surfaceBlack,
          onRefresh: () => provider.loadTables(widget.pitName),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              mainAxisExtent: 150,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: tables.length,
            itemBuilder: (context, index) {
              final code = tables[index].tblCode;
              return _TableCard(
                code: code,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.guests,
                  arguments: code,
                ),
              );
            },
          ),
        );
    }
  }
}

class _TableCard extends StatelessWidget {
  final String code;
  final VoidCallback? onTap;

  const _TableCard({required this.code, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceBlack,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceBlackLight),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Lottie.asset(
              'assets/lottie/Table.json',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.tab_unselected,
                color: AppColors.primaryOrange,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

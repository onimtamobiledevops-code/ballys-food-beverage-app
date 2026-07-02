import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/steward_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class StewardScreen extends StatefulWidget {
  const StewardScreen({super.key});

  @override
  State<StewardScreen> createState() => _StewardScreenState();
}

class _StewardScreenState extends State<StewardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StewardProvider>().loadStewards();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<StewardProvider>().loadStewards(searchText: value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StewardProvider>();

    return AppScaffold(
      title: 'Steward',
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                hintText: 'Search steward...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(StewardProvider provider) {
    switch (provider.status) {
      case StewardStatus.idle:
      case StewardStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case StewardStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.primaryRed, size: 40),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.greyText),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => provider.loadStewards(
                  searchText: _searchController.text,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case StewardStatus.loaded:
        if (provider.stewards.isEmpty) {
          return const Center(
            child: Text(
              'No stewards found.',
              style: TextStyle(color: AppColors.greyText),
            ),
          );
        }
        return RefreshIndicator(
          color: AppColors.primaryOrange,
          backgroundColor: AppColors.surfaceBlack,
          onRefresh: () => provider.loadStewards(
            searchText: _searchController.text,
          ),
          child: ListView.separated(
            itemCount: provider.stewards.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final steward = provider.stewards[index];
              return Card(
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
                    child: Text(
                      steward.stwName.isNotEmpty
                          ? steward.stwName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    steward.stwName,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Code: ${steward.stwCode}',
                    style: const TextStyle(color: AppColors.greyText),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: steward.isActive
                          ? Colors.green.withOpacity(0.15)
                          : AppColors.surfaceBlackLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      steward.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: steward.isActive
                            ? Colors.greenAccent
                            : AppColors.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}
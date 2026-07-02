import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pit_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class PitsScreen extends StatefulWidget {
  const PitsScreen({super.key});

  @override
  State<PitsScreen> createState() => _PitsScreenState();
}

class _PitsScreenState extends State<PitsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PitProvider>();
      if (provider.status == PitStatus.idle) {
        provider.loadPits();
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
    final provider = context.watch<PitProvider>();

    return AppScaffold(
      title: 'Pits',
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Search pit...',
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

  Widget _buildBody(PitProvider provider) {
    switch (provider.status) {
      case PitStatus.idle:
      case PitStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case PitStatus.error:
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
                onPressed: () => provider.loadPits(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case PitStatus.loaded:
        final query = _searchQuery.trim().toLowerCase();
        final pits = query.isEmpty
            ? provider.pits
            : provider.pits
                .where((p) => p.pitName.toLowerCase().contains(query))
                .toList();

        if (pits.isEmpty) {
          return const Center(
            child: Text(
              'No pits found.',
              style: TextStyle(color: AppColors.greyText),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryOrange,
          backgroundColor: AppColors.surfaceBlack,
          onRefresh: () => provider.loadPits(),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180,
              mainAxisExtent: 104,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: pits.length,
            itemBuilder: (context, index) {
              final pit = pits[index];
              return _PitCard(name: pit.pitName);
            },
          ),
        );
    }
  }
}

class _PitCard extends StatelessWidget {
  final String name;

  const _PitCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(Icons.table_bar,
                color: AppColors.primaryOrange, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            name,
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
    );
  }
}

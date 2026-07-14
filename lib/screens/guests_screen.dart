import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/guest.dart';
import '../providers/guest_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_scaffold.dart';

class GuestsScreen extends StatefulWidget {
  final String tblCode;

  const GuestsScreen({super.key, required this.tblCode});

  @override
  State<GuestsScreen> createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuestProvider>().loadGuests(widget.tblCode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GuestProvider>();

    return AppScaffold(
      title: 'Table ${widget.tblCode}',
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
                hintText: 'Search guest name or ID...',
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

  Widget _buildBody(GuestProvider provider) {
    switch (provider.status) {
      case GuestStatus.idle:
      case GuestStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primaryOrange),
        );

      case GuestStatus.error:
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
                onPressed: () => provider.loadGuests(widget.tblCode),
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case GuestStatus.loaded:
        final query = _searchQuery.trim().toLowerCase();
        final guests = query.isEmpty
            ? provider.guests
            : provider.guests
                .where((g) =>
                    g.mName.toLowerCase().contains(query) ||
                    g.mid.toLowerCase().contains(query))
                .toList();

        if (guests.isEmpty) {
          return Center(
            child: Text(
              query.isEmpty
                  ? 'No guests at this table.'
                  : 'No guests match "$_searchQuery".',
              style: const TextStyle(color: AppColors.greyText),
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryOrange,
          backgroundColor: AppColors.surfaceBlack,
          onRefresh: () => provider.loadGuests(widget.tblCode),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: guests.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) => _GuestCard(guest: guests[index]),
          ),
        );
    }
  }
}

class _GuestCard extends StatelessWidget {
  final Guest guest;

  const _GuestCard({required this.guest});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceBlackLight),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _GuestAvatar(guest: guest),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guest.mName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  guest.mid,
                  style: const TextStyle(
                    color: AppColors.greyText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestAvatar extends StatelessWidget {
  final Guest guest;

  const _GuestAvatar({required this.guest});

  @override
  Widget build(BuildContext context) {
    const double size = 56;

    final image = guest.image;
    if (image == null) return _fallback();

    return GestureDetector(
      onTap: () => _showFullImage(context, image),
      child: Hero(
        tag: 'guest-avatar-${guest.mid}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            image,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _fallback(),
          ),
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, Uint8List image) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (dialogContext) => GestureDetector(
        onTap: () => Navigator.of(dialogContext).pop(),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Hero(
                  tag: 'guest-avatar-${guest.mid}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InteractiveViewer(
                      maxScale: 4,
                      child: Image.memory(
                        image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _fallback(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                guest.mName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                guest.mid,
                style: const TextStyle(
                  color: AppColors.greyText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallback() {
    final initial = guest.mName.isNotEmpty ? guest.mName[0].toUpperCase() : '?';
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.primaryOrange,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }
}

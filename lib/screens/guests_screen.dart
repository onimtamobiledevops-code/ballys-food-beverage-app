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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GuestProvider>().loadGuests(widget.tblCode);
    });
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
        child: _buildBody(provider),
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
        final guests = provider.guests;
        if (guests.isEmpty) {
          return const Center(
            child: Text(
              'No guests at this table.',
              style: TextStyle(color: AppColors.greyText),
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

    if (guest.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          guest.image!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallback(),
        ),
      );
    }
    return _fallback();
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

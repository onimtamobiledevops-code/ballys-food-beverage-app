import 'package:flutter/material.dart';

import '../../models/order_item.dart';
import '../../theme/app_theme.dart';

/// "Orders" tab - shows a list of past orders.
class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: mockOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = mockOrders[index];
        final bool isDelivered = order.status == 'Delivered';

        return Container(
          padding: const EdgeInsets.all(16),
          // decoration: BoxDecoration(
          //   color: AppColors.surfaceBlack,
          //   borderRadius: BorderRadius.circular(14),
          // ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       order.id,
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 14,
              //       ),
              //     ),
              //     Container(
              //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              //       decoration: BoxDecoration(
              //         color: isDelivered
              //             ? AppColors.primaryOrange.withOpacity(0.15)
              //             : AppColors.primaryRed.withOpacity(0.15),
              //         borderRadius: BorderRadius.circular(20),
              //       ),
              //       child: Text(
              //         order.status,
              //         style: TextStyle(
              //           color: isDelivered ? AppColors.primaryOrange : AppColors.primaryRed,
              //           fontSize: 11,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            //  const SizedBox(height: 8),
              // Text(
              //   order.title,
              //   style: const TextStyle(color: Colors.white, fontSize: 14),
              // ),
              // const SizedBox(height: 6),
              // Text(
              //   order.date,
              //   style: const TextStyle(color: AppColors.greyText, fontSize: 12),
              // ),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Total: ${order.total}',
              //       style: const TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 13,
              //       ),
              //     ),
              //     TextButton(
              //       onPressed: () {},
              //       child: const Text('Reorder'),
              //     ),
              //   ],
        //       // ),
        //     ],
        //   ),
        );
      },
    );
  }
}

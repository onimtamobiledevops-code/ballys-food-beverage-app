// import 'package:ballysfoodbeverage/models/user_model.dart';
// import 'package:flutter/material.dart';
// import '../theme/app_theme.dart';

// /// Place this file at: lib/widgets/user_profile_card.dart
// ///
// /// A wide member-profile card that displays the logged-in user's
// /// avatar, name, member-ID (docNo), security level (shown as a star
// /// rating out of 5), and device ID.
// ///
// /// Usage:
// ///   UserProfileCard(user: currentUser)
// class UserProfileCard extends StatelessWidget {
//   final UserModel user;

//   const UserProfileCard({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: AppColors.surfaceBlack,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.06),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.35),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // ── Avatar ────────────────────────────────────────────
//           _MemberAvatar(name: user.name),
//           const SizedBox(width: 14),

//           // ── Name + rating + IDs ────────────────────────────────
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Name
//                 Text(
//                   user.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: 0.2,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 5),

//                 // Star rating (secLevel out of 5)
//                 _StarRating(level: user.secLevel),
//                 const SizedBox(height: 6),

//                 // Member-ID row
//                 _InfoChip(
//                   icon: Icons.badge_outlined,
//                   label: 'ID: ${user.docNo}',
//                 ),
//                 const SizedBox(height: 4),

//                 // Device-ID row
//                 _InfoChip(
//                   icon: Icons.devices_outlined,
//                   label: 'Device: ${user.deviceId}',
//                 ),
//               ],
//             ),
//           ),

//           // ── "MEMBER" badge ────────────────────────────────────
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               gradient: AppColors.primaryGradient,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Text(
//               'MEMBER',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 10,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Sub-widgets ──────────────────────────────────────────────────────

// class _MemberAvatar extends StatelessWidget {
//   final String name;
//   const _MemberAvatar({required this.name});

//   String get _initials {
//     final parts = name.trim().split(' ');
//     if (parts.length >= 2) {
//       return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
//     }
//     return name.isNotEmpty ? name[0].toUpperCase() : '?';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 56,
//       height: 56,
//       decoration: BoxDecoration(
//         gradient: AppColors.primaryGradient,
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primaryOrange.withOpacity(0.35),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           _initials,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _StarRating extends StatelessWidget {
//   final int level; // 0–5 mapped to filled stars
//   const _StarRating({required this.level});

//   @override
//   Widget build(BuildContext context) {
//     final clamped = level.clamp(0, 5);
//     return Row(
//       children: List.generate(5, (i) {
//         return Icon(
//           i < clamped ? Icons.star_rounded : Icons.star_outline_rounded,
//           size: 15,
//           color: i < clamped ? AppColors.primaryOrange : AppColors.greyText,
//         );
//       }),
//     );
//   }
// }

// class _InfoChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   const _InfoChip({required this.icon, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 13, color: AppColors.greyText),
//         const SizedBox(width: 4),
//         Flexible(
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.greyText,
//               fontSize: 11,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }



//   // --- 3-Day Communication Window ---

// Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1E140C), // Dark brown/orange tint
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(
//                   color: AppColors.sceOnboardingGold.withValues(alpha: 0.3),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.access_time,
//                         color: AppColors.sceOnboardingGold,
//                         size: 24.sp,
//                       ),
//                       SizedBox(width: 12.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '3-Day Communication Window',
//                               style: FontManager.bodyMedium(
//                                 color: AppColors.white,
//                               ).copyWith(fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 4.h),
//                             Text(
//                               'Contact each other to arrange payment & delivery',
//                               style: FontManager.bodySmall(
//                                 color: AppColors.sceGreyA0,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 12.h),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF2A1B0D),
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Column(
//                       children: [
//                         Text(
//                           '3d 0h remaining',
//                           style: FontManager.heading3(
//                             color: AppColors.sceOnboardingGold,
//                           ),
//                         ),
//                         SizedBox(height: 4.h),
//                         Text(
//                           'Expires on 3/13/2026',
//                           style: FontManager.bodySmall(
//                             color: AppColors.sceGreyA0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             AppSpacing.h32,
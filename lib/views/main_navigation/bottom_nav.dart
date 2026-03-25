import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/core/constants/global_state.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auctions/presentations/add_auction_view.dart';

/// The app-wide scaffold with custom bottom navigation.
///
/// If [isPremiumUser] is provided, it overrides the value in [GlobalState].
class MainNavigationShell extends StatefulWidget {
  /// The four page bodies corresponding to: Home, Auctions, Bids, Profile.
  final List<Widget> pages;

  /// Whether the signed-in user has a Premium subscription.
  final bool? isPremiumUser;

  final int initialIndex;

  const MainNavigationShell({
    super.key,
    required this.pages,
    this.isPremiumUser,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Map raw tab indices (skipping the centre FAB slot) to page indices.
  // Raw order: 0=Home, 1=Auctions, [fab], 2=Bids, 3=Profile
  static const _tabToPage = {0: 0, 1: 1, 3: 2, 4: 3};
  static const _pageToTab = {0: 0, 1: 1, 2: 3, 3: 4};

  void _onTabTap(int rawIndex) {
    // Ignore taps on the centre slot (handled by the FAB)
    if (rawIndex == 2) return;
    final pageIndex = _tabToPage[rawIndex];
    if (pageIndex != null) setState(() => _currentIndex = pageIndex);
  }

  void _onPremiumFabTap() {
    final isPremium = widget.isPremiumUser ?? context.read<GlobalState>().isPremium;
    if (isPremium) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddAuctionView()),
      );
    } else {
      AppSnackBar.warning(
        context,
        'This feature is for Premium members only.',
        actionLabel: 'Upgrade',
        onAction: () {
          // TODO: navigate to subscription page
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = _pageToTab[_currentIndex] ?? 0;
    final isPremium = widget.isPremiumUser ?? context.watch<GlobalState>().isPremium;

    return SafeArea(
      child: Scaffold(
        extendBody: true,
        // backgroundColor: const Color(0xFF0A0A0A),
        body: IndexedStack(index: _currentIndex, children: widget.pages),
        floatingActionButton: _PremiumFab(
          isPremium: isPremium,
          onTap: _onPremiumFabTap,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _BottomNavBar(
          activeIndex: activeTab,
          onTabTap: _onTabTap,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Internal bar widget
// ---------------------------------------------------------------------------

class _BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabTap;

  const _BottomNavBar({required this.activeIndex, required this.onTabTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomAppBar(
          color: const Color(0xFF111827),
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.none,
          child: SizedBox(
            height: 20.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  index: 0,
                  activeIndex: activeIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  onTap: onTabTap,
                ),
                _NavItem(
                  index: 1,
                  activeIndex: activeIndex,
                  icon: Icons.gavel_outlined,
                  activeIcon: Icons.gavel_rounded,
                  label: 'Auctions',
                  onTap: onTabTap,
                ),
                // Centre spacer for the FAB cutout
                SizedBox(width: 48.w),
                _NavItem(
                  index: 3,
                  activeIndex: activeIndex,
                  icon: Icons.card_giftcard_outlined,
                  activeIcon: Icons.card_giftcard_rounded,
                  label: 'Bids',
                  onTap: onTabTap,
                ),
                _NavItem(
                  index: 4,
                  activeIndex: activeIndex,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  onTap: onTabTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Individual nav item
// ---------------------------------------------------------------------------

class _NavItem extends StatelessWidget {
  final int index;
  final int activeIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.index,
    required this.activeIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == activeIndex;
    const teal = Color(0xFF00D5BE);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive ? teal : const Color(0xFF6B7280),
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isActive ? teal : const Color(0xFF6B7280),
                fontSize: 11.sp,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  Centre Premium FAB
// ---------------------------------------------------------------------------

class _PremiumFab extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onTap;

  const _PremiumFab({required this.isPremium, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00D5BE);
    final iconColor = isPremium ? teal : const Color(0xFF6B7280);
    final ringColor = isPremium ? teal : const Color(0xFF374151);

    return FloatingActionButton(
      onPressed: onTap,
      elevation: 0,
      backgroundColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightElevation: 0,
      shape: const CircleBorder(),
      child: Container(
        width: 58.w,
        height: 58.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: ringColor, width: 1.8),
          boxShadow: isPremium
              ? [
                  BoxShadow(
                    color: teal.withOpacity(0.35),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: iconColor,
              size: 30.sp,
            ),
            if (!isPremium)
              Positioned(
                bottom: 6.h,
                right: 6.w,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A0A0A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: const Color(0xFF6B7280),
                    size: 9.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

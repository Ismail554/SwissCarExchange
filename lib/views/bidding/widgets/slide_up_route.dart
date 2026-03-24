import 'package:flutter/material.dart';

/// Slides [child] in from the bottom of the screen.
/// Used to open the full-screen transactions list from the analytics view.
class SlideUpRoute extends PageRoute<void> {
  final Widget child;

  SlideUpRoute({required this.child});

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(curve),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app_utils/utils/app_colors.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/controllers/profile_provider.dart';
import 'package:rionydo/core/widgets/common_background.dart';
import 'package:rionydo/core/widgets/widget_snackbar.dart';
import 'package:rionydo/views/auth/login/login_views.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/presentations/profile_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  final String checkoutUrl;
  const CheckoutWebView({super.key, required this.checkoutUrl});

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            // Stripe redirects back to a success URL after checkout.
            final url = request.url.toLowerCase();
            if (url.contains('success') || url.contains('checkout/complete')) {
              _onCheckoutSuccess();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  /// Checkout completed → hit profile API to verify active subscription,
  /// then directly navigate to the main navigation shell (home).
  Future<void> _onCheckoutSuccess() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider = context.read<UserProfileProvider>();
      final globalState = context.read<GlobalState>();

      // Fetch the updated profile from ApiService.userProfile
      await profileProvider.fetchProfile(globalState: globalState);

      if (!mounted) return;

      final profile = profileProvider.userProfile;
      if (profile != null && profile.subscription.hasSubscription) {
        AppSnackBar.success(context, 'Subscription activated successfully!');
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainNavigationShell(
              pages: [HomeView(), AuctionsView(), BidsView(), ProfileView()],
            ),
          ),
          (route) => false,
        );
      } else {
        // Fallback: If subscription is not active or profile is null, show warning and redirect to Login
        AppSnackBar.warning(context, 'Subscription not detected yet. Please login to verify.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginViews()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Checkout Success Processing Error: $e');
      if (mounted) {
        AppSnackBar.error(context, 'Error processing checkout. Please login again.');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginViews()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Top bar with back button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Checkout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const LinearProgressIndicator(
                color: AppColors.sceTeal,
                backgroundColor: AppColors.darkGrey,
              ),
            Expanded(
              child: WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}

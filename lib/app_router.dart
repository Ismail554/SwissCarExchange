import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rionydo/models/auctions/my_auctions_response.dart';
import 'package:rionydo/models/auctions/auctions_detail_response.dart';
import 'package:rionydo/views/auctions/presentations/auction_bidding.dart';
import 'package:rionydo/views/auctions/presentations/recent_all_bids_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/checkout_webview.dart';
import 'package:rionydo/views/profile/presentations/my_bids_view.dart';
import 'package:rionydo/views/splash/splash_screen.dart';
import 'package:rionydo/views/auth/onboarding/views/step1_onboarding.dart';
import 'package:rionydo/views/auth/onboarding/views/step2_onborading.dart';
import 'package:rionydo/views/auth/onboarding/views/step3_onboarding.dart';
import 'package:rionydo/views/auth/login/login_views.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_view.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_step2.dart';
import 'package:rionydo/views/auth/sign_up/presentations/sign_up_step3.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/before_subs_view.dart';
import 'package:rionydo/views/auth/sign_up/verify_sign_up/presentations/pending_view.dart';
import 'package:rionydo/views/auth/forgot_password/forgot_pass_view.dart';
import 'package:rionydo/views/auth/forgot_password/otp_verify_view.dart';
import 'package:rionydo/views/auth/forgot_password/reset_password_view.dart';
import 'package:rionydo/views/auth/forgot_password/successful_view.dart';
import 'package:rionydo/views/main_navigation/bottom_nav.dart';
import 'package:rionydo/views/home/presentation/home_view.dart';
import 'package:rionydo/views/auctions/presentations/auctions_view.dart';
import 'package:rionydo/views/bidding/presentations/bids_view.dart';
import 'package:rionydo/views/profile/presentations/profile_view.dart';
import 'package:rionydo/views/auctions/presentations/auction_details.dart';
import 'package:rionydo/views/bidding/presentations/online_payment.dart';
import 'package:rionydo/views/bidding/presentations/offline_payment.dart';
import 'package:rionydo/views/bidding/presentations/pay_successful.dart';
import 'package:rionydo/views/won_auction/presentations/auction_contact_view.dart';
import 'package:rionydo/views/won_auction/presentations/rate_dealer_view.dart';
import 'package:rionydo/views/profile/presentations/transaction_completed_view.dart';
import 'package:rionydo/views/payment/presentations/payment_process_view.dart';
import 'package:rionydo/views/profile/presentations/payment_method_view.dart';
import 'package:rionydo/views/profile/widgets/dealer_rating_card.dart';
import 'package:rionydo/views/premium/presentations/create_auction_view.dart';
import 'package:rionydo/views/premium/presentations/auction_management_view.dart';
import 'package:rionydo/views/premium/presentations/update_subscription_view.dart';
import 'package:rionydo/views/settings/presentations/account_settings_view.dart';
import 'package:rionydo/views/settings/presentations/manage_subscription_view.dart';
import 'package:rionydo/views/settings/presentations/privacy_settings_view.dart';
import 'package:rionydo/views/settings/presentations/help_support_view.dart';
import 'package:rionydo/views/settings/presentations/chat_support_view.dart';
import 'package:rionydo/views/won_auction/presentations/review_submitted_view.dart';
import 'package:rionydo/views/notification/notification_view.dart';
import 'package:rionydo/views/profile/presentations/notification_settings_view.dart';
import 'package:rionydo/views/auctions/presentations/my_wishlist_view.dart';
import 'package:rionydo/views/premium/presentations/dealer_reviews_view.dart';
import 'package:rionydo/views/premium/presentations/advance_statistics.dart';
import 'package:rionydo/views/premium/presentations/recieve_payments_view.dart';
import 'package:rionydo/views/profile/presentations/my_shipping_request_view.dart';
import 'package:rionydo/views/won_auction/presentations/won_auction_home.dart';


// ---------------------------------------------------------------------------
// Navigator Keys
// ---------------------------------------------------------------------------

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _shellAuctionsKey =
    GlobalKey<NavigatorState>(debugLabel: 'auctions');
final GlobalKey<NavigatorState> _shellBidsKey =
    GlobalKey<NavigatorState>(debugLabel: 'bids');
final GlobalKey<NavigatorState> _shellProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'profile');

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ------------------------------------------------------------------
    // Splash
    // ------------------------------------------------------------------
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // ------------------------------------------------------------------
    // Onboarding
    // ------------------------------------------------------------------
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const Step1Onboarding(),
      routes: [
        GoRoute(
          path: 'step2',
          builder: (context, state) => const Step2Onboarding(),
        ),
        GoRoute(
          path: 'step3',
          builder: (context, state) => const Step3Onboarding(),
        ),
      ],
    ),

    // ------------------------------------------------------------------
    // Auth
    // ------------------------------------------------------------------
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginViews(),
    ),
    GoRoute(
      path: '/pending',
      builder: (context, state) => const PendingView(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpView(),
      routes: [
        GoRoute(
          path: 'step2',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return SignUpStep2(
              email: extra['email'] as String,
              password: extra['password'] as String,
              phone: extra['phone'] as String,
            );
          },
          routes: [
            GoRoute(
              path: 'step3',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
                return SignUpStep3(
                  email: extra['email'] as String,
                  password: extra['password'] as String,
                  phone: extra['phone'] as String,
                  role: extra['role'], // UserRole
                  address: extra['address'] as String,
                  fullName: extra['fullName'] as String? ?? '',
                  idDocumentFile: extra['idDocumentFile'], // File?
                  company: extra['company'] as String? ?? '',
                  uid: extra['uid'] as String? ?? '',
                );
              },
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OtpVerifyView(
          email: extra['email'] as String,
          isForgotPassword: extra['isForgotPassword'] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/subscription',
      builder: (context, state) => const SubscriptionView(),
    ),
    GoRoute(
      path: '/before-subscription',
      builder: (context, state) => const BeforeSubsView(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CheckoutWebView(
          checkoutUrl: extra?['checkoutUrl'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPassView(),
      routes: [
        GoRoute(
          path: 'reset',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ResetPasswordView(
              email: extra['email'] as String,
              resetToken: extra['resetToken'] as String,
            );
          },
        ),
        GoRoute(
          path: 'success',
          builder: (context, state) {
            final approvalStatus =
                state.extra as String? ?? 'approved';
            return SuccessfulView(approvalStatus: approvalStatus);
          },
        ),
      ],
    ),

    // ------------------------------------------------------------------
    // Main Shell (bottom nav tabs)
    // ------------------------------------------------------------------
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellAuctionsKey,
          routes: [
            GoRoute(
              path: '/auctions',
              builder: (context, state) => const AuctionsView(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellBidsKey,
          routes: [
            GoRoute(
              path: '/bids',
              builder: (context, state) => const BidsView(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),

    // ------------------------------------------------------------------
    // Auction Detail & Bidding (push on top of shell)
    // ------------------------------------------------------------------
    GoRoute(
      path: '/auction-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final item = (state.extra is Map)
            ? AuctionItem.fromJson(Map<String, dynamic>.from(state.extra as Map))
            : state.extra as AuctionItem;
        return AuctionDetails(data: item);
      },
    ),
    GoRoute(
      path: '/auction-bidding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        if (state.extra is Map) {
          final extraMap = state.extra as Map;
          if (extraMap.containsKey('initialData')) {
            final initialData = extraMap['initialData'] is Map
                ? AuctionItem.fromJson(Map<String, dynamic>.from(extraMap['initialData'] as Map))
                : extraMap['initialData'] as AuctionItem;
            
            final detailData = extraMap.containsKey('detailData') && extraMap['detailData'] != null
                ? (extraMap['detailData'] is Map 
                    ? AuctionDetailResponse.fromJson(Map<String, dynamic>.from(extraMap['detailData'] as Map)) 
                    : extraMap['detailData'] as AuctionDetailResponse)
                : null;
                
            return AuctionBidding(initialData: initialData, detailData: detailData);
          } else {
            final item = AuctionItem.fromJson(Map<String, dynamic>.from(extraMap));
            return AuctionBidding(initialData: item);
          }
        }
        
        final item = state.extra as AuctionItem;
        return AuctionBidding(initialData: item);
      },
    ),
    GoRoute(
      path: '/all-bids/:auctionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final auctionId = state.pathParameters['auctionId']!;
        return RecentAllBidsView(auctionId: auctionId);
      },
    ),

    // ------------------------------------------------------------------
    // Car Details
    // ------------------------------------------------------------------
    GoRoute(
      path: '/car-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final item = (state.extra is Map)
            ? AuctionItem.fromJson(Map<String, dynamic>.from(state.extra as Map))
            : state.extra as AuctionItem;
        return AuctionDetails(data: item);
      },
    ),

    // ------------------------------------------------------------------
    // Won Auction
    // ------------------------------------------------------------------
    GoRoute(
      path: '/auction-contact/:auctionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final auctionId = state.pathParameters['auctionId']!;
        return AuctionContactView(auctionId: auctionId);
      },
    ),
    GoRoute(
      path: '/rate-dealer/:auctionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final auctionId = state.pathParameters['auctionId']!;
        return RateDealerView(auctionId: auctionId);
      },
    ),
    GoRoute(
      path: '/review-submitted',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReviewSubmittedView(),
    ),

    // ------------------------------------------------------------------
    // Payment
    // ------------------------------------------------------------------
    GoRoute(
      path: '/payment/:auctionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final auctionId = state.pathParameters['auctionId']!;
        final initialStep = state.extra as int? ?? 0;
        return PaymentProcessView(auctionId: auctionId, initialStep: initialStep);
      },
    ),
    GoRoute(
      path: '/online-payment',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OnlinePaymentView(
          carName: extra['carName'] as String,
          amount: extra['amount'] as String,
        );
      },
    ),
    GoRoute(
      path: '/offline-payment',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return OfflinePaymentView(
          carName: extra['carName'] as String,
          amount: extra['amount'] as String,
        );
      },
    ),
    GoRoute(
      path: '/pay-successful',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaySuccessful(
          nextRoute: extra?['nextRoute'] as String?,
        );
      },
    ),

    // ------------------------------------------------------------------
    // Profile sub-screens
    // ------------------------------------------------------------------
    GoRoute(
      path: '/my-bids',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MyBidsView(),
    ),
    GoRoute(
      path: '/payment-method',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PaymentMethodView(),
    ),
    GoRoute(
      path: '/transaction-completed/:auctionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final auctionId = state.pathParameters['auctionId']!;
        return TransactionCompletedView(auctionId: auctionId);
      },
    ),
    GoRoute(
      path: '/dealer-rating/:dealerId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return const DealerRatingCard();
      },
    ),

    // ------------------------------------------------------------------
    // Premium
    // ------------------------------------------------------------------
    GoRoute(
      path: '/create-auction',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateAuction(),
    ),
    GoRoute(
      path: '/auction-management',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuctionManagement(),
    ),
    GoRoute(
      path: '/update-subscription',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionViews(),
    ),

    // ------------------------------------------------------------------
    // Settings
    // ------------------------------------------------------------------
    GoRoute(
      path: '/account-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccountSettingsView(),
    ),
    GoRoute(
      path: '/notification-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationSettingsView(),
    ),
    GoRoute(
      path: '/manage-subscription',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AccountSubscriptionView(),
    ),
    GoRoute(
      path: '/privacy-settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrivacySettingsView(),
    ),
    GoRoute(
      path: '/help-support',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpSupportView(),
    ),
    GoRoute(
      path: '/chat-support',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChatSupportView(),
    ),

    // ------------------------------------------------------------------
    // Notification & Search
    // ------------------------------------------------------------------
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationView(),
    ),
    // GoRoute(
    //   path: '/search',
    //   parentNavigatorKey: _rootNavigatorKey,
    //   builder: (context, state) => const SearchView(),
    // ),
    GoRoute(
      path: '/wishlist',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MyWishlistView(),
    ),
    GoRoute(
      path: '/won-auctions',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const WonAuctionHome(),
    ),
    GoRoute(
      path: '/shipping-requests',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const MyShippingRequestView(),
    ),
    GoRoute(
      path: '/advanced-statistics',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AdvanceStatistics(),
    ),
    GoRoute(
      path: '/receive-payments',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecievePayments(),
    ),
    GoRoute(
      path: '/dealer-reviews',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DealerReviewsView(),
    ),
  ],
);

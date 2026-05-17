import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rionydo/app.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/controllers/auctions/auctions_detail_provider.dart';
import 'package:rionydo/controllers/auctions/create_auctions_provider.dart';
import 'package:rionydo/controllers/auctions/my_auctions_provider.dart';import 'package:rionydo/controllers/auctions/auction_management_provider.dart';
import 'package:rionydo/controllers/auctions/won_auction_provider.dart';
import 'package:rionydo/controllers/auctions/my_bids_provider.dart';
import 'package:rionydo/controllers/auctions/dealer_contact_provider.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/controllers/auth/register_provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/controllers/profile_provider.dart';
import 'package:rionydo/controllers/subscription_provider.dart';
import 'package:rionydo/controllers/premium_analytics_provider.dart';
import 'package:rionydo/controllers/dealer_reviews_provider.dart';
import 'package:rionydo/controllers/advance_statistics_provider.dart';
import 'package:rionydo/controllers/bank_account_provider.dart';
import 'package:rionydo/controllers/home_stats_provider.dart';
import 'package:rionydo/controllers/payment_process_provider.dart';
import 'package:rionydo/controllers/rate_dealer_provider.dart';
import 'package:rionydo/controllers/profile/my_shipping_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: ".env");
  DioManager.init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final globalState = GlobalState();
  await globalState.rehydrate();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: globalState),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => CreateAuctionProvider()),
        ChangeNotifierProvider(create: (_) => MyAuctionsProvider()),
        ChangeNotifierProvider(create: (_) => AuctionManagementProvider()),
        ChangeNotifierProvider(create: (_) => AuctionsDetailProvider()),
        ChangeNotifierProvider(create: (_) => PremiumAnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => DealerReviewsProvider()),
        ChangeNotifierProvider(create: (_) => AdvanceStatisticsProvider()),
        ChangeNotifierProvider(create: (_) => BankAccountProvider()),
        ChangeNotifierProvider(create: (_) => WonAuctionProvider()),
        ChangeNotifierProvider(create: (_) => MyBidsProvider()),
        ChangeNotifierProvider(create: (_) => DealerContactProvider()),
        ChangeNotifierProvider(create: (_) => HomeStatsProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProcessProvider()),
        ChangeNotifierProvider(create: (_) => RateDealerProvider()),
        ChangeNotifierProvider(create: (_) => MyShippingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

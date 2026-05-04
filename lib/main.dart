import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rionydo/app.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/controllers/auctions/create_auctions_provider.dart';
import 'package:rionydo/controllers/auctions/my_auctions_provider.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/controllers/auth/register_provider.dart';
import 'package:rionydo/app_utils/network/dio_manager.dart';
import 'package:rionydo/controllers/profile_provider.dart';
import 'package:rionydo/controllers/subscription_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  DioManager.init();

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
      ],
      child: const MyApp(),
    ),
  );
}

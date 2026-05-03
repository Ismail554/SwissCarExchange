import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';
import 'package:rionydo/controllers/auth/auth_provider.dart';
import 'package:rionydo/controllers/auth/register_provider.dart';
import 'package:rionydo/controllers/profile_provider.dart';
import 'package:rionydo/controllers/subscription_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalState()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

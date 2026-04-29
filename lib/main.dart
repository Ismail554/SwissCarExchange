import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rionydo/app.dart';
import 'package:rionydo/app_utils/constants/global_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GlobalState(),
      child: const MyApp(),
    ),
  );
}

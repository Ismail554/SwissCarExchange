import 'package:flutter/material.dart';
import 'package:wynante/core/widgets/common_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Container(child: const Center(child: Text('Home')));
  }
}

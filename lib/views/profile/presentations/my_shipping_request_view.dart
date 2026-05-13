import 'package:flutter/material.dart';
import 'package:rionydo/core/widgets/common_background.dart';

class MyShippingRequestView extends StatelessWidget {
  const MyShippingRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonBackground(appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text("My Shipping Request", style: TextStyle(color: Colors.white)),
    ), child: Column(
      children: [
        Text("My Shipping Request")
      ],
    ));
  }
}
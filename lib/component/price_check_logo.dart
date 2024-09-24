import 'package:flutter/material.dart';

class PriceCheckLogo extends StatelessWidget {
  const PriceCheckLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double h5 = screenHeight / 224.4;

    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image(
            height: h5 * 50,
            image: const AssetImage("assets/images/barcode.png"),
          ),
        ),
      ),
    );
  }
}

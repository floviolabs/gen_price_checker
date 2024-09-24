import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double h5 = screenHeight / 224.4;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        alignment: Alignment.center,
        child: Image(
          height: h5 * 30,
          image: const AssetImage("assets/images/aeon-white.png"),
        ),
      ),
    );
  }
}

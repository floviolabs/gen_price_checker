import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaitingConfigurationPage extends StatefulWidget {
  const WaitingConfigurationPage({super.key});

  @override
  State<WaitingConfigurationPage> createState() =>
      _WaitingConfigurationPageState();
}

class _WaitingConfigurationPageState extends State<WaitingConfigurationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 2))
        ..repeat();
  final barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double h2 = screenHeight / 561;
    // double h3 = screenHeight / 374;
    double h5 = screenHeight / 224.4;
    // double h7 = screenHeight / 160.3;

    //Width
    // double w2 = screenWidth / 270;
    // double w3 = screenWidth / 180;
    // double w5 = screenWidth / 108;
    // double w7 = screenWidth / 77.143;

    // double rad5 = h5;
    // double rad10 = h5 * 2;
    // double rad20 = h5 * 4;
    // double rad25 = h5 * 5;

    //Font & Icon
    // double font12 = h2 * 6;
    // double font14 = h2 * 7;
    double font16 = h2 * 8;
    // double font18 = h2 * 9;
    double font20 = h2 * 10;
    // double font24 = h2 * 12;
    // double font30 = h2 * 15;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 173, 33, 129),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      alignment: Alignment.center,
                      child: Image(
                        height: h5 * 30,
                        image: const AssetImage("assets/images/aeon-white.png"),
                      ),
                    ),
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 1 * math.pi,
                          child: child,
                        );
                      },
                      child: Image(
                        height: h5 * 60,
                        image: const AssetImage("assets/images/arrow.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: h2,
                  )
                ],
              ),
            )));
  }
}

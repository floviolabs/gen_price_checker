import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/routes/route_helper.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

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

  String? storedDeviceId = '';
  String? storedStore = '';
  String? storedStoreName = '';
  String? storedUrl = '';
  String? storedType = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double h2 = screenHeight / 561;
    double h5 = screenHeight / 224.4;

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
                  ElevatedButton(
                    onPressed: () => Get.offNamed(Routes.getDashboardPage()),
                    child: Text('Reload'),
                  ),
                  SizedBox(
                    height: h2,
                  )
                ],
              ),
            )));
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/routes/route_helper.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  final barcodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.toNamed(Routes.getDashboardPage());
    });
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
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image(
                          height: h5 * 50,
                          image:
                              const AssetImage("assets/images/exclamation.png"),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Produk tidak ditemukan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font20 * 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Product not found',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font20 * 2,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '商品が見つかりません',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font20 * 2,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mohon hubungi staff yang bertugas',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font16 * 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Please contact the staff on duty',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font16 * 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '常駐スタッフまでお問い合わせください',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: font16 * 1.5,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: h2,
                  )
                ],
              ),
            )));
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gen_price_checker/routes/route_helper.dart';

// ignore: must_be_immutable
class FoundPage extends StatefulWidget {
  String id;
  FoundPage({super.key, required this.id});

  @override
  State<FoundPage> createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage> {
  final barcodeController = TextEditingController();

  late Map<String, dynamic> productData = {};

  @override
  void initState() {
    super.initState();
    _fetchProductData();
    Timer(const Duration(seconds: 4), () {
      Get.toNamed(Routes.getDashboardPage());
    });
  }

  Future<void> _fetchProductData() async {
    // await Future.delayed(const Duration(seconds: 1));
    print(widget.id);
    final url = Uri.parse(
        'https://pos.aeonindonesia.co.id/pos/price/product/7003/${widget.id}');
    // 'https://aeondb.server1601.weha-id.com/pos/price/product/7003/${widget.id}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          productData = jsonData['data'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

  // Future<void> _fetchProductData() async {
  //   final jsonData = {
  //     "err": false,
  //     "msg": "",
  //     "data": {
  //       "display_name": "IFREE PAD TERAPI HANGAT NYERI",
  //       "list_price": "Rp. 23.500",
  //       "image_url":
  //           "/weha_smart_pos_aeon_price_check/static/src/img/placeholder.png",
  //       "current_price": "Rp. 20.500",
  //       "is_diff": true,
  //       "diff": 3000,
  //       "promotion": [
  //         {
  //           "promotion_code": "P000517002",
  //           "promotion_description": "BUY 1 GET 1",
  //           "from_date": "2024-02-24",
  //           "to_date": "2024-06-30",
  //           "quantity": 2,
  //           "quantity_amt": 0,
  //           "fixed_price": 23500.0
  //         },
  //         {
  //           "promotion_code": "P000517002",
  //           "promotion_description": "BUY 1 GET 1",
  //           "from_date": "2024-02-24",
  //           "to_date": "2024-06-30",
  //           "quantity": 2,
  //           "quantity_amt": 0,
  //           "fixed_price": 23500.0
  //         }
  //       ]
  //     }
  //   };

  //   setState(() {
  //     productData = jsonData['data'] as Map<String, dynamic>;
  //   });
  // }

  String formatDateString(String input) {
    DateTime dateTime = DateTime.parse(input);
    DateFormat dateFormat = DateFormat("d MMM yyyy");
    return dateFormat.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
    // double font16 = h2 * 8;
    double font18 = h2 * 9;
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
              if (productData.isNotEmpty) ...[
                Column(children: [
                  if (productData['is_diff']) ...[
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Center(
                        child: Text(
                          '${productData['display_name']}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: font20 * 2,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: font18,
                    ),
                    Text(
                      '${productData['list_price']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: font20 * 2,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                        decorationThickness: 2,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: h5 * 10),
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'HARGA PROMO',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20 * 2,
                            ),
                          ),
                          Text(
                            '${productData['current_price']}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20 * 3,
                            ),
                          ),
                          Text(
                            'HEMAT ${productData['diff']}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20 * 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: Center(
                        child: Text(
                          '${productData['display_name']}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: font20 * 2,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: font18,
                    ),
                    Text(
                      '${productData['list_price']}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: font20 * 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  if (productData['promotion'] != null &&
                      productData['promotion'].isNotEmpty) ...[
                    Container(
                      margin: EdgeInsets.only(top: h5 * 5),
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'PROMO',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20 * 2,
                            ),
                          ),
                          Text(
                            '${productData['promotion'][0]['promotion_description']}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20 * 2,
                            ),
                          ),
                          Text(
                            '${formatDateString(productData['promotion'][0]['from_date'])} - ${formatDateString(productData['promotion'][0]['to_date'])}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: const Color.fromARGB(255, 173, 33, 129),
                              fontWeight: FontWeight.bold,
                              fontSize: font20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ]),
                const Text('')
              ],
            ],
          ),
        ),
      ),
    );
  }
}

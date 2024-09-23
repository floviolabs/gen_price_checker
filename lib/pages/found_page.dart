import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:price_checker/routes/route_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html/parser.dart' as html_parser;

// ignore: must_be_immutable
class FoundPage extends StatefulWidget {
  String id;
  FoundPage({super.key, required this.id});

  @override
  State<FoundPage> createState() => _FoundPageState();
}

class _FoundPageState extends State<FoundPage> {
  String? storedDeviceId = '';
  String? storedStore = '';
  String? storedStoreName = '';
  String? storedUrl = '';
  String? storedType = '';

  String itemDesc = '';
  String amountPrice = '';

  String promoPrice = '';
  String promoPriceSaved = '';
  String promoPriceUntil = '';

  String mMDesc1 = '';
  String mMPrice = '';
  String mMPriceSaved = '';
  String mMPriceUntil = '';

  final barcodeController = TextEditingController();

  late Map<String, dynamic> productData = {};

  @override
  void initState() {
    super.initState();
    _initializeData(); // Panggil metode asinkron di sini tanpa async/await

    // Timer untuk berpindah ke dashboard
    Timer(const Duration(seconds: 7), () {
      Get.toNamed(Routes.getDashboardPage());
    });
  }

  Future<void> _initializeData() async {
    super.initState();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedDeviceId = prefs.getString('device_id');
    storedStore = prefs.getString('store');
    storedStoreName = prefs.getString('store_name');
    storedUrl = prefs.getString('url');
    storedType = prefs.getString('type');

    storedType == 'seito' ? _fetchProductDataSeito() : _fetchProductDataOdoo();
    Timer(const Duration(seconds: 7), () {
      Get.toNamed(Routes.getDashboardPage());
    });
  }

  Future<void> _fetchProductDataOdoo() async {
    // await Future.delayed(const Duration(seconds: 1));
    final url = Uri.parse('$storedUrl${widget.id}');
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

  Future<void> _fetchProductDataSeito() async {
    final url = Uri.parse('$storedUrl${widget.id}' //MCT
        );
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var document = html_parser.parse(response.body);

        var itemDescElement = document.querySelector('#ItemDesc1');
        var amountPriceElement = document.querySelector('#UnitPrice');

        var promoPriceElement = document.querySelector('#PromoPrice');
        var promoPriceSavedElement = document.querySelector('#PromoPriceSaved');
        var promoPriceUntilElement = document.querySelector('#PromoPriceUntil');

        var mMDesc1Element = document.querySelector('#MMDesc1');
        var mMPriceElement = document.querySelector('#MMPrice');
        var mMPriceSavedElement = document.querySelector('#MMPriceSaved');
        var mMPriceUntilElement = document.querySelector('#MMPriceUntil');

        setState(() {
          itemDesc = itemDescElement?.text ?? '0';
          amountPrice = amountPriceElement?.text ?? '0';

          promoPrice = promoPriceElement?.text ?? '0';
          promoPriceSaved = promoPriceSavedElement?.text ?? '0';
          promoPriceUntil = promoPriceUntilElement?.text ?? '0';

          mMDesc1 = mMDesc1Element?.text ?? '0';
          mMPrice = mMPriceElement?.text ?? '0';
          mMPriceSaved = mMPriceSavedElement?.text ?? '0';
          mMPriceUntil = mMPriceUntilElement?.text ?? '0';
        });
      }
    } catch (e) {
      // print('Error fetching data: $e');
    }
  }

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
    double h5 = screenHeight / 224.4;

    double font18 = h2 * 9;
    double font20 = h2 * 10;

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
              Container(
                  child: storedType == 'seito'
                      ? (itemDesc.isNotEmpty)
                          ? Column(children: [
                              if (promoPrice != '0') ...[
                                SizedBox(
                                  width: screenWidth * 0.8,
                                  child: Center(
                                    child: Text(
                                      itemDesc,
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
                                  amountPrice,
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
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'HARGA PROMO',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        promoPrice,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 3,
                                        ),
                                      ),
                                      Text(
                                        'HEMAT $promoPriceSaved',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
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
                                      itemDesc,
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
                                  amountPrice,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: font20 * 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              if (mMDesc1 != '0' && mMDesc1.isNotEmpty) ...[
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
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        mMDesc1,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        'BERLAKU SAMPAI $mMPriceUntil',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ])
                          : const Text('')
                      : (productData.isNotEmpty)
                          ? Column(children: [
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
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        '${productData['current_price']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 3,
                                        ),
                                      ),
                                      Text(
                                        'HEMAT ${productData['diff']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
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
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        '${productData['promotion'][0]['promotion_description']}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20 * 2,
                                        ),
                                      ),
                                      Text(
                                        '${formatDateString(productData['promotion'][0]['from_date'])} - ${formatDateString(productData['promotion'][0]['to_date'])}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: const Color.fromARGB(
                                              255, 173, 33, 129),
                                          fontWeight: FontWeight.bold,
                                          fontSize: font20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            ])
                          : const Text('')),
              const Text('')
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:price_checker/component/check_the_price.dart';
import 'package:price_checker/component/logo.dart';
import 'package:price_checker/component/price_check_logo.dart';
import 'package:price_checker/component/scan_here.dart';
// import 'package:price_checker/utilities/scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:price_checker/routes/route_helper.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// SCANNER
// class MyReceiver {
//   final StreamController<String> _receiverController =
//       StreamController<String>.broadcast();

//   Stream<String> get receiverStream => _receiverController.stream;

//   void onReceive(String action, String data) {
//     _receiverController.add('$action: $data');
//   }

//   void dispose() {
//     _receiverController.close();
//   }
// }

// final MyReceiver receiver = MyReceiver();

// void onReceive(
//     BuildContext context, String action, Map<String, dynamic> intent) {
//   if (action == ScannerConstants.deviceConnection) {
//     _appendMessage(context, "\nUSB Connect");
//   } else if (action == ScannerConstants.deviceDisconnection) {
//     _appendMessage(context, "\nUSB Disconnect");
//   } else if (action == ScannerConstants.resultAction) {
//     String extraByteData = intent[ScannerConstants.extraDecodeData] ?? "";
//     String extraData = intent[ScannerConstants.extraDecodeDataStr] ?? "";
//     Uint8List? decodeData = base64Decode(extraByteData);
//     String strData = extraData;
//     _appendMessage(context, "\nBroadcast result: byte: $decodeData");
//     _appendMessage(context, "\nBroadcast result: string: $strData");
//     _incrementScanCount(context);
//   } else if (action == ScannerConstants.connectionBackAction) {
//     int type = intent[ScannerConstants.connectionType] ?? 0;
//     _appendMessage(context, "\ndevice isConnection is ${type == 1}");
//   }
// }

// void _appendMessage(BuildContext context, String message) {}

// void _incrementScanCount(BuildContext context) {}

// void dispose() {
//   receiver.dispose();
// }

class _DashboardPageState extends State<DashboardPage> {
  String itemDesc = '';
  String amountPrice = '';

  String promoPrice = '';
  String promoPriceSaved = '';
  String promoPriceUntil = '';

  String mMDesc1 = '';
  String mMPrice = '';
  String mMPriceSaved = '';
  String mMPriveUntil = '';

  String? storedDeviceId = '';
  String? storedStore = '';
  String? storedStoreName = '';
  String? storedUrl = '';
  String? storedType = '';

  final barcodeController = TextEditingController();
  String deviceId = "";
  String mResultAction = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkDeviceId();
  }

  Future<void> checkDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    storedDeviceId = prefs.getString('device_id');
    storedStore = prefs.getString('store');
    storedStoreName = prefs.getString('store_name');
    storedUrl = prefs.getString('url');
    storedType = prefs.getString('type');

    if (storedDeviceId == null) {
      // cek ID dan store ke local storage
      await getDeviceId();

      // akses API dan simpan ke database
      final url = Uri.parse('https://ccm.aeonindonesia.co.id/api/v1/pc/check');
      Map<String, String> payload = {
        'device_id': prefs.getString('device_id')!
      };
      try {
        await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload), // Mengonversi map ke format JSON
        );
      } catch (e) {
        // print('Error: $e');
      }
      Get.offNamed(Routes.getWaitingConfigurationPage());
    } else {
      if (storedStore == null) {
        final url =
            Uri.parse('https://ccm.aeonindonesia.co.id/api/v1/pc/check');
        Map<String, String> payload = {
          'device_id': prefs.getString('device_id')!
        };

        try {
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload), // Mengonversi map ke format JSON
          );

          String a = '', b = '', c = '', d = '';

          if (response.statusCode == 200) {
            Map<String, dynamic> responseData = jsonDecode(response.body);
            List<dynamic> data = responseData['data'];
            if (data.isEmpty) {
              Get.offNamed(Routes.getWaitingConfigurationPage());
            } else {
              a = data[0]['mdev_store_code'];
              b = data[0]['mdev_store_name'];
              c = data[0]['mdev_url'];
              d = data[0]['mdev_type'];

              await prefs.setString('store', a);
              await prefs.setString('store_name', b);
              await prefs.setString('url', c);
              await prefs.setString('type', d);
              setState(() {
                isLoading = false; // Stop loading once device ID is fetched
              });
            }
          } else {
            //
          }
        } catch (e) {
          // print('Error: $e');
        }
      } else {
        setState(() {
          isLoading = false; // Stop loading once device ID is fetched
        });
      }
    }
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', deviceId + DateTime.now().toString());
    } catch (e) {
      // Handle error
    }
  }

  FocusNode barcodeFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 173, 33, 129),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  color: Colors.transparent,
                  height: screenHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Logo(),
                      const PriceCheckLogo(),
                      const CheckThePrice(),
                      Column(
                        children: [
                          TextField(
                            focusNode: barcodeFocusNode,
                            autofocus: true,
                            controller: barcodeController,
                            onSubmitted: (_) => storedType == 'seito'
                                ? _checkBarcodeSeito()
                                : _checkBarcodeOdoo(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize:
                                  16, // Sesuaikan dengan ukuran yang diinginkan
                              color: Colors.transparent,
                            ),
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                          const ScanHere(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _checkBarcodeOdoo() async {
    String barcode = barcodeController.text;
    String addLeadingZero(String barcode) {
      return '0$barcode';
    }

    bool barcodeFound = false;
    while (barcode.length <= 16 && !barcodeFound) {
      var url = Uri.parse('$storedUrl$barcode');

      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var responseData = json.decode(response.body);
          bool err = responseData['err'];
          if (!err) {
            barcodeFound = true;
            Get.toNamed(Routes.getFoundPage(barcode));
          }
        }
        if (!barcodeFound) {
          barcode = addLeadingZero(barcode);
        }
      } catch (e) {
        // Tangani kesalahan koneksi atau lainnya
        // print('Exception occurred while fetching data: $e');
      }
    }
    if (!barcodeFound) {
      Get.toNamed(Routes.getNotFoundPage());
    }
  }

  void _checkBarcodeSeito() async {
    String barcode = barcodeController.text;

    // Jika panjang teks kurang dari 13 digit, tambahkan "0" di depannya
    if (barcode.length < 16) {
      int zerosToAdd = 16 - barcode.length;
      String zeros = "0" * zerosToAdd;
      barcode = barcode + zeros;
    }

    var url = Uri.parse('$storedUrl$barcode');

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
        var mMPriveUntilElement = document.querySelector('#MMPriveUntil');

        setState(() {
          itemDesc = itemDescElement?.text ?? '0';
          amountPrice = amountPriceElement?.text ?? '0';

          promoPrice = promoPriceElement?.text ?? '0';
          promoPriceSaved = promoPriceSavedElement?.text ?? '0';
          promoPriceUntil = promoPriceUntilElement?.text ?? '0';

          mMDesc1 = mMDesc1Element?.text ?? '0';
          mMPrice = mMPriceElement?.text ?? '0';
          mMPriceSaved = mMPriceSavedElement?.text ?? '0';
          mMPriveUntil = mMPriveUntilElement?.text ?? '0';
        });

        if (itemDesc != '') {
          Get.toNamed(Routes.getFoundPage(barcode));
        } else {
          Get.toNamed(Routes.getNotFoundPage());
        }
      } else {
        // print('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // print('Exception occurred while fetching data: $e');
    }
  }
}

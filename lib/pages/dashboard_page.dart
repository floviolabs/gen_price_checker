import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:price_checker/utilities/scanner.dart';
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

class MyReceiver {
  final StreamController<String> _receiverController =
      StreamController<String>.broadcast();

  Stream<String> get receiverStream => _receiverController.stream;

  void onReceive(String action, String data) {
    _receiverController.add('$action: $data');
  }

  void dispose() {
    _receiverController.close();
  }
}

final MyReceiver receiver = MyReceiver();

void onReceive(
    BuildContext context, String action, Map<String, dynamic> intent) {
  if (action == ScannerConstants.deviceConnection) {
    // Scanner is connected
    // Append the message to a TextView or similar widget
    _appendMessage(context, "\nUSB Connect");
  } else if (action == ScannerConstants.deviceDisconnection) {
    // Scanner is disconnected
    // Append the message to a TextView or similar widget
    _appendMessage(context, "\nUSB Disconnect");
  } else if (action == ScannerConstants.resultAction) {
    // Scanner content
    String extraByteData = intent[ScannerConstants.extraDecodeData] ?? "";
    String extraData = intent[ScannerConstants.extraDecodeDataStr] ?? "";
    // String labelType = intent[ScannerConstants.labelType] ?? "";
    Uint8List? decodeData = base64Decode(extraByteData);
    String strData = extraData;

    // Append the result to a TextView or similar widget
    _appendMessage(context, "\nBroadcast result: byte: $decodeData");
    _appendMessage(context, "\nBroadcast result: string: $strData");

    // Increment scanner count
    _incrementScanCount(context);
  } else if (action == ScannerConstants.connectionBackAction) {
    // Obtain scanner device connection status
    int type = intent[ScannerConstants.connectionType] ?? 0;
    // Append the connection status to a TextView or similar widget
    _appendMessage(context, "\ndevice isConnection is ${type == 1}");
  }
}

void _appendMessage(BuildContext context, String message) {
  // Here, you would update your UI, maybe using a StatefulWidget
  // In this example, let's print the message to the console
  // print(message);
}

void _incrementScanCount(BuildContext context) {
  // Increment scan count
  // Here, you can handle your scan count logic
}

void dispose() {
  receiver.dispose();
}

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
    registerScannerBroadcast();

    checkDeviceId();
  }

  void registerScannerBroadcast() {}

  Future<void> checkDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.remove('device_id');
    // prefs.remove('store');
    // prefs.remove('store_name');
    // prefs.remove('url');
    // prefs.remove('type');

    storedDeviceId = prefs.getString('device_id');
    storedStore = prefs.getString('store');
    storedStoreName = prefs.getString('store_name');
    storedUrl = prefs.getString('url');
    storedType = prefs.getString('type');

    if (storedStore == null) {
      await getDeviceId();
      Get.offNamed(Routes.getWaitingConfigurationPage());
      final url = Uri.parse('https://ccm.aeonindonesia.co.id/api/v1/pc/check');

      // Payload yang akan dikirim
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

        String a = '';
        String b = '';
        String c = '';
        String d = '';

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          List<dynamic> data = responseData['data'];

          a = data[0]['mdev_store_code'];
          b = data[0]['mdev_store_name'];
          c = data[0]['mdev_url'];
          d = data[0]['mdev_type'];

          await prefs.setString('store', a);
          await prefs.setString('store_name', b);
          await prefs.setString('url', c);
          await prefs.setString('type', d);
        } else {
          //
        }
      } catch (e) {
        // print('Error: $e');
      }
    } else {
      final url = Uri.parse('https://ccm.aeonindonesia.co.id/api/v1/pc/check');

      // Payload yang akan dikirim
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

        String a = '';
        String b = '';
        String c = '';
        String d = '';

        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = jsonDecode(response.body);
          List<dynamic> data = responseData['data'];

          a = data[0]['mdev_store_code'];
          b = data[0]['mdev_store_name'];
          c = data[0]['mdev_url'];
          d = data[0]['mdev_type'];

          await prefs.setString('store', a);
          await prefs.setString('store_name', b);
          await prefs.setString('url', c);
          await prefs.setString('type', d);
        } else {
          //
        }
      } catch (e) {
        // print('Error: $e');
      }
      deviceId = storedDeviceId!;
      setState(() {
        isLoading = false; // Stop loading once device ID is fetched
      });
    }
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Use `id` instead of `androidId`
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId =
            iosInfo.identifierForVendor ?? ""; // Retrieve device ID for iOS
      }

      // Store the device ID in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', deviceId);

      // Navigate to waiting configuration page
      Get.offNamed(Routes.getWaitingConfigurationPage());
    } catch (e) {
      // Handle error
    }
  }

  // void _scannerReceiver(Map<String, dynamic> message) {

  // }

  // @override
  // void dispose() {

  // }
  FocusNode barcodeFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
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
    double rad10 = h5 * 2;
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
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading while fetching the device ID
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
                      // AEON Store + Device ID
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 80),
                          alignment: Alignment.center,
                          child: Image(
                            height: h5 * 30,
                            image: const AssetImage(
                                "assets/images/aeon-white.png"),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image(
                              height: h5 * 50,
                              image:
                                  const AssetImage("assets/images/barcode.png"),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CEK HARGA',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: font20 * 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Check the price',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: font20 * 2,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Text(
                            '価格を確認する',
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
                              fontFamily: 'Poppins',
                            ),
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                fontSize:
                                    0, // Ukuran 0 untuk hintStyle akan membuatnya tidak terlihat
                                fontFamily: 'Poppins',
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(rad10),
                                borderSide: const BorderSide(
                                    width: 1.0, color: Colors.transparent),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(rad10),
                                borderSide: BorderSide(
                                    color: Colors.blueGrey.withOpacity(0)),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Pindai disini ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: font16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '/ Scan here ',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: font16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '/ ここでスキャン',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: font16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

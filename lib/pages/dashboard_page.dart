import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gen_price_checker/utilities/scanner.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gen_price_checker/routes/route_helper.dart';
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
    String? storedDeviceId = prefs.getString('device_id');

    if (storedDeviceId == null) {
      // If no device ID in storage, fetch it
      await getDeviceId();
      Get.offNamed(Routes.getWaitingConfigurationPage());
    } else {
      // If device ID exists, use it and remain on the dashboard
      deviceId = storedDeviceId;
      setState(() {
        isLoading = false;  // Stop loading once device ID is fetched
      });
    }
  }

  Future<void> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;  // Use `id` instead of `androidId`
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? "";  // Retrieve device ID for iOS
      }

      // Store the device ID in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', deviceId);

      // Navigate to waiting configuration page
      Get.offNamed(Routes.getWaitingConfigurationPage());
    } catch (e) {
      // Handle error
      print('Failed to get device ID: $e');
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
          ? const Center(child: CircularProgressIndicator()) // Show loading while fetching the device ID
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
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ÆON Store',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: font16 / 2,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            deviceId,  // Display fetched device ID
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white70,
                              fontSize: font16 / 2,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                            onSubmitted: (_) => _checkBarcode(),
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

  void _checkBarcode() async {
    // Mengambil teks dari barcodeController
    String barcode = barcodeController.text;

    // Fungsi untuk menambahkan nol di depan barcode
    String addLeadingZero(String barcode) {
      return '0$barcode';
    }

    // Cek barcode hingga maksimal 16 digit
    bool barcodeFound = false;
    while (barcode.length <= 16 && !barcodeFound) {
      var url = Uri.parse(
          'https://pos.aeonindonesia.co.id/pos/price/product/7003/$barcode');

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
        // Tambahkan nol di depan jika barcode tidak ditemukan
        if (!barcodeFound) {
          barcode = addLeadingZero(barcode);
        }
      } catch (e) {
        // Tangani kesalahan koneksi atau lainnya
        // print('Exception occurred while fetching data: $e');
      }
    }

    // Jika barcode tidak ditemukan setelah mencoba hingga 16 digit, arahkan ke halaman tidak ditemukan
    if (!barcodeFound) {
      Get.toNamed(Routes.getNotFoundPage());
    }
  }
}

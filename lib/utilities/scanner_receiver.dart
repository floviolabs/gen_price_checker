import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'scanner.dart';

class ScannerReceiver {
  void onReceive(
      BuildContext context, String action, Map<String, dynamic> intent) {
    if (action == ScannerConstants.deviceConnection) {
      _appendMessage(context, "\nUSB Connect");
    } else if (action == ScannerConstants.deviceDisconnection) {
      _appendMessage(context, "\nUSB Disconnect");
    } else if (action == ScannerConstants.resultAction) {
      String extraByteData = intent[ScannerConstants.extraDecodeData] ?? "";
      String extraData = intent[ScannerConstants.extraDecodeDataStr] ?? "";
      // String labelType = intent[ScannerConstants.labelType] ?? "";
      Uint8List? decodeData = base64Decode(extraByteData);
      String strData = extraData;

      _appendMessage(context, "\nBroadcast result: byte: $decodeData");
      _appendMessage(context, "\nBroadcast result: string: $strData");

      _incrementScanCount(context);
    } else if (action == ScannerConstants.connectionBackAction) {
      int type = intent[ScannerConstants.connectionType] ?? 0;
      _appendMessage(context, "\ndevice isConnection is ${type == 1}");
    }
  }

  void _appendMessage(BuildContext context, String message) {
    // print(message);
  }

  void _incrementScanCount(BuildContext context) {
    // Implement your scan count logic here
  }
}

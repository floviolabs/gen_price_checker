import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_checker/routes/route_helper.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AEON PRICE CHECKER',
      // initialRoute: Routes.getDashboardPage(),
      initialRoute: Routes.getDashboardPage(),
      getPages: Routes.routes,
    );
  }
}

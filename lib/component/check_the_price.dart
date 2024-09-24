import 'package:flutter/material.dart';

class CheckThePrice extends StatelessWidget {
  const CheckThePrice({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double h2 = screenHeight / 561;
    double font20 = h2 * 10;

    return Column(
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
    );
  }
}

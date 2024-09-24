import 'package:flutter/material.dart';

class ScanHere extends StatelessWidget {
  const ScanHere({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double h2 = screenHeight / 561;
    double font16 = h2 * 8;

    return Container(
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
    );
  }
}

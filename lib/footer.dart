import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = _calculateResponsiveFontSize(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© ${DateTime.now().year} Khoirul Fahmi. All rights reserved.',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: fontSize),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Text(
            "Made by Flutter",
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.normal,
                fontSize: fontSize),
          )
        ],
      ),
    );
  }

  double _calculateResponsiveFontSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 16.0; // Untuk mobile
    } else if (screenWidth < 800) {
      return 22.0; // Untuk tablet
    } else {
      return 26.0; // Untuk desktop
    }
  }
}

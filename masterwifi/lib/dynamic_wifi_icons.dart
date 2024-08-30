import 'package:flutter/material.dart';

class DynamicWifiIcon extends StatelessWidget {
  final int signalStrength;

  DynamicWifiIcon({required this.signalStrength});

  @override
  Widget build(BuildContext context) {
    String iconPath;

    // Determine the appropriate image based on the signal strength
    if (signalStrength > -30) {
      iconPath = 'assets/excellent.jpeg'; // High signal
    } else if (signalStrength > -70) {
      iconPath = 'assets/very good.jpeg'; // Medium signal
    } else if (signalStrength > -80) {
      iconPath = 'assets/normal.jpeg'; // Low signal
    } else {
      iconPath = 'assets/poor.jpeg'; // No signal
    }

    return Image.asset(iconPath, width: 40, height: 40);
  }
}

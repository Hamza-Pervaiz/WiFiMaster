import 'package:flutter/services.dart';

class HotspotManager {
  static const platform = MethodChannel('com.example.masterwifi/hotspot');

  Future<void> createHotspot(String ssid, String password) async {
    try {
      final result = await platform.invokeMethod('createHotspot', {
        'ssid': ssid,
        'password': password,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to create hotspot: '${e.message}'.");
    }
  }
}

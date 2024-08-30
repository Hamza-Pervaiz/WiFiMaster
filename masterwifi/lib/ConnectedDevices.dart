import 'package:flutter/material.dart';

class DeviceListScreen extends StatelessWidget {
  final List<Map<String, String>> devices;

  const DeviceListScreen({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Devices'),
      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          final device = devices[index];
          return ListTile(
            title: Text(device["IP"] ?? "Unknown IP"),
            subtitle: Text(device["Hostname"] ?? "Unknown Host"),
          );
        },
      ),
    );
  }
}

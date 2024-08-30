import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ScanDevices extends StatefulWidget {
  const ScanDevices({super.key});

  @override
  State<ScanDevices> createState() => _ScanDevicesState();
}

class _ScanDevicesState extends State<ScanDevices> {
  bool _isScanning = true;
  List<String> _devices = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  Future<void> _startScan() async {
    List<String> connectedDevices = await scanNetwork();
    setState(() {
      _devices = connectedDevices;
      _isScanning = false;
    });
  }

  Future<List<String>> scanNetwork() async {
    List<String> connectedDevices = [];
    List<int> commonPorts = [80, 443, 8080]; // Common HTTP/HTTPS ports

    String? ip = await NetworkInfo().getWifiIP();
    connectedDevices.add(ip!);

    if (ip != null) {
      final String subnet = ip.substring(0, ip.lastIndexOf('.'));

      for (var i = 1; i < 255; i++) {
        String targetIp = '$subnet.$i';
        bool deviceFound = false;

        for (int port in commonPorts) {
          try {
            // Try to establish a connection to the target IP on the specified port
            Socket socket = await Socket.connect(targetIp, port,
                timeout: Duration(milliseconds: 20));

            try {
              // If the connection is successful, try to get the hostname
              InternetAddress address = socket.address;
              connectedDevices.add((await address.reverse()).host);
            } catch (e) {
              // If hostname retrieval fails, add the IP address
              connectedDevices.add(socket.address.address);
            }

            socket.destroy();
            deviceFound = true;
            break; // If a device is found on one port, skip checking other ports
          } catch (e) {
            // Ignore the error and continue scanning other ports
          }
        }

        if (deviceFound) {
          // Add the IP to the list if a connection was established on any port
          continue;
        }
      }
    }

    return connectedDevices;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('View Device', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _isScanning
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 8.0,
              )
            : _devices.isEmpty
                ? Text(
                    'No devices found',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                : Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.09),
                    width: screenWidth * 0.99, // 90% of screen width
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05, // 5% of screen width
                      vertical: screenHeight * 0.02, // 2% of screen height
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.1), // Shadow color with opacity
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 8, // How blurred the shadow is
                          offset: Offset(0, 4), // Position of the shadow
                        ),
                      ],
                    ),
                    //  color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_devices.length}Devices are Connected',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth *
                                0.05, // Font size relative to screen width
                          ),
                        ),
                        SizedBox(
                            height: screenHeight *
                                0.02), // Space between text and list
                        Expanded(
                          child: ListView.builder(
                            itemCount: _devices.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  'Device ${index + 1}: ${_devices[index]}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:masterwifi/connectScreen.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  Future<Map<String, dynamic>> getWifiInfo() async {
    try {
      WifiInfoWrapper? wifiInfo = await WifiInfoPlugin.wifiDetails;

      if (wifiInfo != null) {
        // Extract information from WifiInfoWrapper
        String? wifiName = wifiInfo.ssid; // Wi-Fi Name (SSID)
        int? signalStrength = wifiInfo.signalStrength; // Signal Strength in dBm
        String? encryptionType = wifiInfo.dns1; // Encryption Type
        int? maxConnectSpeed = wifiInfo.linkSpeed; // Max Connect Speed in Mbps
        String? ipAddress = wifiInfo.ipAddress; // IP Address
        String? macAddress = wifiInfo.bssId; // MAC Address

        // Create a map with all the information
        return {
          'wifiName': wifiName,
          'signalStrength': signalStrength,
          'encryptionType': encryptionType,
          'maxConnectSpeed': maxConnectSpeed,
          'ipAddress': ipAddress,
          'macAddress': macAddress,
        };
      } else {
        return {'error': 'Failed to retrieve Wi-Fi information'};
      }
    } catch (e) {
      print("Failed to get Wi-Fi info: $e");
      return {'error': 'Exception occurred: $e'};
    }
  }

  Map<String, dynamic>? wifidetails;
  Future<void> fetchWifiInfo() async {
    Map<String, dynamic> info = await getWifiInfo();
    setState(() {
      wifidetails = info;
    });
  }

  void initState() {
    super.initState();
    fetchWifiInfo();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (wifidetails == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'NETWORK SECURITY',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Text(
          'NETWORK SECURITY',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Score: 100',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Regular optimization to ensure safety',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('WiFi security'),
              tileColor: Colors.grey.shade200,
            ),
            _buildSecurityCheck('Check if WiFi is encrypted'),
            _buildSecurityCheck('Check if Arp is abnormal'),
            _buildSecurityCheck('Check for DNS hijacking'),
            _buildSecurityCheck('Check for tampered pages'),
            _buildSecurityCheck('Check for SSL man-in-the-middle attacks'),
            _buildSecurityCheck('Check whether it is a phishing WiFi'),
            ListTile(
              title: Text('WiFi details'),
              tileColor: Colors.grey.shade200,
            ),
            _buildWifiDetail(
                'WiFi Name',
                wifidetails!['wifiName'] == null
                    ? ''
                    : wifidetails!['wifiName'],
                screenWidth),
            _buildWifiDetail(
                'Signal strength',
                wifidetails!['signalStrength'].toString() == null
                    ? ''
                    : wifidetails!['signalStrength'].toString(),
                screenWidth),
            _buildWifiDetail('Encryption', 'WPA/WPA2', screenWidth),
            _buildWifiDetail(
                'Max connect speed',
                wifidetails!['maxConnectSpeed'].toString() == null
                    ? ''
                    : wifidetails!['maxConnectSpeed'].toString(),
                screenWidth),
            _buildWifiDetail(
                'Assigned IP address',
                wifidetails!['ipAddress'] == null
                    ? ''
                    : wifidetails!['ipAddress'],
                screenWidth),
            _buildWifiDetail(
                'MAC address',
                wifidetails!['macAddress'] == null
                    ? ''
                    : wifidetails!['macAddress'],
                screenWidth),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Connectscreen()),
                  );
                },
                child: Text('Connect now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  // primary: Colors.white,
                  // onPrimary: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  minimumSize: Size(double.infinity, screenHeight * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCheck(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(
        Icons.security,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildWifiDetail(String title, String value, double screenWidth) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

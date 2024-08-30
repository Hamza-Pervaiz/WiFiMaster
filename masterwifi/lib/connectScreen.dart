import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_android_intent/flutter_android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterwifi/dynamic_wifi_icons.dart';
import 'package:masterwifi/hotspotmanager.dart';
import 'package:masterwifi/qrcodeScreen.dart';
import 'package:masterwifi/security.dart';
import 'package:masterwifi/signals.dart';
import 'package:masterwifi/speedup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'dart:async';

import 'package:flutter/foundation.dart';

import 'CutomWiFiNetwork.dart';

class Connectscreen extends StatefulWidget {
  const Connectscreen({super.key});

  @override
  State<Connectscreen> createState() => _ConnectscreenState();
}

class _ConnectscreenState extends State<Connectscreen> {
  bool checkvalue = true;
  // dialog box
  bool _obscureText = false;
  bool issharinghotspot = false;
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  Timer? _timer;
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      scanForNetworks();
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _showForgetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Forget Network'),
          content: Text(
              'Due to system restrictions, we failed to forget this network. Please process in phone settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _openWifiSettings(); // Open Wi-Fi settings
              },
              child: Text('Go to Settings'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openWifiSettings() async {
    try {
      final intent = AndroidIntent(
        action: 'android.settings.WIFI_SETTINGS',
        package: 'com.android.settings',
        componentName: 'com.android.settings/.wifi.WifiSettings',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );

      await AndroidIntent().launch();
    } catch (e) {
      print("Failed to open Wi-Fi settings: '${e.toString()}'.");
    }
  }

  void _showPasswordDialogforconnectedDevices(
      BuildContext context, String ssid) {
    final TextEditingController _passwordController = TextEditingController();
    bool _obscureText = true;
    bool _isPasswordValid = true;
    bool _isChecked = false;

    // Add a flag to control if the server has been started
    bool _serverStarted = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            return AlertDialog(
              title: Text(
                'Connect to $ssid',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              content: Container(
                width: screenWidth * 0.8,
                constraints: BoxConstraints(
                  maxHeight: screenHeight * 0.4,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The current network does not save the password. After entering the password, a QR code will be generated for you.',
                      style: TextStyle(
                        fontSize: screenWidth * 0.033,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.blue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorText: !_isPasswordValid
                            ? 'Password must be at least 8 characters long'
                            : null,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isPasswordValid = value.length >= 8;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Checkbox(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Share WiFi',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ],
                    ),
                    if (_isChecked)
                      GestureDetector(
                        onTap: () {
                          // Optionally handle this tap
                        },
                        child: Text(
                          'Read and agree to the Hotspot Sharing Program',
                          style: TextStyle(
                              fontSize: screenWidth * 0.033,
                              color: Colors.blue),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                TextButton(
                  onPressed: _isPasswordValid
                      ? () async {
                          final password = _passwordController.text;
                          if (password.length >= 8) {
                            // Show connecting SnackBar
                            final snackBar = SnackBar(
                              content: Text(
                                'Connecting...',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.blueAccent,
                              duration: Duration(
                                  days: 1), // Long duration to keep it visible
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);

                            bool isConnected =
                                await attemptWifiConnection(ssid, password);
                            ScaffoldMessenger.of(context)
                                .hideCurrentSnackBar(); // Hide connecting SnackBar

                            if (isConnected) {
                              if (_isChecked && !_serverStarted) {
                                // Start the local server
                                createHotspot(ssid, '');
                                _serverStarted = true;

                                // Prevent restarting the server
                              }
                              Navigator.pop(context);
                              String qrData = "WIFI:S:$ssid;T:WPA;P:$password;";
                              _showQRCode(context, qrData);
                              if (_isChecked) {
                                // Handle hotspot sharing
                                //startLocalServer(); // Start the server if it's not already started
                              }
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Wrong Password',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  action: SnackBarAction(
                                    label: 'Retry',
                                    textColor: Colors.yellow,
                                    onPressed: () {
                                      // Retry logic if needed
                                    },
                                  ),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              _isPasswordValid = false;
                            });
                          }
                        }
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor:
                        _isPasswordValid ? Colors.blue : Colors.grey,
                  ),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

/////////////////////////////////// HotSpot Functionality------------------------
  List<String> hotspots = [];

  HotspotManager _hotspotManager = HotspotManager();
  List<CustomWiFiNetwork> availableNetworks = [];
  CustomWiFiNetwork? currentNetwork;
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

  int androidVersion() {
    if (Platform.isAndroid) {
      try {
        // Extracting the major version from the operating system version
        String versionString = Platform.operatingSystemVersion;
        List<String> parts = versionString.split(' ');

        if (parts.isNotEmpty) {
          // Use a regex to extract the version number
          RegExp versionRegExp = RegExp(r'(\d+)\.(\d+)');
          Match? match = versionRegExp.firstMatch(parts[0]);

          if (match != null && match.groupCount >= 2) {
            int majorVersion = int.parse(match.group(1)!);
            return majorVersion;
          }
        }
      } catch (e) {
        print("Error parsing Android version: $e");
      }
    }
    return 0; // Default value for non-Android or error cases
  }

  Future<void> checkHotspotVisibility() async {
    if (Platform.isAndroid) {
      List<String>? networks =
          (await WiFiForIoTPlugin.loadWifiList()).cast<String>();
      if (networks != null) {
        print("Available networks:");
        for (String network in networks) {
          print(network);
        }
      } else {
        print("No networks found.");
      }
    }
  }

  // Future<CustomWiFiNetwork> _getHotspotInfo() async {
  //   try {
  //     final Map<dynamic, dynamic>? info =
  //         await platform.invokeMethod('getHotspotInfo');

  //     if (info != null) {
  //       // Cast the map to Map<String, dynamic>
  //       final Map<String, dynamic> typedInfo = Map<String, dynamic>.from(info);

  //       final String ssid = typedInfo['SSID'] ?? 'Unknown SSID';
  //       final String band = typedInfo['Band'] ?? 'Unknown Band';

  //       final int frequency = int.tryParse(band) ?? 0;

  //       var network = CustomWiFiNetwork(
  //         ssid: ssid,
  //         capabilities: '', // Set this if available or remove if not needed
  //         frequency: frequency,
  //         level: 0, // Set this if available or remove if not needed
  //         bssid: '333',
  //       );
  //       currentNetwork = network;
  //       setState(() {});

  //       return network;
  //     } else {
  //       return CustomWiFiNetwork(
  //         ssid: 'Unknown SSID',
  //         capabilities: '',
  //         frequency: 0,
  //         level: 0,
  //         bssid: 'Unknown BSSID',
  //       );
  //     }
  //   } on PlatformException catch (e) {
  //     print("Failed to get hotspot info: ${e.message}");
  //     return CustomWiFiNetwork(
  //       ssid: 'Error',
  //       capabilities: '',
  //       frequency: 0,
  //       level: 0,
  //       bssid: 'Error',
  //     );
  //   }
  // }

  Future<void> scanForNetworks() async {
    final List<WiFiAccessPoint> networks =
        await WiFiScan.instance.getScannedResults();

    availableNetworks.addAll(networks.map((ap) => CustomWiFiNetwork(
          ssid: ap.ssid,
          capabilities: ap.capabilities,
          frequency: ap.frequency,
          level: ap.level,
          bssid: ap.bssid,
        )));

    for (int i = 0; i < availableNetworks.length; i++) {
      print(availableNetworks[i].ssid);
    }
  }

  Future<bool> attemptWifiConnection(String ssid, String password) async {
    try {
      bool result = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        joinOnce: true,
        security: NetworkSecurity.WPA,
      );

      // Avoid long waits
      if (result) {
        // Short wait to verify connection
        // await Future.delayed(Duration(seconds: 2));
        String? connectedSSID = await WiFiForIoTPlugin.getSSID();
        return connectedSSID == ssid;
      }
    } on PlatformException catch (e) {
      print("Error connecting to $ssid: $e");
    } catch (e) {
      print("Error connecting to $ssid: $e");
    }
    return false;
  }

  // This is for creating hotspot

// this is for the connected device to share the qrcode with other devices

  void _sendConnectRequest(String ssid) async {
    try {
      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: passwordController.text,
        security: NetworkSecurity
            .WPA, // Change according to your network's security type
        joinOnce: true,
        withInternet: true,
      );

      if (isConnected) {
        // Connection successful, close the dialog
        // Navigator.pop(context);

        // Generate the QR code data
        String qrData = "WIFI:S:$ssid;T:WPA;P:${passwordController.text};;";

        // Show QR code dialog
        _showQRCode(context, qrData);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Connected to $ssid')),
        // );
      } else {
        // Connection failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to connect to $ssid. Please check your password.'),
          ),
        );
      }
    } catch (e) {
      // Handle exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showQRCode(BuildContext context, String qrData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wi-Fi QR Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrettyQr(
                data: qrData,
                size: 200,
                roundEdges: true,
                errorCorrectLevel:
                    QrErrorCorrectLevel.M, // Medium error correction
                elementColor: Colors.black, // Color of the QR code elements
                // glassmorphism: false, // Whether to use glassmorphism effect
              ),
              SizedBox(height: 10),
              Text(
                'Use this QR code to connect other devices to the network.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  final TextEditingController passwordController = TextEditingController();

  void _showPasswordDialog(BuildContext context, String ssid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _obscureText = true;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Connect to $ssid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'The current network does not save the password. After entering the password, a QR code will be generated for you.',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
                      Expanded(
                        child: Text(
                          'Share WiFi',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Implement navigation to the Hotspot Sharing Program
                    },
                    child: Text(
                      'Read and agree to the Hotspot Sharing Program',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    attemptWifiConnection(ssid, passwordController.text);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRepotDialog(BuildContext context, String ssid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool _obscureText = true;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                '$ssid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are You sure to report ${ssid}  as a Phishing WiFi.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Report Submitted successfully!'),
                        duration: Duration(
                            seconds: 2), // Duration the snackbar is shown
                        backgroundColor: Colors
                            .blue, // Optional: Change the background color
                      ),
                    );
                    //  Navigator.pop(context);
                  },
                  child: Text('Report'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// show alter dialog for more options
// this is for 3 dots more option
  void _showCustomAlert(BuildContext context, String ssid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Material(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: screenWidth * 0.8,
                  maxWidth: screenWidth * 0.95,
                ),
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$ssid',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _showPasswordDialog(context, ssid);
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showPasswordDialog(context, ssid);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.edit, size: screenWidth * 0.08),
                                SizedBox(height: screenWidth * 0.01),
                                Text('Input Password',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getWifiInfo();
                            int newsignal = signalStrength;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignalsDetection(
                                      signals: newsignal,
                                      name: connectionname)),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.signal_cellular_alt,
                                  size: screenWidth * 0.08),
                              SizedBox(height: screenWidth * 0.01),
                              Text('Signal',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.03)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showPasswordDialogforconnectedDevices(
                                context, connectionname);
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showPasswordDialog(context, ssid);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.share, size: screenWidth * 0.08),
                                SizedBox(height: screenWidth * 0.01),
                                Text('Share',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03)),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showRepotDialog(context, ssid);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.report_problem,
                                  size: screenWidth * 0.08),
                              SizedBox(height: screenWidth * 0.01),
                              Text('Report',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.03)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    TextButton(
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? filteredAccessPoints;
  int signalStrength = 0;
  String status = '';
  String connectionname = ' ';

  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  void kShowSnackBar(BuildContext context, String message) {
    if (kDebugMode) print(message);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// show wifi options for connected device
  void _showWiFiOptions(BuildContext context, String connectionname) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double iconSize = screenWidth * 0.08;
        final double textSize = screenWidth * 0.03;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$connectionname',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                  ),
                  Icon(Icons.lock_outline),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      Share.share(
                        '''Hey, I am using the WiFi Master key for free internet access, 
                      and the nearby WiFi can be connected for free.
                      Click the link below to download this super 
                      APP: https://en.wifi.com/app_h5/wifiShare/index.html?type=3&language=en''',
                        subject: 'Wi-Fi Network',
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, size: iconSize),
                        SizedBox(height: 5),
                        Text('Invite', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Security()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.security, size: iconSize),
                        SizedBox(height: 5),
                        Text('Safety', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpeedUp()),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.speed, size: iconSize),
                        SizedBox(height: 5),
                        Text('Speed', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      getWifiInfo();
                      int newsignal = signalStrength;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignalsDetection(
                                signals: newsignal, name: connectionname)),
                      );
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => SignalsDetection(
                                    signals: signalStrength,
                                    name: connectionname,
                                  )),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.network_wifi, size: iconSize),
                          SizedBox(height: 5),
                          Text('Signal', style: TextStyle(fontSize: textSize)),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showPasswordDialog(context, connectionname);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share, size: iconSize),
                        SizedBox(height: 5),
                        Text('Share', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showReportAlert(context, connectionname);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.report, size: iconSize),
                        SizedBox(height: 5),
                        Text('Report', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showForgetDialog(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, size: iconSize),
                        SizedBox(height: 5),
                        Text('Forget', style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Disconnect logic
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.link_off, size: iconSize),
                        SizedBox(height: 5),
                        Text('Disconnect',
                            style: TextStyle(fontSize: textSize)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            ListTile(
              title: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getWifiInfo() async {
    try {
      // Retrieve the Wi-Fi name
      final wifiName = await WifiInfo().getWifiName();

      if (wifiName != null && wifiName.isNotEmpty) {
        // Filter the access points to find the one matching the connected Wi-Fi name
        final filteredAccessPoints =
            accessPoints.where((ap) => ap.ssid == wifiName).toList();

        // If the access point is found, get its signal strength
        if (filteredAccessPoints.isNotEmpty) {
          var signal = filteredAccessPoints[0].level ?? 0;

          // Update the state with the Wi-Fi name and signal strength
          connectionname = wifiName;
          //  status = 'connected';
          signalStrength = signal;

          print('Connected to Wi-Fi SSID: $wifiName');
          print('Signal Strength: $signalStrength dBm');
          setState(() {});
        } else {
          print('Connected Wi-Fi not found in access points');
        }
      } else {
        print('Not connected to Wi-Fi');
      }
    } catch (e) {
      print("Failed to get Wi-Fi info: $e");
    }
  }

  //  show report dialog
  void _showReportAlert(BuildContext context, String connectionname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final double screenWidth = MediaQuery.of(context).size.width;

        return AlertDialog(
          title: Text(
            '$connectionname',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.045,
            ),
          ),
          content: Text(
            'Are you sure to report $connectionname as a Phishing WiFi?',
            style: TextStyle(fontSize: screenWidth * 0.04),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Report',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              onPressed: () {
                // Show a notification that the report was submitted
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Report submitted successfully'),
                        ],
                      ),
                    ),
                    backgroundColor: Colors.blueAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    margin: EdgeInsets.all(16.0),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startConnectionCheck();
    startTimer();
    _startScan(context).then((_) {
      _listenToScannedResults();

      // Wait for a short time to ensure scan results are available
    });
    _getScannedResults(context);
  }

  bool _isConnected = false;
  Timer? _connectionCheckTimer;

  void _startConnectionCheck() {
    _connectionCheckTimer =
        Timer.periodic(Duration(seconds: 2), (Timer timer) async {
      bool isConnected = await WiFiForIoTPlugin.isConnected();

      if (mounted) {
        // Check if the widget is still mounted
        if (isConnected) {
          String? name = await WifiInfo().getWifiName();
          setState(() {
            _isConnected = true;
            status = 'Connected';
            connectionname = name ?? 'Unknown SSID'; // Default if name is null
          });
        } else {
          setState(() {
            _isConnected = false;
            status = 'Disconnected';
            connectionname = ' '; // Or use an empty string if preferred
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _connectionCheckTimer?.cancel(); // Cancel the timer
    subscription?.cancel(); // Ensure that the subscription is cancelled

    super.dispose();
  }

  Future<void> _startScan(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canStartScan();
      if (can != CanStartScan.yes) {
        if (mounted) return;
      }
    }

    final result = await WiFiScan.instance.startScan();
    if (mounted) setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  void _listenToScannedResults() {
    subscription =
        WiFiScan.instance.onScannedResultsAvailable.listen((results) {
      setState(() {
        accessPoints = results;
      });
      if (kDebugMode) print("Scanned Results: ${results.length}");
    });
  }

  // Future<void> _getScannedResults(BuildContext context) async {
  //   if (await _canGetScannedResults(context)) {
  //     final results = await WiFiScan.instance.getScannedResults();
  //     setState(() => accessPoints = results);
  //     if (kDebugMode) print("Fetched Results: ${results.length}");
  //   }
  // }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      final results = await WiFiScan.instance.getScannedResults();

      // Print or log the signal strength (level) of each access point
      for (final accessPoint in results) {
        final signalStrength = accessPoint.level; // Using `level` for RSSI
        if (signalStrength != null) {
          print(
              'SSID: ${accessPoint.ssid}, Signal Strength (RSSI): $signalStrength dBm');
        } else {
          print('SSID: ${accessPoint.ssid}, Signal Strength not available');
        }
      }

      setState(() => accessPoints = results);
      if (kDebugMode) print("Fetched Results: ${results.length}");
    }
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      final can = await WiFiScan.instance.canGetScannedResults();
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  void _connectToWifi(String ssid) async {
    setState(() {
      status = 'Connected';
      connectionname = ssid;
    });
  }

  Future<void> connectToHotspot(String ssid) async {
    try {
      // Scan for available networks
      List<WiFiAccessPoint> accessPoints =
          await WiFiScan.instance.getScannedResults();
      for (int i = 0; i < accessPoints.length; i++) {
        print(accessPoints[i].ssid + "  " + accessPoints[i].bssid);
      } // Find the desired network
      WiFiAccessPoint? accessPointToConnect = accessPoints.firstWhere(
        (ap) => ap.ssid == ssid,
      );

      if (accessPointToConnect != null) {
        bool isOpenNetwork = accessPointToConnect.capabilities == null ||
            accessPointToConnect.capabilities!.contains('WEP') ||
            accessPointToConnect.capabilities!.contains('WPA');

        if (isOpenNetwork) {
          // Connect to open network
          bool result = await WiFiForIoTPlugin.connect(
            accessPointToConnect.ssid,
            password: "", // No password for open networks
          );

          if (result) {
            print('Connected to $ssid');
          } else {
            print('Failed to connect to $ssid');
          }
        } else {
          // Show password dialog for secured networks
          _showPasswordDialog(context, accessPointToConnect.ssid);
        }
      } else {
        print('Network $ssid not found');
      }
    } catch (e) {
      print('Error connecting to $ssid: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double sizedboxwidth = MediaQuery.of(context).size.width;
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate a responsive font size based on the screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.wifi)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isConnected
                    ? Text(
                        'Connected',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      )
                    : Text('Disconnected',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                const SizedBox(height: 1),
                Text(
                  connectionname,
                  style: const TextStyle(fontSize: 17),
                )
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double fontSize = constraints.maxWidth * 0.04;
          double fontSize1 = constraints.maxWidth * 0.03;
          double? fontSizemainicons = screenWidth * 0.04;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 15),
                color: Colors.blueAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Qrcodescreen()),
                        );
                        if (result != null) {
                          // Handle the result (scanned QR code data)
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Scanned Code: $result')),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/scan.png',
                            width: constraints.maxWidth * 0.2,
                            height: constraints.maxWidth * 0.1,
                          ),
                          const SizedBox(height: 8),
                          const Text('Scan', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showPasswordDialogforconnectedDevices(
                            context, connectionname);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/sharenew.png',
                            width: constraints.maxWidth * 0.2,
                            height: constraints.maxWidth * 0.1,
                          ),
                          const SizedBox(height: 8),
                          const Text('Share', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getWifiInfo();
                            int newsignal = signalStrength;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignalsDetection(
                                      signals: newsignal,
                                      name: connectionname)),
                            );
                          },
                          child: Image.asset(
                            'assets/signal.png',
                            width: constraints.maxWidth * 0.2,
                            height: constraints.maxWidth * 0.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Signal', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => (SpeedUp())),
                            );
                          },
                          child: Image.asset(
                            'assets/speed.png',
                            width: constraints.maxWidth * 0.2,
                            height: constraints.maxWidth * 0.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Speed up', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 60,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Speed',
                                      style: TextStyle(
                                          fontSize: fontSize1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: sizedboxwidth * 0.2),
                                    Text(
                                      'Just now',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: fontSize1),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Transmission Rate 0.11Mb/s',
                                      style: TextStyle(fontSize: fontSize1),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            margin: const EdgeInsets.only(left: 10),
                            height: 60,
                            width: 183,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Scan device',
                                      style: TextStyle(
                                          fontSize: fontSize1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Identifiable',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 207, 42, 152),
                                          fontSize: fontSize1),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'detected',
                                      style: TextStyle(fontSize: fontSize1),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(sizedboxwidth * 0.01),
                          margin: EdgeInsets.only(left: sizedboxwidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          width: sizedboxwidth * 0.9,
                          height: 100,
                          child: Column(
                            children: const [
                              Text('Pocket Option'),
                              SizedBox(height: 0),
                              Text('Earn on Financial Markets'),
                              SizedBox(height: 20),
                              Text(
                                'Start investing',
                                style: TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //final ipAddress = await Connectivity().getWifiIP();
//final wifiName = await Connectivity().getWifiName();

              connectionname != ' '
                  ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      color: Colors.white,
                      height: currentNetwork != null
                          ? MediaQuery.of(context).size.height * 0.2
                          : MediaQuery.of(context).size.height * 0.11,
                      width: constraints.maxWidth,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: signalStrength != null
                                      ? DynamicWifiIcon(
                                          signalStrength: signalStrength!)
                                      : Text(''),
                                  subtitle: Text(
                                    'Connected',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  title: GestureDetector(
                                    onTap: () {
                                      _connectToWifi(connectionname);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(connectionname ?? ''),
                                      ],
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      _showWiFiOptions(context, connectionname);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.more_vert,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          currentNetwork != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: signalStrength != null
                                            ? DynamicWifiIcon(
                                                signalStrength: signalStrength!)
                                            : Text(''),
                                        subtitle: Text(
                                          'Open To Connect',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        title: GestureDetector(
                                          onTap: () {
                                            _connectToWifi(
                                                currentNetwork!.ssid);
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(currentNetwork!.ssid ?? ''),
                                            ],
                                          ),
                                        ),
                                        trailing: ElevatedButton(
                                          onPressed: () {
                                            _showWiFiOptions(
                                                context, currentNetwork!.ssid);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                          ),
                                          child: const Icon(
                                            Icons.more_vert,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(),

                          // Divider(
                          //     color:
                          //         Colors.grey), // Place Divider outside the Row
                        ],
                      ),
                    )
                  : Container(),

              // Return an empty Container if connectionname is null
              Container(
                margin: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.6),
                child: Text(
                  'Password Required',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: fontSize1, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: ListView.separated(
                    itemCount: accessPoints
                        .where((ap) => ap.ssid != null && ap.ssid!.isNotEmpty)
                        .toList()
                        .length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      final filteredAccessPoints = accessPoints
                          .where((ap) => ap.ssid != null && ap.ssid!.isNotEmpty)
                          .toList();

                      final signalStrength =
                          filteredAccessPoints[index].level ?? 0;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading:
                              DynamicWifiIcon(signalStrength: signalStrength),
                          title: GestureDetector(
                            onTap: () {
                              // _showPasswordDialog(
                              //     context, filteredAccessPoints[index].ssid);
                              connectToHotspot(
                                  filteredAccessPoints[index].ssid);
                              // _connectToWifi(
                              //     filteredAccessPoints[index].ssid ?? '');
                            },
                            child: Text(filteredAccessPoints[index].ssid ?? ''),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Background color
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showCustomAlert(
                                    context, filteredAccessPoints[index].ssid);
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.brown, // Adjust text color
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

Widget getWifiIconWithSignalStrength(int signalStrength) {
  final thresholds = [-90, -70, -50, -30]; // Signal strength thresholds
  final barCount = thresholds.length;
  final activeBars = <Widget>[];

  // Determine how many bars to show based on the signal strength
  int numBars = 0;
  for (int i = 0; i < barCount; i++) {
    if (signalStrength > thresholds[i]) {
      numBars = i + 1;
    }
  }

  // Create signal bars
  for (int i = 0; i < barCount; i++) {
    activeBars.add(
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 4.0,
          height: (i + 1) * 8.0, // Adjust bar height based on signal strength
          color: i < numBars ? Colors.green : Colors.grey[300],
        ),
      ),
    );
  }

  return Container(
    width: 40, // Define a fixed width
    height: (barCount * 8.0) + 20, // Adjust height dynamically
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.wifi, size: 40, color: Colors.blue), // Wi-Fi icon
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: activeBars,
          ),
        ),
      ],
    ),
  );
}

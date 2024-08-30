import 'package:flutter/material.dart';
import 'package:masterwifi/security.dart';
import 'package:masterwifi/signals.dart';
import 'package:masterwifi/speedtest.dart';
import 'package:masterwifi/speedup.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  int signalStrength = 0;
  String? wifiName;
  Future<void> getWifiInfo() async {
    WifiInfoWrapper? _wifiObject;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _wifiObject = await WifiInfoPlugin.wifiDetails;
    } catch (Exception) {
      print("Failed to get Wi-Fi info.");
    }

    // Ensure the widget is still mounted before updating the state
    if (!mounted) return;

    setState(() {
      signalStrength = _wifiObject!.signalStrength;
      wifiName = _wifiObject!.ssid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/animated.jpg',
                width: 40,
                height: 40,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'WiFi Master',
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color.fromARGB(255, 244, 255, 255),
        body: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 244, 255, 255),
              width: MediaQuery.of(context).size.width * 3,
              height: MediaQuery.of(context).size.height * 0.32,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width *
                        0.08, // Adjust the vertical position
                    left: MediaQuery.of(context).size.width *
                        0.08, // Adjust the horizontal position
                    child: Text(
                      'Speed',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width *
                        0.20, // Adjust the vertical position
                    left: MediaQuery.of(context).size.width *
                        0.08, // Adjust the horizontal position
                    child: Text(
                      'Up',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width *
                        0.01, // Position the image below the text
                    left: MediaQuery.of(context).size.width * 0.43,
                    child: Image.asset(
                      'assets/speeduppage1.jpeg',
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.29,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.width *
                          0.09, // Position the button near the bottom
                      right: MediaQuery.of(context).size.width *
                          0.45, // Align the button to the right
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SpeedUp()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Adjust padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                          backgroundColor: Color.fromARGB(
                              255, 29, 197, 57), // Background color
                          elevation: 5, // Elevation for shadow effect
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color.fromARGB(
                                  255, 22, 219, 177); // Darker shade on press
                            }
                            return Color.fromARGB(
                                255, 63, 192, 51); // Regular background color
                          }),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(211, 159, 248, 58),
                                Color.fromARGB(255, 230, 95, 223)
                              ], // Gradient colors
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              maxWidth: 100, // Adjust button width
                              minHeight: 40, // Adjust button height
                            ),
                            child: Text(
                              'Up',
                              style: TextStyle(
                                color: Colors.white, // Text color
                                fontSize: 18, // Font size
                                fontWeight: FontWeight.bold, // Font weight
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              color: Colors.white,
              // width:MediaQuery.of(context).size.width * 0.6 ,
              height: MediaQuery.of(context).size.height * 0.09,
              child: Row(
                children: [
                  Icon(Icons.abc),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpeedTest()),
                      );
                    },
                    child: Text('Speed Test',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              color: Colors.white,
              // width:MediaQuery.of(context).size.width * 0.6 ,
              height: MediaQuery.of(context).size.height * 0.09,
              child: GestureDetector(
                onTap: () async {
                  await getWifiInfo();
                  int newsignal = signalStrength;
                  String name = wifiName!;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignalsDetection(
                              signals: newsignal, name: name)));
                },
                child: Row(
                  children: [
                    Icon(Icons.abc),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.78,
                    ),
                    Text('Signal',
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              color: Colors.white,
              // width:MediaQuery.of(context).size.width * 0.6 ,
              height: MediaQuery.of(context).size.height * 0.09,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Security()),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.abc),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.76,
                    ),
                    Text(
                      'Security',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

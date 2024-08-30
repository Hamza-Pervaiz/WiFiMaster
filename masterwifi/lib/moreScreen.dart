import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterwifi/appsetting.dart';
import 'package:masterwifi/browserScreen.dart';
import 'package:masterwifi/faq.dart';
import 'package:masterwifi/feedback.dart';
import 'package:masterwifi/loginWithGoogle.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masterwifi/scan_Devices.dart';
import 'package:masterwifi/security.dart';
import 'package:masterwifi/signals.dart';
import 'package:masterwifi/speedtest.dart';
import 'package:masterwifi/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_info_plugin_plus/wifi_info_plugin_plus.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  void initState() {
    super.initState();
    _fetchUserCredentials();
  }

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

  void _checkForLatestVersion() {
    // Simulate version check
    bool isLatestVersion = true; // Replace with actual version checking logic

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isLatestVersion
            ? 'You have already upgraded to the latest version.'
            : 'A new version is available!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.halo.wifikey.wifilocating';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  GoogleSignInAccount? _currentUser;

  Future<void> _fetchUserCredentials() async {
    // Fetch user credentials here if needed
    // This could be from a state management solution or other means
    _currentUser =
        Provider.of<UserProvider>(context, listen: false).userCredential;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final userCredential = Provider.of<UserProvider>(context).userCredential;

    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final imageWidth = screenWidth * 0.12; // 12% of screen width
    final imageHeight = screenHeight * 0.06; // 6% of screen height

    // Define responsive values
    final containerHeight1 = screenHeight * 0.2; // 20% of screen height
    final textSize = screenWidth * 0.05; // 5% of screen width
    final borderRadius =
        screenWidth * 0.05; // 5% of screen width for border radius

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02), // 2% of screen width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: containerHeight1,
              margin: EdgeInsets.only(top: screenWidth * 0.04),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius), // Responsive radius
                  topRight: Radius.circular(borderRadius), // Responsive radius
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.07),
                child: Padding(
                  padding:
                      EdgeInsets.all(screenWidth * 0.02), // 2% of screen width
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final GoogleSignInAccount? currentUser =
                          userProvider.userCredential;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          currentUser == null
                              ? Row(
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textSize,
                                      ),
                                    ),
                                    Spacer(), // To push the icon to the end
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: Icon(Icons.person,
                                          color: Colors.white),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      '${currentUser.email}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: textSize,
                                      ),
                                    ),
                                    Spacer(), // To push the icon to the end
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Text(
                                          currentUser.displayName![
                                              0], // Display the first letter of the name
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                              height:
                                  screenHeight * 0.01), // 1% of screen height
                          Text(
                            'Free WiFi access anything and anywhere',
                            style: TextStyle(
                              color: Color.fromARGB(255, 253, 234, 234),
                              fontSize: textSize *
                                  0.8, // Slightly smaller than title text
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            Container(
              width: double.infinity,
              height: screenHeight * 0.36, // 36% of screen height
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.06), // 6% of screen width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Common Tools',
                      style: TextStyle(
                        fontSize: textSize, // Consistent with the text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: screenHeight * 0.02), // 2% of screen height
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Browserscreen()));
                          },
                          child: _buildToolColumn('assets/browse.jpeg',
                              'Browse', imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Security()));
                          },
                          child: _buildToolColumn('assets/safety.jpeg',
                              'Safety', imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpeedTest()));
                          },
                          child: _buildToolColumn('assets/speed2.jpeg', 'Speed',
                              imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.12),
                        GestureDetector(
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
                          child: _buildToolColumn('assets/signal2.jpeg',
                              'Signal', imageWidth, imageHeight, textSize),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: screenHeight * 0.04), // 4% of screen height
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScanDevices(),
                              ),
                            );
                          },
                          child: _buildToolColumn('assets/browse.jpeg', 'Scan',
                              imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.12),
                        GestureDetector(
                          onTap: () {
                            _showInviteBottomSheet(context);
                          },
                          child: _buildToolColumn('assets/safety.jpeg',
                              'Invite', imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FAQScreen(),
                              ),
                            );
                          },
                          child: _buildToolColumn('assets/speed2.jpeg', 'FAQ',
                              imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppSettingsScreen(),
                              ),
                            );
                          },
                          child: _buildToolColumn('assets/signal2.jpeg',
                              'Setting', imageWidth, imageHeight, textSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02), // 2% of screen height
            Container(
              width: double.infinity,
              height: screenHeight * 0.25, // 25% of screen height
              child: Padding(
                padding:
                    EdgeInsets.all(screenWidth * 0.06), // 6% of screen width
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Tools',
                      style: TextStyle(
                        fontSize: textSize, // Consistent with the text size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                        height: screenHeight * 0.02), // 2% of screen height
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackScreen(),
                              ),
                            );
                          },
                          child: _buildToolColumn('assets/browse.jpeg',
                              'Feedback', imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.10),
                        _buildToolColumn('assets/safety.jpeg', 'Cancel',
                            imageWidth, imageHeight, textSize),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            _launchURL();
                          },
                          child: _buildToolColumn('assets/speed2.jpeg',
                              'Rate Us', imageWidth, imageHeight, textSize),
                        ),
                        SizedBox(width: screenWidth * 0.11),
                        GestureDetector(
                          onTap: () {
                            _checkForLatestVersion();
                          },
                          child: _buildToolColumn('assets/signal2.jpeg',
                              'Version', imageWidth, imageHeight, textSize),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolColumn(String imagePath, String title, double imageWidth,
      double imageHeight, double textSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          imagePath,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover, // Ensures the image covers the space
        ),
        SizedBox(height: 8.0), // Space between image and text
        Text(
          title,
          style: TextStyle(
            fontSize: textSize * 0.6, // Slightly smaller for subtitle
          ),
        ),
      ],
    );
  }
}

void _showInviteBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Share to your friend',
              style: TextStyle(fontWeight: FontWeight.bold),
              // style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Text(
              'Share the trick of free WiFi to your friends.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _copyLink();
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.copy,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 8),
                      Text('Copy Link'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showMoreOptions(context);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.more_horiz,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 8),
                      Text('More'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

void _copyLink() {
  final String inviteLink =
      'Hey, I am using the WiFi Master key for free internet access, and the nearby WiFi can be connected for free.Click the link below to download this super APPhttps://en.wifi.com/app_h5/wifiShare/index.html?type=2&language=en'; // Your invite link here
  Clipboard.setData(ClipboardData(text: inviteLink));
  // Optionally, show a snackbar to confirm the action
  // ScaffoldMessenger.of(currentContext!).showSnackBar(
  //   SnackBar(content: Text('Link copied to clipboard!')),
  // );
}

void _showMoreOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share via other apps'),
              onTap: () {
                // Add share functionality here
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Send via Email'),
              onTap: () {
                // Add email functionality here
                Navigator.of(context).pop();
              },
            ),
            // Add more options if needed
          ],
        ),
      );
    },
  );
}

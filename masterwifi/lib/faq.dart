import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Back arrow icon
          onPressed: () {
            Navigator.of(context)
                .pop(); // Navigates back to the previous screen
          },
        ),
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      //backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQItem(
              context,
              'What is WiFi Master?',
              'WiFi Master is an essential tool for Android smart phone users to search for, connect with and manage their WiFi access. Millions of WiFi hotspots are available worldwide.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'How does WiFi Master work?',
              'Launch WiFi Master on your Android smartphone. Go to the "Connect" tab, tap on "WiFi Key Search" to search for available WiFi hotspots nearby. Blue key hotspots are shared and can be connected for free.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'What are Blue Key Hotspots?',
              'Once an encrypted WiFi access is shared by its owner, a blue key icon will appear next to the hotspot. Blue Key Hotspots can be connected by retrieving secure encrypted passwords from our cloud database.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Why does it require mobile data?',
              'WiFi Master requires minimal mobile data to perform "WiFi Key Search", hence to obtain the secure encrypted passwords from our cloud database and to get you connected. Only 10-15KB data will be used for every "WiFi Key Search" performed.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Do I need to pay to use WiFi?',
              'WiFi Master is completely free to use. On top of that, we will organize contests from time to time. Keep an eye on our contests and stand a chance to win big prizes.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Why do I fail to connect?',
              'Please kindly check if there\'s hotspot in the system\'s WiFi list. If yes, please uninstall WiFi Master from your current device. Upon re-installation, please allow WiFi Master to use the device\'s location. After re-installation, you will see the WiFi list after tapping "WiFi Key Search".',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Why can\'t I crack the WiFi password?',
              'WiFi Master is not a cracking tool, and please note that hacking is illegal. We would like to build a sharing community, hence everyone can get connected anywhere, any time.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'What are the other features?',
              'For the good of all users to enjoy free and fast WiFi connection, you can share the hotspot. Note that all shared passwords will be transmitted and stored at our cloud database with 128 bits encryption.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Can I stop sharing?',
              'Absolutely. All password sharing will only be performed with your prior consent. You can turn off sharing any time when you don\'t feel like.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'I found a phishing hotspot!',
              'Please report ASAP by selecting the WiFi hotspot from the list and tapping "Report Phishing”!',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Is my WiFi information safe?',
              'Yes. WiFi Master is a crowdsourcing app for users to share and connect to WiFi hotspots. All shared hotspots are listed with a Blue Key icon. To protect the privacy and security of the sharer, shared passwords are not shown.',
              screenWidth,
              screenHeight,
            ),
            _buildFAQItem(
              context,
              'Personal Information',
              'When you visit our website and/or use our application, we will collect, use and process your personal information such as your mobile phone number, your IP-address, the duration of a visit/session to enable us to deliver the functionalities of the website and our application.',
              screenWidth,
              screenHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer,
      double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: Colors.blue,
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // Responsive spacing
          Text(
            answer,
            style: TextStyle(
              color: Colors.black87,
              fontSize: screenWidth * 0.045, // Responsive font size
            ),
          ),
        ],
      ),
    );
  }
}

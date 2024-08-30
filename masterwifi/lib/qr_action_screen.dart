import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart'; // For Clipboard
// For URL launching

class QrActionScreen extends StatefulWidget {
  final String qrCodeData;

  QrActionScreen({required this.qrCodeData});

  @override
  State<QrActionScreen> createState() => _QrActionScreenState();
}

class _QrActionScreenState extends State<QrActionScreen> {
  // Function to launch URL
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanned'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Connectscreen(),
            //   ),
            // ); // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('QR Code Data:', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(widget.qrCodeData, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.qrCodeData));
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to clipboard')));
                  },
                  child: Text('Copy'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _launchURL(widget.qrCodeData); // Use QR code data as URL
                  },
                  child: Text('Browse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

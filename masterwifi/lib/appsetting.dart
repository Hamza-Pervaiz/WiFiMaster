import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _showStatusBar = false;
  bool _newVersionNotifications = false;
  bool _safetyTest = false;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define responsive font size and spacing
    final double fontSizeHeading = screenWidth * 0.06; // 6% of screen width
    final double fontSizeText = screenWidth * 0.045; // 4.5% of screen width
    final double spacing = screenHeight * 0.02; // 2% of screen height

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APP SETTINGS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // This handles the back navigation
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading for Rules
            Text(
              'Rules',
              style: TextStyle(
                fontSize: fontSizeHeading,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: spacing),

            // Row for Show icon and checkbox
            Row(
              children: [
                Icon(Icons.visibility, color: Colors.blue, size: fontSizeText),
                SizedBox(width: screenWidth * 0.02), // 2% of screen width
                Text(
                  'Show Icon on Status Bar',
                  style: TextStyle(fontSize: fontSizeText),
                ),
                Spacer(),
                Checkbox(
                  value: _showStatusBar,
                  onChanged: (value) {
                    setState(() {
                      _showStatusBar = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: spacing),
            Divider(color: Colors.grey),
            SizedBox(height: spacing),

            // Heading for Reminder
            Text(
              'Reminder',
              style: TextStyle(
                fontSize: fontSizeHeading,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: spacing),

            // First row for New Version Notifications
            Row(
              children: [
                Expanded(
                  child: Text(
                    'New Version Notifications',
                    style: TextStyle(fontSize: fontSizeText),
                  ),
                ),
                Checkbox(
                  value: _newVersionNotifications,
                  onChanged: (value) {
                    setState(() {
                      _newVersionNotifications = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: spacing),

            // Second row for Safety Test
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Safety Test',
                    style: TextStyle(fontSize: fontSizeText),
                  ),
                ),
                Checkbox(
                  value: _safetyTest,
                  onChanged: (value) {
                    setState(() {
                      _safetyTest = value!;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

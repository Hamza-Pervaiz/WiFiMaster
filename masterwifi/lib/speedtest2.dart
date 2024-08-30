import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final double downloadSpeed;
  final double uploadSpeed;
  final String? ipAddress;
  final String? ispName;

  const ResultScreen({
    Key? key,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.ipAddress,
    required this.ispName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AP-5th Floor-2.4G'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D0D0D),
              Color(0xFF1C1C1C),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Adjust row width and font size based on screen width
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: _buildStatisticItem(
                      'Download\n', '${downloadSpeed.toStringAsFixed(1)} Mbps',
                      screenWidth * 0.05, // Responsive font size
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02), // Responsive spacing
                  Flexible(
                    child: _buildStatisticItem(
                      'Upload\n', '${uploadSpeed.toStringAsFixed(1)} Mbps',
                      screenWidth * 0.05, // Responsive font size
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatisticItem(
                      'Network latency', '959ms', screenWidth * 0.04),
                  _buildStatisticItem('Jitter', '2ms', screenWidth * 0.04),
                  _buildStatisticItem(
                      'Packet Loss Rate', '0.87%', screenWidth * 0.04),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        screenWidth * 0.2, // Responsive horizontal padding
                    vertical:
                        screenHeight * 0.02, // Responsive vertical padding
                  ),
                ),
                child: Text(
                  'Check Again',
                  style: TextStyle(
                      fontSize: screenWidth * 0.045), // Responsive font size
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ispName ?? 'ISP Name Not Available',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045, // Responsive font size
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Internal IP: ${ipAddress ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Device: SM-A325F',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Location: (Location is not enabled, and geographic information cannot be obtained)',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticItem(String label, String value, double fontSize) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize, // Responsive font size
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize * 1, // Responsive font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

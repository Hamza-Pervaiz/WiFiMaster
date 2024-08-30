import 'dart:math';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SignalsDetection extends StatefulWidget {
  final int signals;
  final String name;

  SignalsDetection({super.key, required this.signals, required this.name});

  @override
  State<SignalsDetection> createState() => _SignalsDetectionState();
}

class _SignalsDetectionState extends State<SignalsDetection>
    with TickerProviderStateMixin {
  late AnimationController _con;
  late Animation<double> _animation;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _con = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    )..addListener(() {
        if (!_animationCompleted && _animation.value >= 99) {
          _animationCompleted = true;
          _con.stop(); // Stop the animation when value is 94 or above
        }
        setState(() {}); // Rebuild to update progress
      });

    _animation = Tween<double>(begin: 0, end: 100).animate(CurvedAnimation(
      parent: _con,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _con.forward();
  }

  @override
  void dispose() {
    _con.dispose();
    super.dispose();
  }

  int convertDbmToPercentage(int dbm) {
    int maxSignal = -30; // Strongest signal
    int minSignal = -90; // Weakest signal

    if (dbm > maxSignal) dbm = maxSignal;
    if (dbm < minSignal) dbm = minSignal;

    return ((dbm - minSignal) / (maxSignal - minSignal) * 100).toInt();
  }

  String _getStrengthLabel(double strength) {
    if (strength > 0.75) return 'Powerful';
    if (strength > 0.5) return 'Good';
    if (strength > 0.25) return 'Weak';
    return 'None';
  }

  Color _getColorForStrength(double strength) {
    if (strength > 0.75) {
      return Colors.greenAccent[400]!;
    } else if (strength > 0.5) {
      return Colors.yellow[700]!;
    } else if (strength > 0.25) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    int signalPercentage = convertDbmToPercentage(widget.signals);
    double normalizedStrength = signalPercentage / 100;

    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Signal Detection',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0, // Remove shadow
      ),
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.name,
              style: TextStyle(
                fontSize: screenWidth * 0.07, // Larger font size
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: screenWidth * 0.15), // Larger padding
            CircularStepProgressIndicator(
              arcSize: ((pi * 2)),
              totalSteps: 100, // Total number of steps
              currentStep: _animation.value.toInt(), // Animated step value
              stepSize: 38, // Adjust thickness
              selectedColor: Colors.white.withOpacity(0.2),
              unselectedColor: Colors.grey, // More transparent background
              padding: pi / 70,
              startingAngle: 0,
              width: 300, // Diameter of the circle
              height: 300,
              roundedCap: (_, __) => true,
              child: Center(
                child: Text(
                  _animationCompleted
                      ? "${signalPercentage}%"
                      : "${_animation.value.toInt()}%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.12, // Larger font size
                    color: _getColorForStrength(normalizedStrength),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
            if (_animationCompleted)
              Text(
                'Detected Signal Strength: ${_getStrengthLabel(normalizedStrength)}',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            if (_animationCompleted) SizedBox(height: screenWidth * 0.03),
            if (_animationCompleted)
              Text(
                'Please move around to find the strongest connection spot.',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

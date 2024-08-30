import 'dart:async';
import 'package:flutter/material.dart';
// Ensure this path is correct

class SpeedUp extends StatefulWidget {
  const SpeedUp({super.key});

  @override
  State<SpeedUp> createState() => _SpeedUpState();
}

class _SpeedUpState extends State<SpeedUp> with SingleTickerProviderStateMixin {
  Color _backgroundColor = Colors.white;
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.pink,
  ];
  int _currentColorIndex = 0;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
        _backgroundColor = _colors[_currentColorIndex];
      });
    });

    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..addListener(() {
        if (_animationController.isCompleted) {
          _navigateToNextScreen();
        }
      });

    _animation = Tween<double>(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation after a slight delay to ensure the screen is rendered
    Future.delayed(Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Set responsive padding values
    final responsiveTopPadding = screenHeight * 0.2; // 20% of screen height
    final responsiveRightPadding = screenWidth * 0.1; // 10% of screen width

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Speed Up',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _backgroundColor,
      ),
      body: Container(
        color: _backgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: _animation.value,
              left: (screenWidth - screenWidth * 0.30) / 2, // Center the image
              child: GestureDetector(
                onTap: _navigateToNextScreen,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: responsiveTopPadding,
                    right: responsiveRightPadding,
                  ),
                  child: Image.asset(
                    'assets/boost.png', // Update this path to match your asset
                    width: screenWidth * 0.30, // Responsive width
                    height: screenWidth * 0.30, // Responsive height
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

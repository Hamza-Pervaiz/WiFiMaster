import 'package:flutter/material.dart';
import 'package:masterwifi/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _visible = true;
      });
    });

    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background cloud image
          Image.asset(
            'assets/cloud.jpg', // Ensure this path matches your asset directory
            fit: BoxFit.cover,
          ),
          // Overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.6),
                  Colors.white.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Content on top of the background and gradient
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Responsive logo size with animation
                    // SizedBox(
                    //   height: constraints.maxHeight * 0.05,
                    // ),
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(seconds: 3),
                      child: Image.asset(
                        'assets/animation1.png',
                        width: constraints.maxWidth * 0.7,
                        height: constraints.maxHeight * 0.7,
                      ),
                    ),
                    // SizedBox(height: constraints.maxHeight * 0.01),
                    // Responsive text styles with animation
                    AnimatedOpacity(
                      opacity: _visible ? 1.0 : 0.0,
                      duration: Duration(seconds: 2),
                      child: Column(
                        children: [
                          Text(
                            'WiFi Master',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.08,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'World\'s Leading Free Internet Platform',
                            style: TextStyle(
                              fontSize: constraints.maxWidth * 0.05,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // Footer text with cloud background
                    Column(
                      children: [
                        // Image.asset(
                        //   'assets/cloud.jpg', // Ensure this path matches your asset directory
                        //   fit: BoxFit.cover,
                        //   width: constraints.maxWidth,
                        //   height: constraints.maxHeight * 0.1,
                        // ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                width: constraints.maxWidth * 0.1,
                                height: constraints.maxWidth * 0.1,
                              ),
                              SizedBox(
                                height: constraints.maxHeight * 0.07,
                                width: constraints.maxWidth * 0.07,
                              ),
                              // Responsive text styles
                              Text(
                                'WiFi Master',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.07,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '© 2015-2024 LinkSure Network. All Rights Reserved',
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.02,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: constraints.maxHeight * 0.02),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(child: Text('Home Screen Content')),
    );
  }
}

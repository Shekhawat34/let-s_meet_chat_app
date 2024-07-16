import 'package:flutter/material.dart';

import '../../auth/screens/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentPage = 1;

  void _navigateToNextScreen(BuildContext context) {
    if (_currentPage == 1) {
      setState(() {
        _currentPage = 2;
      });
    } else {
      Navigator.pushNamed(context, LoginScreen.routeName);
    }
  }

  void _navigateToPreviousScreen() {
    setState(() {
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _currentPage == 1
                ? _buildFirstScreen(context)
                : _buildSecondScreen(context),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomCard(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 3 / 4,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/cellular.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(), // Empty space to prevent overflow
        ),
      ],
    );
  }

  Widget _buildSecondScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 3 / 4,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mobile.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Container(), // Empty space to prevent overflow
        ),
      ],
    );
  }

  Widget _buildBottomCard(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height / 4 + 20, // Increased height to cover more of the bottom
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Welcome to Let's Meet,a fully functional chat and calling app with some additional functionality",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          if (_currentPage == 1)
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => _navigateToNextScreen(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  backgroundColor: Colors.red,
                  shadowColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('NEXT'),
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _navigateToPreviousScreen,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shadowColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('BACK'),
                ),
                ElevatedButton(
                  onPressed: () => _navigateToNextScreen(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    backgroundColor: Colors.red,
                    shadowColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('NEXT'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

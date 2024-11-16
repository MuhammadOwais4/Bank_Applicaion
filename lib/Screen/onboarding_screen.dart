import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': 'Managing Your Money',
      'description': 'Lorem ipsum is simply dummy text of the printing and typesetting.',
      'image': 'assets/1.png',
    },
    {
      'title': 'Pay All Of Your Monthly Bills',
      'description': 'Lorem ipsum is simply dummy text of the printing and typesetting.',
      'image': 'assets/2.png',
    },
    {
      'title': '24/7 Support & Instant Alerts',
      'description': 'Lorem ipsum is simply dummy text of the printing and typesetting.',
      'image': 'assets/3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // Adjust padding based on screen size
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: screenWidth * 0.04, // Responsive font size
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // Responsive padding
                    child: Column(
                      children: [
                        // Image with Icons
                        Expanded(
                          flex: 7,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                _onboardingData[index]['image']!,
                                height: screenHeight * 0.4, // Responsive height for image
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        // Title and Description Positioned Near Bottom
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                            children: [
                              Text(
                                _onboardingData[index]['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.06, // Responsive title font size
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.02), // Responsive spacing
                              Text(
                                _onboardingData[index]['description']!,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04, // Responsive description font size
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.03), // Responsive spacing
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.1), // Responsive padding
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.02), // Responsive margin
                        height: screenHeight * 0.01, // Responsive dot height
                        width: _currentPage == index ? screenWidth * 0.06 : screenWidth * 0.02, // Responsive dot width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: _currentPage == index
                              ? const Color(0xFF4285F4)
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03), // Responsive spacing
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.08, // Responsive button height
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4285F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.05, // Responsive font size
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

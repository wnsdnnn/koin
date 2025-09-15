import 'package:flutter/material.dart';
import 'package:koin/common/widgets/custom_app_bar.dart';
import 'package:koin/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:koin/user/koin/koin_screen.dart';
import 'package:koin/user/kuration/kuration_screen.dart';
import 'package:koin/user/kommunity/kommunity_screen.dart';
import 'package:koin/user/kamera/kamera_screen.dart';
import 'package:koin/user/my/my_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          KoinScreen(),
          KurationScreen(),
          KommunityScreen(),
          KameraScreen(),
          MyScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}

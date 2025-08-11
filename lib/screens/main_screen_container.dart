import 'package:flutter/material.dart';
import 'package:project/screens/community_screen.dart'; // import 경로 확인
import 'package:project/screens/koin_home_screen.dart'; // import 경로 확인
import 'package:project/screens/kuration_screen.dart'; // import 경로 확인
import 'package:project/screens/my_page_screen.dart'; // 새로 추가된 마이페이지 화면 import

// 메인 화면 컨테이너 (하단 내비게이션 바 관리)
class MainScreenContainer extends StatefulWidget {
  const MainScreenContainer({super.key});

  @override
  State<MainScreenContainer> createState() => _MainScreenContainerState();
}

class _MainScreenContainerState extends State<MainScreenContainer> {
  // 하단 내비게이션 바 선택 인덱스: Koin이 선택된 상태 (인덱스 0)
  int _selectedIndex = 0; // Koin (첫 번째 아이템)

  // 선택된 탭에 따라 다른 화면을 반환하는 함수
  Widget _getScreen(int index) {
    switch (index) {
      case 0: // Koin 탭
        return const KoinHomeScreen();
      case 1: // K-uration 탭
        return const KurationScreen();
      case 2: // Community 탭
        return const CommunityScreen();
      case 3: // Camera 탭
        return const Center(
          child: Text('Camera Screen (준비 중)', style: TextStyle(fontSize: 24)),
        );
      case 4: // My 탭
        return const MyPageScreen(); // 이 부분을 수정하세요.
      default:
        return const Center(child: Text('Unknown Screen'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getScreen(_selectedIndex)), // 선택된 탭에 따라 화면 변경
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true, // 레이블 표시
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility), // Koin (눈 모양 아이콘)
            label: 'Koin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), // K-uration (대시보드/그리드 아이콘)
            label: 'K-uration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people), // Community (사람 아이콘)
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt), // Camera (카메라 아이콘)
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // My (사람 아이콘)
            label: 'My',
          ),
        ],
      ),
    );
  }
}

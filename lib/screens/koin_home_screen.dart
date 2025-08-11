import 'package:flutter/material.dart';

// Koin 홈 화면 (image_7ad61c.png)
class KoinHomeScreen extends StatelessWidget {
  const KoinHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단바 (Koin 로고, 검색 아이콘, 알림 아이콘)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Koin 로고
                const Icon(
                  Icons.visibility,
                  size: 30,
                  color: Color(0xFF4285F4),
                ), // 눈 모양 아이콘 (Koin 로고 대체)
                const SizedBox(width: 8),
                const Text(
                  'Koin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(), // 남은 공간 채우기
                // 검색 아이콘
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    size: 28,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    print('검색 아이콘 클릭');
                  },
                ),
                const SizedBox(width: 8),
                // 알림 아이콘 (빨간 점 포함)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none,
                        size: 28,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        print('알림 아이콘 클릭');
                      },
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // K-uration 큐레이션 카드 섹션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                // 이미지와 유사한 그라데이션
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4285F4), // 시작: 파란색 (이미지 좌상단)
                    Color(0xFF67B2E8), // 중간: 밝은 파란색
                    Color(0xFFBBDEFB), // 끝: 연한 하늘색 (이미지 우하단)
                  ],
                ),
                borderRadius: BorderRadius.circular(15), // 둥근 모서리
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 하단에 배치
                  children: [
                    Text(
                      'K-uration 큐레이션',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Koin 이용 가이드',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '카드뉴스 →',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 메뉴 섹션
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '메뉴',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120, // 메뉴 영역을 위한 임시 높이
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white, // 배경색
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text('메뉴 항목들 (예정)', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 20),

          // 커뮤니티 섹션
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '커뮤니티',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            // Expanded 대신 고정 높이 Container로 변경 (SingleChildScrollView 내부에 Expanded 사용 불가)
            height: 200, // 커뮤니티 영역을 위한 임시 높이
            margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '커뮤니티 게시글 (예정)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16), // 하단바와 커뮤니티 사이 간격
        ],
      ),
    );
  }
}

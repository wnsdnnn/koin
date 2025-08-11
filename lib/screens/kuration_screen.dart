import 'package:flutter/material.dart';
import 'package:project/widgets/card_news_item.dart'; // import 경로 확인

// K-uration 화면
class KurationScreen extends StatefulWidget {
  const KurationScreen({super.key});

  @override
  State<KurationScreen> createState() => _KurationScreenState();
}

class _KurationScreenState extends State<KurationScreen> {
  String _selectedCategoryChip = '전체';

  final List<String> _categoryChips = ['전체', '음식', '장소', '생활', '문화', '행정'];

  final List<Map<String, String>> _cardNewsData = [
    {
      'title': '빙수야 녹지마 녹지마',
      'image': 'https://placehold.co/300x200/4285F4/FFFFFF?text=Bingsu',
      'category': '음식',
    },
    {
      'title': '서울에서 즐기는 전통문화',
      'image': 'https://placehold.co/300x200/ADD8E6/FFFFFF?text=Culture',
      'category': '문화',
    },
    {
      'title': '외국인 필수 생활 팁',
      'image': 'https://placehold.co/300x200/FFD700/FFFFFF?text=LifeTip',
      'category': '생활',
    },
    {
      'title': '부산 해운대 맛집 탐방',
      'image': 'https://placehold.co/300x200/FF6347/FFFFFF?text=BusanFood',
      'category': '음식',
    },
    {
      'title': 'K-pop 댄스 클래스',
      'image': 'https://placehold.co/300x200/98FB98/FFFFFF?text=Kpop',
      'category': '문화',
    },
    {
      'title': '한국 비자 연장 가이드',
      'image': 'https://placehold.co/300x200/DDA0DD/FFFFFF?text=VisaGuide',
      'category': '행정',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 선택된 카테고리에 따라 필터링된 카드 뉴스 데이터
    final List<Map<String, String>> filteredCardNews =
        _selectedCategoryChip == '전체'
        ? _cardNewsData
        : _cardNewsData
              .where((item) => item['category'] == _selectedCategoryChip)
              .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 상단 검색창 및 알림 아이콘
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: '입력하세요',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Stack(
                  children: [
                    const Icon(Icons.notifications_none, size: 30),
                    Positioned(
                      right: 0,
                      top: 0,
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

          // 2. 히어로 섹션 (이미지 + 텍스트 오버레이)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://placehold.co/600x400/87CEEB/FFFFFF?text=Seoul+Bingsu',
                  ), // 플레이스홀더 이미지
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end, // 텍스트를 하단에 배치
                  children: [
                    Text(
                      '빙수야 녹지마 녹지마',
                      style: TextStyle(
                        color: const Color.fromRGBO(
                          255,
                          255,
                          255,
                          0.9,
                        ), // withOpacity 대신 Color.fromRGBO 사용
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        shadows: const [
                          // 텍스트 그림자 추가로 가독성 높임
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '서울 빙수 성지',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28, // 이미지와 유사하게 크게
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      '바로가기 →',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black54,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 3. 카테고리 칩스 섹션
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 가로 스크롤
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: _categoryChips.map((chipLabel) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0), // 칩 사이 간격
                  child: ChoiceChip(
                    label: Text(chipLabel),
                    selected: _selectedCategoryChip == chipLabel,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategoryChip = chipLabel;
                      });
                    },
                    selectedColor: Colors.blue, // 선택 시 파란색
                    labelStyle: TextStyle(
                      color: _selectedCategoryChip == chipLabel
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.bold, // 선택된 칩은 볼드 처리
                    ),
                    backgroundColor: Colors.grey[200], // 기본 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 둥근 모서리
                      side: BorderSide(
                        color: _selectedCategoryChip == chipLabel
                            ? Colors.blue
                            : Colors.grey[400]!,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // 4. 카드 뉴스 섹션 (스크롤 가능)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
              shrinkWrap: true, // ListView/GridView가 Column 내부에 있을 때 필수
              physics:
                  const NeverScrollableScrollPhysics(), // GridView 자체 스크롤 비활성화 (전체 SingleChildScrollView가 담당)
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 2개 아이템
                crossAxisSpacing: 10.0, // 가로 간격
                mainAxisSpacing: 10.0, // 세로 간격
                childAspectRatio: 0.9, // 아이템의 가로/세로 비율 (이미지에 맞춰 조정)
              ),
              itemCount: filteredCardNews.length, // 필터링된 데이터 사용
              itemBuilder: (context, index) {
                final item = filteredCardNews[index];
                return CardNewsItem(
                  title: item['title']!,
                  imageUrl: item['image']!,
                );
              },
            ),
          ),
          const SizedBox(height: 20), // 하단 여백
        ],
      ),
    );
  }
}

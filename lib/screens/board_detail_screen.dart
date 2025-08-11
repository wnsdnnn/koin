import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/create_post_screen.dart';
import 'package:project/widgets/community_post_item.dart';
import 'package:intl/intl.dart';

class BoardDetailScreen extends StatefulWidget {
  final String boardName; // 어떤 게시판인지 받아옴
  const BoardDetailScreen({super.key, required this.boardName});

  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen> {
  String _selectedFilter = '최신순';
  String? _selectedRegion;
  String? _selectedNationality;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _regions = [
    '서울', '부산', '제주', '인천', '경기', '강원', '충청', '전라', '경상', '세종', '대전', '광주', '대구', '울산',
  ];
  final List<String> _nationalityFlags = [
    '🇰🇷 한국', '🇺🇸 미국', '🇯🇵 일본', '🇨🇳 중국', '🇩🇪 독일', '🇫🇷 프랑스', '🇻🇳 베트남', '🇹🇭 태국', '🇵🇭 필리핀', '🇬🇧 영국', '🇦🇺 호주', '🇨🇦 캐나다',
  ];

  // 기존 _formatTime 함수 (변경 없음)
  String _formatTime(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return DateFormat('yyyy.MM.dd').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
  
  // 기존 _showFilterSelectionModal 함수 (UI 일부 수정)
  Future<void> _showFilterSelectionModal(List<String> options, String filterType) async {
    final String? selectedOption = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '$filterType 선택',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Center(child: Text(option)),
                      onTap: () => Navigator.pop(context, option),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selectedOption != null) {
      setState(() {
        if (filterType == '지역') {
          _selectedFilter = '지역';
          _selectedRegion = selectedOption;
          _selectedNationality = null;
        } else if (filterType == '국적') {
          _selectedFilter = '국적';
          _selectedNationality = selectedOption;
          _selectedRegion = null;
        }
      });
    }
  }
  
  // 필터 버튼 위젯
  Widget _buildFilterChip(String label, {VoidCallback? onTap}) {
    bool isSelected = _selectedFilter == label;
    String displayText = label;

    if (label == '지역' && _selectedRegion != null) {
      displayText = _selectedRegion!;
      isSelected = true;
    } else if (label == '국적' && _selectedNationality != null) {
      displayText = _selectedNationality!;
      isSelected = true;
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          displayText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // **수정**: collectionGroup을 사용하여 모든 게시글을 대상으로 하되, category로 필터링
    Query query = _firestore
        .collectionGroup('communityPosts')
        .where('category', isEqualTo: widget.boardName);

    // 필터링 로직 적용
    if (_selectedFilter == '지역' && _selectedRegion != null) {
      query = query.where('region', isEqualTo: _selectedRegion).orderBy('time', descending: true);
    } else if (_selectedFilter == '국적' && _selectedNationality != null) {
      final String flagOnly = _selectedNationality!.split(' ')[0];
      query = query.where('flag', isEqualTo: flagOnly).orderBy('time', descending: true);
    } else { // 최신순 (기본)
      query = query.orderBy('time', descending: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 필터 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                _buildFilterChip('최신순', onTap: () {
                  setState(() {
                    _selectedFilter = '최신순';
                    _selectedRegion = null;
                    _selectedNationality = null;
                  });
                }),
                _buildFilterChip('지역', onTap: () => _showFilterSelectionModal(_regions, '지역')),
                _buildFilterChip('국적', onTap: () => _showFilterSelectionModal(_nationalityFlags, '국적')),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // 게시글 목록
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: query.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // Firestore 색인 생성 링크가 보통 에러 메시지에 포함됩니다.
                  return Center(child: Text('오류가 발생했습니다. Firestore 색인을 확인해주세요.\n${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('게시글이 없습니다.'));
                }

                final posts = snapshot.data!.docs;
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: posts.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final post = posts[index].data() as Map<String, dynamic>;
                    final postId = posts[index].id;
                    final formattedTime = (post['time'] is Timestamp)
                        ? _formatTime(post['time'] as Timestamp)
                        : '방금 전';
                    
                    // 기존에 사용하시던 CommunityPostItem 위젯을 그대로 사용
                    return CommunityPostItem(
                      postId: postId,
                      title: post['title'] ?? '제목 없음',
                      subtitle: post['subtitle'] ?? '내용 없음',
                      time: formattedTime,
                      flag: post['flag'] ?? '❓',
                      authorName: post['authorName'] ?? '익명',
                      postData: post,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(
                // **수정**: 글쓰기 화면에 현재 게시판 이름을 전달
                defaultCategory: widget.boardName,
              ),
            ),
          );
        },
        backgroundColor: const Color(0xFF4285F4),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
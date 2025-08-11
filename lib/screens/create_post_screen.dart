// lib/screens/create_post_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePostScreen extends StatefulWidget {
  // 2번 수정사항: 이전 화면에서 게시판 이름을 전달받기 위한 변수 추가
  final String? defaultCategory;

  const CreatePostScreen({super.key, this.defaultCategory});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? _selectedCategory;
  String? _selectedRegion;
  String? _selectedNationalityFlag;

  // 1번 수정사항: 카테고리 목록을 community_screen.dart 와 통일
  final List<String> _categories = [
    '맛집 게시판',
    '구인구직 게시판',
    '유학/교환학생 게시판',
    '뉴스 게시판',
    '기타'
  ];
  final List<String> _regions = [
    '서울', '부산', '제주', '인천', '경기', '강원', '충청', '전라', '경상', '세종', '대전', '광주', '대구', '울산',
  ];
  // 3번 수정사항: 오타 수정
  final List<String> _nationalityFlags = [
    '🇰🇷 한국', '🇺🇸 미국', '🇯🇵 일본', '🇨🇳 중국', '🇩🇪 독일', '🇫🇷 프랑스', '🇻🇳 베트남', '🇹🇭 태국', '🇵🇭 필리핀', // '필리쉬' -> '필리핀'
    '🇬🇧 영국', '🇦🇺 호주', '🇨🇦 캐나다',
  ];

  @override
  void initState() {
    super.initState();
    // 2번 수정사항: 위젯이 생성될 때 전달받은 defaultCategory가 있으면 _selectedCategory로 설정
    if (widget.defaultCategory != null && _categories.contains(widget.defaultCategory)) {
      _selectedCategory = widget.defaultCategory;
    }
  }

  // 게시글 올리기 함수 (변경 없음)
  Future<void> _uploadPost() async {
    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    if (title.isEmpty ||
        content.isEmpty ||
        _selectedCategory == null ||
        _selectedRegion == null ||
        _selectedNationalityFlag == null) {
      _showMessage(context, '모든 필드를 채워주세요.');
      return;
    }

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showMessage(context, '로그인이 필요합니다.');
        return;
      }

      final String authorId = user.uid;
      final String authorName = user.displayName ?? user.email?.split('@')[0] ?? '익명';
      final String currentFlag = _selectedNationalityFlag!.split(' ')[0];

      final String appId = const String.fromEnvironment('APP_ID', defaultValue: 'default-app-id');
      await FirebaseFirestore.instance
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .add({
        'title': title,
        'subtitle': content,
        'time': FieldValue.serverTimestamp(),
        'flag': currentFlag,
        'region': _selectedRegion,
        'category': _selectedCategory,
        'authorId': authorId,
        'authorName': authorName,
        'likes': 0,
      });

      _showMessage(context, '게시글이 성공적으로 등록되었습니다!');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showMessage(context, '게시글 등록 중 오류가 발생했습니다.');
    }
  }
  
  // 나머지 코드는 이전과 동일합니다...
  void _showMessage(BuildContext context, String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '글쓰기',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _uploadPost,
            child: const Text(
              '등록',
              style: TextStyle(
                color: Color(0xFF4285F4),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField(
              buildContext: context,
              label: '카테고리',
              value: _selectedCategory,
              items: _categories,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              hint: '게시판을 선택해주세요',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration.collapsed(
                hintText: '제목',
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              maxLength: 50,
            ),
            const Divider(),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: const InputDecoration.collapsed(
                hintText: '내용을 입력하세요.',
              ),
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              buildContext: context,
              label: '지역',
              value: _selectedRegion,
              items: _regions,
              onChanged: (newValue) {
                setState(() {
                  _selectedRegion = newValue;
                });
              },
              hint: '관련 지역을 선택해주세요',
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              buildContext: context,
              label: '국적',
              value: _selectedNationalityFlag,
              items: _nationalityFlags,
              onChanged: (newValue) {
                setState(() {
                  _selectedNationalityFlag = newValue;
                });
              },
              hint: '작성자 국적을 선택해주세요',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext buildContext,
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4285F4)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          hint: Text(hint ?? '선택해주세요', style: TextStyle(color: Colors.grey[600])),
        ),
      ],
    );
  }
}
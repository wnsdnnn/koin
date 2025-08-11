// lib/widgets/community_post_item.dart
import 'package:flutter/material.dart';
import 'package:project/screens/post_detail_screen.dart'; // PostDetailScreen import

// 커뮤니티 게시글 아이템 위젯 (Community 화면용)
class CommunityPostItem extends StatelessWidget {
  final String postId; // 게시글 ID를 추가합니다.
  final String title;
  final String subtitle;
  final String time;
  final String flag;
  final String authorName;
  final Map<String, dynamic> postData; // 전체 게시글 데이터를 전달하기 위해 추가합니다.

  const CommunityPostItem({
    super.key,
    required this.postId, // postId를 필수로 받도록 수정
    required this.title,
    required this.subtitle,
    required this.time,
    required this.flag,
    required this.authorName,
    required this.postData, // postData를 필수로 받도록 수정
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector로 감싸서 탭 이벤트 처리
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                PostDetailScreen(postId: postId, postData: postData),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '|',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$flag $authorName',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

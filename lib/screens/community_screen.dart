import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/board_detail_screen.dart';
import 'package:project/screens/post_detail_screen.dart';
import 'package:intl/intl.dart'; // *** 해결: DateFormat을 사용하기 위해 이 줄을 추가합니다! ***

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _boardCategories = [
    '맛집 게시판',
    '행정 게시판',
    '구인구직 게시판',
    '뉴스 게시판',
  ];

  Future<int> _getCommentsCount(String postId) async {
    final String appId = const String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    try {
      final snapshot = await _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .doc(postId)
          .collection('comments')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '커뮤니티',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('게시판'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _boardCategories.length,
              itemBuilder: (context, index) {
                final boardName = _boardCategories[index];
                return _buildLatestPostForBoard(boardName);
              },
            ),

            _buildSectionTitle('실시간 인기 글 🔥'),
            _buildHotPosts(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLatestPostForBoard(String boardName) {
    final String appId = const String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .where('category', isEqualTo: boardName)
          .orderBy('time', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return ListTile(
            title: Text(boardName),
            subtitle: const Text('아직 게시글이 없습니다.'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BoardDetailScreen(boardName: boardName),
                ),
              );
            },
          );
        }

        final latestPostData =
            snapshot.data!.docs.first.data() as Map<String, dynamic>;
        return ListTile(
          title: Text(boardName),
          subtitle: Text(
            latestPostData['title'] ?? '제목 없음',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BoardDetailScreen(boardName: boardName),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHotPosts() {
    final String appId = const String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .where('likedBy', isNotEqualTo: [])
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('인기 글이 없습니다.')),
          );
        }

        List<DocumentSnapshot> posts = snapshot.data!.docs;
        posts.sort((a, b) {
          int likesA =
              (a.data() as Map<String, dynamic>)['likedBy']?.length ?? 0;
          int likesB =
              (b.data() as Map<String, dynamic>)['likedBy']?.length ?? 0;
          return likesB.compareTo(likesA);
        });

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: posts.length > 5 ? 5 : posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final postData = post.data() as Map<String, dynamic>;
              final likesCount = (postData['likedBy'] ?? []).length;

              return FutureBuilder<int>(
                future: _getCommentsCount(post.id),
                builder: (context, commentSnapshot) {
                  final commentsCount = commentSnapshot.data ?? 0;
                  return _buildHotPostCard(
                    post,
                    postData,
                    likesCount,
                    commentsCount,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHotPostCard(
    DocumentSnapshot post,
    Map<String, dynamic> postData,
    int likesCount,
    int commentsCount,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                PostDetailScreen(postId: post.id, postData: postData),
          ),
        );
      },
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    postData['flag'] ?? '❓',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  postData['authorName'] ?? '익명',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatTime(postData['time']),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              postData['title'] ?? '제목 없음',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              postData['subtitle'] ?? '',
              style: TextStyle(color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Text(
              postData['category'] ?? '기타',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                const SizedBox(width: 4),
                Text('$likesCount'),
                const SizedBox(width: 16),
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.blue,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text('$commentsCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    return DateFormat('MM/dd HH:mm').format(timestamp.toDate());
  }
}

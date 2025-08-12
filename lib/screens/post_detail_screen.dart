import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:project/screens/write_post_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.postData,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  String _currentUserName = '익명';
  String _currentAuthorFlag = '❓';

  bool _isLiked = false;
  int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _fetchUserData();

    final List<dynamic> likedBy = widget.postData['likedBy'] ?? [];
    _likesCount = likedBy.length;
    if (_currentUser != null) {
      _isLiked = likedBy.contains(_currentUser!.uid);
    }
  }

  Future<void> _fetchUserData() async {
    if (_currentUser != null) {
      final String appId = const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'default-app-id',
      );
      DocumentSnapshot userDoc = await _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      if (mounted && userDoc.exists) {
        setState(() {
          _currentUserName = userDoc['email']?.split('@')[0] ?? '익명';
          String nationality = userDoc['selectedNationality'] ?? 'Unknown';
          _currentAuthorFlag = _getFlagForNationality(nationality);
        });
      }
    }
  }

  // --- ⬇️ [추가] 게시글 삭제 및 확인 다이얼로그 함수 ⬇️ ---
  Future<void> _showDeleteConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('게시글 삭제'),
          content: const Text('정말로 이 게시글을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            TextButton(
              child: Text('삭제', style: TextStyle(color: Colors.red.shade600)),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _deletePost();
    }
  }

  Future<void> _deletePost() async {
    try {
      final String appId = const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'default-app-id',
      );
      await _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .doc(widget.postId)
          .delete();

      if (mounted) {
        _showMessage('게시글이 삭제되었습니다.');
        Navigator.of(context).pop(); // 상세 화면 닫기
      }
    } catch (e) {
      if (mounted) {
        _showMessage('삭제 중 오류가 발생했습니다.');
      }
    }
  }
  // --- ⬆️ [추가] 게시글 삭제 및 확인 다이얼로그 함수 ⬆️ ---

  Future<void> _toggleLike() async {
    if (_currentUser == null) {
      _showMessage('공감하려면 로그인해야 합니다.');
      return;
    }

    final String appId = const String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    final DocumentReference postRef = _firestore
        .collection('artifacts')
        .doc(appId)
        .collection('public')
        .doc('data')
        .collection('communityPosts')
        .doc(widget.postId);

    final String uid = _currentUser!.uid;

    // UI 즉시 업데이트
    setState(() {
      if (_isLiked) {
        _likesCount -= 1;
        _isLiked = false;
      } else {
        _likesCount += 1;
        _isLiked = true;
      }
    });

    // 서버 업데이트
    try {
      if (_isLiked) {
        // UI가 이미 true로 바뀌었으므로, 서버에 추가
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([uid]),
        });
      } else {
        // UI가 이미 false로 바뀌었으므로, 서버에서 제거
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([uid]),
        });
      }
    } catch (e) {
      // 오류 발생 시 UI 원상 복구
      setState(() {
        if (_isLiked) {
          // 실패했으니 다시 감소
          _likesCount -= 1;
          _isLiked = false;
        } else {
          // 실패했으니 다시 증가
          _likesCount += 1;
          _isLiked = true;
        }
      });
      _showMessage('공감 처리 중 오류가 발생했습니다.');
    }
  }

  Future<void> _addComment() async {
    final String commentText = _commentController.text.trim();
    if (commentText.isEmpty) {
      _showMessage('댓글 내용을 입력해주세요.');
      return;
    }
    if (_currentUser == null) {
      _showMessage('댓글을 작성하려면 로그인해야 합니다.');
      return;
    }

    try {
      final String appId = const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'default-app-id',
      );
      await _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts')
          .doc(widget.postId)
          .collection('comments')
          .add({
            'authorId': _currentUser!.uid,
            'authorName': _currentUserName,
            'authorFlag': _currentAuthorFlag,
            'commentText': commentText,
            'timestamp': FieldValue.serverTimestamp(),
          });
      _commentController.clear();
      // 키보드 숨기기
      FocusScope.of(context).unfocus();
    } catch (e) {
      _showMessage('댓글 작성 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String appId = const String.fromEnvironment(
      'APP_ID',
      defaultValue: 'default-app-id',
    );
    // 현재 사용자가 글 작성자인지 확인
    final bool isAuthor = _currentUser?.uid == widget.postData['authorId'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.postData['category'] ?? '게시판',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // --- ⬇️ [수정] AppBar의 actions 부분 ⬇️ ---
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
          // 작성자일 경우에만 더보기 메뉴 표시
          if (isAuthor)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  // WritePostScreen으로 이동하며 게시물 ID와 기존 데이터를 전달합니다.
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WritePostScreen(
                        // WritePostScreen은 이전에 만든 파일입니다.
                        postId: widget.postId,
                        initialData: widget.postData,
                      ),
                    ),
                  );
                } else if (value == 'delete') {
                  _showDeleteConfirmationDialog();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'edit', child: Text('수정')),
                const PopupMenuItem<String>(value: 'delete', child: Text('삭제')),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.black54),
            ),
        ],
        // --- ⬆️ [수정] AppBar의 actions 부분 ⬆️ ---
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postData['title'] ?? '제목 없음',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _formatTime(widget.postData['time']),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '|',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.postData['flag'] ?? '❓'} ${widget.postData['authorName'] ?? '익명'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  Text(
                    widget.postData['subtitle'] ?? '내용 없음',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(
                        _isLiked
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        '공감 $_likesCount',
                        _toggleLike,
                        color: _isLiked ? Colors.blue : Colors.black54,
                      ),
                      _buildActionButton(Icons.comment_outlined, '댓글', () {}),
                      _buildActionButton(Icons.bookmark_border, '스크랩', () {}),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('artifacts')
                        .doc(appId)
                        .collection('public')
                        .doc('data')
                        .collection('communityPosts')
                        .doc(widget.postId)
                        .collection('comments')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('아직 댓글이 없습니다.'),
                          ),
                        );
                      }
                      final comments = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment =
                              comments[index].data() as Map<String, dynamic>;
                          return CommentItem(comment: comment);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String text,
    VoidCallback onPressed, {
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? Colors.black54),
      label: Text(text, style: TextStyle(color: color ?? Colors.black54)),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                _currentAuthorFlag,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: '댓글을 입력하세요.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _addComment,
          ),
        ],
      ),
    );
  }

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '방금 전';
    DateTime date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) return DateFormat('yyyy.MM.dd').format(date);
    if (difference.inDays > 0) return '${difference.inDays}일 전';
    if (difference.inHours > 0) return '${difference.inHours}시간 전';
    if (difference.inMinutes > 0) return '${difference.inMinutes}분 전';
    return '방금 전';
  }

  String _getFlagForNationality(String nationality) {
    const flags = {
      'Korea': '🇰🇷',
      'USA': '🇺🇸',
      'Japan': '🇯🇵',
      'China': '🇨🇳',
      'Germany': '🇩🇪',
      'France': '🇫🇷',
      'Vietnam': '🇻🇳',
      'Thailand': '🇹🇭',
      'Philippines': '🇵🇭',
      'UK': '🇬🇧',
      'Australia': '🇦🇺',
      'Canada': '🇨🇦',
    };
    return flags[nationality] ?? '❓';
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  const CommentItem({super.key, required this.comment});

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 7) return DateFormat('yyyy.MM.dd').format(date);
    if (difference.inDays > 0) return '${difference.inDays}일 전';
    if (difference.inHours > 0) return '${difference.inHours}시간 전';
    if (difference.inMinutes > 0) return '${difference.inMinutes}분 전';
    return '방금 전';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                comment['authorFlag'] ?? '❓',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment['authorName'] ?? '익명',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment['timestamp']),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment['commentText'] ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          // 댓글의 더보기 메뉴는 여기에 추가할 수 있습니다.
          // IconButton(icon: const Icon(Icons.more_horiz, size: 18, color: Colors.grey), onPressed: () {}),
        ],
      ),
    );
  }
}

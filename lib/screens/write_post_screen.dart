import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WritePostScreen extends StatefulWidget {
  final String? postId;
  final Map<String, dynamic>? initialData;

  const WritePostScreen({super.key, this.postId, this.initialData});

  bool get isEditing => postId != null;

  @override
  State<WritePostScreen> createState() => _WritePostScreenState();
}

class _WritePostScreenState extends State<WritePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ❗️기본으로 선택될 게시판 설정
  String _selectedCategory = '맛집 게시판';

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.initialData != null) {
      _titleController.text = widget.initialData!['title'] ?? '';
      _contentController.text = widget.initialData!['subtitle'] ?? '';
      _selectedCategory = widget.initialData!['category'] ?? '맛집 게시판';
    }
  }

  Future<void> _savePost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('글을 저장하려면 로그인이 필요합니다.')));
      return;
    }

    final String title = _titleController.text.trim();
    final String content = _contentController.text.trim();

    try {
      final String appId = const String.fromEnvironment(
        'APP_ID',
        defaultValue: 'default-app-id',
      );
      final postCollection = _firestore
          .collection('artifacts')
          .doc(appId)
          .collection('public')
          .doc('data')
          .collection('communityPosts');

      final Map<String, dynamic> postData = {
        'title': title,
        'subtitle': content,
        'category': _selectedCategory,
        'lastEdited': FieldValue.serverTimestamp(),
      };

      if (widget.isEditing) {
        await postCollection.doc(widget.postId).update(postData);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게시글이 수정되었습니다.')));
        }
      } else {
        postData['authorId'] = user.uid;
        postData['authorName'] = user.email?.split('@')[0] ?? '익명';
        postData['flag'] = '❓';
        postData['likedBy'] = [];
        postData['time'] = FieldValue.serverTimestamp();

        await postCollection.add(postData);
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게시글이 등록되었습니다.')));
        }
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
      }
    }
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
      appBar: AppBar(
        title: Text(widget.isEditing ? '게시글 수정' : '새 글 작성'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: _savePost,
              child: Text(
                widget.isEditing ? '저장' : '등록',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isEditing)
                TextFormField(
                  initialValue: _selectedCategory,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: '게시판',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  // ❗️실제 게시판 목록으로 수정된 부분
                  items: ['맛집 게시판', '행정 게시판', '구인구직 게시판', '뉴스 게시판']
                      .map(
                        (label) =>
                            DropdownMenuItem(value: label, child: Text(label)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: '게시판 선택',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: '내용',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) =>
                    value == null || value.isEmpty ? '내용을 입력해주세요.' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/screens/login_screen.dart'; // 로그인 화면 import 경로 확인

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  // 로그아웃 함수를 build 메서드 밖으로 이동시켰습니다.
  // 비동기 작업 후 context를 안전하게 사용하기 위해 BuildContext를 인자로 받습니다.
  Future<void> _signOut(BuildContext context) async {
    try {
      // 1. Firebase 로그아웃 실행
      await FirebaseAuth.instance.signOut();

      // 2. 비동기 작업 후, 위젯이 여전히 화면에 있는지 확인 (가장 중요한 부분)
      if (!context.mounted) return;

      // 3. 확인 후 안전하게 화면 이동
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainLoginScreen()), // 로그인 선택 화면으로 이동
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // 4. 오류 발생 시에도 위젯이 화면에 있는지 확인
      if (!context.mounted) return;

      // 5. 안전하게 오류 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그아웃 오류: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 로그인된 사용자 정보 가져오기
    final user = FirebaseAuth.instance.currentUser;
    // 사용자 이메일 변수 초기화
    final userEmail = user?.email ?? '로그인 정보 없음';

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F5F5), // 배경색 변경
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 사용자 이메일 정보 섹션
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 계정 섹션
            _buildSectionHeader('계정'),
            _buildListTile(context, '이메일', trailing: userEmail),
            _buildListTile(context, '비밀번호 변경'),

            // 커뮤니티 섹션
            _buildSectionHeader('커뮤니티'),
            _buildListTile(context, '이용 제한 내역'),
            _buildListTile(context, '관심 키워드 설정'),
            _buildListTile(context, '커뮤니티 이용규칙'),

            // 앱 설정 섹션
            _buildSectionHeader('앱 설정'),
            _buildListTile(context, '다크 모드', trailing: '시스템 기본값'),
            _buildListTile(context, '알림 설정'),
            _buildListTile(context, '암호/지문 잠금'),

            // 이용 안내 섹션
            _buildSectionHeader('이용 안내'),
            _buildListTile(context, '앱 버전', trailing: '8.1.27'),
            _buildListTile(context, '문의하기'),
            _buildListTile(context, '공지사항'),
            _buildListTile(context, '서비스 이용약관'),
            _buildListTile(context, '개인정보 처리방침'),
            _buildListTile(context, '청소년 보호정책'),
            _buildListTile(context, '오픈소스 라이선스'),

            // 기타 섹션
            _buildSectionHeader('기타'),
            _buildListTile(context, '정보 동의 설정'),
            _buildListTile(context, '회원 탈퇴'),
            _buildListTile(
              context,
              '로그아웃',
              // onTap 콜백에서 context를 _signOut 함수로 전달합니다.
              onTap: () => _signOut(context),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 섹션 헤더를 만드는 헬퍼 위젯
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // 리스트 타일을 만드는 헬퍼 위젯
  Widget _buildListTile(
    BuildContext context,
    String title, {
    String? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            if (trailing != null)
              Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 16)),
            if (onTap != null)
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // TapGestureRecognizer를 사용하기 위해 import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/screens/main_screen_container.dart'; // 회원가입 완료 후 메인 화면으로 이동하기 위해 import

// SignUpInfoScreen은 여기에 정의합니다. (방문 정보 입력)
class SignUpInfoScreen extends StatefulWidget {
  const SignUpInfoScreen({super.key});

  @override
  State<SignUpInfoScreen> createState() => _SignUpInfoScreenState();
}

class _SignUpInfoScreenState extends State<SignUpInfoScreen> {
  String? _selectedNationality;
  String? _selectedResidenceType;
  String? _selectedResidencePeriod;

  final List<String> _nationalities = [
    'Germany',
    'USA',
    'Korea',
    'China',
    'Japan',
  ];
  final List<String> _residenceTypes = [
    'Exchange Student',
    'Working Holiday',
    'Tourist',
    'Resident',
  ];
  final List<String> _residencePeriods = [
    '1 Month',
    '3 Months',
    '6 Months',
    '1 Year',
    'More than 1 Year',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '코인을 더욱 유용하게 사용하기 위해',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // 방문 정보 클릭 시 동작 (예: 약관 팝업, 자세한 설명)
              },
              child: const Text(
                '방문 정보를 알려주세요.',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4285F4),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 40),

            _buildDropdownField(
              buildContext: context,
              label: 'Nationality',
              value: _selectedNationality,
              items: _nationalities,
              onChanged: (newValue) {
                setState(() {
                  _selectedNationality = newValue;
                });
              },
            ),
            const SizedBox(height: 25),

            _buildDropdownField(
              buildContext: context,
              label: 'Residence type',
              value: _selectedResidenceType,
              items: _residenceTypes,
              onChanged: (newValue) {
                setState(() {
                  _selectedResidenceType = newValue;
                });
              },
            ),
            const SizedBox(height: 25),

            _buildDropdownField(
              buildContext: context,
              label: 'Residence Period',
              value: _selectedResidencePeriod,
              items: _residencePeriods,
              onChanged: (newValue) {
                setState(() {
                  _selectedResidencePeriod = newValue;
                });
              },
            ),
            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedNationality == null ||
                      _selectedResidenceType == null ||
                      _selectedResidencePeriod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 방문 정보를 선택해주세요.')),
                    );
                    return;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategorySelectionScreen(
                        selectedNationality: _selectedNationality!,
                        selectedResidenceType: _selectedResidenceType!,
                        selectedResidencePeriod: _selectedResidencePeriod!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: RichText(
                text: TextSpan(
                  text: '궁금한 점이 있나요? ',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                      text: '이용 약관',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print('이용 약관 클릭됨');
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4285F4)),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (BuildContext buildContext) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              );
            }).toList();
          },
          hint: Text('Select $label'),
        ),
      ],
    );
  }
}

// CategorySelectionScreen은 여기에 정의합니다. (카테고리/지역/문화 선택)
class CategorySelectionScreen extends StatefulWidget {
  final String selectedNationality;
  final String selectedResidenceType;
  final String selectedResidencePeriod;

  const CategorySelectionScreen({
    super.key,
    required this.selectedNationality,
    required this.selectedResidenceType,
    required this.selectedResidencePeriod,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final Set<String> _selectedCategories = <String>{};
  final Set<String> _selectedRegions = <String>{};
  final Set<String> _selectedCultures = <String>{};

  final List<String> _categories = [
    '여행',
    '생활',
    '취업',
    '문화',
    '교육',
    '교통',
    '음식',
    '쇼핑',
    '기타',
  ];
  final List<String> _regions = [
    '서울',
    '부산',
    '제주',
    '인천',
    '경기',
    '강원',
    '충청',
    '전라',
    '경상',
    '세종',
    '대전',
    '광주',
    '대구',
    '울산',
  ];
  final List<String> _cultures = [
    'K-pop',
    'K-drama',
    '전통문화',
    '현대예술',
    '음식문화',
    '언어학습',
    '스포츠',
    '자연',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '관심사를 선택하고',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              '나에게 맞는 정보를 받아보세요.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            _buildSelectionSection(
              buildContext: context,
              title: '카테고리',
              options: _categories,
              selectedOptions: _selectedCategories,
              onSelected: (option, selected) {
                setState(() {
                  if (selected) {
                    _selectedCategories.add(option);
                  } else {
                    _selectedCategories.remove(option);
                  }
                });
              },
            ),
            const SizedBox(height: 30),

            _buildSelectionSection(
              buildContext: context,
              title: '지역',
              options: _regions,
              selectedOptions: _selectedRegions,
              onSelected: (option, selected) {
                setState(() {
                  if (selected) {
                    _selectedRegions.add(option);
                  } else {
                    _selectedRegions.remove(option);
                  }
                });
              },
            ),
            const SizedBox(height: 30),

            _buildSelectionSection(
              buildContext: context,
              title: '문화',
              options: _cultures,
              selectedOptions: _selectedCultures,
              onSelected: (option, selected) {
                setState(() {
                  if (selected) {
                    _selectedCultures.add(option);
                  } else {
                    _selectedCultures.remove(option);
                  }
                });
              },
            ),
            const SizedBox(height: 50),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('선택된 카테고리: $_selectedCategories');
                  print('선택된 지역: $_selectedRegions');
                  print('선택된 문화: $_selectedCultures');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpCredentialsScreen(
                        selectedCategories: _selectedCategories.toList(),
                        selectedRegions: _selectedRegions.toList(),
                        selectedCultures: _selectedCultures.toList(),
                        selectedNationality: widget.selectedNationality,
                        selectedResidenceType: widget.selectedResidenceType,
                        selectedResidencePeriod: widget.selectedResidencePeriod,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Next', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionSection({
    required BuildContext buildContext,
    required String title,
    required List<String> options,
    required Set<String> selectedOptions,
    required Function(String, bool) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: options.map((option) {
            final bool isSelected = selectedOptions.contains(option);
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) => onSelected(option, selected),
              selectedColor: const Color(0xFF4285F4),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF4285F4)
                      : Colors.grey[400]!,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// SignUpCredentialsScreen은 여기에 정의합니다. (아이디/비밀번호 입력)
class SignUpCredentialsScreen extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedRegions;
  final List<String> selectedCultures;
  final String selectedNationality;
  final String selectedResidenceType;
  final String selectedResidencePeriod;

  const SignUpCredentialsScreen({
    super.key,
    required this.selectedCategories,
    required this.selectedRegions,
    required this.selectedCultures,
    required this.selectedNationality,
    required this.selectedResidenceType,
    required this.selectedResidencePeriod,
  });

  @override
  State<SignUpCredentialsScreen> createState() =>
      _SignUpCredentialsScreenState();
}

class _SignUpCredentialsScreenState extends State<SignUpCredentialsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signUp() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage(context, '이메일과 비밀번호를 모두 입력해주세요.');
      return;
    }
    if (password != confirmPassword) {
      _showMessage(context, '비밀번호가 일치하지 않습니다.');
      return;
    }
    if (password.length < 6) {
      _showMessage(context, '비밀번호는 6자 이상이어야 합니다.');
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;
      if (user != null) {
        final String appId = const String.fromEnvironment(
          'APP_ID',
          defaultValue: 'default-app-id',
        );
        await _firestore
            .collection('artifacts')
            .doc(appId)
            .collection('users')
            .doc(user.uid)
            .set({
              'email': email,
              'uid': user.uid,
              'selectedCategories': widget.selectedCategories,
              'selectedRegions': widget.selectedRegions,
              'selectedCultures': widget.selectedCultures,
              'selectedNationality': widget.selectedNationality,
              'selectedResidenceType': widget.selectedResidenceType,
              'selectedResidencePeriod': widget.selectedResidencePeriod,
              'createdAt': FieldValue.serverTimestamp(),
            });

        _showMessage(context, '회원가입 성공!');

        // 회원가입 성공 후 AuthWrapper가 상태 변경을 감지하도록
        // 현재 라우트 스택을 모두 제거하고 앱의 초기 라우트로 이동합니다.
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainScreenContainer(),
          ), // AuthWrapper가 자동으로 메인으로 이동하지만, 명시적으로 이동할 수도 있습니다.
          (Route<dynamic> route) => false, // 모든 이전 라우트 제거
        );

        // 또는 단순히 팝하여 로그인 화면으로 돌아가게 할 수도 있습니다.
        // Navigator.of(context).popUntil((route) => route.isFirst); // 모든 회원가입 화면 스택 제거 후 MainLoginScreen으로 돌아감
        // 이때는 AuthWrapper가 로그인 성공 상태를 감지하고 MainScreenContainer로 전환해줄 것입니다.
      }
    } on FirebaseAuthException catch (e) {
      String message = '회원가입 실패';
      if (e.code == 'weak-password') {
        message = '비밀번호가 너무 약합니다.';
      } else if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다.';
      } else if (e.code == 'invalid-email') {
        message = '유효하지 않은 이메일 형식입니다.';
      }
      _showMessage(context, message);
    } catch (e) {
      _showMessage(context, '회원가입 중 오류가 발생했습니다: $e');
      print('회원가입 오류: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '회원 정보를 입력해주세요.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '이메일',
                hintText: 'example@email.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4285F4)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: '비밀번호',
                hintText: '6자 이상 입력해주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4285F4)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _confirmPasswordController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                hintText: '비밀번호를 다시 입력해주세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4285F4)),
                ),
              ),
            ),
            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('회원가입', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

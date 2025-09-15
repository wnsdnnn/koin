import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:koin/common/const/colors.dart';

// 1단계: 방문 정보 입력 화면
class SignUpInfoScreen extends StatefulWidget {
  const SignUpInfoScreen({super.key});

  @override
  State<SignUpInfoScreen> createState() => _SignUpInfoScreenState();
}

class _SignUpInfoScreenState extends State<SignUpInfoScreen> {
  String? _selectedNationality;
  String? _selectedLanguage;
  String? _selectedResidenceType;
  String? _selectedResidencePeriod;

  final List<String> _nationalities = [
    'China',
    'Japan',
    'Taiwan',
    'USA',
    'Vietnam',
    'Philippines',
    'Hong Kong',
    'Thailand',
    'Malaysia',
  ];
  final List<String> _languages = [
    'English',
    'Chinese',
    'Japanese',
    'Cantonese (Hong Kong)',
    'Taiwanese',
    'Vietnamese',
    'Thai',
    'Malay',
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: TRANSPARENT_COLOR, // AppBar 배경 투명하게
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: BLACK_COLOR),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GRADIENT_COLOR, // 연한 파란색
              TRANSPARENT_COLOR, // 투명
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                '코인을 더욱 유용하게 사용하기 위해',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: BLACK_COLOR,
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    const TextSpan(
                      text: '방문 정보',
                      style: TextStyle(color: PRIMARY_COLOR),
                    ),
                    const TextSpan(
                      text: '를 알려주세요.',
                      style: TextStyle(color: BLACK_COLOR),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              _buildDropdownField(
                context: context,
                label: 'Nationality',
                value: _selectedNationality,
                items: _nationalities,
                onChanged: (newValue) {
                  setState(() => _selectedNationality = newValue);
                },
              ),
              const SizedBox(height: 30),
              _buildDropdownField(
                context: context,
                label: 'Language',
                value: _selectedLanguage,
                items: _languages,
                onChanged: (newValue) {
                  setState(() => _selectedLanguage = newValue);
                },
              ),
              const SizedBox(height: 30),
              _buildDropdownField(
                context: context,
                label: 'Residence type',
                value: _selectedResidenceType,
                items: _residenceTypes,
                onChanged: (newValue) {
                  setState(() => _selectedResidenceType = newValue);
                },
              ),
              const SizedBox(height: 30),
              _buildDropdownField(
                context: context,
                label: 'Residence Period',
                value: _selectedResidencePeriod,
                items: _residencePeriods,
                onChanged: (newValue) {
                  setState(() => _selectedResidencePeriod = newValue);
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedNationality == null ||
                        _selectedLanguage == null ||
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
                          selectedLanguage: _selectedLanguage!,
                          selectedResidenceType: _selectedResidenceType!,
                          selectedResidencePeriod: _selectedResidencePeriod!,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    foregroundColor: WHITE_COLOR,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
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
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: PRIMARY_COLOR,
          ),
        ),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: PRIMARY_COLOR),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: PRIMARY_COLOR),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            hintText: 'Select $label',
            hintStyle: const TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.grey,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontFamily: 'GapyeongHanseokbong',
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Text(
                item,
                style: const TextStyle(
                  fontFamily: 'GapyeongHanseokbong',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: BLACK_COLOR,
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

// 2단계: 관심사 선택 화면
class CategorySelectionScreen extends StatefulWidget {
  final String selectedNationality;
  final String selectedLanguage;
  final String selectedResidenceType;
  final String selectedResidencePeriod;

  const CategorySelectionScreen({
    super.key,
    required this.selectedNationality,
    required this.selectedLanguage,
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
    '생활정보',
    '관광',
    '법',
    '일자리',
    '결혼',
  ];
  final List<String> _regions = [
    '서울',
    '부산',
    '대전',
    '광주',
    '대구',
    '경기도',
    '강원도',
    '충청북도',
    '충청남도',
    '전라북도',
    '전라남도',
    '경상북도',
    '경상남도',
    '제주도',
    '울산',
  ];
  final List<String> _cultures = [
    '카페',
    '한식',
    '한옥',
    '전통',
    '공예',
    'Game',
    '한국어',
    'K-pop',
    'Music',
    'Movie',
    'Drama',
    'Sport',
    'Museum',
    '대학생',
    'Band',
    'Photo',
    'Book',
  ];

  void _startKoin() {
    print('--- 최종 선택 정보 ---');
    print('Nationality: ${widget.selectedNationality}');
    print('Language: ${widget.selectedLanguage}');
    print('Residence Type: ${widget.selectedResidenceType}');
    print('Residence Period: ${widget.selectedResidencePeriod}');
    print('Categories: ${_selectedCategories.toList()}');
    print('Regions: ${_selectedRegions.toList()}');
    print('Cultures: ${_selectedCultures.toList()}');
    print('--------------------');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('정보가 콘솔에 출력되었습니다. Koin을 시작합니다!')),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // body가 AppBar 뒤로 확장되도록 설정
      backgroundColor: Colors.transparent, // Scaffold의 배경을 투명하게 설정
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar 배경 투명하게
        elevation: 0, // AppBar 아래 그림자 제거
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: BLACK_COLOR),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GRADIENT_COLOR, // 연한 파란색
              TRANSPARENT_COLOR, // 투명
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.4],
          ),
        ),
        child: Stack(
          children: [
            Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 100.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // Column에 좌우 패딩 추가
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: BLACK_COLOR,
                            height: 1.4,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '내가 관심 있는 '),
                            TextSpan(
                              text: '한국 관련 키워드',
                              style: TextStyle(color: PRIMARY_COLOR),
                            ),
                            TextSpan(text: '를\n자유롭게 선택해주세요.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      _buildSelectionSection(
                        title: '카테고리',
                        options: _categories,
                        selectedOptions: _selectedCategories,
                      ),
                      const SizedBox(height: 30),
                      _buildSelectionSection(
                        title: '지역',
                        options: _regions,
                        selectedOptions: _selectedRegions,
                      ),
                      const SizedBox(height: 30),
                      _buildSelectionSection(
                        title: '문화',
                        options: _cultures,
                        selectedOptions: _selectedCultures,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ElevatedButton(
                onPressed: _startKoin,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        SPLASH_COLOR_START,
                        SPLASH_COLOR_MIDDLE,
                        SECONDARY_COLOR,
                      ],
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewPadding.bottom / 2),
                    constraints: const BoxConstraints(
                      minHeight: 60,
                      minWidth: double.infinity,
                    ),
                    child: const Text(
                      'Koin 시작하기',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: WHITE_COLOR,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required List<String> options,
    required Set<String> selectedOptions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: BLACK_COLOR,
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
              showCheckmark: false,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedOptions.add(option);
                  } else {
                    selectedOptions.remove(option);
                  }
                });
              },
              selectedColor: PRIMARY_COLOR,
              labelStyle: TextStyle(
                fontFamily: 'Pretendard',
                color: isSelected ? WHITE_COLOR : PRIMARY_COLOR,
                fontSize: 16,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  color: PRIMARY_COLOR,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

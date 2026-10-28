import 'package:flutter/material.dart';

import 'design/tokens.dart';
import 'screens/report_screen.dart';

void main() => runApp(const ReportProtoApp());

class ReportProtoApp extends StatelessWidget {
  const ReportProtoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report Prototype',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Spoqa',
        scaffoldBackgroundColor: AppColors.white,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      // 넓은 화면(데스크톱 브라우저)에서는 375x812 폰 프레임 안에 띄운다.
      builder: (context, child) => _PhoneFrame(child: child!),
      home: const ReportScreen(),
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  static const _size = Size(375, 812);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    if (screen.width < 500) return child;

    // 창 높이에 맞춰 프레임 전체를 축소한다(최대 1배). FittedBox라 레이아웃 크기 자체가 줄어 잘리지 않는다.
    return ColoredBox(
      color: const Color(0xFF2B2D31),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: _size.width + 24,
            height: _size.height + 24,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(56),
              boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 40, offset: Offset(0, 16))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(44),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(size: _size, padding: EdgeInsets.zero),
                child: SizedBox.fromSize(size: _size, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

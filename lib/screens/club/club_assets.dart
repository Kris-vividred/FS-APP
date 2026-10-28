import 'package:flutter/widgets.dart';

/// 클럽 기록/통계 화면 전용 에셋.
abstract final class ClubImg {
  static const _p = 'assets/images/club/';
  static const gradeS = '${_p}record_grade_s.svg';
  static const gradeB = '${_p}record_grade_b.svg';
  static const arrowDownW12 = '${_p}stats_arrow_down_w_12.svg';
  static const bgLine = '${_p}stats_bg_line.svg';
  static const bottomLine = '${_p}stats_bottomline.svg';
  static const graphDot = '${_p}stats_graph_dot.svg';
}

/// Figma 변수 중 공통 토큰에 없는 색.
abstract final class ClubColors {
  static const barPositive = Color(0xFFA7E4BF); // 그래프 막대(초록)
  static const barNegative = Color(0xFFFFD9D0); // 그래프 막대(주황)
  static const functionalS1 = Color(0xFFFF9D88); // functional/s1
  static const lineTertiary = Color(0xFFADB9C2); // contents/tertiary
}

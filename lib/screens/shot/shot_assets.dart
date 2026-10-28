import 'package:flutter/widgets.dart';

/// 샷 데이터 / 트레이닝 / 스크린 empty 그룹 전용 에셋.
abstract final class ShotImg {
  static const _p = 'assets/images/shot/';
  static const profilePhoto = '${_p}profile_photo.png';
  static const profileDefault = '${_p}profile_default.svg';
  static const clubDriver = '${_p}club_driver.png';
  static const clubDriverShadow = '${_p}club_driver_shadow.png';
  static const gradeS = '${_p}grade_s.svg'; // flGrade 30
  static const gradeSLg = '${_p}grade_s_lg.svg'; // flGrade 36
  static const thumbPlaceholder = '${_p}thumb_placeholder.svg';
}

/// tokens.dart 에 없는 Figma 변수.
abstract final class ShotColors {
  static const contentsDimmed = Color(0xFFD0D7DC); // contents/dimed
  static const functionalS1 = Color(0xFFFF9D88); // functional/s1
  static const thumbnailDim = Color(0x33101214); // transparent/thumbnaildim
}

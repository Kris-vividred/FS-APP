import 'package:flutter/widgets.dart';

/// 스코어카드 공유 화면 에셋 경로.
abstract final class ShareImg {
  static const _p = 'assets/images/share/';

  /// FRIENDS SCREEN 로고(흰색) 132×16 — 기본형 카드 하단.
  static const biLogo = '${_p}bi_logo.svg';

  /// FRIENDS SCREEN 로고(흰색) 122×12 — 편집형 카드.
  static const cardLogo = '${_p}card_logo.svg';
  static const cardCDim = '${_p}card_c_dim.svg';
  static const circleWhite = '${_p}card_circle_white.svg';
  static const circleOutline = '${_p}card_circle_outline.svg';

  static const bgCharacter = '${_p}bg_character.png';

  static const iconCharacter = '${_p}icon_character.svg';
  static const optCourse = '${_p}bg_opt_course.svg';
  static const optCamera = '${_p}bg_opt_camera.svg';
  static const optAlbum = '${_p}bg_opt_album.svg';

  static const thumbA = '${_p}thumb_a.png';
  static const thumbB = '${_p}thumb_b.png';
  static const thumbC = '${_p}thumb_c.png';
  static const thumbD = '${_p}thumb_d.png';
  static const thumbE = '${_p}thumb_e.png';
  static const thumbF = '${_p}thumb_f.png';
}

/// Figma 변수 중 공유 화면에서만 쓰는 색.
abstract final class ShareColors {
  static const surfaceSecondary = Color(0xFFF6F8F9);
  static const borderSecondary = Color(0xFFD0D7DC);
  static const gray700 = Color(0xFF3E454B);
  static const toast = Color(0xFF555F67);
  static const contentsMuted = Color(0xFFECEFF1);

  static const scoreEagle = Color(0xFFFF9D88);
  static const scoreBirdie = Color(0xFFFFD9D0);
  static const scoreBogey = Color(0xFFADB9C2);
  static const scoreDb = Color(0xFFD0D7DC);
  static const scoreUp = Color(0xFFFA5E4C);
  static const scoreDn = Color(0xFF8CD6FF);

  static const reportcard01 = Color(0x66101214);
  static const reportcard02 = Color(0x80101214);
  static const reportcard03 = Color(0xCC101214);
  static const surfaceInverse = Color(0xFF101214);
}

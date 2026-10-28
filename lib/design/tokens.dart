import 'package:flutter/widgets.dart';

/// Figma 변수(contents/*, surface/*, badge/* …)를 그대로 옮긴 색상 토큰.
abstract final class AppColors {
  static const contentsPrimary = Color(0xFF101214);
  static const contentsSecondary = Color(0xFF6C7883);
  static const contentsTertiary = Color(0xFFADB9C2);
  static const contentsBrand = Color(0xFF22BB5F);
  static const white = Color(0xFFFFFFFF);

  static const backgroundSecondary = Color(0xFFF6F8F9);
  static const borderPrimary = Color(0xFFECEFF1);
  static const borderTertiary = Color(0xFFADB9C2);

  static const actionPrimary = Color(0xFF22BB5F);
  static const tabSelected = Color(0xFF101214);
  static const green700 = Color(0xFF1FA856);

  static const badgeQ = Color(0xFF3E454B);
  static const badgeBrand = Color(0xFF22BB5F);
  static const badgeSecondary = Color(0xFF6C7883);
  static const badgeBad = Color(0xFFFA5E4C);

  static const dim = Color(0x99000000);
}

/// 간격/라운드 토큰 (padding/global, radius/md …).
abstract final class AppSpace {
  static const global = 18.0;
  static const radiusSm = 4.0;
  static const radiusMd = 8.0;
  static const radiusXl = 16.0;
}

/// Figma 텍스트 스타일(bold/h4, reg/h5, mid/h7 …)에 대응하는 헬퍼.
/// lineHeight가 "normal"인 스타일은 height를 지정하지 않는다.
abstract final class AppText {
  static const _family = 'Spoqa';
  static const _xs = -0.3;
  static const _sm = -0.2;

  static TextStyle _s(
    double size,
    FontWeight w,
    double ls, {
    double? lh,
    Color color = AppColors.contentsPrimary,
  }) => TextStyle(
    fontFamily: _family,
    fontSize: size,
    fontWeight: w,
    letterSpacing: ls,
    height: lh == null ? null : lh / size,
    color: color,
  );

  static TextStyle bold(
    double size, {
    double? lh,
    Color color = AppColors.contentsPrimary,
  }) => _s(size, FontWeight.w700, _ls(size), lh: lh, color: color);
  static TextStyle medium(
    double size, {
    double? lh,
    Color color = AppColors.contentsPrimary,
  }) => _s(size, FontWeight.w500, _ls(size), lh: lh, color: color);
  static TextStyle regular(
    double size, {
    double? lh,
    Color color = AppColors.contentsPrimary,
  }) => _s(size, FontWeight.w400, _ls(size), lh: lh, color: color);

  // letter-spacing 토큰: 16px = xs, 12–18px = sm, 10px·24px 이상 = rg(0)
  static double _ls(double size) {
    if (size == 16) return _xs;
    if (size >= 12 && size <= 18) return _sm;
    return 0;
  }
}

abstract final class Img {
  static const _p = 'assets/images/';
  static const statusIcons = '${_p}status_icons.svg';
  static const info = '${_p}info.svg';
  static const dropdown = '${_p}dropdown.svg';
  static const dividerV24 = '${_p}divider_v24.svg';
  static const dividerV9 = '${_p}divider_v9.svg';
  static const character = '${_p}character.png';
  static const adMain = '${_p}ad_main.png';
  static const indicatorAd = '${_p}indicator_ad.svg';
  static const gameModeTeam = '${_p}game_mode_team.svg';
  static const gameModeSolo = '${_p}game_mode_solo.svg';
  static const badge1 = '${_p}badge_1.svg';
  static const badge2 = '${_p}badge_2.svg';
  static const badge3 = '${_p}badge_3.svg';
  static const arrowDown12 = '${_p}arrow_down_12.svg';
  static const arrowRight = '${_p}arrow_right.svg';
  static const radarGraph = '${_p}radar_graph.svg';
  static const dotMe = '${_p}dot_me.svg';
  static const dotAvg = '${_p}dot_avg.svg';
  static const navHome = '${_p}nav_home.svg';
  static const navReport = '${_p}nav_report.svg';
  static const navQr = '${_p}nav_qr.svg';
  static const navPin = '${_p}nav_pin.svg';
  static const navVideo = '${_p}nav_video.svg';
  static const sheetBar = '${_p}sheet_bar.svg';
  static const close = '${_p}close.svg';
  static const check = '${_p}check.svg';
  static const appbarBack = '${_p}appbar_back.svg';
}

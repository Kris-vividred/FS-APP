/// 스코어카드 그룹 전용 에셋 경로. 공용 에셋은 `Img`(design/tokens.dart)를 쓴다.
abstract final class ScorecardImg {
  static const _p = 'assets/images/scorecard/';

  // 게임 모드 아이콘 (목록 16px / 베스트 카드 24px / 상세 meta 16px)
  static const modeTrophy = '${_p}mode_trophy.svg';
  static const modeVersus = '${_p}mode_versus.svg';
  static const modeFire = '${_p}mode_fire.svg';
  static const modeTeam24 = '${_p}mode_team_24.svg';
  static const modeFire24 = '${_p}mode_fire_24.svg';
  static const modeStroke = '${_p}mode_stroke.svg';
  static const modeFoursome = '${_p}mode_foursome.svg';

  // gameBadge — 홀인원/이글/콘도르는 공용 Img.badge1~3 재사용
  static const badgeAlbatross = '${_p}badge_albatross.svg';

  // 상세
  static const appbarShare = '${_p}appbar_share.svg';
  static const spacer = '${_p}spacer.svg';
  static const arrowDownScorecard = '${_p}arrow_down_scorecard.svg';
  static const arrow12Filled = '${_p}arrow_12_filled.svg';
  static const profileMe = '${_p}profile_me.svg';
  static const profileRyan = '${_p}profile_ryan.png';
  static const profileCha = '${_p}profile_cha.png';
  static const teamAceLogo = '${_p}team_ace_logo.svg';
  static const teamEpicLogo = '${_p}team_epic_logo.svg';
  static const teamBestLogo = '${_p}team_best_logo.svg';
  static const userIcon = '${_p}user_icon.svg';

  static const legendEagle = '${_p}legend_eagle.svg';
  static const legendBirdie = '${_p}legend_birdie.svg';
  static const legendPar = '${_p}legend_par.svg';
  static const legendUp = '${_p}legend_up.svg';
  static const legendAs = '${_p}legend_as.svg';
  static const legendDown = '${_p}legend_down.svg';

  static const refreshPartA = '${_p}refresh_part_a.svg';
  static const refreshPartB = '${_p}refresh_part_b.svg';
  static const thumbPlaceholder = '${_p}thumb_placeholder.svg';
  static const holePrev = '${_p}hole_prev.svg';
  static const holeNext = '${_p}hole_next.svg';

  static const gradeS = '${_p}grade_s.svg';
  static const gradeA = '${_p}grade_a.svg';
  static const gradeB = '${_p}grade_b.svg';
  static const gradeC = '${_p}grade_c.svg';
}

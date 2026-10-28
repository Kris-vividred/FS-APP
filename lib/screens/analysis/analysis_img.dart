/// 기록 분석(analysis) 그룹 전용 에셋 경로.
abstract final class AnalysisImg {
  static const _p = 'assets/images/analysis/';

  static const share = '${_p}appbar_share.svg';
  static const ball = '${_p}ball.svg';

  // 평균 스코어 — 스코어 분포 반원 그래프 + 범례
  static const scoreSemi = '${_p}score_semi.svg';
  static const scoreLegend = [
    '${_p}legend_1.svg',
    '${_p}legend_2.svg',
    '${_p}legend_3.svg',
    '${_p}legend_4.svg',
    '${_p}legend_5.svg',
  ];

  // 드라이버 샷 분석
  static const driverBgAngleBg = '${_p}driver_bg_angle_bg.svg';
  static const driverAngle01 = '${_p}driver_angle_01.svg';
  static const driverAngle02 = '${_p}driver_angle_02.svg';
  static const driverAngle03 = '${_p}driver_angle_03.svg';
  static const driverBgAngle = '${_p}driver_bg_angle.svg';
  static const driverAnglePoint = '${_p}driver_angle_03_point.svg';

  // 안착률 분석
  static const fairwayMap = '${_p}fairway_map.svg';
  static const fairwayHazard = '${_p}fairway_hazard.svg';

  // 홀컵 적중도
  static const girGreen10m = '${_p}gir_green_10m.svg';
  static const girGreen5m = '${_p}gir_green_5m.svg';
  static const girGreen3m = '${_p}gir_green_3m.svg';
  static const girFlag = '${_p}gir_flag.svg';

  // 퍼트 정확도
  static const puttingSemi = '${_p}putting_semi.svg';
  static const puttLegend = [
    '${_p}putt_legend_1.svg',
    '${_p}putt_legend_2.svg',
    '${_p}putt_legend_3.svg',
  ];
}

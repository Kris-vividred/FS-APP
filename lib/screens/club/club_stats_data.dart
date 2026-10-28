import 'package:flutter/widgets.dart';

import '../../design/tokens.dart';
import 'club_assets.dart';

/// 그래프 범례 한 칸.
typedef LegendItem = (String label, Color color);

/// 클럽별 통계 탭(통계 카드 8종). `q['tab']` 값이 [key].
class StatsTab {
  const StatsTab({
    required this.key,
    required this.label,
    required this.value,
    required this.unit,
    this.decimals = 1,
    this.byClub = false,
    this.legend,
    this.twoTone = false,
  });

  final String key;
  final String label;
  final double value; // 드라이버 기준 평균
  final String unit;
  final int decimals;

  /// 선택한 클럽에 따라 값이 달라지는 항목(거리·속도·높이).
  final bool byClub;

  /// 지정하지 않으면 [label] 한 칸(contents/brand).
  final List<LegendItem>? legend;

  /// 막대를 초록/주황 두 색으로 나누는 탭(백스핀·사이드스핀).
  final bool twoTone;

  List<LegendItem> get legendItems =>
      legend ?? [(label, AppColors.contentsBrand)];

  String format(double v) => v.toStringAsFixed(decimals);
}

const statsTabs = [
  StatsTab(
    key: 'distance',
    label: '비거리',
    value: 220.2,
    unit: 'm',
    byClub: true,
  ),
  StatsTab(key: 'carry', label: '캐리', value: 205.2, unit: 'm', byClub: true),
  StatsTab(
    key: 'ballSpeed',
    label: '볼스피드',
    value: 59.6,
    unit: 'm/s',
    byClub: true,
  ),
  StatsTab(
    key: 'maxHeight',
    label: '최고높이',
    value: 22.2,
    unit: 'm',
    byClub: true,
  ),
  StatsTab(key: 'launchAngle', label: '발사각', value: 13.5, unit: '°'),
  StatsTab(key: 'directionAngle', label: '방향각', value: 10.2, unit: '°'),
  StatsTab(
    key: 'backspin',
    label: '백스핀',
    value: 3536,
    unit: 'rpm',
    decimals: 0,
    twoTone: true,
    legend: [('증가', AppColors.contentsBrand), ('감소', ClubColors.functionalS1)],
  ),
  StatsTab(
    key: 'sidespin',
    label: '사이드스핀',
    value: 1022,
    unit: 'rpm',
    decimals: 0,
    twoTone: true,
    legend: [('왼쪽', AppColors.contentsBrand), ('오른쪽', ClubColors.functionalS1)],
  ),
];

int statsTabIndex(String? key) {
  final i = statsTabs.indexWhere((t) => t.key == key);
  return i < 0 ? 0 : i;
}

/// 클럽 선택 시트(2672:16385) 항목과 값 배율.
const clubOptions = [
  '드라이버',
  '우드',
  '하이브리드',
  '아이언',
  '웨지',
  'PW',
  'SW',
  'AW',
  'LW',
];
const _clubScale = [1.0, 0.88, 0.8, 0.68, 0.45, 0.52, 0.4, 0.44, 0.32];

double clubScale(String club) {
  final i = clubOptions.indexOf(club);
  return i < 0 ? 1 : _clubScale[i];
}

/// 횟수 선택 시트(1726:9797) 항목.
const countOptions = ['최근 1회', '최근 5회', '최근 10회', '최근 20회', '최근 30회'];

/// 그래프 한 점(날짜별).
class GraphPoint {
  const GraphPoint(
    this.date,
    this.ratio,
    this.barHeight,
    this.target,
    this.dotY,
    this.negative,
  );

  final String date;

  /// 평균 대비 비율 — 탭 값에 곱해 막대 라벨을 만든다.
  final double ratio;

  /// Figma 막대 높이(최대 124).
  final double barHeight;

  /// 타겟 안착률(%).
  final int target;

  /// Figma 타겟 그래프 점의 중심 y(그래프 상단 기준).
  final double dotY;

  /// twoTone 탭에서 주황(감소/오른쪽) 막대.
  final bool negative;
}

/// Figma 그래프(2296:48658) 데이터. 비거리 탭 기준 216.1m … 96.3m.
const graphPoints = [
  GraphPoint('12.1', 216.1 / 220.2, 113, 30, 93, false),
  GraphPoint('12.2', 156.1 / 220.2, 74, 0, 109, true),
  GraphPoint('12.17', 96.1 / 220.2, 60, 25, 94, false),
  GraphPoint('1.8', 98.7 / 220.2, 60, 20, 96, true),
  GraphPoint('1.21', 271.1 / 220.2, 124, 35, 85, false),
  GraphPoint('2.1', 250.9 / 220.2, 105, 10, 100, false),
  GraphPoint('2.12', 96.3 / 220.2, 60, 100, 45, true),
];

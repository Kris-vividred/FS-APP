import 'package:flutter/widgets.dart';

import '../../design/tokens.dart';

/// 기록 분석 탭. `q['tab']` 값과 이름이 같다.
enum AnalysisTab { score, driverDistance, fairway, gir, parSave, putting }

AnalysisTab analysisTabFrom(String? v) => AnalysisTab.values.firstWhere(
  (t) => t.name == v,
  orElse: () => AnalysisTab.score,
);

/// Figma `Report/statisticsCard` 하나.
class StatCard {
  const StatCard(this.value, this.unit, this.title);
  final String value;
  final String unit;
  final String title;
}

/// Figma `Badge` (Good / Normal / Bad).
enum Grade {
  good('Good', AppColors.badgeBrand),
  normal('Normal', AppColors.badgeSecondary),
  bad('Bad', AppColors.badgeBad);

  const Grade(this.label, this.color);
  final String label;
  final Color color;
}

/// 제목 + (배지) + 나의 평균 / 동급 평균 블록.
class AverageHeader {
  const AverageHeader({
    required this.title,
    required this.mine,
    required this.peer,
    required this.unit,
    this.grade,
  });

  final String title;
  final Grade? grade;
  final String mine;
  final String peer;
  final String unit;
}

/// Figma `Report/recordCountList` 한 줄.
class RecordRow {
  const RecordRow(this.name, this.value, this.unit, {this.dot});
  final String name;
  final String value;
  final String unit;
  final String? dot;
}

const statCards = {
  AnalysisTab.score: StatCard('90', '타', '타수'),
  AnalysisTab.driverDistance: StatCard('222.7', 'm', '드라이버 거리'),
  AnalysisTab.fairway: StatCard('90.4', '%', '페어웨이 안착률'),
  AnalysisTab.gir: StatCard('60.0', '%', '그린 적중률'),
  AnalysisTab.parSave: StatCard('20.9', '%', '파 세이브율'),
  AnalysisTab.putting: StatCard('2.1', '타', '평균 퍼팅'),
};

const averageHeaders = {
  AnalysisTab.score: AverageHeader(
    title: '평균 타수',
    mine: '90',
    peer: '100',
    unit: '타',
  ),
  AnalysisTab.driverDistance: AverageHeader(
    title: '드라이버 거리',
    grade: Grade.good,
    mine: '183.1',
    peer: '171.9',
    unit: 'm',
  ),
  AnalysisTab.fairway: AverageHeader(
    title: '페어웨이 안착률',
    grade: Grade.normal,
    mine: '60.9',
    peer: '78.3',
    unit: '%',
  ),
  AnalysisTab.gir: AverageHeader(
    title: '그린 적중률',
    grade: Grade.bad,
    mine: '5.2',
    peer: '8.3',
    unit: '%',
  ),
  AnalysisTab.parSave: AverageHeader(
    title: '파 세이브율',
    grade: Grade.normal,
    mine: '20.5',
    peer: '21.3',
    unit: '%',
  ),
  AnalysisTab.putting: AverageHeader(
    title: '평균 퍼팅',
    grade: Grade.good,
    mine: '2.1',
    peer: '2.3',
    unit: '타',
  ),
};

/// 추이 그래프 한 점: 라벨과 그래프(높이 180) 안의 점 중심 y.
typedef GraphPoint = (String label, double y);

/// Figma 최근 10회 그래프(2261:47773)의 점 — 라벨과 y는 시안 값 그대로.
const _points10 = <GraphPoint>[
  ('90', 108.5),
  ('88', 139.5),
  ('78', 161.5),
  ('92', 124.5),
  ('117', 39.5),
  ('92', 39.5),
  ('83', 124.5),
  ('76', 160.5),
  ('85', 142.5),
  ('89', 93.5),
];

/// Figma 최근 5회 그래프(2261:47884)의 점.
const _points5 = <GraphPoint>[
  ('90', 108.5),
  ('88', 140.5),
  ('78', 161.5),
  ('92', 124.5),
  ('117', 39.5),
];

/// 횟수 선택(최근 5/10/20회)에 맞는 그래프 점.
List<GraphPoint> graphPointsFor(String count) => switch (count) {
  '최근 5회' => _points5,
  '최근 20회' => [..._points10, ..._points10],
  _ => _points10,
};

/// 시안 기준 초기 횟수: 평균 스코어·드라이버 비거리는 10회, 나머지는 5회.
String defaultCountFor(AnalysisTab tab) =>
    tab == AnalysisTab.score || tab == AnalysisTab.driverDistance
    ? '최근 10회'
    : '최근 5회';

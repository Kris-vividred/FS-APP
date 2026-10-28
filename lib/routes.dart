import 'package:flutter/material.dart';

/// 쿼리 파라미터(`?tab=fairway&state=empty`)를 받아 화면을 만드는 빌더.
typedef RouteBuilder = Widget Function(Map<String, String> q);

/// 화면 경로. 웹에서는 `#/scorecard` 처럼 주소로 바로 열 수 있다.
abstract final class Routes {
  static const home = '/';
  static const screens = '/screens'; // 전체 화면 목록(디자이너 확인용)

  // A. 스코어카드
  static const scorecardList = '/scorecard';
  static const scorecardDetail = '/scorecard/detail';
  // B. 스코어카드 공유
  static const scorecardShare = '/scorecard/share';
  static const scorecardShareEdit = '/scorecard/share/edit';
  // C. 기록 분석
  static const analysis = '/analysis';
  // D. 클럽
  static const clubRecord = '/club';
  static const clubStats = '/club/stats';
  static const clubDetail = '/club/detail';
  // E. 샷 데이터
  static const shotRecords = '/shot';
  static const shotCompare = '/shot/compare';
}

/// `Navigator.pushNamed(context, Routes.analysis, arguments: {'tab': 'gir'})` 형태로 쓴다.
/// arguments(`Map<String, String>`)와 URL 쿼리는 합쳐져 빌더에 전달된다.
Route<dynamic>? buildRoute(
  RouteSettings settings,
  Map<String, RouteBuilder> table,
) {
  final uri = Uri.parse(settings.name ?? '/');
  final builder = table[uri.path];
  if (builder == null) return null;
  final q = {...uri.queryParameters};
  final args = settings.arguments;
  if (args is Map) args.forEach((k, v) => q['$k'] = '$v');
  return MaterialPageRoute(settings: settings, builder: (_) => builder(q));
}

import '../../routes.dart';
import 'shot_data_screen.dart';

/// E. 샷 데이터 — 내기록/평균기록 비교는 한 화면의 두 탭.
/// 쿼리: tab=records|compare, club=driver|wood3|…|lw, level=beginner|double|…|pga
final Map<String, RouteBuilder> shotRoutes = {
  Routes.shotRecords: (q) => ShotDataScreen.fromQuery(q, tab: 0),
  Routes.shotCompare: (q) => ShotDataScreen.fromQuery(q, tab: 1),
};

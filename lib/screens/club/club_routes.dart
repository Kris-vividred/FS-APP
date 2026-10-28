import '../../routes.dart';
import 'club_screen.dart';

/// 클럽 기록 / 클럽별 통계.
/// - `state=empty` : 빈 상태(가상 데이터 반투명)
/// - `tab=distance|carry|ballSpeed|maxHeight|launchAngle|directionAngle|backspin|sidespin` (통계)
final Map<String, RouteBuilder> clubRoutes = {
  Routes.clubRecord: (q) => ClubScreen(
    initialPage: 0,
    statsTab: q['tab'],
    empty: q['state'] == 'empty',
  ),
  Routes.clubStats: (q) => ClubScreen(
    initialPage: 1,
    statsTab: q['tab'],
    empty: q['state'] == 'empty',
  ),
};

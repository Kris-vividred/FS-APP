import '../../routes.dart';
import 'scorecard_detail_screen.dart';
import 'scorecard_list_screen.dart';

/// A. 스코어카드
/// - `/scorecard?state=best1|empty`
/// - `/scorecard/detail?type=18h|9h|team`
final Map<String, RouteBuilder> scorecardRoutes = {
  Routes.scorecardList: (q) => ScorecardListScreen(state: q['state']),
  Routes.scorecardDetail: (q) =>
      ScorecardDetailScreen(type: q['type'] ?? '18h'),
};

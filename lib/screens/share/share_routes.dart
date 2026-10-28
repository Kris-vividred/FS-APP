import '../../routes.dart';
import 'scorecard_share_edit_screen.dart';
import 'scorecard_share_screen.dart';
import 'share_cards.dart';

/// B. 스코어카드 공유
/// - scorecardShare: `type` = default | team | incomplete
/// - scorecardShareEdit: `type` = default | team, `tab` = background | layout,
///   `layout` = a–f (팀은 a·c·e·f)
final Map<String, RouteBuilder> shareRoutes = {
  Routes.scorecardShare: (q) =>
      ScorecardShareScreen(type: ShareType.parse(q['type'])),
  Routes.scorecardShareEdit: (q) {
    final team = q['type'] == 'team';
    var layout = ShareLayout.parse(q['layout']);
    if (team && layout != null && !ShareLayout.teamSet.contains(layout)) {
      layout = null;
    }
    return ScorecardShareEditScreen(
      team: team,
      initialTab: q['tab'] == 'layout' ? 1 : 0,
      initialLayout: layout,
    );
  },
};

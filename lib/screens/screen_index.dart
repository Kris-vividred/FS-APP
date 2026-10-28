import 'package:flutter/material.dart';

import '../design/components.dart';
import '../design/tokens.dart';
import '../routes.dart';

/// 피그마 프레임 ↔ 프로토타입 화면 대응표. 디자이너가 각 상태를 바로 열어볼 수 있게 한다.
class ScreenIndex extends StatelessWidget {
  const ScreenIndex({super.key});

  static const _groups =
      <(String, List<(String, String, Map<String, String>)>)>[
        (
          '리포트 홈',
          [
            ('Report_Screen', Routes.home, {}),
            ('Report_Screen_empty', Routes.home, {'state': 'empty'}),
            ('Report_Training', Routes.home, {'tab': 'training'}),
            (
              'Report_Training_empty',
              Routes.home,
              {'tab': 'training', 'state': 'empty'},
            ),
          ],
        ),
        (
          '스코어카드',
          [
            ('Scorecard_list', Routes.scorecardList, {}),
            ('Scorecard_list_best1', Routes.scorecardList, {'state': 'best1'}),
            ('Scorecard_list_empty', Routes.scorecardList, {'state': 'empty'}),
            (
              'Scorecard_Detail_stroke_18H',
              Routes.scorecardDetail,
              {'type': '18h'},
            ),
            (
              'Scorecard_Detail_stroke_9H',
              Routes.scorecardDetail,
              {'type': '9h'},
            ),
            ('Scorecard_Detail_team', Routes.scorecardDetail, {'type': 'team'}),
          ],
        ),
        (
          '스코어카드 공유',
          [
            (
              'Scorecard_share_default',
              Routes.scorecardShare,
              {'type': 'default'},
            ),
            ('Scorecard_share_team', Routes.scorecardShare, {'type': 'team'}),
            (
              'Scorecard_share_incomplete',
              Routes.scorecardShare,
              {'type': 'incomplete'},
            ),
            (
              'Scorecard_share_edit',
              Routes.scorecardShareEdit,
              {'type': 'default'},
            ),
            (
              'Scorecard_share_edit_layout_team',
              Routes.scorecardShareEdit,
              {'type': 'team'},
            ),
          ],
        ),
        (
          '기록 분석',
          [
            ('Analysis_score', Routes.analysis, {'tab': 'score'}),
            (
              'Analysis_driverDistance',
              Routes.analysis,
              {'tab': 'driverDistance'},
            ),
            ('Analysis_fairway', Routes.analysis, {'tab': 'fairway'}),
            ('Analysis_gir', Routes.analysis, {'tab': 'gir'}),
            ('Analysis_parSave', Routes.analysis, {'tab': 'parSave'}),
            ('Analysis_putting', Routes.analysis, {'tab': 'putting'}),
          ],
        ),
        (
          '클럽',
          [
            ('Club_record', Routes.clubRecord, {}),
            ('Club_record_empty', Routes.clubRecord, {'state': 'empty'}),
            ('Club_stats (distance)', Routes.clubStats, {'tab': 'distance'}),
            ('Club_stats (sidespin)', Routes.clubStats, {'tab': 'sidespin'}),
            ('Club_stats_empty', Routes.clubStats, {'state': 'empty'}),
            (
              'ClubDetail_shot_wood',
              Routes.clubDetail,
              {'tab': 'shot', 'club': 'wood'},
            ),
            (
              'ClubDetail_shot_hybrid',
              Routes.clubDetail,
              {'tab': 'shot', 'club': 'hybrid'},
            ),
            (
              'ClubDetail_shot_iron8',
              Routes.clubDetail,
              {'tab': 'shot', 'club': 'iron8'},
            ),
            (
              'ClubDetail_target_driver',
              Routes.clubDetail,
              {'tab': 'target', 'club': 'driver'},
            ),
            (
              'ClubDetail_target_hybrid4',
              Routes.clubDetail,
              {'tab': 'target', 'club': 'hybrid4'},
            ),
            (
              'ClubDetail_target_iron8',
              Routes.clubDetail,
              {'tab': 'target', 'club': 'iron8'},
            ),
          ],
        ),
        (
          '샷 데이터',
          [
            ('ShotData_records', Routes.shotRecords, {}),
            ('ShotData_compare', Routes.shotCompare, {}),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SubHeader(title: '전체 화면'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 40),
              children: [
                for (final (group, items) in _groups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpace.global,
                      24,
                      AppSpace.global,
                      8,
                    ),
                    child: Text(group, style: AppText.bold(18, lh: 26)),
                  ),
                  for (final (name, route, q) in items)
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(
                        Uri(
                          path: route,
                          queryParameters: q.isEmpty ? null : q,
                        ).toString(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpace.global,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: AppText.medium(
                                  14,
                                  color: AppColors.contentsSecondary,
                                ),
                              ),
                            ),
                            svg(Img.arrowRight, width: 6, height: 10),
                          ],
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

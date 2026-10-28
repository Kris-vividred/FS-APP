import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'club_common.dart';
import 'club_record_view.dart';
import 'club_stats_view.dart';

/// 클럽 측정 — Header(168: statusbar + appbar + 기록/클럽별 통계 탭) 아래 본문 전환.
/// 0 = 기록(Routes.clubRecord), 1 = 클럽별 통계(Routes.clubStats).
class ClubScreen extends StatefulWidget {
  const ClubScreen({
    super.key,
    required this.initialPage,
    this.statsTab,
    this.empty = false,
  });

  final int initialPage;
  final String? statsTab;
  final bool empty;

  @override
  State<ClubScreen> createState() => _ClubScreenState();
}

class _ClubScreenState extends State<ClubScreen> {
  late int _page = widget.initialPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SubHeader(
            title: '클럽 측정',
            bottom: ClubHeaderTabs(
              index: _page,
              onChanged: (i) => setState(() => _page = i),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _page,
              children: [
                ClubRecordView(empty: widget.empty),
                ClubStatsView(initialTab: widget.statsTab, empty: widget.empty),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

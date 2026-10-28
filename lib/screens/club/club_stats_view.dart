import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'club_assets.dart';
import 'club_common.dart';
import 'club_stats_data.dart';
import 'club_stats_graph.dart';

/// Figma 1177:42572 Club_stats_* (8개 탭) / 1693:46686 Club_stats_empty.
/// Header 아래 72px tab(정렬 칩) + con(통계 카드 8개 + 그래프).
class ClubStatsView extends StatefulWidget {
  const ClubStatsView({
    super.key,
    required this.initialTab,
    required this.empty,
  });

  final String? initialTab;
  final bool empty;

  @override
  State<ClubStatsView> createState() => _ClubStatsViewState();
}

class _ClubStatsViewState extends State<ClubStatsView> {
  late int _tab = statsTabIndex(widget.initialTab);
  String _club = clubOptions.first;
  String _count = countOptions[1];

  Future<void> _pickClub() async {
    final v = await showClubHandleSheet(
      context,
      options: clubOptions,
      selected: _club,
    );
    if (v != null) setState(() => _club = v);
  }

  Future<void> _pickCount() async {
    final v = await showClubHandleSheet(
      context,
      options: countOptions,
      selected: _count,
    );
    if (v != null) setState(() => _count = v);
  }

  @override
  Widget build(BuildContext context) {
    final chips = Row(
      children: [
        _StatsChip(label: _club, onTap: _pickClub),
        const SizedBox(width: 10),
        _StatsChip(label: _count, onTap: _pickCount),
      ],
    );
    final con = Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StatCards(
            selected: _tab,
            scale: clubScale(_club),
            onSelect: (i) => setState(() => _tab = i),
          ),
          const SizedBox(height: 30),
          StatsGraph(tab: statsTabs[_tab], scale: clubScale(_club)),
        ],
      ),
    );

    if (widget.empty) {
      // 빈 상태: tab(172) 안에 InfoText + 반투명 칩, con 반투명.
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(
                20,
              ).copyWith(left: AppSpace.global, right: AppSpace.global),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ClubInfoText(),
                  const SizedBox(height: 20),
                  IgnorePointer(child: Opacity(opacity: 0.5, child: chips)),
                ],
              ),
            ),
            IgnorePointer(child: Opacity(opacity: 0.5, child: con)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 72,
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.global,
            vertical: 20,
          ),
          child: chips,
        ),
        Expanded(child: SingleChildScrollView(child: con)),
      ],
    );
  }
}

/// Figma `sortCombination` 의 sort(선택됨) — ico/arrow_down_w_12.
class _StatsChip extends StatelessWidget {
  const _StatsChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.tabSelected,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 48),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppText.regular(14, lh: 20, color: AppColors.white),
              ),
              const SizedBox(width: 4),
              svg(ClubImg.arrowDownW12, width: 12, height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

/// Figma `Container` — Report/statisticsCard 4열 × 2행. 탭하면 그래프 탭 전환.
class _StatCards extends StatelessWidget {
  const _StatCards({
    required this.selected,
    required this.scale,
    required this.onSelect,
  });

  final int selected;
  final double scale;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    Widget row(int start) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = start; i < start + 4; i++) ...[
          if (i > start) const SizedBox(width: 10),
          Expanded(
            child: _StatCard(
              tab: statsTabs[i],
              value: statsTabs[i].value * (statsTabs[i].byClub ? scale : 1),
              selected: i == selected,
              onTap: () => onSelect(i),
            ),
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
      child: Column(children: [row(0), const SizedBox(height: 10), row(4)]),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.tab,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final StatsTab tab;
  final double value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final main = selected ? AppColors.white : AppColors.contentsPrimary;
    final sub = selected ? AppColors.white : AppColors.contentsSecondary;
    return Material(
      color: selected ? AppColors.actionPrimary : AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(AppSpace.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 78),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tab.format(value),
                      style: AppText.bold(16, lh: 24, color: main),
                    ),
                    const SizedBox(width: 1),
                    Text(
                      tab.unit,
                      style: AppText.regular(14, lh: 20, color: main),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  tab.label,
                  style: AppText.regular(14, lh: 20, color: sub),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

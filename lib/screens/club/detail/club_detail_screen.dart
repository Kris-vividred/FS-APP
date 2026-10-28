import 'package:flutter/material.dart';

import '../../../design/components.dart';
import '../../../design/tokens.dart';
import '../../../routes.dart';
import 'club_detail_charts.dart';
import 'club_detail_data.dart';

/// Figma 02.0.CategoryHome_Report_ClubDetail_{shot|target}_{club}
/// shot: hybrid 1693:46897 · wood 1693:48592 · iron8 1693:48746
/// target: driver 1693:49216 · hybrid4 1693:55759 · iron8 1693:55891
class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({super.key, this.club, this.tab});

  final String? club;
  final String? tab;

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  late String _club = normalizeClub(widget.club);
  late DetailTab _tab = widget.tab == 'target'
      ? DetailTab.target
      : DetailTab.shot;

  ClubDetailData get _data => clubs[_club]!;

  /// clubInfo 영역을 좌우로 밀어 이전/다음 클럽으로 이동.
  void _shiftClub(int dir) {
    final i = clubOrder.indexOf(_club) + dir;
    if (i < 0 || i >= clubOrder.length) return;
    setState(() => _club = clubOrder[i]);
  }

  @override
  Widget build(BuildContext context) {
    final frame = frameKey(_club, _tab);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          _DetailHeader(
            data: _data,
            tab: _tab,
            onSwipe: (v) {
              if (v.abs() < 150) return;
              _shiftClub(v < 0 ? 1 : -1);
            },
          ),
          _DetailTabs(
            index: _tab.index,
            onChanged: (i) => setState(() => _tab = DetailTab.values[i]),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 320,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _tab == DetailTab.shot
                          ? ShotSpreadChart(
                              key: ValueKey('shot-$_club'),
                              data: shotSpreads[frame]!,
                            )
                          : TargetHitChart(
                              key: ValueKey('target-$_club'),
                              data: targetHits[frame]!,
                            ),
                    ),
                  ),
                  Container(height: 12, color: AppColors.backgroundSecondary),
                  _ShotDataSection(
                    stats: statsFor(_club, _tab),
                    onAll: () => Navigator.pushNamed(
                      context,
                      Routes.shotRecords,
                      arguments: {'club': _club},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header (220): statusbar + appbar + clubInfo ─────────────────────────────

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.data,
    required this.tab,
    required this.onSwipe,
  });

  final ClubDetailData data;
  final DetailTab tab;
  final ValueChanged<double> onSwipe;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundSecondary,
      child: Column(
        children: [
          const AppStatusBar(),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: AppSpace.global,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: svg(Img.appbarBack, width: 24, height: 24),
                  ),
                ),
                Text('4월 2일', style: AppText.bold(16, lh: 24)),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (d) => onSwipe(d.primaryVelocity ?? 0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _ClubInfo(
                key: ValueKey('${data.key}-${tab.name}'),
                data: data,
                tab: tab,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubInfo extends StatelessWidget {
  const _ClubInfo({super.key, required this.data, required this.tab});

  final ClubDetailData data;
  final DetailTab tab;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: AppText.bold(
                      16,
                      lh: 24,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        data.distance,
                        style: AppText.bold(
                          20,
                          lh: 30,
                        ).copyWith(letterSpacing: -0.3),
                      ),
                      const SizedBox(width: 10),
                      svg(data.gradeAsset(tab), width: 36, height: 36),
                    ],
                  ),
                ],
              ),
            ),
            _ClubPhotoBox(photo: data.photo),
          ],
        ),
      ),
    );
  }
}

class _ClubPhotoBox extends StatelessWidget {
  const _ClubPhotoBox({required this.photo});

  final ClubPhoto photo;

  @override
  Widget build(BuildContext context) {
    Widget place(Rect r, Widget child) => Positioned(
      left: r.left,
      top: r.top,
      width: r.width,
      height: r.height,
      child: child,
    );
    return SizedBox(
      width: 110,
      height: 100,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          place(
            photo.shadowRect,
            Opacity(
              opacity: photo.shadowOpacity,
              child: Image.asset(photo.shadow, fit: BoxFit.fill),
            ),
          ),
          place(photo.imageRect, Image.asset(photo.image, fit: BoxFit.cover)),
        ],
      ),
    );
  }
}

// ── tabCombination (60) ─────────────────────────────────────────────────────

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['샷분포도', '목표적중률'];
    return SizedBox(
      height: 60,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth / 2;
          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(height: 1, color: AppColors.borderPrimary),
              ),
              Row(
                children: [
                  for (var i = 0; i < 2; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: i == index
                                ? AppText.bold(16, lh: 24)
                                : AppText.regular(16),
                            child: Text(labels[i]),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: w * index,
                width: w,
                bottom: 0,
                child: Container(height: 2, color: AppColors.tabSelected),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── 나의 샷 데이터 (ContainerContentsDefault) ────────────────────────────────

class _ShotDataSection extends StatelessWidget {
  const _ShotDataSection({required this.stats, required this.onAll});

  final List<ClubStat> stats;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.global,
        30,
        AppSpace.global,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('나의 샷 데이터', style: AppText.bold(18, lh: 26)),
          const SizedBox(height: 20),
          for (var r = 0; r < stats.length; r += 3)
            Row(
              children: [
                for (final s in stats.skip(r).take(3))
                  Expanded(child: _DataCard(stat: s)),
              ],
            ),
          const SizedBox(height: 10),
          _OutlineButton(label: '모든 기록 보기', onTap: onAll),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.stat});

  final ClubStat stat;

  @override
  Widget build(BuildContext context) {
    final (label, value) = stat;
    final ready = value != null;
    Widget box(double h, Widget child) => SizedBox(
      height: h,
      child: OverflowBox(maxHeight: 30, child: Center(child: child)),
    );
    return SizedBox(
      height: 108,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          box(
            16,
            Text(
              label,
              style: AppText.regular(
                14,
                lh: 20,
                color: ready
                    ? AppColors.contentsSecondary
                    : AppColors.contentsTertiary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          box(
            18,
            ready
                ? Text(
                    value,
                    style: AppText.bold(
                      16,
                      lh: 24,
                      color: AppColors.contentsBrand,
                    ),
                  )
                : Text(
                    '데이터 준비중',
                    style: AppText.medium(
                      14,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        height: 42,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _down ? AppColors.backgroundSecondary : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
          border: Border.all(color: AppColors.borderTertiary, width: 0.5),
        ),
        child: Text(
          widget.label,
          style: AppText.bold(14, lh: 20, color: AppColors.contentsSecondary),
        ),
      ),
    );
  }
}

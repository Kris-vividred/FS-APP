import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'club_assets.dart';
import 'club_stats_data.dart';

/// Figma `graph`(1177:42616) — legend + 320px 그래프(막대 + 타겟 안착률 꺾은선).
class StatsGraph extends StatelessWidget {
  const StatsGraph({super.key, required this.tab, required this.scale});

  final StatsTab tab;

  /// 선택한 클럽 배율(byClub 탭에만 적용).
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Legend(tab.legendItems),
        const SizedBox(height: 20),
        _Graph(tab: tab, scale: scale),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.items);

  final List<LegendItem> items;

  @override
  Widget build(BuildContext context) {
    final all = [...items, ('타겟안착률', ClubColors.lineTertiary)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '누적 14회 평균',
            style: AppText.medium(14, color: AppColors.contentsTertiary),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              for (final (i, (label, color)) in all.indexed) ...[
                if (i > 0) const SizedBox(width: 20),
                Container(
                  width: 14,
                  height: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: AppText.medium(
                    12,
                    lh: 18,
                    color: AppColors.contentsSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Graph extends StatelessWidget {
  const _Graph({required this.tab, required this.scale});

  final StatsTab tab;
  final double scale;

  static const _w = 375.0;
  static const _h = 320.0;
  static const _baseline = 292.0; // 막대 바닥(bottomline) y
  static const _labelW = 80.0;

  /// 막대/점 중심 x. Figma bar Graph(-13) + Graph Bar(10) + 막대 반폭(12).
  static double _cx(int i) => 9 + 54.0 * i;

  @override
  Widget build(BuildContext context) {
    final pts = graphPoints;
    final s = tab.byClub ? scale : 1.0;
    final values = [for (final p in pts) tab.value * p.ratio * s];
    final maxBar = _argBest(values, (a, b) => a > b);
    final minBar = _argBest(values, (a, b) => a < b);
    final targets = [for (final p in pts) p.target.toDouble()];
    final maxDot = _argBest(targets, (a, b) => a > b);
    final minDot = _argBest(targets, (a, b) => a < b);

    return SizedBox(
      width: _w,
      height: _h,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: 0,
            top: 45,
            child: svg(ClubImg.bgLine, width: 375, height: 248),
          ),
          // 막대
          for (final (i, p) in pts.indexed)
            Positioned(
              left: _cx(i) - 12,
              top: _baseline - p.barHeight,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: p.barHeight,
                decoration: BoxDecoration(
                  color: tab.twoTone && p.negative
                      ? ClubColors.barNegative
                      : ClubColors.barPositive,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
            ),
          Positioned(
            left: 0,
            top: _baseline - 0.25,
            child: svg(ClubImg.bottomLine, width: 375, height: 0.5),
          ),
          // 막대 값 라벨
          for (final (i, p) in pts.indexed)
            _label(
              cx: _cx(i),
              bottom: _baseline - p.barHeight - 4,
              text: '${tab.format(values[i])}${tab.unit}',
              badge: i == maxBar
                  ? '최고'
                  : i == minBar
                  ? '최소'
                  : null,
            ),
          // 날짜
          for (final (i, p) in pts.indexed)
            Positioned(
              left: _cx(i) - _labelW / 2,
              width: _labelW,
              top: 302,
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  p.date,
                  textAlign: TextAlign.center,
                  style: AppText.medium(
                    12,
                    lh: 18,
                    color: AppColors.contentsSecondary,
                  ),
                ),
              ),
            ),
          // 타겟 안착률 꺾은선
          Positioned.fill(
            child: CustomPaint(
              painter: _LinePainter([
                for (final (i, p) in pts.indexed) Offset(_cx(i), p.dotY),
              ]),
            ),
          ),
          for (final (i, p) in pts.indexed) ...[
            Positioned(
              left: _cx(i) - 7,
              top: p.dotY - 7,
              child: svg(ClubImg.graphDot, width: 14, height: 14),
            ),
            _label(
              cx: _cx(i),
              bottom: p.dotY - 7,
              text: '${p.target}%',
              badge: i == maxDot
                  ? '최고'
                  : i == minDot
                  ? '최소'
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  static int _argBest(List<double> v, bool Function(double, double) better) {
    var best = 0;
    for (var i = 1; i < v.length; i++) {
      if (better(v[i], v[best])) best = i;
    }
    return best;
  }

  /// Figma `Graph Details` — (배지 + 2 +) 값 텍스트. [bottom] 은 라벨 하단 y.
  Widget _label({
    required double cx,
    required double bottom,
    required String text,
    String? badge,
  }) {
    final isMax = badge == '최고';
    return Positioned(
      left: cx - _labelW / 2,
      width: _labelW,
      bottom: _h - bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null) ...[
            AppBadge(
              badge,
              color: isMax ? AppColors.badgeBrand : AppColors.badgeSecondary,
            ),
            const SizedBox(height: 2),
          ],
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppText.medium(
              12,
              lh: 18,
              color: isMax
                  ? AppColors.contentsBrand
                  : AppColors.contentsPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.points);

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    // Figma Path 3 는 첫 점 왼쪽 화면 밖(-17, y-6)에서 시작한다.
    final first = points.first;
    final path = Path()..moveTo(first.dx - 26, first.dy - 6);
    for (final p in points) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = ClubColors.lineTertiary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.points != points;
}

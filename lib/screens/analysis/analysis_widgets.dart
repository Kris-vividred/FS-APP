import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'analysis_data.dart';

/// 그래프 진입 애니메이션 진행도(0→1)를 자식에게 넘겨주는 빌더.
/// key가 바뀌면(탭/횟수 변경) 다시 재생된다.
class EntryProgress extends StatelessWidget {
  const EntryProgress({
    super.key,
    required this.builder,
    this.duration = const Duration(milliseconds: 900),
  });

  final Widget Function(BuildContext, double t) builder;
  final Duration duration;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: duration,
    curve: Curves.easeOutCubic,
    builder: (ctx, t, _) => builder(ctx, t),
  );
}

/// 살짝 떠오르며 나타나는 가벼운 진입 효과.
class FadeRise extends StatelessWidget {
  const FadeRise({super.key, required this.child, this.delayFraction = 0});

  final Widget child;

  /// 0~1: 애니메이션 앞부분을 비워 순차적으로 보이게 한다.
  final double delayFraction;

  @override
  Widget build(BuildContext context) => EntryProgress(
    duration: const Duration(milliseconds: 700),
    builder: (_, t) {
      final v = ((t - delayFraction) / (1 - delayFraction)).clamp(0.0, 1.0);
      return Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(0, 12 * (1 - v)),
          child: Transform.scale(scale: 0.96 + 0.04 * v, child: child),
        ),
      );
    },
  );
}

/// Figma `Report/statisticsCard` — 선택되면 브랜드 그린.
class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.card,
    required this.selected,
    required this.onTap,
  });

  final StatCard card;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.white : AppColors.contentsPrimary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        constraints: const BoxConstraints(minHeight: 78),
        // 가로 패딩 12는 시안과 같지만 긴 제목(페어웨이 안착률)이 가운데서 넘치도록 0으로 둔다.
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.actionPrimary
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(card.value, style: AppText.bold(16, lh: 24, color: fg)),
                const SizedBox(width: 1),
                Text(card.unit, style: AppText.regular(14, lh: 20, color: fg)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              card.title,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: AppText.regular(
                14,
                lh: 20,
                color: selected ? AppColors.white : AppColors.contentsSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `LabelContents` 제목(bold/h2).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: AppText.bold(18, lh: 26));
}

/// 섹션 제목 + 오른쪽 날짜.
class DatedTitle extends StatelessWidget {
  const DatedTitle(this.title, {super.key, this.date = '2024.2.17'});
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: SectionTitle(title)),
      Text(
        date,
        style: AppText.regular(14, lh: 20, color: AppColors.contentsTertiary),
      ),
    ],
  );
}

/// 제목(+배지) · 나의 평균 · 동급 평균.
class AverageTitle extends StatelessWidget {
  const AverageTitle(this.data, {super.key});
  final AverageHeader data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(data.title),
              if (data.grade != null) ...[
                const SizedBox(height: 8),
                AppBadge(data.grade!.label, color: data.grade!.color),
              ],
            ],
          ),
        ),
        const SizedBox(width: 20),
        _Average(
          label: '나의 평균',
          value: data.mine,
          unit: data.unit,
          color: AppColors.contentsBrand,
        ),
        const SizedBox(width: 20),
        _Average(
          label: '동급 평균',
          value: data.peer,
          unit: data.unit,
          color: AppColors.contentsSecondary,
        ),
      ],
    );
  }
}

class _Average extends StatelessWidget {
  const _Average({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(label, style: AppText.medium(14, color: AppColors.contentsTertiary)),
      const SizedBox(height: 6),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: AppText.bold(20, lh: 30, color: color)),
          Text(unit, style: AppText.regular(18, color: color)),
        ],
      ),
    ],
  );
}

/// Figma `Report/recordCountList` 목록(폭 260, 간격 12).
class RecordList extends StatelessWidget {
  const RecordList(this.rows, {super.key});
  final List<RecordRow> rows;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 260,
    child: Column(
      children: [
        for (final (i, r) in rows.indexed) ...[
          if (i > 0) const SizedBox(height: 12),
          SizedBox(
            height: 24,
            child: Row(
              children: [
                if (r.dot != null) ...[
                  svg(r.dot!, width: 12, height: 12),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    r.name,
                    style: AppText.regular(
                      16,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
                ),
                Text(r.value, style: AppText.bold(16, lh: 24)),
                if (r.unit.isNotEmpty) ...[
                  const SizedBox(width: 1),
                  Text(r.unit, style: AppText.regular(16)),
                ],
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

/// 추이 그래프(높이 180). 점 간격 82.5 — 5회는 339 폭에 맞고,
/// 10회 이상은 가로 스크롤된다. 선이 왼쪽부터 그려지는 진입 효과.
class TrendGraph extends StatelessWidget {
  const TrendGraph({super.key, required this.points});

  final List<GraphPoint> points;

  static const height = 180.0;
  static const step = 82.5;
  static const avgY = 74.0;

  static double xOf(int i) => 4.5 + i * step;

  @override
  Widget build(BuildContext context) {
    final width = xOf(points.length - 1) + 4.5;
    // 시안처럼 스크롤 영역은 화면 오른쪽 끝까지 이어진다(오른쪽 global 여백만큼 넘침).
    // 그래서 오른쪽 여백에 걸친 점·라벨(예: 117)이 잘리지 않는다.
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, c) => OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: c.maxWidth + AppSpace.global,
          maxWidth: c.maxWidth + AppSpace.global,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: AppSpace.global),
            child: EntryProgress(
              duration: const Duration(milliseconds: 1100),
              builder: (_, t) => SizedBox(
                width: width,
                height: height,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _TrendPainter(points, t)),
                    ),
                    for (final (i, p) in points.indexed) _label(i, p, width, t),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(int i, GraphPoint p, double width, double t) {
    // 점이 지나간 뒤에 라벨이 나타난다.
    final reveal = xOf(i) / width;
    final o = ((t - reveal) * 6 + 1).clamp(0.0, 1.0);
    final text = Opacity(
      opacity: o,
      child: Text(p.$1, style: AppText.bold(16, lh: 24)),
    );
    // 라벨(24) · 간격 4 · 점(9) 세로 배치 — 첫/마지막 점은 양 끝 정렬.
    final top = p.$2 - 4.5 - 4 - 24;
    if (i == 0) return Positioned(left: 0, top: top, child: text);
    if (i == points.length - 1) {
      return Positioned(right: 0, top: top, child: text);
    }
    return Positioned(
      left: xOf(i) - 40,
      width: 80,
      top: top,
      child: Center(child: text),
    );
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.points, this.t);

  final List<GraphPoint> points;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final pts = [
      for (final (i, p) in points.indexed) Offset(TrendGraph.xOf(i), p.$2),
    ];
    final left = pts.first.dx;
    final right = pts.last.dx;
    final bottom = size.height;

    // 동급 평균 점선 (1px 선, 4px 간격)
    final dash = Paint()
      ..color = AppColors.contentsSecondary
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (var x = left; x <= right; x += 4) {
      canvas.drawLine(
        Offset(x, TrendGraph.avgY),
        Offset(math.min(x + 0.5, right), TrendGraph.avgY),
        dash,
      );
    }

    // 왼쪽부터 드러나는 클립
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(0, 0, left + (right - left + 10) * t, bottom),
    );

    final area = Path()..moveTo(left, pts.first.dy);
    for (final p in pts.skip(1)) {
      area.lineTo(p.dx, p.dy);
    }
    area
      ..lineTo(right, bottom - 8)
      ..arcToPoint(Offset(right - 8, bottom), radius: const Radius.circular(8))
      ..lineTo(left + 8, bottom)
      ..arcToPoint(Offset(left, bottom - 8), radius: const Radius.circular(8))
      ..close();
    canvas.drawPath(area, Paint()..color = const Color(0xFFA7E4BF));

    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final p in pts.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.contentsBrand
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.restore();

    final dot = Paint()..color = AppColors.contentsBrand;
    final revealX = left + (right - left + 10) * t;
    for (final p in pts) {
      if (p.dx > revealX) continue;
      canvas.drawCircle(p, 4.5, dot);
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) => old.t != t || old.points != points;
}

/// 반원 그래프를 왼쪽(180°)부터 시계 방향으로 펼쳐 보이는 클리퍼.
class SweepClipper extends CustomClipper<Path> {
  SweepClipper(this.t, {required this.center});

  final double t;
  final Offset center;

  @override
  Path getClip(Size size) {
    final r = size.longestSide * 2;
    return Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: r),
        math.pi,
        math.pi * t,
        false,
      )
      ..close();
  }

  @override
  bool shouldReclip(SweepClipper old) => old.t != t;
}

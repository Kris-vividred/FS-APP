import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../design/components.dart';
import '../../../design/tokens.dart';
import 'club_detail_data.dart';

const _grey100 = Color(0xFFECEFF1);
const _lineGrey = Color(0xFFADB9C2);

/// 진입 애니메이션을 한 번 재생하는 공통 베이스.
mixin _EntryAnim<T extends StatefulWidget>
    on State<T>, SingleTickerProviderStateMixin<T> {
  late final AnimationController anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..forward();

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }
}

double _interval(
  double t,
  double begin,
  double end, [
  Curve c = Curves.linear,
]) => c.transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

// ── 샷분포도 (graphContainer 375×320) ─────────────────────────────────────────

class ShotSpreadChart extends StatefulWidget {
  const ShotSpreadChart({super.key, required this.data});

  final ShotSpread data;

  @override
  State<ShotSpreadChart> createState() => _ShotSpreadChartState();
}

class _ShotSpreadChartState extends State<ShotSpreadChart>
    with SingleTickerProviderStateMixin, _EntryAnim {
  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Center(
      child: SizedBox(
        width: 375,
        height: 320,
        child: Stack(
          children: [
            Positioned(
              left: 62,
              top: 35,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: anim,
                  curve: const Interval(0, 0.35),
                ),
                child: svg(ClubDetailImg.shotBg, width: 251.136, height: 250),
              ),
            ),
            Positioned(
              left: 94.25,
              top: 106.59,
              child: AnimatedBuilder(
                animation: anim,
                builder: (_, _) => CustomPaint(
                  size: const Size(95.4545, 82.9545),
                  painter: _BallPainter(dots: d.dots, t: anim.value),
                ),
              ),
            ),
            Positioned(
              left: 24,
              top: 36,
              child: _DiffLabel(
                title: '앞, 뒤 차이',
                value: d.frontBack,
                end: false,
              ),
            ),
            Positioned(
              right: 24,
              top: 36,
              child: _DiffLabel(title: '좌,우 차이', value: d.leftRight, end: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiffLabel extends StatelessWidget {
  const _DiffLabel({
    required this.title,
    required this.value,
    required this.end,
  });

  final String title;
  final String value;
  final bool end;

  @override
  Widget build(BuildContext context) {
    final align = end ? Alignment.centerRight : Alignment.centerLeft;
    Widget line(String s, double h, Color c) => SizedBox(
      height: h,
      child: OverflowBox(
        maxHeight: 20,
        alignment: align,
        child: Text(s, style: AppText.bold(14, lh: 20, color: c)),
      ),
    );
    return Column(
      crossAxisAlignment: end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        line(title, 12, AppColors.contentsSecondary),
        const SizedBox(height: 6),
        line(value, 18, AppColors.contentsPrimary),
      ],
    );
  }
}

class _BallPainter extends CustomPainter {
  _BallPainter({required this.dots, required this.t});

  final List<Offset> dots;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = _interval(t, 0.1, 0.55, Curves.easeOutBack);
    if (s > 0) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: size.width * s,
          height: size.height * s,
        ),
        Paint()..color = AppColors.contentsBrand.withValues(alpha: 0.3),
      );
    }
    final dot = Paint()..color = AppColors.contentsPrimary;
    for (final (i, p) in dots.indexed) {
      final start = 0.35 + i * 0.045;
      final k = _interval(t, start, start + 0.2, Curves.easeOutBack);
      if (k <= 0) continue;
      // 중심에서 제자리로 퍼져 나간다.
      final pos = Offset.lerp(center, p, k.clamp(0.0, 1.2))!;
      canvas.drawCircle(pos, 2.27273 * k.clamp(0.0, 1.0), dot);
    }
  }

  @override
  bool shouldRepaint(_BallPainter old) => old.t != t || old.dots != dots;
}

// ── 목표적중률 (graphContainer 375×320) ───────────────────────────────────────

class TargetHitChart extends StatefulWidget {
  const TargetHitChart({super.key, required this.data});

  final TargetHit data;

  @override
  State<TargetHitChart> createState() => _TargetHitChartState();
}

class _TargetHitChartState extends State<TargetHitChart>
    with SingleTickerProviderStateMixin, _EntryAnim {
  @override
  Widget build(BuildContext context) {
    final lane = widget.data.shape == TargetShape.lane;
    // 퍼센트 라벨 세로 중심(Figma 텍스트 박스 기준)
    final centers = lane
        ? const [120.0, 167.0, 215.0, 269.0]
        : const [145.0, 199.0, 240.0, 287.0];
    return Center(
      child: SizedBox(
        width: 375,
        height: 320,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: anim,
                builder: (_, _) => CustomPaint(
                  painter: lane
                      ? _LanePainter(anim.value)
                      : _RingPainter(anim.value),
                ),
              ),
            ),
            for (final (i, cy) in centers.indexed)
              Positioned(
                left: lane ? 1 : 0,
                right: 0,
                top: cy - 15,
                height: 30,
                child: _Percent(
                  value: widget.data.percents[i],
                  anim: CurvedAnimation(
                    parent: anim,
                    curve: Interval(
                      0.35 + i * 0.1,
                      0.75 + i * 0.06,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Percent extends StatelessWidget {
  const _Percent({required this.value, required this.anim});

  final int value;
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 6 * (1 - anim.value)),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${(value * anim.value).round()}',
                    style: AppText.bold(18, lh: 26),
                  ),
                  TextSpan(text: '%', style: AppText.regular(18, lh: 26)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _dashed(Canvas canvas, Offset a, Offset b) {
  final paint = Paint()
    ..color = _lineGrey
    ..strokeWidth = 0.5;
  final total = (b - a).distance;
  final dir = (b - a) / total;
  const dash = 3.0, gap = 4.0;
  for (var d = 0.0; d < total; d += dash + gap) {
    canvas.drawLine(a + dir * d, a + dir * math.min(d + dash, total), paint);
  }
}

/// 드라이버·우드·하이브리드 — U자 레인 + 목표 필.
class _LanePainter extends CustomPainter {
  _LanePainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    const clip = Rect.fromLTWH(48, 0, 280, 240);
    canvas.save();
    canvas.clipRect(clip);

    // U 레인 — 위에서 아래로 내려오며 나타남
    final band = _interval(t, 0, 0.45, Curves.easeOutCubic);
    canvas.save();
    canvas.translate(0, -24 * (1 - band));
    final u = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(48, -280, 280, 520),
          const Radius.circular(140),
        ),
      )
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(98, -230, 180, 420),
          const Radius.circular(90),
        ),
      );
    canvas.drawPath(u, Paint()..color = _grey100.withValues(alpha: band));
    canvas.restore();

    // 목표 필 — 아래로 자라남
    final grow = _interval(t, 0.2, 0.75, Curves.easeOutCubic);
    if (grow > 0) {
      final bottom = -102 + (146 + 102) * grow;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(148, -182, 228, bottom),
          const Radius.circular(40),
        ),
        Paint()..color = AppColors.contentsBrand.withValues(alpha: 0.3),
      );
    }

    _dashed(canvas, const Offset(188, 0), const Offset(188, 240));
    _dashed(canvas, const Offset(48, 120), const Offset(328, 120));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_LanePainter old) => old.t != t;
}

/// 아이언 — 동심원 타깃.
class _RingPainter extends CustomPainter {
  _RingPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    const c = Offset(187.5, 145);
    final outer = _interval(t, 0, 0.45, Curves.easeOutCubic);
    canvas.drawCircle(
      c,
      115 * (0.85 + 0.15 * outer),
      Paint()..color = _grey100.withValues(alpha: outer),
    );
    canvas.drawCircle(
      c,
      75 * (0.85 + 0.15 * outer),
      Paint()..color = Colors.white,
    );
    final core = _interval(t, 0.25, 0.7, Curves.easeOutBack);
    if (core > 0) {
      canvas.drawCircle(
        c,
        35 * core,
        Paint()..color = AppColors.contentsBrand.withValues(alpha: 0.3),
      );
    }
    _dashed(
      canvas,
      const Offset(72.5, 30 + 114.79),
      const Offset(302.5, 30 + 114.79),
    );
    _dashed(canvas, const Offset(187.5, 30), const Offset(187.5, 260));
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.t != t;
}

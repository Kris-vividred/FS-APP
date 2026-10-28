import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'scorecard_img.dart';
import 'scorecard_widgets.dart';

/// 1px 가로 구분선 (dividerDefault).
class HLine extends StatelessWidget {
  const HLine({super.key, this.color = AppColors.borderPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 1, color: color);
}

/// 숫자(bold) + 단위(regular) — Figma MyGradeValue / DistanceValue.
class ValueText extends StatelessWidget {
  const ValueText(this.value, this.unit, {super.key});

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(value, style: AppText.bold(14, lh: 20)),
      const SizedBox(width: 1),
      Text(unit, style: AppText.regular(14, lh: 20)),
    ],
  );
}

/// 스코어카드 한 줄 — 제목(33) · 16 · 값 10칸(290, space-between).
class _ScoreLine extends StatelessWidget {
  const _ScoreLine({
    required this.title,
    required this.cells,
    this.background = AppColors.white,
  });

  final String title;
  final List<Widget> cells;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
      child: Row(
        children: [
          SizedBox(
            width: 33,
            child: OverflowBox(
              maxWidth: 52,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.medium(
                  12,
                  lh: 18,
                  color: AppColors.contentsSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final c in cells)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: OverflowBox(maxWidth: 40, child: Center(child: c)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _plain(String t, {bool bold = false, Color? color}) => Text(
  t,
  textAlign: TextAlign.center,
  style: bold
      ? AppText.bold(12, color: color ?? AppColors.contentsSecondary)
      : AppText.medium(12, lh: 18, color: color ?? AppColors.contentsSecondary),
);

/// Report/scorecardHoleILabel (OUT 1‥9 / IN 10‥18).
class HoleLabelRow extends StatelessWidget {
  const HoleLabelRow({super.key, required this.isIn});

  final bool isIn;

  @override
  Widget build(BuildContext context) => _ScoreLine(
    title: 'HOLE',
    background: AppColors.backgroundSecondary,
    cells: [
      for (var i = 1; i <= 9; i++) _plain('${isIn ? i + 9 : i}'),
      _plain('T'),
    ],
  );
}

/// Report/scorecardHoleInfo (PAR).
class ParRow extends StatelessWidget {
  const ParRow({super.key});

  static const _par = ['5', '4', '3', '4', '4', '5', '4', '3', '4', '36'];

  @override
  Widget build(BuildContext context) =>
      _ScoreLine(title: 'PAR', cells: [for (final p in _par) _plain(p)]);
}

/// Report/scorecardPutt.
class PuttRow extends StatelessWidget {
  const PuttRow({super.key});

  static const _putt = ['0', '1', '1', '2', '2', '1', '1', '1', '1'];

  @override
  Widget build(BuildContext context) => _ScoreLine(
    title: 'PUTT',
    cells: [for (final p in _putt) _plain(p), _plain('10', bold: true)],
  );
}

enum _S { eagle, birdie, par, bogey, double }

/// Report/strokeScore — Scorecard/personal 상태(이글/버디/파/보기/더블보기).
class StrokeScoreRow extends StatelessWidget {
  const StrokeScoreRow({super.key});

  static const _scores = [
    ('3', _S.eagle),
    ('3', _S.birdie),
    ('3', _S.par),
    ('5', _S.bogey),
    ('6', _S.double),
    ('5', _S.par),
    ('5', _S.bogey),
    ('3', _S.par),
    ('2', _S.eagle),
  ];

  @override
  Widget build(BuildContext context) => _ScoreLine(
    title: 'SCORE',
    cells: [
      for (final (n, s) in _scores) _ScoreCell(n, s),
      _plain('35', bold: true, color: AppColors.contentsPrimary),
    ],
  );
}

class _ScoreCell extends StatelessWidget {
  const _ScoreCell(this.n, this.s);

  final String n;
  final _S s;

  @override
  Widget build(BuildContext context) {
    final decoration = switch (s) {
      _S.eagle => const BoxDecoration(
        color: ScColors.scoreEagle,
        shape: BoxShape.circle,
      ),
      _S.birdie => const BoxDecoration(
        color: ScColors.scoreBirdie,
        shape: BoxShape.circle,
      ),
      _S.bogey => BoxDecoration(border: Border.all(color: ScColors.scoreBogey)),
      _S.double => const BoxDecoration(color: ScColors.scoreDb),
      _S.par => null,
    };
    return Container(
      width: 20,
      height: 20,
      padding: const EdgeInsets.only(top: 1),
      decoration: decoration,
      alignment: Alignment.center,
      child: _plain(n, color: AppColors.contentsPrimary),
    );
  }
}

/// Report/matchScore — 팀 매치 결과 (UP/DN/AS, ±타수, 합계).
class MatchRow extends StatelessWidget {
  const MatchRow({super.key});

  static const _cells = [
    ('DN', ScColors.scoreDn, false),
    ('UP', ScColors.scoreUp, false),
    ('AS', ScColors.scoreAs, false),
    ('-2', ScColors.scoreAs, true),
    ('-2', ScColors.scoreUp, true),
    ('-2', ScColors.scoreDn, true),
    ('DN', ScColors.scoreDn, false),
    ('DN', ScColors.scoreDn, false),
    ('DN', ScColors.scoreDn, false),
    ('7DN', ScColors.scoreDn, true),
  ];

  @override
  Widget build(BuildContext context) => _ScoreLine(
    title: 'Match',
    cells: [for (final (t, c, b) in _cells) _plain(t, bold: b, color: c)],
  );
}

/// Report/scorecardFooter — Stack(스트로크) / Foursome(팀) 범례.
class ScoreLegend extends StatelessWidget {
  const ScoreLegend({super.key, required this.team});

  final bool team;

  @override
  Widget build(BuildContext context) {
    Widget box(BoxDecoration d) =>
        Container(width: 12, height: 12, decoration: d);
    final items = team
        ? [
            (svg(ScorecardImg.legendUp, width: 12, height: 12), 'UP'),
            (svg(ScorecardImg.legendAs, width: 12, height: 12), 'ALL SQUARED'),
            (svg(ScorecardImg.legendDown, width: 12, height: 12), 'DOWN'),
          ]
        : [
            (svg(ScorecardImg.legendEagle, width: 12, height: 12), '이글 이하'),
            (svg(ScorecardImg.legendBirdie, width: 12, height: 12), '버디'),
            (svg(ScorecardImg.legendPar, width: 12, height: 12), '파'),
            (
              box(
                BoxDecoration(border: Border.all(color: ScColors.scoreBogey)),
              ),
              '보기',
            ),
            (box(const BoxDecoration(color: ScColors.scoreDb)), '더블보기 이상'),
          ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (i, (icon, label)) in items.indexed) ...[
              if (i > 0) SizedBox(width: team ? 30 : 16),
              icon,
              const SizedBox(width: 4),
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
        const SizedBox(height: 16),
        const HLine(),
      ],
    );
  }
}

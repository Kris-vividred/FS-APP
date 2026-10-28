import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'share_img.dart';
import 'share_widgets.dart';

/// 공유 카드 유형: 개인(default) / 팀(team) / 미완료(incomplete).
enum ShareType {
  personal,
  team,
  incomplete;

  static ShareType parse(String? v) => switch (v) {
    'team' => team,
    'incomplete' => incomplete,
    _ => personal,
  };

  String get query => switch (this) {
    personal => 'default',
    team => 'team',
    incomplete => 'incomplete',
  };
}

/// Figma Scorecard_share_default (1726:10119) / _team (1738:10057) /
/// _incomplete (1738:10469) — 기본형 공유 미리보기.
class ScorecardShareScreen extends StatefulWidget {
  const ScorecardShareScreen({super.key, required this.type});

  final ShareType type;

  @override
  State<ScorecardShareScreen> createState() => _ScorecardShareScreenState();
}

class _ScorecardShareScreenState extends State<ScorecardShareScreen>
    with ShareToastMixin {
  void _openEdit() {
    Navigator.pushNamed(
      context,
      Routes.scorecardShareEdit,
      arguments: {'type': widget.type.query},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              const SubHeader(title: '스코어카드 공유하기'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.global,
                    20,
                    AppSpace.global,
                    40,
                  ),
                  child: Column(
                    children: [
                      ShareToggle(edit: false, onChanged: (_) => _openEdit()),
                      const SizedBox(height: 20),
                      _BasicCard(type: widget.type),
                    ],
                  ),
                ),
              ),
              ShareBottomButtons(
                onSave: () => showToast(shareSaveToast),
                onShare: () => showToast(shareSaveToast),
              ),
            ],
          ),
          buildToast(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 기본형 카드

enum _S { eagle, birdie, par, bogey, db }

const _par = ['5', '4', '3', '4', '4', '5', '4', '3', '4', '36'];
const _score = [
  ('3', _S.eagle),
  ('3', _S.birdie),
  ('3', _S.par),
  ('5', _S.bogey),
  ('6', _S.db),
  ('5', _S.par),
  ('5', _S.bogey),
  ('3', _S.par),
  ('2', _S.eagle),
];
const _putt = ['0', '1', '1', '2', '2', '1', '1', '1', '1', '10'];

enum _M { dn, up, as }

/// (텍스트, 상태, 굵게)
const _match = [
  ('DN', _M.dn, false),
  ('UP', _M.up, false),
  ('AS', _M.as, false),
  ('-2', _M.as, true),
  ('-2', _M.up, true),
  ('-2', _M.dn, true),
  ('DN', _M.dn, false),
  ('DN', _M.dn, false),
  ('DN', _M.dn, false),
  ('7DN', _M.dn, true),
];

class _BasicCard extends StatelessWidget {
  const _BasicCard({required this.type});

  final ShareType type;

  bool get _team => type == ShareType.team;

  List<Widget> _half(int start) {
    final holes = [for (var i = 0; i < 9; i++) '${start + i}', 'T'];
    return [
      _Row(
        title: 'HOLE',
        bg: ShareColors.surfaceSecondary,
        cells: [for (final h in holes) _plain(h)],
      ),
      const _Divider(),
      _Row(title: 'PAR', cells: [for (final p in _par) _plain(p)]),
      const _Divider(),
      if (_team)
        _Row(title: 'Match', cells: [for (final m in _match) _MatchCell(m)])
      else ...[
        _Row(
          title: 'SCORE',
          cells: [
            for (final s in _score) _ScoreCell(s.$1, s.$2),
            _plain('35', bold: true, color: AppColors.contentsPrimary),
          ],
        ),
        const _Divider(),
        _Row(
          title: 'PUTT',
          cells: [for (final (i, p) in _putt.indexed) _plain(p, bold: i == 9)],
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpace.radiusXl),
        border: Border.all(color: AppColors.borderPrimary, width: 0.5),
        boxShadow: const [
          BoxShadow(color: Color(0x05162B4F), blurRadius: 20, spreadRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _team ? 'Team EPIC' : '나는쏘니야',
                        style: AppText.bold(16, lh: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '비에이비스타-몬티/벨라',
                        style: AppText.medium(
                          14,
                          color: AppColors.contentsSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  _team ? '2UP' : '99',
                  style: AppText.bold(
                    42,
                    lh: 42 * 1.3,
                    color: type == ShareType.incomplete
                        ? AppColors.contentsTertiary
                        : AppColors.contentsPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._half(1),
          const _Divider(color: ShareColors.borderSecondary),
          ..._half(10),
          const SizedBox(height: 12),
          Container(
            height: 48,
            color: ShareColors.gray700,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                svg(ShareImg.biLogo, width: 132, height: 16),
                Expanded(
                  child: Text(
                    '2024.07.19',
                    textAlign: TextAlign.right,
                    style: AppText.medium(14, color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _plain(
  String t, {
  bool bold = false,
  Color color = AppColors.contentsSecondary,
}) => _Cell(
  child: Text(
    t,
    softWrap: false,
    style: bold
        ? AppText.bold(12, color: color)
        : AppText.medium(12, lh: 18, color: color),
  ),
);

class _Divider extends StatelessWidget {
  const _Divider({this.color = AppColors.borderPrimary});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(height: 1, color: color);
}

/// Figma Report/scorecardHoleILabel · scorecardHoleInfo · strokeScore ·
/// scorecardPutt · matchScore 공통 행.
class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.cells,
    this.bg = AppColors.white,
  });

  final String title;
  final List<Widget> cells;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              title,
              textAlign: TextAlign.center,
              softWrap: false,
              style: AppText.medium(
                12,
                lh: 18,
                color: AppColors.contentsSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: cells,
            ),
          ),
        ],
      ),
    );
  }
}

/// 20×20 칸. 내용이 칸보다 넓으면(7DN 등) 가운데 기준으로 넘친다.
class _Cell extends StatelessWidget {
  const _Cell({required this.child, this.decoration});

  final Widget child;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    decoration: decoration,
    child: OverflowBox(maxWidth: 40, child: Center(child: child)),
  );
}

/// Figma Scorecard/personal (Eagle/Birdie/Par/Bogey/Double_Bogey).
class _ScoreCell extends StatelessWidget {
  const _ScoreCell(this.text, this.state);

  final String text;
  final _S state;

  @override
  Widget build(BuildContext context) {
    final deco = switch (state) {
      _S.eagle => const BoxDecoration(
        color: ShareColors.scoreEagle,
        shape: BoxShape.circle,
      ),
      _S.birdie => const BoxDecoration(
        color: ShareColors.scoreBirdie,
        shape: BoxShape.circle,
      ),
      _S.bogey => BoxDecoration(
        border: Border.all(color: ShareColors.scoreBogey),
      ),
      _S.db => const BoxDecoration(color: ShareColors.scoreDb),
      _S.par => null,
    };
    return _Cell(
      decoration: deco,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Text(text, style: AppText.medium(12, lh: 18)),
      ),
    );
  }
}

/// Figma Scorecard/match (DN/UP/AS + score 변형).
class _MatchCell extends StatelessWidget {
  const _MatchCell(this.m);

  final (String, _M, bool) m;

  @override
  Widget build(BuildContext context) {
    final color = switch (m.$2) {
      _M.dn => ShareColors.scoreDn,
      _M.up => ShareColors.scoreUp,
      _M.as => AppColors.contentsPrimary,
    };
    return _Cell(
      child: Text(
        m.$1,
        softWrap: false,
        style: m.$3
            ? AppText.bold(12, color: color)
            : AppText.medium(12, lh: 18, color: color),
      ),
    );
  }
}

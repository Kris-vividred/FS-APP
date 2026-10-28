import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'scorecard_img.dart';
import 'scorecard_widgets.dart';

/// Figma 02.0.CategoryHome_Report_Scorecard_list
/// - base 1177:46827 / best1 1648:8196 / empty 1650:31406
/// - 유형 시트 2122:11619 / 제품 시트 2122:12203
class ScorecardListScreen extends StatefulWidget {
  const ScorecardListScreen({super.key, this.state});

  /// `best1` · `empty` · null(기본)
  final String? state;

  @override
  State<ScorecardListScreen> createState() => _ScorecardListScreenState();
}

class _Round {
  const _Round({
    required this.month,
    required this.date,
    required this.mode,
    required this.gameType,
    required this.players,
    required this.holes,
    required this.name,
    required this.badges,
    required this.score,
    required this.detailType,
    this.dimmed = false,
  });

  final String month;
  final String date;
  final String mode;
  final String gameType;
  final int players;
  final String holes; // 18H / 9H
  final String name;
  final List<GameBadge> badges;
  final int score;
  final String detailType; // 18h / 9h / team
  /// 모든 기록이 Friends Screen Q — 제품 필터 T2/FA 선택 시 빈 상태.
  String get product => 'Q';
  final bool dimmed;
}

class _Best {
  const _Best(this.score, this.mode, this.badges, this.name, this.type);
  final int score;
  final String mode;
  final List<GameBadge> badges;
  final String name;
  final String type;
}

const _all = GameBadge.values;
const _h = GameBadge.holeinone;
const _e = GameBadge.eagle;
const _c = GameBadge.condor;
const _a = GameBadge.albatross;

const _rounds = [
  _Round(
    month: '2023년 12월',
    date: '12월 18일',
    mode: Img.gameModeTeam,
    gameType: '포섬/포볼',
    players: 3,
    holes: '18H',
    name: '소피아그린CC',
    badges: [_e, _c, _a],
    score: 98,
    detailType: 'team',
  ),
  _Round(
    month: '2023년 12월',
    date: '12월 18일',
    mode: Img.gameModeSolo,
    gameType: '스트로크',
    players: 4,
    holes: '18H',
    name: '서산수',
    badges: [_c, _a],
    score: 98,
    detailType: '18h',
  ),
  _Round(
    month: '2023년 12월',
    date: '12월 18일',
    mode: Img.gameModeTeam,
    gameType: '포섬/포볼',
    players: 4,
    holes: '18H',
    name: '스크린디자인그룹 12월 신페리오 스크린디자인그룹 12월 신페리오',
    badges: _all,
    score: 52,
    detailType: 'team',
    dimmed: true,
  ),
  _Round(
    month: '2023년 10월',
    date: '10월 50일',
    mode: ScorecardImg.modeTrophy,
    gameType: '대회',
    players: 3,
    holes: '18H',
    name: '미션힐드 - 라바필드',
    badges: _all,
    score: 81,
    detailType: '18h',
  ),
  _Round(
    month: '2023년 10월',
    date: '10월 8일',
    mode: ScorecardImg.modeVersus,
    gameType: '멀티플레이',
    players: 2,
    holes: '9H',
    name: '드비치',
    badges: [_h, _e, _c],
    score: 79,
    detailType: '9h',
  ),
  _Round(
    month: '2023년 9월',
    date: '9월 18일',
    mode: Img.gameModeTeam,
    gameType: '포섬/포볼',
    players: 4,
    holes: '18H',
    name: '세라지오',
    badges: _all,
    score: 98,
    detailType: 'team',
  ),
  _Round(
    month: '2023년 9월',
    date: '9월 17일',
    mode: ScorecardImg.modeFire,
    gameType: '챌린지',
    players: 4,
    holes: '18H',
    name: '루트52',
    badges: _all,
    score: 98,
    detailType: '18h',
  ),
];

const _bests = [
  _Best(70, ScorecardImg.modeTeam24, _all, '소피아그린', 'team'),
  _Best(
    98,
    ScorecardImg.modeFire24,
    [_c, _a],
    '소피아그린소피아그린소피아그린소피아그린소피아그린',
    '18h',
  ),
  _Best(98, ScorecardImg.modeFire24, _all, '소피아그린', '9h'),
];

const _bestSingle = _Best(
  98,
  ScorecardImg.modeFire24,
  [_c, _a],
  '소피아그린',
  '18h',
);

class _ScorecardListScreenState extends State<ScorecardListScreen> {
  static const _types = ['전체', '스트로크', '대회', '포섬/포볼', '멀티플레이', '챌린지'];
  static const _products = ['전체', 'Q', 'T2', 'FA'];

  String _type = '전체';
  String _product = '전체';
  String? _holes; // null · 18H · 9H

  bool get _empty => widget.state == 'empty';

  List<_Round> get _filtered => _empty
      ? const []
      : _rounds
            .where(
              (r) =>
                  (_type == '전체' || r.gameType == _type) &&
                  (_product == '전체' || r.product == _product) &&
                  (_holes == null || r.holes == _holes),
            )
            .toList();

  Future<void> _pickType() async {
    final v = await showChoiceSheet(
      context,
      title: '유형',
      options: _types,
      selected: _type,
    );
    if (v != null) setState(() => _type = v);
  }

  Future<void> _pickProduct() async {
    final v = await showChoiceSheet(
      context,
      title: '제품',
      options: _products,
      selected: _product,
    );
    if (v != null) setState(() => _product = v);
  }

  void _toggleHoles(String h) =>
      setState(() => _holes = _holes == h ? null : h);

  void _openDetail(String type) => Navigator.pushNamed(
    context,
    Routes.scorecardDetail,
    arguments: {'type': type},
  );

  @override
  Widget build(BuildContext context) {
    final rounds = _filtered;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SubHeader(title: '스코어카드'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const _AdBanner(),
                  _bestSection(),
                  SectionContainer(
                    title: SectionLabel('전체', count: '${rounds.length}회'),
                    bottomPadding: 40,
                    divider: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _filters(),
                        const SizedBox(height: 30),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: rounds.isEmpty
                              ? const _EmptyRounds()
                              : _RoundList(
                                  key: ValueKey('$_type-$_product-$_holes'),
                                  rounds: rounds,
                                  onTap: (r) => _openDetail(r.detailType),
                                ),
                        ),
                      ],
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

  Widget _bestSection() {
    final List<_Best> cards = switch (widget.state) {
      'best1' || 'empty' => const [_bestSingle],
      _ => _bests,
    };
    return SectionContainer(
      title: const SectionLabel('베스트 스코어', count: '3회'),
      subText: _empty ? '아래 데이터는 가상 스코어입니다.' : null,
      bleedRight: true,
      child: Opacity(
        opacity: _empty ? 0.5 : 1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(right: AppSpace.global),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, b) in cards.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                _BestCard(
                  data: b,
                  onTap: _empty ? null : () => _openDetail(b.type),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _filters() {
    return Row(
      children: [
        _FilterChip(
          label: _type == '전체' ? '유형' : _type,
          selected: _type != '전체',
          arrow: true,
          onTap: _pickType,
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: _product == '전체' ? '제품' : _product,
          selected: _product != '전체',
          arrow: true,
          onTap: _pickProduct,
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: '18홀',
          selected: _holes == '18H',
          onTap: () => _toggleHoles('18H'),
        ),
        const SizedBox(width: 10),
        _FilterChip(
          label: '9홀',
          selected: _holes == '9H',
          onTap: () => _toggleHoles('9H'),
        ),
      ],
    );
  }
}

/// Figma sortCombination 의 sort 칩 (화살표 선택).
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.arrow = false,
  });

  final String label;
  final bool selected;
  final bool arrow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minWidth: 48),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.tabSelected : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.tabSelected : AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppText.regular(
                14,
                lh: 20,
                color: selected ? AppColors.white : AppColors.contentsSecondary,
              ),
            ),
            if (arrow) ...[
              const SizedBox(width: 4),
              svg(
                Img.arrowDown12,
                width: 12,
                height: 12,
                tint: selected ? AppColors.white : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Figma Report/BestscoreCard (184 × 188).
class _BestCard extends StatelessWidget {
  const _BestCard({required this.data, this.onTap});

  final _Best data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 184,
        constraints: const BoxConstraints(minHeight: 188),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.contentsBrand),
          borderRadius: BorderRadius.circular(AppSpace.radiusXl),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${data.score}',
                        style: AppText.bold(
                          42,
                          lh: 42 * 1.3,
                          color: AppColors.contentsBrand,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '타',
                        style: AppText.regular(
                          36,
                          color: AppColors.contentsBrand,
                        ).copyWith(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  GameBadgeSet(data.badges),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 144,
                    child: Text(
                      data.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bold(16, lh: 24),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '2023.12.18',
                    style: AppText.medium(
                      14,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 139,
              top: 18,
              child: svg(data.mode, width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// 월별 그룹 + Report/screenList 카드 목록.
class _RoundList extends StatelessWidget {
  const _RoundList({super.key, required this.rounds, required this.onTap});

  final List<_Round> rounds;
  final ValueChanged<_Round> onTap;

  @override
  Widget build(BuildContext context) {
    final months = <String, List<_Round>>{};
    for (final r in rounds) {
      (months[r.month] ??= []).add(r);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (i, e) in months.entries.indexed) ...[
          if (i > 0) const SizedBox(height: 20),
          Text(
            e.key,
            style: AppText.bold(14, lh: 20, color: AppColors.contentsSecondary),
          ),
          const SizedBox(height: 12),
          for (final (j, r) in e.value.indexed) ...[
            if (j > 0) const SizedBox(height: 10),
            _RoundCard(data: r, onTap: () => onTap(r)),
          ],
        ],
      ],
    );
  }
}

/// Figma Report/screenList.
class _RoundCard extends StatelessWidget {
  const _RoundCard({required this.data, required this.onTap});

  final _Round data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final d = data;
    final meta = AppText.medium(14, color: AppColors.contentsSecondary);
    return Pressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          16,
          AppSpace.global,
          12,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(d.date, style: meta),
                      const SizedBox(width: 4),
                      AppBadge(d.product, color: AppColors.badgeQ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SlotIcon(d.mode),
                const SizedBox(width: 8),
                Text('${d.players}명', style: meta),
                const SizedBox(width: 8),
                const VDivider.h9(),
                const SizedBox(width: 8),
                Text(d.holes, style: meta),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    d.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.bold(16, lh: 24),
                  ),
                ),
                const SizedBox(width: 10),
                GameBadgeSet(d.badges),
                const SizedBox(width: 8),
                Text(
                  '${d.score}',
                  style: AppText.bold(
                    24,
                    lh: 24 * 1.3,
                    color: d.dimmed
                        ? AppColors.contentsTertiary
                        : AppColors.contentsPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRounds extends StatelessWidget {
  const _EmptyRounds();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 100,
    child: Center(
      child: Text(
        '라운드 기록이 없어요.',
        style: AppText.regular(16, color: AppColors.contentsSecondary),
      ),
    ),
  );
}

/// 광고 배너 (339 × 90) — report_screen 의 배너와 동일한 Figma 인스턴스.
class _AdBanner extends StatelessWidget {
  const _AdBanner();

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(
        offset: Offset(0, 4.185),
        blurRadius: 20.926,
        color: Color(0x997D3400),
      ),
    ];
    const base = TextStyle(
      fontFamily: 'Spoqa',
      fontSize: 16.741,
      letterSpacing: -0.3139,
      color: AppColors.white,
      shadows: shadow,
    );
    return GestureDetector(
      onTap: () => showNotReady(context, '이벤트'),
      child: ClipRect(
        child: SizedBox(
          height: 90,
          child: Center(
            child: SizedBox(
              width: 339,
              height: 90,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpace.radiusMd),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF6B00), Color(0xFFFF9900)],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 169.5 + 74.19 - 126.175 / 2,
                    bottom: -37.11,
                    width: 126.175,
                    height: 138.963,
                    child: Center(
                      child: Transform.rotate(
                        angle: -6.77 * math.pi / 180,
                        child: Image.asset(
                          Img.adMain,
                          width: 112.027,
                          height: 126.64,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 169.5 - 148.57,
                    top: 33.93 - 25.111 / 2,
                    child: Text(
                      '광동제약과 함께 하는',
                      style: base.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 25.111 / 16.741,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 169.5 - 148.57,
                    top: 58.63 - 12,
                    child: Text(
                      '행운가드득 클래식 시즌2',
                      style: base.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                  Positioned(
                    top: 18,
                    right: 18,
                    child: svg(Img.indicatorAd, width: 30, height: 6),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

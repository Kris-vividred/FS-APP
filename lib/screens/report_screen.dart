import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design/components.dart';
import '../design/tokens.dart';
import '../routes.dart';
import 'shot/screen_empty_body.dart';
import 'shot/training_body.dart';

/// Figma 02.0.CategoryHome_Report_Screen (1177:56265)
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.initialTab = 0, this.empty = false});

  /// 0 = 스크린, 1 = 트레이닝 (`?tab=training`)
  final int initialTab;

  /// 데이터가 없는 상태 (`?state=empty`)
  final bool empty;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late int _tab = widget.initialTab; // 0 = 스크린, 1 = 트레이닝
  int _nav = 1; // 리포트
  String _product = '프렌즈 스크린 Q';
  String _count = '최근 5회';

  static const _products = ['프렌즈 스크린 Q', '프렌즈 스크린 T2'];
  static const _counts = ['최근 5회', '최근 10회', '최근 20회'];

  String get _productTitle =>
      _product == _products[0] ? 'Friends Screen Q' : 'Friends Screen T2';
  String get _productShort => _product == _products[0] ? 'Q' : 'T2';

  Future<void> _pickProduct() async {
    final v = await showChoiceSheet(
      context,
      title: '제품 선택',
      options: _products,
      selected: _product,
    );
    if (v != null) setState(() => _product = v);
  }

  Future<void> _pickCount() async {
    final v = await showChoiceSheet(
      context,
      title: '횟수 선택',
      options: _counts,
      selected: _count,
    );
    if (v != null) setState(() => _count = v);
  }

  void _showDataInfo() {
    showAppSheet<void>(
      context,
      title: '데이터 집계',
      showBar: false,
      contentBuilder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Friends Screen Q, T2', style: AppText.bold(16, lh: 24)),
          const SizedBox(height: 10),
          Text('비기너를 제외한 18홀 스트로크를 5경기 이상', style: AppText.regular(16)),
          const SizedBox(height: 6),
          Text('진행 시, 기록 분석 데이터를 확인 할 수 있습니다.', style: AppText.regular(16)),
        ],
      ),
    );
  }

  void _notReady(String what) => showNotReady(context, what);

  static const _analysisTabs = {
    '평균 타수': 'score',
    '드라이버 거리': 'driverDistance',
    '페어웨이 안착률': 'fairway',
    '그린 적중률': 'gir',
    '파 세이브율': 'parSave',
    '평균 퍼팅': 'putting',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const AppStatusBar(),
          _TabHeader(index: _tab, onChanged: (i) => setState(() => _tab = i)),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _tab == 1
                  ? TrainingReportBody(
                      key: ValueKey('training-${widget.empty}'),
                      empty: widget.empty,
                    )
                  : widget.empty
                  ? const ReportScreenEmptyBody(key: ValueKey('screen-empty'))
                  : SingleChildScrollView(
                      key: const ValueKey('screen'),
                      child: Column(
                        children: [
                          _MySection(
                            productTitle: _productTitle,
                            onProduct: _pickProduct,
                            onInfo: _showDataInfo,
                          ),
                          const SizedBox(height: 20),
                          const _AdBanner(),
                          _ScorecardSection(
                            onSeeAll: () => Navigator.of(
                              context,
                            ).pushNamed(Routes.scorecardList),
                          ),
                          _AnalysisSection(
                            productShort: _productShort,
                            countLabel: _count,
                            onProduct: _pickProduct,
                            onCount: _pickCount,
                            onItem: (name) => Navigator.of(context).pushNamed(
                              Routes.analysis,
                              arguments: {
                                'tab': _analysisTabs[name] ?? 'score',
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          _BottomNav(
            index: _nav,
            onTap: (i, label) {
              if (i == 1) return setState(() => _nav = 1);
              _notReady(label);
            },
          ),
        ],
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['스크린', '트레이닝'];
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
              // 선택 인디케이터 — 탭 전환 시 슬라이드
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                left: w * index,
                width: w,
                bottom: 0,
                child: Container(height: 2, color: AppColors.contentsPrimary),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MySection extends StatelessWidget {
  const _MySection({
    required this.productTitle,
    required this.onProduct,
    required this.onInfo,
  });

  final String productTitle;
  final VoidCallback onProduct;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        color: AppColors.backgroundSecondary,
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          24,
          AppSpace.global,
          20,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '나의 핸디',
                            style: AppText.bold(
                              12,
                              color: AppColors.contentsTertiary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: onInfo,
                            child: svg(Img.info, width: 16, height: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: onProduct,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              productTitle,
                              style: AppText.bold(
                                16,
                                lh: 24,
                                color: AppColors.contentsSecondary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            svg(Img.dropdown, width: 12, height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _CountUp(
                        value: -7.1,
                        style: AppText.bold(
                          42,
                          lh: 42 * 1.3,
                          color: AppColors.contentsBrand,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpace.radiusMd),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: _Stat(
                          label: '최대 비거리',
                          value: '239.2',
                          unit: 'm',
                        ),
                      ),
                      VDivider.h24(),
                      Expanded(
                        child: _Stat(label: '최소 퍼팅수', value: '11', unit: '타'),
                      ),
                      VDivider.h24(),
                      Expanded(
                        child: _Stat(label: '최저 타수', value: '79', unit: '타'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // 캐릭터 이미지: img 박스(247,45) 기준 -44.94/-44.01 오프셋, -2.43° 회전
            Positioned(
              left: 247 - AppSpace.global - 44.94,
              top: 45 - 24 - 44.01,
              width: 163.946,
              height: 163.946,
              child: IgnorePointer(
                child: Center(
                  child: Transform.rotate(
                    angle: -2.43 * math.pi / 180,
                    child: Image.asset(
                      Img.character,
                      width: 157.407,
                      height: 157.407,
                      fit: BoxFit.cover,
                    ),
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

/// 핸디 숫자가 0에서 목표값까지 올라가는 진입 인터랙션.
class _CountUp extends StatelessWidget {
  const _CountUp({required this.value, required this.style});

  final double value;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, v, _) => Text(
        '${v < 0 ? '-' : ''}${v.abs().toStringAsFixed(1)}',
        style: style,
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppText.medium(14, color: AppColors.contentsSecondary),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: AppText.bold(18, lh: 26)),
            const SizedBox(width: 2),
            Text(unit, style: AppText.regular(16)),
          ],
        ),
      ],
    );
  }
}

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
    return ClipRect(
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
                // 제품 이미지: 박스 중심 x = 169.5+74.19, bottom -37.11, -6.77° 회전
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
    );
  }
}

class _ScoreData {
  const _ScoreData(
    this.name,
    this.players,
    this.teamMode,
    this.badges, {
    this.dimmed = false,
  });
  final String name;
  final int players;
  final bool teamMode;
  final List<String> badges;
  final bool dimmed;
}

class _ScorecardSection extends StatelessWidget {
  const _ScorecardSection({required this.onSeeAll});

  final VoidCallback onSeeAll;

  static const _items = [
    _ScoreData('소피아그린CC', 3, true, [Img.badge1]),
    _ScoreData('소피아그린소피아그린소피아소피아그린소피아그린소피아소피아그린소피아그린소피아', 4, false, [
      Img.badge1,
      Img.badge2,
      Img.badge3,
    ]),
    _ScoreData('블루원용인', 3, false, [Img.badge1], dimmed: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.global,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('스코어카드', style: AppText.bold(18, lh: 26)),
                  const SizedBox(width: 6),
                  Text(
                    '${_items.length}회',
                    style: AppText.regular(18, color: AppColors.contentsBrand),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              for (final s in _items) ...[
                _ScoreCard(data: s),
                const SizedBox(height: 10),
              ],
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpace.radiusMd),
                    border: Border.all(
                      color: AppColors.borderTertiary,
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    '전체보기',
                    style: AppText.bold(
                      14,
                      lh: 20,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: AppColors.borderPrimary),
      ],
    );
  }
}

class _ScoreCard extends StatefulWidget {
  const _ScoreCard({required this.data});

  final _ScoreData data;

  @override
  State<_ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<_ScoreCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final meta = AppText.medium(14, color: AppColors.contentsSecondary);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      // 카드 → 스코어카드 상세(팀 경기는 팀 상세, 그 외 18홀 스트로크)
      onTap: () => Navigator.of(context).pushNamed(
        Routes.scorecardDetail,
        arguments: {'type': d.teamMode ? 'team' : '18h'},
      ),
      // 눌림 피드백: 살짝 축소
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
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
                        Text('12월 18일', style: meta),
                        const SizedBox(width: 4),
                        const AppBadge('Q', color: AppColors.badgeQ),
                      ],
                    ),
                  ),
                  svg(
                    d.teamMode ? Img.gameModeTeam : Img.gameModeSolo,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  Text('${d.players}명', style: meta),
                  const SizedBox(width: 8),
                  const VDivider.h9(),
                  const SizedBox(width: 8),
                  Text('18H', style: meta),
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
                  for (final (i, b) in d.badges.indexed) ...[
                    if (i > 0) const SizedBox(width: 4),
                    svg(b, width: 12, height: 12),
                  ],
                  const SizedBox(width: 8),
                  Text(
                    '98',
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
      ),
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  const _AnalysisSection({
    required this.productShort,
    required this.countLabel,
    required this.onProduct,
    required this.onCount,
    required this.onItem,
  });

  final String productShort;
  final String countLabel;
  final VoidCallback onProduct;
  final VoidCallback onCount;
  final ValueChanged<String> onItem;

  @override
  Widget build(BuildContext context) {
    const good = ('Good', AppColors.badgeBrand);
    const normal = ('Normal', AppColors.badgeSecondary);
    const bad = ('Bad', AppColors.badgeBad);
    final items = <(String, String, String, (String, Color)?)>[
      ('평균 타수', '90', '타', null),
      ('드라이버 거리', '112.7', 'm', bad),
      ('페어웨이 안착률', '60.9', '%', good),
      ('그린 적중률', '25.2', '%', normal),
      ('파 세이브율', '20.5', '%', good),
      ('평균 퍼팅', '2.1', '타', good),
    ];
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
          Text('기록분석', style: AppText.bold(18, lh: 26)),
          const SizedBox(height: 20),
          Row(
            children: [
              SortChip(label: productShort, selected: true, onTap: onProduct),
              const SizedBox(width: 10),
              SortChip(
                label: countLabel == '최근 5회' ? '필터' : countLabel,
                selected: false,
                onTap: onCount,
              ),
            ],
          ),
          const SizedBox(height: 30),
          // 제품/횟수가 바뀌면 그래프가 다시 그려지도록 key 부여
          _RadarGraph(key: ValueKey('$productShort-$countLabel')),
          const SizedBox(height: 30),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            ),
            child: Column(
              children: [
                for (final (i, it) in items.indexed) ...[
                  if (i > 0) const SizedBox(height: 20),
                  AnalysisItem(
                    name: it.$1,
                    value: it.$2,
                    unit: it.$3,
                    badge: it.$4,
                    onTap: () => onItem(it.$1),
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

/// 레이더 그래프 (339x276). 그래프 SVG는 디자인 에셋을 그대로 쓰고,
/// 진입 시 중심에서 펼쳐지는 애니메이션만 추가.
class _RadarGraph extends StatelessWidget {
  const _RadarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 339,
        height: 276,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 77.5,
              top: 27,
              width: 180,
              height: 180,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutBack,
                builder: (_, t, child) => Opacity(
                  opacity: t.clamp(0, 1),
                  child: Transform.scale(scale: 0.6 + 0.4 * t, child: child),
                ),
                child: svg(Img.radarGraph, width: 180, height: 180),
              ),
            ),
            const _RadarLabel(
              cx: 169.5,
              top: 0,
              lines: ['드라이버 거리'],
              value: '112.7',
              unit: 'm',
            ),
            const _RadarLabel(
              cx: 169.5 - 118.5,
              top: 78,
              lines: ['페어웨이', '안착률'],
              value: '60.9',
              unit: '%',
            ),
            const _RadarLabel(
              cx: 169.5 + 118.5,
              top: 78,
              lines: ['샌드', '세이브율'],
              value: '50.5',
              unit: '%',
            ),
            const _RadarLabel(
              cx: 169.5 - 50.5,
              top: 194,
              lines: ['그린 적중률'],
              value: '25.2',
              unit: '%',
            ),
            const _RadarLabel(
              cx: 169.5 + 44.5,
              top: 194,
              lines: ['퍼팅'],
              value: '2.1',
              unit: '타',
            ),
            Positioned(
              left: 115.5,
              top: 258,
              child: _Legend(dot: Img.dotMe, label: '나'),
            ),
            Positioned(
              left: 161.5,
              top: 258,
              child: _Legend(dot: Img.dotAvg, label: '동급 평균'),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarLabel extends StatelessWidget {
  const _RadarLabel({
    required this.cx,
    required this.top,
    required this.lines,
    required this.value,
    required this.unit,
  });

  final double cx;
  final double top;
  final List<String> lines;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    // 라벨 중심이 cx에 오도록 넉넉한 폭의 박스를 가운데 정렬
    const w = 120.0;
    return Positioned(
      left: cx - w / 2,
      top: top,
      width: w,
      child: Column(
        children: [
          Text(
            lines.join('\n'),
            textAlign: TextAlign.center,
            style: AppText.bold(14, lh: 20, color: AppColors.contentsSecondary),
          ),
          const SizedBox(height: 4),
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.green700,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: AppText.bold(10, color: AppColors.white)),
                Text(unit, style: AppText.regular(10, color: AppColors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.dot, required this.label});

  final String dot;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      svg(dot, width: 8, height: 8),
      const SizedBox(width: 6),
      Text(
        label,
        style: AppText.medium(12, lh: 18, color: AppColors.contentsSecondary),
      ),
    ],
  );
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.index, required this.onTap});

  final int index;
  final void Function(int index, String label) onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Img.navHome, '홈'),
      (Img.navReport, '리포트'),
      ('', ''),
      (Img.navPin, '매장찾기'),
      (Img.navVideo, '스윙영상'),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderPrimary, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final (i, it) in items.indexed)
                if (i == 2)
                  _QrButton(onTap: () => onTap(2, 'QR 로그인'))
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onTap(i, it.$2),
                    child: SizedBox(
                      width: 56,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            svg(it.$1, width: 24, height: 24),
                            const SizedBox(height: 6),
                            Text(
                              it.$2,
                              style: AppText.bold(
                                10,
                                color: i == index
                                    ? AppColors.contentsPrimary
                                    : AppColors.contentsSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrButton extends StatefulWidget {
  const _QrButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_QrButton> createState() => _QrButtonState();
}

class _QrButtonState extends State<_QrButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 5,
            top: -6,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _pressed = true),
              onTapUp: (_) {
                setState(() => _pressed = false);
                widget.onTap();
              },
              onTapCancel: () => setState(() => _pressed = false),
              child: AnimatedScale(
                scale: _pressed ? 0.9 : 1,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: AppColors.actionPrimary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: svg(Img.navQr, width: 24, height: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

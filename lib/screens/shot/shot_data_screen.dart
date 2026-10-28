import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'shot_assets.dart';
import 'shot_common.dart';

/// 클럽 선택지 (Figma compare_sheet_club 1721:10693). key 는 쿼리 값.
const shotClubs = <(String, String, double)>[
  ('driver', '드라이버', 1.0),
  ('wood3', '3번 우드', 0.88),
  ('wood5', '5번 우드', 0.84),
  ('wood7', '7번 우드', 0.80),
  ('hybrid3', '3번 하이브리드', 0.78),
  ('hybrid4', '4번 하이브리드', 0.75),
  ('hybrid5', '5번 하이브리드', 0.72),
  ('hybrid7', '7번 하이브리드', 0.66),
  ('lw', 'LW', 0.35),
];

/// 비교 레벨 선택지 (Figma compare_sheet_level 1721:10150).
const shotLevels = <(String, String)>[
  ('beginner', '초보'),
  ('double', '더블보기 플레이어'),
  ('hundred', '백돌이'),
  ('bogey', '보기 플레이어'),
  ('single', '싱글 플레이어'),
  ('pga', 'PGA 선수급'),
];

int _indexOf(List<String> keys, List<String> labels, String? v) {
  if (v == null) return 0;
  final i = keys.indexOf(v);
  if (i >= 0) return i;
  final j = labels.indexOf(v);
  return j >= 0 ? j : 0;
}

/// 드라이버 샷 데이터 — 탭 0 = 내기록(ShotData_records 2296:49632),
/// 탭 1 = 평균기록 비교(ShotData_compare 1177:42440 / 2600:9381).
class ShotDataScreen extends StatefulWidget {
  const ShotDataScreen({super.key, this.initialTab = 0, this.club, this.level});

  /// `?tab=records|compare` 또는 0/1.
  final int initialTab;

  /// `?club=driver|wood3|…` 또는 한글 라벨.
  final String? club;

  /// `?level=beginner|double|hundred|bogey|single|pga` 또는 한글 라벨.
  final String? level;

  factory ShotDataScreen.fromQuery(Map<String, String> q, {int tab = 0}) {
    final t = q['tab'];
    return ShotDataScreen(
      initialTab: t == null
          ? tab
          : (t == 'compare' || t == '1')
          ? 1
          : 0,
      club: q['club'],
      level: q['level'],
    );
  }

  @override
  State<ShotDataScreen> createState() => _ShotDataScreenState();
}

class _ShotDataScreenState extends State<ShotDataScreen> {
  late int _tab = widget.initialTab;
  late int _club = _indexOf(
    [for (final c in shotClubs) c.$1],
    [for (final c in shotClubs) c.$2],
    widget.club,
  );
  late int _level = _indexOf(
    [for (final l in shotLevels) l.$1],
    [for (final l in shotLevels) l.$2],
    widget.level,
  );

  String get _clubName => shotClubs[_club].$2;
  double get _factor => shotClubs[_club].$3;

  Future<void> _pickClub() async {
    final v = await showChoiceSheet(
      context,
      title: '클럽',
      options: [for (final c in shotClubs) c.$2],
      selected: _clubName,
    );
    if (v == null) return;
    setState(() => _club = shotClubs.indexWhere((c) => c.$2 == v));
  }

  Future<void> _pickLevel() async {
    final v = await showHandleChoiceSheet(
      context,
      options: [for (final l in shotLevels) l.$2],
      selected: shotLevels[_level].$2,
    );
    if (v == null) return;
    setState(() => _level = shotLevels.indexWhere((l) => l.$2 == v));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Stack(
            children: [
              SubHeader(
                title: '$_clubName 샷 데이터',
                bottom: _ShotTabs(
                  index: _tab,
                  onChanged: (i) => setState(() => _tab = i),
                ),
              ),
              // 제목 영역 탭 → 클럽 선택 시트
              Positioned(
                top: 60,
                left: 60,
                right: 60,
                height: 60,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _pickClub,
                ),
              ),
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _tab == 0
                  ? _RecordsTable(
                      key: ValueKey('records-$_club'),
                      factor: _factor,
                    )
                  : _CompareBody(
                      key: const ValueKey('compare'),
                      factor: _factor,
                      clubKey: _club,
                      levelName: _levelDisplay(shotLevels[_level].$2),
                      onLevel: _pickLevel,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static String _levelDisplay(String s) => s == '초보' ? '초보 플레이어' : s;
}

/// Figma `tabCombination` (48h) — 내기록 / 평균기록 비교.
class _ShotTabs extends StatelessWidget {
  const _ShotTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['내기록', '평균기록 비교'];
    return SizedBox(
      height: 48,
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
                child: Container(height: 2, color: AppColors.contentsPrimary),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ───────────────────────── 내기록 (conTable) ─────────────────────────

class _RecordsTable extends StatelessWidget {
  const _RecordsTable({super.key, required this.factor});

  final double factor;

  static const _rows = [
    ('비거리', '(m)'),
    ('캐리', '(m)'),
    ('볼스피드', '(m/s)'),
    ('최고높이', '(m)'),
    ('발사각', '(°)'),
    ('방향각', '(°)'),
    ('백스핀', '(rpm)'),
    ('사이드스핀', '(rpm)'),
  ];

  static const _straight = [
    '194.4',
    '60.7',
    '27.4',
    '14.5',
    '-1.5',
    '1534',
    '-900',
    '210.3',
  ];

  static const _columns = <(String, List<String>)>[
    ('스트레이트', _straight),
    (
      '푸시 슬라이스',
      ['42.7', '26.7', '3.2', '11.7', '-4.3', '2839', '-1002', '215.6'],
    ),
    ('페이드', ['194.4', '60.7', '27.4', '14.5', '3.4', '1534', '-900', '93.4']),
    ('스트레이트', _straight),
    ('스트레이트', _straight),
  ];

  /// 비거리·캐리·볼스피드는 클럽에 따라 달라지도록 배율 적용.
  String _value(String v, int row) {
    if (row > 2 || factor == 1) return v;
    return (double.parse(v) * factor).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final label = AppText.bold(14, lh: 20, color: AppColors.contentsSecondary);
    final unit = AppText.regular(10, color: AppColors.contentsSecondary);
    final head = AppText.medium(14, color: AppColors.contentsSecondary);
    final value = AppText.regular(16, color: AppColors.contentsSecondary);

    Widget cell(Widget child) =>
        SizedBox(height: 56, child: Center(child: child));

    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        // 표 높이 = padding 18*2 + 행 56*9 = 540. 화면보다 짧으면 화면 높이까지 배경을 채운다.
        child: SizedBox(
          height: c.maxHeight > 540 ? c.maxHeight : 540,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Category Column (129w, 고정)
              Container(
                width: 129,
                color: AppColors.backgroundSecondary,
                padding: const EdgeInsets.all(AppSpace.global),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 56,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('구질', style: label),
                      ),
                    ),
                    for (final r in _rows)
                      SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Text(r.$1, style: label),
                            const SizedBox(width: 2),
                            Text(r.$2, style: unit),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              // Data Columns (가로 스크롤)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpace.global,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final col in _columns)
                        Container(
                          constraints: const BoxConstraints(minWidth: 68),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              cell(Text(col.$1, style: head)),
                              for (final (i, v) in col.$2.indexed)
                                cell(Text(_value(v, i), style: value)),
                            ],
                          ),
                        ),
                    ],
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

// ───────────────────────── 평균기록 비교 (con) ─────────────────────────

class _CompareBody extends StatelessWidget {
  const _CompareBody({
    super.key,
    required this.factor,
    required this.clubKey,
    required this.levelName,
    required this.onLevel,
  });

  final double factor;
  final int clubKey;
  final String levelName;
  final VoidCallback onLevel;

  String _scale(String v) =>
      factor == 1 ? v : (double.parse(v) * factor).toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final rows = <_StatRowData>[
      _StatRowData(
        _scale('192.4'),
        'm',
        '비거리',
        '평균보다 +2.0',
        true,
        _scale('192.4'),
      ),
      _StatRowData(
        _scale('27.9'),
        'm/s',
        '볼스피드',
        '평균보다 -0.6',
        false,
        _scale('56.8'),
      ),
      const _StatRowData('14.3', '°', '발사각', '평균보다 -22', false, '13.6'),
      const _StatRowData('3654', 'rpm', '백스핀', '평균보다 -120', false, '3500'),
    ];

    return Container(
      color: AppColors.backgroundSecondary,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          20,
          AppSpace.global,
          40,
        ),
        child: Column(
          children: [
            _ProfileVs(levelName: levelName, onLevel: onLevel),
            const SizedBox(height: 30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.02),
                    end: Offset.zero,
                  ).animate(a),
                  child: child,
                ),
              ),
              child: _StatsCard(
                key: ValueKey('$clubKey-$levelName'),
                rows: rows,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileVs extends StatelessWidget {
  const _ProfileVs({required this.levelName, required this.onLevel});

  final String levelName;
  final VoidCallback onLevel;

  @override
  Widget build(BuildContext context) {
    final name = AppText.bold(16, lh: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Column(
              children: [
                const _ProfilePhoto(),
                const SizedBox(height: 10),
                Text('수내이덕화', style: name),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 41,
            height: 106,
            child: Text(
              'VS',
              style: const TextStyle(
                fontFamily: 'Spoqa',
                fontSize: 36,
                fontWeight: FontWeight.w300,
                color: AppColors.contentsTertiary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onLevel,
            child: SizedBox(
              width: 105,
              child: Column(
                children: [
                  svg(ShotImg.profileDefault, width: 72, height: 72),
                  const SizedBox(height: 10),
                  // 이름이 105 폭을 넘어도 가운데 기준으로 넘치게 배치
                  SizedBox(
                    height: 24,
                    child: OverflowBox(
                      maxWidth: 220,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            child: Text(
                              levelName,
                              key: ValueKey(levelName),
                              style: name,
                            ),
                          ),
                          const SizedBox(width: 4),
                          svg(
                            Img.dropdown,
                            width: 12,
                            height: 12,
                            tint: AppColors.contentsPrimary,
                          ),
                        ],
                      ),
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

/// Figma `img/Profile` type=3 — 원형 마스크 안의 사진(inset -20% -8.33% -51.67% -6.67%).
class _ProfilePhoto extends StatelessWidget {
  const _ProfilePhoto();

  @override
  Widget build(BuildContext context) {
    const s = 72.0;
    return ClipOval(
      child: SizedBox(
        width: s,
        height: s,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -s * 0.0667,
              top: -s * 0.20,
              width: s * (1 + 0.0667 + 0.0833),
              height: s * (1 + 0.20 + 0.5167),
              child: Image.asset(ShotImg.profilePhoto, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRowData {
  const _StatRowData(
    this.mine,
    this.unit,
    this.name,
    this.diff,
    this.better,
    this.avg,
  );
  final String mine;
  final String unit;
  final String name;
  final String diff;
  final bool better;
  final String avg;
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({super.key, required this.rows});

  final List<_StatRowData> rows;

  @override
  Widget build(BuildContext context) {
    Widget value(String v, String u) => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          v,
          style: AppText.bold(20, lh: 30, color: AppColors.contentsSecondary),
        ),
        const SizedBox(width: 1),
        Text(u, style: AppText.regular(18, color: AppColors.contentsSecondary)),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpace.radiusXl),
      ),
      child: Column(
        children: [
          for (final (i, r) in rows.indexed) ...[
            if (i > 0) Container(height: 0.5, color: AppColors.borderPrimary),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
              child: SizedBox(
                height: 36,
                child: Row(
                  children: [
                    Expanded(child: value(r.mine, r.unit)),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(r.name, style: AppText.bold(14, lh: 19)),
                          const SizedBox(height: 4),
                          Text(
                            r.diff,
                            style: AppText.medium(
                              12,
                              lh: 13,
                              color: r.better
                                  ? AppColors.contentsBrand
                                  : ShotColors.functionalS1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: value(r.avg, r.unit)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

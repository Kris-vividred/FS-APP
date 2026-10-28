import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'shot_assets.dart';
import 'shot_common.dart';

/// 리포트 홈 > 스크린 탭의 empty `Con` (Figma Report_Screen_empty 1177:47207).
/// report_screen.dart 의 섹션을 복사해 empty 표현(dimmed 값, "-", opacity 50%,
/// "가상 스코어" 서브텍스트)으로 바꿨다. Expanded 안에 넣어 쓰는 스크롤 위젯.
class ReportScreenEmptyBody extends StatefulWidget {
  const ReportScreenEmptyBody({super.key});

  @override
  State<ReportScreenEmptyBody> createState() => _ReportScreenEmptyBodyState();
}

class _ReportScreenEmptyBodyState extends State<ReportScreenEmptyBody> {
  static const _products = ['프렌즈 스크린 Q', '프렌즈 스크린 T2'];
  static const _counts = ['최근 5회', '최근 10회', '최근 20회'];
  static const _virtual = '아래 데이터는 가상 스코어입니다.';

  String _product = _products[0];
  String _count = _counts[0];

  bool get _isQ => _product == _products[0];

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmptyMySection(
            productTitle: _isQ ? 'Friends Screen Q' : 'Friends Screen T2',
            onProduct: _pickProduct,
            onInfo: _showDataInfo,
          ),
          const SizedBox(height: 20),
          const ShotAdBanner(),
          ContentsContainer(
            title: '스코어카드',
            titleTrailing: Text(
              '3회',
              style: AppText.regular(18, color: AppColors.contentsBrand),
            ),
            subText: _virtual,
            contentsOpacity: 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _EmptyScoreCard(),
                const SizedBox(height: 10),
                OutlineButton42(
                  label: '전체보기',
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.scorecardList),
                ),
              ],
            ),
          ),
          ContentsContainer(
            title: '기록분석',
            subText: _virtual,
            bottomPadding: 40,
            divider: false,
            child: _EmptyAnalysis(
              productShort: _isQ ? 'Q' : 'T2',
              countLabel: _count,
              onProduct: _pickProduct,
              onCount: _pickCount,
              onItem: () => Navigator.pushNamed(context, Routes.analysis),
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma `my` (1615:15108) — 핸디 0.0(dimmed), 통계 "-".
class _EmptyMySection extends StatelessWidget {
  const _EmptyMySection({
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
                      Text(
                        '0.0',
                        style: AppText.bold(
                          42,
                          lh: 42 * 1.3,
                          color: ShotColors.contentsDimmed,
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
                        child: _EmptyStat(label: '최대 비거리', unit: 'm'),
                      ),
                      VDivider.h24(),
                      Expanded(
                        child: _EmptyStat(label: '최소 퍼팅수', unit: '타'),
                      ),
                      VDivider.h24(),
                      Expanded(
                        child: _EmptyStat(label: '최저 타수', unit: '타'),
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

class _EmptyStat extends StatelessWidget {
  const _EmptyStat({required this.label, required this.unit});

  final String label;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Text(
            label,
            style: AppText.medium(14, color: AppColors.contentsSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('-', style: AppText.bold(18, lh: 26)),
              const SizedBox(width: 2),
              Text(unit, style: AppText.regular(16)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma `Report/screenList` (가상 스코어 1건).
class _EmptyScoreCard extends StatelessWidget {
  const _EmptyScoreCard();

  @override
  Widget build(BuildContext context) {
    final meta = AppText.medium(14, color: AppColors.contentsSecondary);
    return Container(
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
              svg(Img.gameModeTeam, width: 16, height: 16),
              const SizedBox(width: 8),
              Text('3명', style: meta),
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
                  '소피아그린CC',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bold(16, lh: 24),
                ),
              ),
              const SizedBox(width: 10),
              svg(Img.badge1, width: 12, height: 12),
              const SizedBox(width: 8),
              Text('98', style: AppText.bold(24, lh: 24 * 1.3)),
            ],
          ),
        ],
      ),
    );
  }
}

/// 기록분석 empty — 칩은 활성, 그래프(값 라벨 없음)와 목록은 opacity 50%.
class _EmptyAnalysis extends StatelessWidget {
  const _EmptyAnalysis({
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
  final VoidCallback onItem;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const Opacity(opacity: 0.5, child: _EmptyRadar()),
        const SizedBox(height: 30),
        Opacity(
          opacity: 0.5,
          child: Container(
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
                    onTap: onItem,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 레이더 그래프 (339x276) — 값 pill 없이 라벨만.
class _EmptyRadar extends StatelessWidget {
  const _EmptyRadar();

  @override
  Widget build(BuildContext context) {
    final label = AppText.bold(14, lh: 20, color: AppColors.contentsSecondary);
    Widget at(double cx, double top, String text) => Positioned(
      left: cx - 60,
      top: top,
      width: 120,
      child: Text(text, textAlign: TextAlign.center, style: label),
    );
    Widget legend(String dot, String text) => Row(
      children: [
        svg(dot, width: 8, height: 8),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppText.medium(12, lh: 18, color: AppColors.contentsSecondary),
        ),
      ],
    );
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
              child: svg(Img.radarGraph, width: 180, height: 180),
            ),
            at(169.5, 0, '드라이버 거리'),
            at(169.5 - 118.5, 78, '페어웨이\n안착률'),
            at(169.5 + 118.5, 78, '샌드\n세이브율'),
            at(169.5 - 50.5, 194, '그린 적중률'),
            at(169.5 + 44.5, 194, '퍼팅'),
            Positioned(left: 115.5, top: 258, child: legend(Img.dotMe, '나')),
            Positioned(
              left: 161.5,
              top: 258,
              child: legend(Img.dotAvg, '동급 평균'),
            ),
          ],
        ),
      ),
    );
  }
}

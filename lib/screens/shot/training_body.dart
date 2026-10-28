import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'shot_assets.dart';
import 'shot_common.dart';

/// 리포트 홈 > 트레이닝 탭의 `con` 영역.
/// Figma 02.0.CategoryHome_Report_Training (1693:47233) /
/// Report_Training_empty (1654:42612). Expanded 안에 넣어 쓰는 스크롤 위젯.
class TrainingReportBody extends StatelessWidget {
  const TrainingReportBody({super.key, this.empty = false});

  final bool empty;

  static const _virtual = '아래 데이터는 가상 스코어입니다.';

  void _go(BuildContext context, String route, [Map<String, String>? args]) =>
      Navigator.pushNamed(context, route, arguments: args);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RecentClubSection(
            empty: empty,
            onClub: empty
                ? null
                : () => _go(context, Routes.shotRecords, {'club': 'driver'}),
            onGrade: empty
                ? null
                : () => _go(context, Routes.shotCompare, {'club': 'driver'}),
            onStats: empty ? null : () => _go(context, Routes.clubStats),
          ),
          const SizedBox(height: 20),
          const ShotAdBanner(),
          ContentsContainer(
            title: '스윙영상',
            subText: empty ? _virtual : null,
            contentsOpacity: empty ? 0.5 : 1,
            child: _ThumbnailRow(
              onTap: empty ? null : () => showNotReady(context, '스윙영상'),
            ),
          ),
          ContentsContainer(
            title: '클럽 측정',
            subText: empty ? _virtual : null,
            contentsOpacity: empty ? 0.5 : 1,
            bottomPadding: 40,
            divider: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TrainingListItem(
                  date: '12월 10일',
                  avg: '5구 평균',
                  club: '6번 아이언',
                  value: '130.5m',
                  onTap: empty
                      ? null
                      : () =>
                            _go(context, Routes.clubRecord, {'club': 'iron6'}),
                ),
                const SizedBox(height: 10),
                _TrainingListItem(
                  date: '12월 10일',
                  avg: '10구 평균',
                  club: '3번 우드',
                  value: '168.5m',
                  onTap: empty
                      ? null
                      : () =>
                            _go(context, Routes.clubRecord, {'club': 'wood3'}),
                ),
                if (!empty) ...[
                  const SizedBox(height: 10),
                  OutlineButton42(
                    label: '전체보기',
                    onTap: () => _go(context, Routes.clubRecord),
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

/// Recent Club Section — 최근 연습한 클럽 + 누적 통계 카드.
class _RecentClubSection extends StatelessWidget {
  const _RecentClubSection({
    required this.empty,
    this.onClub,
    this.onGrade,
    this.onStats,
  });

  final bool empty;
  final VoidCallback? onClub;
  final VoidCallback? onGrade;
  final VoidCallback? onStats;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.global,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '최근 연습한 클럽',
                  style: AppText.bold(
                    14,
                    lh: 20,
                    color: AppColors.contentsTertiary,
                  ),
                ),
                const SizedBox(height: 12),
                Pressable(
                  onTap: onClub,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '드라이버',
                              style: AppText.bold(
                                16,
                                lh: 24,
                                color: AppColors.contentsSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 36,
                              child: Row(
                                children: [
                                  Text(
                                    empty ? '0.0m' : '275.5m',
                                    style: AppText.bold(
                                      20,
                                      lh: 30,
                                      color: empty
                                          ? ShotColors.contentsDimmed
                                          : AppColors.contentsPrimary,
                                    ),
                                  ),
                                  if (!empty) ...[
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: onGrade,
                                      child: svg(
                                        ShotImg.gradeSLg,
                                        width: 36,
                                        height: 36,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const _ClubImage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Pressable(
            onTap: onStats,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpace.radiusMd),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _CumStat(
                      label: '누적 연습 시간',
                      value: empty ? '-' : '10,290',
                      unit: '분',
                      dim: empty,
                    ),
                  ),
                  const VDivider.h24(),
                  Expanded(
                    child: _CumStat(
                      label: '누적 연습 볼 수',
                      value: empty ? '-' : '211,118',
                      unit: '구',
                      dim: empty,
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

class _CumStat extends StatelessWidget {
  const _CumStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.dim,
  });

  final String label;
  final String value;
  final String unit;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dim ? 0.5 : 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              Text(unit, style: AppText.regular(18)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Figma `img/clubImg` (driver) — 110x100, 바닥 그림자(multiply 6%) + 클럽 이미지.
class _ClubImage extends StatelessWidget {
  const _ClubImage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 100,
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 73,
              width: 104,
              height: 26,
              child: ClipRect(
                child: Opacity(
                  opacity: 0.06,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: -104 * 1.4478,
                        top: -26 * 3.9857,
                        width: 104 * 2.4481,
                        height: 26 * 5.6395,
                        child: Image.asset(
                          ShotImg.clubDriverShadow,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 1,
              width: 107,
              height: 78,
              child: Image.asset(ShotImg.clubDriver, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}

/// 스윙영상 썸네일 3개 (가로 스크롤, 오른쪽으로 잘려 보임).
class _ThumbnailRow extends StatelessWidget {
  const _ThumbnailRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Pressable(onTap: onTap, child: const _Thumbnail()),
          ],
          const SizedBox(width: AppSpace.global),
        ],
      ),
    );
  }
}

/// Figma `thumbnailReport` 126x126.
class _Thumbnail extends StatelessWidget {
  const _Thumbnail();

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(
        offset: Offset(0, 3.19),
        blurRadius: 3.19,
        color: Color(0x4D000000),
      ),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 126,
        height: 126,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: AppColors.backgroundSecondary,
                alignment: Alignment.center,
                child: svg(ShotImg.thumbPlaceholder, width: 72, height: 72),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: ShotColors.thumbnailDim,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '어프로치',
                      style: AppText.medium(
                        14,
                        color: AppColors.white,
                      ).copyWith(shadows: shadow),
                    ),
                    Text(
                      '20.1m',
                      style: AppText.bold(
                        14,
                        lh: 20,
                        color: AppColors.white,
                      ).copyWith(shadows: shadow),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma `Report/trainingList`.
class _TrainingListItem extends StatelessWidget {
  const _TrainingListItem({
    required this.date,
    required this.avg,
    required this.club,
    required this.value,
    this.onTap,
  });

  final String date;
  final String avg;
  final String club;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final meta = AppText.medium(14, color: AppColors.contentsSecondary);
    return Pressable(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          16,
          AppSpace.global,
          14,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(date, style: meta)),
                const SizedBox(width: 10),
                Text(avg, style: meta),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: Text(club, style: AppText.bold(16, lh: 24))),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Text(value, style: AppText.bold(24, lh: 24 * 1.3)),
                    const SizedBox(width: 10),
                    svg(ShotImg.gradeS, width: 30, height: 30),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

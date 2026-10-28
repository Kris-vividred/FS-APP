import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'analysis_data.dart';
import 'analysis_img.dart';
import 'analysis_widgets.dart';

/// 구분선 아래 섹션(Figma `ScoreDistribution` 프레임) — 탭마다 내용이 다르다.
class AnalysisDetailSection extends StatelessWidget {
  const AnalysisDetailSection({super.key, required this.tab});

  final AnalysisTab tab;

  @override
  Widget build(BuildContext context) {
    final (Widget top, List<RecordRow> rows) = switch (tab) {
      AnalysisTab.score => (
        _withGraph('스코어 분포', const _ScoreSemi(), 140),
        [
          for (final (i, (n, v)) in const [
            ('버디 이하', '1'),
            ('파', '13'),
            ('보기', '2'),
            ('더블보기', '2'),
            ('트리플보기 이상', '0'),
          ].indexed)
            RecordRow(n, v, '회', dot: AnalysisImg.scoreLegend[i]),
        ],
      ),
      AnalysisTab.driverDistance => (
        _withGraph('드라이버 샷 분석', const _DriverAngle(), 140),
        const [
          RecordRow('나의 발사각', '15.3', ''),
          RecordRow('나의 볼스피드', '66.1', 'm/s'),
        ],
      ),
      AnalysisTab.fairway => (
        _withGraph('안착률 분석', const _FairwayMap(), 204),
        const [
          RecordRow('페어웨이', '50', '%'),
          RecordRow('벙커', '10', '%'),
          RecordRow('러프', '10', '%'),
          RecordRow('OB', '10', '%'),
          RecordRow('해저드', '10', '%'),
        ],
      ),
      AnalysisTab.gir => (
        _withGraph('홀컵 적중도', const _GirGreen(), 180),
        const [
          RecordRow('3m 이내', '50', '%'),
          RecordRow('5m 이내', '10', '%'),
          RecordRow('10m 이내', '10', '%'),
        ],
      ),
      AnalysisTab.parSave => (
        const AverageTitle(
          AverageHeader(
            title: '샌드 세이브율',
            grade: Grade.good,
            mine: '50.5',
            peer: '48.3',
            unit: '%',
          ),
        ),
        const [RecordRow('시도 횟수', '9', '회'), RecordRow('성공 횟수', '5', '회')],
      ),
      AnalysisTab.putting => (
        _withGraph('퍼트 정확도', const _PuttingSemi(), 140),
        [
          for (final (i, (n, v)) in const [
            ('1퍼트', '9'),
            ('2퍼트', '2'),
            ('3퍼트 이상', '7'),
          ].indexed)
            RecordRow(n, v, '회', dot: AnalysisImg.puttLegend[i]),
        ],
      ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.global,
        0,
        AppSpace.global,
        40,
      ),
      child: Column(
        children: [
          top,
          const SizedBox(height: 30),
          FadeRise(delayFraction: 0.3, child: RecordList(rows)),
        ],
      ),
    );
  }

  static Widget _withGraph(String title, Widget graph, double height) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DatedTitle(title),
      const SizedBox(height: 20),
      SizedBox(height: height, child: graph),
    ],
  );
}

Widget _pct(
  String label,
  String value, {
  Color color = AppColors.contentsPrimary,
}) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(label, style: AppText.medium(14, color: color)),
    Text(value, style: AppText.bold(18, lh: 26, color: color)),
  ],
);

Widget _bold14(String text, {Color color = AppColors.contentsPrimary}) => Text(
  text,
  textAlign: TextAlign.center,
  style: AppText.bold(14, lh: 20, color: color),
);

Widget _ball() => svg(AnalysisImg.ball, width: 24.2352, height: 35);

/// 스코어 분포 반원 그래프 (2389:50768).
class _ScoreSemi extends StatelessWidget {
  const _ScoreSemi();

  @override
  Widget build(BuildContext context) => _Semi(
    asset: AnalysisImg.scoreSemi,
    assetTop: 0.5,
    assetHeight: 130.008,
    labels: [
      (53, 53.89, _bold14('50%')),
      (146, 26.32, _bold14('12%')),
      (184, 44.37, _bold14('10%')),
      (213, 78.89, _bold14('21%')),
      (226, 110.89, _bold14('7%')),
    ],
  );
}

/// 퍼트 정확도 반원 그래프 (1654:42252).
class _PuttingSemi extends StatelessWidget {
  const _PuttingSemi();

  @override
  Widget build(BuildContext context) => _Semi(
    asset: AnalysisImg.puttingSemi,
    assetTop: 0,
    assetHeight: 131.179,
    labels: [
      (53, 53, _bold14('1퍼트', color: AppColors.white)),
      (143, 26, _bold14('2퍼트')),
      (200, 62, _bold14('3퍼트\n이상')),
    ],
  );
}

/// 270×132 반원 영역(가운데 정렬) + 공. 왼쪽부터 펼쳐지며 등장.
class _Semi extends StatelessWidget {
  const _Semi({
    required this.asset,
    required this.assetTop,
    required this.assetHeight,
    required this.labels,
  });

  final String asset;
  final double assetTop;
  final double assetHeight;
  final List<(double, double, Widget)> labels;

  @override
  Widget build(BuildContext context) => EntryProgress(
    duration: const Duration(milliseconds: 1000),
    builder: (_, t) => Stack(
      children: [
        Positioned(
          left: 35,
          top: 4.5,
          width: 270,
          height: 132,
          child: ClipRect(
            child: Stack(
              children: [
                Positioned(
                  left: 5,
                  top: assetTop,
                  child: ClipPath(
                    clipper: SweepClipper(t, center: Offset(130, assetHeight)),
                    child: svg(asset, width: 260, height: assetHeight),
                  ),
                ),
                for (final (x, y, w) in labels)
                  Positioned(
                    left: x,
                    top: y,
                    child: Opacity(
                      opacity: ((t - 0.55) / 0.45).clamp(0.0, 1.0),
                      child: w,
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(left: 158, top: 101.5, child: _ball()),
      ],
    ),
  );
}

/// 드라이버 샷 분석 각도 그래픽 (1654:40755). 발사각 선이 0°에서 올라온다.
class _DriverAngle extends StatelessWidget {
  const _DriverAngle();

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      Positioned(
        left: 106,
        top: 17.5,
        width: 161,
        height: 113,
        child: EntryProgress(
          builder: (_, t) => Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 2.53,
                top: -0.38,
                child: svg(
                  AnalysisImg.driverBgAngleBg,
                  width: 151.49,
                  height: 109.154,
                ),
              ),
              Positioned(
                left: 2.58,
                top: 80.56,
                child: svg(
                  AnalysisImg.driverAngle01,
                  width: 148.981,
                  height: 28.2142,
                ),
              ),
              Positioned(
                left: 2.58,
                top: 56.02,
                child: svg(
                  AnalysisImg.driverAngle02,
                  width: 140.363,
                  height: 52.748,
                ),
              ),
              Positioned(
                left: -15.95,
                top: 12.84,
                width: 147.663,
                height: 96.869,
                child: Center(
                  child: Transform.rotate(
                    angle: -19.93 * math.pi / 180,
                    child: SizedBox(
                      width: 137.666,
                      height: 53.166,
                      child: OverflowBox(
                        alignment: Alignment.topRight,
                        maxWidth: 137.666 * 1.0047,
                        maxHeight: 53.166 * 1.0121,
                        child: svg(
                          AnalysisImg.driverAngle03,
                          width: 137.666 * 1.0047,
                          height: 53.166 * 1.0121,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 1.08,
                top: -10,
                child: svg(
                  AnalysisImg.driverBgAngle,
                  width: 162.92,
                  height: 120,
                ),
              ),
              // 발사각 지시선: 공 위치(왼쪽 아래)를 축으로 회전하며 등장
              Positioned(
                left: 3.13,
                top: 30.82,
                child: Transform.rotate(
                  angle: (1 - t) * 30.3 * math.pi / 180,
                  alignment: const Alignment(-0.99, 0.97),
                  child: svg(
                    AnalysisImg.driverAnglePoint,
                    width: 131.138,
                    height: 78.7171,
                  ),
                ),
              ),
              Positioned(
                left: 143.27,
                top: 18.82,
                child: Opacity(
                  opacity: ((t - 0.5) / 0.5).clamp(0.0, 1.0),
                  child: Text.rich(
                    TextSpan(
                      text: '15.3',
                      children: [
                        TextSpan(
                          text: '°',
                          style: AppText.regular(
                            18,
                            lh: 26,
                            color: AppColors.contentsBrand,
                          ),
                        ),
                      ],
                    ),
                    style: AppText.bold(
                      18,
                      lh: 26,
                      color: AppColors.contentsBrand,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(left: 72, top: 96.5, child: _ball()),
    ],
  );
}

/// 안착률 분석 코스 맵 (1654:41185).
class _FairwayMap extends StatelessWidget {
  const _FairwayMap();

  @override
  Widget build(BuildContext context) => FadeRise(
    child: Stack(
      children: [
        Positioned(
          left: 16.76,
          top: 0,
          child: svg(AnalysisImg.fairwayMap, width: 306.327, height: 204.706),
        ),
        Positioned(
          left: 191,
          top: 118,
          child: svg(AnalysisImg.fairwayHazard, width: 132, height: 86),
        ),
        Positioned(left: 151, top: 29, child: _pct('벙커', '10%')),
        Positioned(left: 219, top: 141, child: _pct('해저드', '10%')),
        Positioned(
          left: 33,
          top: 136,
          child: _pct('러프', '10%', color: AppColors.white),
        ),
        Positioned(left: 40, top: 30, child: _pct('OB', '10%')),
      ],
    ),
  );
}

/// 홀컵 적중도 그린 (1654:41732). 바깥 링부터 차례로 커지며 등장.
class _GirGreen extends StatelessWidget {
  const _GirGreen();

  @override
  Widget build(BuildContext context) => ClipRect(
    child: EntryProgress(
      duration: const Duration(milliseconds: 1000),
      builder: (_, t) {
        double step(int i) => ((t - i * 0.2) / 0.6).clamp(0.0, 1.0);
        Widget pop(int i, Widget child) => Opacity(
          opacity: step(i),
          child: Transform.scale(scale: 0.85 + 0.15 * step(i), child: child),
        );
        return Stack(
          children: [
            Positioned(
              left: 24,
              top: 9.78,
              child: pop(
                0,
                svg(AnalysisImg.girGreen10m, width: 291.338, height: 162.08),
              ),
            ),
            Positioned(
              left: 110.53,
              top: 31.18,
              child: pop(
                1,
                svg(AnalysisImg.girGreen5m, width: 193.309, height: 103.898),
              ),
            ),
            Positioned(
              left: 186.63,
              top: 43.07,
              child: pop(
                2,
                svg(AnalysisImg.girGreen3m, width: 107.177, height: 62.24),
              ),
            ),
            Positioned(
              left: 195.56,
              top: 57,
              width: 47,
              child: pop(2, _pct('3m이내', '10%')),
            ),
            Positioned(
              left: 126.56,
              top: 57,
              width: 47,
              child: pop(1, _pct('5m이내', '10%')),
            ),
            Positioned(
              left: 45.56,
              top: 57,
              width: 55,
              child: pop(0, _pct('10m이내', '10%', color: AppColors.white)),
            ),
            Positioned(
              left: 259.04,
              top: 52.49,
              child: pop(
                2,
                svg(AnalysisImg.girFlag, width: 17.5433, height: 26),
              ),
            ),
          ],
        );
      },
    ),
  );
}

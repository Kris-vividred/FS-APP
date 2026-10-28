import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'share_img.dart';

/// 편집형 카드 레이아웃 — Figma Section "Default"(1738:11831) A–F,
/// "Team"(2543:10244) A·C·E·F.
enum ShareLayout {
  a(ShareImg.thumbA),
  b(ShareImg.thumbB),
  c(ShareImg.thumbC),
  d(ShareImg.thumbD),
  e(ShareImg.thumbE),
  f(ShareImg.thumbF);

  const ShareLayout(this.thumb);
  final String thumb;

  static const personalSet = values;
  static const teamSet = [a, c, e, f];

  static ShareLayout? parse(String? v) {
    for (final l in values) {
      if (l.name == v?.toLowerCase()) return l;
    }
    return null;
  }
}

/// 편집형 카드 배경.
enum ShareBackground { character, course, camera, album }

const _date = '2024.07.19';
const _course = '비에이비스타-몬티/벨라';

/// 360×360 기준으로 그린 편집형 카드. 미리보기에서는 FittedBox로 축소한다.
class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.layout,
    required this.background,
    required this.team,
  });

  final ShareLayout layout;
  final ShareBackground background;
  final bool team;

  String get _name => team ? 'Team EPIC' : '3초홍길동';

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 360,
      child: Stack(
        children: [
          Positioned.fill(child: _Background(background)),
          ...switch (layout) {
            ShareLayout.a => _layoutA(),
            ShareLayout.b => _layoutB(),
            ShareLayout.c => _layoutC(),
            ShareLayout.d => _layoutD(),
            ShareLayout.e => _layoutE(),
            ShareLayout.f => _layoutF(),
          },
        ],
      ),
    );
  }

  // A (1774:13828) — 반투명 박스 안에 이름/코스/점수.
  List<Widget> _layoutA() => [
    const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.23558, 0.51923, 1],
            colors: [Color(0x000D1322), Color(0x240D1322), Color(0x800D1322)],
          ),
        ),
      ),
    ),
    Positioned(
      left: 10,
      top: 263,
      width: 340,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ShareColors.reportcard01,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: _W.bold(18, lh: 26)),
                  const SizedBox(height: 4),
                  Text(_course, style: _W.regular(14, lh: 20)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(team ? '2UP' : '74', style: _W.bold(42, lh: 42 * 1.3)),
          ],
        ),
      ),
    ),
    const _Header(),
  ];

  // B (1774:13759) — 하단 그린 바에 홀별 스코어.
  List<Widget> _layoutB() => [
    const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.30288, 1],
            colors: [Color(0x000D1322), Color(0xE6000000)],
          ),
        ),
      ),
    ),
    Positioned(
      left: 24,
      top: 288.5 - 42 * 1.3 / 2,
      child: Text('86', style: _W.bold(42, lh: 42 * 1.3)),
    ),
    Positioned(
      left: 85,
      top: 260,
      width: 255,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(_name, style: _W.bold(16, lh: 24)),
          const SizedBox(height: 4),
          Text(_course, style: _W.medium(14)),
        ],
      ),
    ),
    const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: _HoleBar(
        color: AppColors.contentsBrand,
        circle: ShareImg.circleWhite,
        circleText: AppColors.contentsBrand,
      ),
    ),
    const _Header(),
  ];

  // C (1774:13693) — 오른쪽 세로 스코어 패널.
  List<Widget> _layoutC() {
    final values = team
        ? const ['DN', 'UP', 'AS', 'DN', 'UP', 'AS', 'DN', 'UP', 'AS']
        : const ['0', '-1', '3', '0', '2', '-1', '1', '-1', '0'];
    final total = team ? '7DN' : '34';
    Widget column() => Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final v in values)
          Container(
            width: 24,
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            alignment: Alignment.centerRight,
            child: Text(
              v,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: _W.medium(12, lh: 18),
            ),
          ),
        const SizedBox(height: 12),
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(0x33F6F8F9),
            shape: BoxShape.circle,
          ),
          child: OverflowBox(
            maxWidth: 40,
            child: Center(
              child: Text(total, softWrap: false, style: _W.bold(12)),
            ),
          ),
        ),
      ],
    );

    return [
      Positioned.fill(child: svg(ShareImg.cardCDim, width: 360, height: 360)),
      Positioned(
        left: 276,
        top: 0,
        width: 84,
        height: 360,
        child: Container(
          color: ShareColors.reportcard03,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [column(), const SizedBox(width: 12), column()],
              ),
              const SizedBox(height: 20),
              Text(
                team ? '3UP' : '76',
                softWrap: false,
                style: _W.bold(42, lh: 42 * 1.3),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 18,
        top: 18,
        width: 248,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_course, style: _W.bold(16, lh: 24)),
            const SizedBox(height: 4),
            Text(_date, style: _W.medium(14)),
          ],
        ),
      ),
      Positioned(
        left: 20,
        top: 328,
        child: svg(ShareImg.cardLogo, width: 122, height: 12),
      ),
    ];
  }

  // D (1774:13860) — 하단 블랙 바에 홀별 스코어.
  List<Widget> _layoutD() => [
    const Positioned.fill(child: _MultiplyDim()),
    Positioned(
      left: 18,
      top: 264,
      width: 263,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_name, style: _W.bold(16, lh: 24)),
          const SizedBox(height: 4),
          Text(_course, style: _W.medium(14)),
        ],
      ),
    ),
    Positioned(
      right: 18,
      top: 291.5 - 42 * 1.3 / 2,
      child: Text('82', style: _W.bold(42, lh: 42 * 1.3)),
    ),
    const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: _HoleBar(
        color: ShareColors.surfaceInverse,
        circle: ShareImg.circleOutline,
        circleText: AppColors.white,
      ),
    ),
    const _Header(),
  ];

  // E (1774:13925) — 하단 전체폭 반투명 바, 총타수(+오버).
  List<Widget> _layoutE() => [
    Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: ShareColors.reportcard01,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: _W.bold(18, lh: 26)),
                  const SizedBox(height: 6),
                  Text(_course, style: _W.medium(14)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('132 (+60)', style: _W.bold(24, lh: 24 * 1.3)),
                const SizedBox(height: 8),
                Text(
                  _date,
                  style: AppText.medium(
                    12,
                    lh: 18,
                    color: ShareColors.contentsMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    const _Header(showDate: false),
  ];

  // F (2543:10405) — 점수 + 전/후반 홀별 스코어 2줄.
  List<Widget> _layoutF() {
    final rows = team
        ? const [
            (['DN', 'UP', 'AS', 'DN', 'UP', 'AS', 'DN', 'UP', 'AS'], '3DN'),
            (['DN', 'UP', 'AS', 'DN', 'UP', 'AS', 'DN', 'UP', 'AS'], '3DN'),
          ]
        : const [
            (['0', '-1', '3', '0', '2', '-1', '1', '-1', '0'], '40'),
            (['-1', '-1', '3', '0', '2', '-1', '1', '-1', '0'], '34'),
          ];
    return [
      const Positioned.fill(child: _MultiplyDim()),
      Positioned(
        left: 10,
        top: 250,
        width: 340,
        height: 100,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
          decoration: BoxDecoration(
            color: ShareColors.reportcard02,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Text(_name, style: _W.bold(16, lh: 24))),
                  Text(_course, style: _W.medium(12, lh: 18)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(team ? '7DN' : '74', style: _W.bold(42, lh: 42 * 1.3)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        for (final (vals, total) in rows)
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    for (final (i, v) in vals.indexed) ...[
                                      if (i > 0) const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          v,
                                          textAlign: TextAlign.center,
                                          softWrap: false,
                                          overflow: TextOverflow.visible,
                                          style: _W.medium(12, lh: 18),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(total, style: _W.bold(13, lh: 18)),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const _Header(),
    ];
  }
}

/// 흰 글씨 AppText 단축.
abstract final class _W {
  static TextStyle bold(double s, {double? lh}) =>
      AppText.bold(s, lh: lh, color: AppColors.white);
  static TextStyle medium(double s, {double? lh}) =>
      AppText.medium(s, lh: lh, color: AppColors.white);
  static TextStyle regular(double s, {double? lh}) =>
      AppText.regular(s, lh: lh, color: AppColors.white);
}

/// 상단 FRIENDS SCREEN 로고 + 날짜 (padding 20).
class _Header extends StatelessWidget {
  const _Header({this.showDate = true});

  final bool showDate;

  @override
  Widget build(BuildContext context) => Positioned(
    left: 0,
    right: 0,
    top: 0,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            svg(ShareImg.cardLogo, width: 122, height: 12),
            if (showDate) Text(_date, style: _W.bold(14, lh: 20)),
          ],
        ),
      ),
    ),
  );
}

/// Figma dim (mix-blend-mode: multiply, #D9D9D9 0% → #737373 100%, y 153→360).
/// multiply 결과와 같은 검정 반투명 그라데이션으로 옮겼다.
class _MultiplyDim extends StatelessWidget {
  const _MultiplyDim();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment(0, -1 + 2 * 153 / 360),
        end: Alignment.bottomCenter,
        colors: [Color(0x00000000), Color(0x8C000000)],
      ),
    ),
  );
}

/// B·D 하단 바 — 18홀 스코어, 전/후반 합계는 원 안에.
class _HoleBar extends StatelessWidget {
  const _HoleBar({
    required this.color,
    required this.circle,
    required this.circleText,
  });

  final Color color;
  final String circle;
  final Color circleText;

  static const _front = ['1', '0', '1', '0', '0', '0', '0', '1', '0'];
  static const _back = ['0', '2', '-1', '1', '1', '1', '1', '1', '1'];

  @override
  Widget build(BuildContext context) {
    Widget item(String t) => SizedBox(
      width: 14,
      height: 12,
      child: OverflowBox(
        maxWidth: 24,
        child: Center(child: Text(t, softWrap: false, style: _W.regular(10))),
      ),
    );
    Widget total(String t) => SizedBox(
      width: 20,
      height: 12,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: -4,
            child: svg(circle, width: 20, height: 20),
          ),
          Text(
            t,
            style: AppText.bold(10, color: circleText).copyWith(height: 1),
          ),
        ],
      ),
    );

    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final v in _front) item(v),
          total('39'),
          for (final v in _back) item(v),
          total('43'),
        ],
      ),
    );
  }
}

/// 배경 선택 결과. 코스는 같은 원본 이미지에서 코스(카트·그린) 쪽을 확대해 보여준다.
class _Background extends StatelessWidget {
  const _Background(this.bg);

  final ShareBackground bg;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(ShareImg.bgCharacter, fit: BoxFit.cover);
    return switch (bg) {
      ShareBackground.course => ClipRect(
        child: Transform.scale(
          scale: 2.2,
          alignment: const Alignment(-1, 0.55),
          child: image,
        ),
      ),
      _ => image,
    };
  }
}

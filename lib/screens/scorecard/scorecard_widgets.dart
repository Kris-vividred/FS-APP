import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'scorecard_img.dart';

/// 스코어카드 그룹에서만 쓰는 색 (Figma score/*, action/*, functional/*).
abstract final class ScColors {
  static const borderSecondary = Color(0xFFD0D7DC);
  static const scoreEagle = Color(0xFFFF9D88);
  static const scoreBirdie = Color(0xFFFFD9D0);
  static const scoreBogey = Color(0xFFADB9C2);
  static const scoreDb = Color(0xFFD0D7DC);
  static const scoreUp = Color(0xFFFA5E4C);
  static const scoreDn = Color(0xFF8CD6FF);
  static const scoreAs = Color(0xFF101214);
  static const functionalS1 = Color(0xFFFF9D88);
  static const primaryDisabled = Color(0xFFD3F1DF);
  static const gray800 = Color(0xFF272C30);
  static const thumbDim = Color(0x33101214);
}

/// Figma gameBadge 종류.
enum GameBadge {
  holeinone(Img.badge1),
  eagle(Img.badge2),
  condor(Img.badge3),
  albatross(ScorecardImg.badgeAlbatross);

  const GameBadge(this.asset);
  final String asset;
}

/// SVG를 원본 크기 그대로 [box] 크기 슬롯 가운데에 그린다
/// (Figma의 `inset-[0_-4.17%]`처럼 슬롯보다 살짝 넓은 에셋용).
class SlotIcon extends StatelessWidget {
  const SlotIcon(this.asset, {super.key, this.size = 16, this.tint});

  final String asset;
  final double size;
  final Color? tint;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: OverflowBox(
      maxWidth: size * 1.5,
      maxHeight: size * 1.5,
      child: svg(asset, tint: tint),
    ),
  );
}

/// Figma gameBadgeSet — 12px 배지를 4px 간격으로 나열.
class GameBadgeSet extends StatelessWidget {
  const GameBadgeSet(this.badges, {super.key});

  final List<GameBadge> badges;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final (i, b) in badges.indexed) ...[
        if (i > 0) const SizedBox(width: 4),
        SlotIcon(b.asset, size: 12),
      ],
    ],
  );
}

/// 눌림 피드백(살짝 축소)이 있는 탭 영역.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) => setState(() => _down = v);

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTapDown: (_) => _set(true),
    onTapUp: (_) => _set(false),
    onTapCancel: () => _set(false),
    onTap: widget.onTap,
    child: AnimatedScale(
      scale: _down ? 0.98 : 1,
      duration: const Duration(milliseconds: 120),
      child: widget.child,
    ),
  );
}

/// Figma `LabelContents` — 제목 + (선택) 초록 카운트.
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.title, {super.key, this.count});

  final String title;
  final String? count;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(title, style: AppText.bold(18, lh: 26)),
      if (count != null) ...[
        const SizedBox(width: 6),
        Text(
          count!,
          style: AppText.regular(18, color: AppColors.contentsBrand),
        ),
      ],
    ],
  );
}

/// Figma `ContainerContentsDefault` — 패딩 18/30, 제목과 내용 간격 20, 하단 구분선.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.subText,
    this.bottomPadding = 30,
    this.divider = true,
    this.bleedRight = false,
  });

  final Widget title;
  final Widget child;
  final Widget? trailing;
  final String? subText;
  final double bottomPadding;
  final bool divider;

  /// 가로 스크롤 콘텐츠가 오른쪽 패딩을 넘어 화면 끝까지 이어지게 한다.
  final bool bleedRight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(AppSpace.global, 30, AppSpace.global, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: title),
                  if (trailing != null) ...[
                    const SizedBox(width: 10),
                    trailing!,
                  ],
                ],
              ),
              if (subText != null) ...[
                const SizedBox(height: 10),
                Text(
                  subText!,
                  style: AppText.medium(14, color: AppColors.contentsTertiary),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(
            left: AppSpace.global,
            right: bleedRight ? 0 : AppSpace.global,
            bottom: bottomPadding,
          ),
          child: child,
        ),
        if (divider) Container(height: 1, color: AppColors.borderPrimary),
      ],
    );
  }
}

/// 세로 구분선(9px)을 사이에 둔 meta 텍스트 묶음.
class MetaTexts extends StatelessWidget {
  const MetaTexts(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final style = AppText.medium(14, color: AppColors.contentsSecondary);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, t) in items.indexed) ...[
          if (i > 0) ...[
            const SizedBox(width: 8),
            const VDivider.h9(),
            const SizedBox(width: 8),
          ],
          Text(t, style: style),
        ],
      ],
    );
  }
}

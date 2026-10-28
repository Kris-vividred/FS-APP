import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';

/// 눌림 피드백(살짝 축소)을 주는 탭 래퍼.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _pressed = false;

  void _set(bool v) {
    if (widget.onTap != null) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

/// Figma `ContainerContentsDefault` — 제목(+서브텍스트) + 컨텐츠 + 하단 구분선.
class ContentsContainer extends StatelessWidget {
  const ContentsContainer({
    super.key,
    required this.title,
    required this.child,
    this.titleTrailing,
    this.subText,
    this.bottomPadding = 30,
    this.divider = true,
    this.contentsOpacity = 1,
  });

  final String title;
  final Widget? titleTrailing;
  final String? subText;
  final Widget child;
  final double bottomPadding;
  final bool divider;
  final double contentsOpacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpace.global,
            30,
            AppSpace.global,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(title, style: AppText.bold(18, lh: 26)),
                  if (titleTrailing != null) ...[
                    const SizedBox(width: 6),
                    titleTrailing!,
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
              const SizedBox(height: 20),
              Opacity(opacity: contentsOpacity, child: child),
            ],
          ),
        ),
        if (divider) Container(height: 1, color: AppColors.borderPrimary),
      ],
    );
  }
}

/// Figma `button` (outline, 42h) — "전체보기".
class OutlineButton42 extends StatelessWidget {
  const OutlineButton42({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
          border: Border.all(color: AppColors.borderTertiary, width: 0.5),
        ),
        child: Text(
          label,
          style: AppText.bold(14, lh: 20, color: AppColors.contentsSecondary),
        ),
      ),
    );
  }
}

/// report_screen.dart 의 _AdBanner 복사본 (Figma `ad`, 375x90).
class ShotAdBanner extends StatelessWidget {
  const ShotAdBanner({super.key});

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

/// Figma `bottomsheetHandle` — 제목 없이 20px 핸들만 있는 체크 목록 시트.
Future<String?> showHandleChoiceSheet(
  BuildContext context, {
  required List<String> options,
  required String selected,
}) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: false,
    barrierColor: AppColors.dim,
    backgroundColor: AppColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpace.radiusXl),
      ),
    ),
    builder: (ctx) => Padding(
      // handle 20 + contents pt 20
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, o) in options.indexed) ...[
            if (i > 0) const SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.of(ctx).pop(o),
              child: SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Text(o, style: AppText.regular(16)),
                    if (o == selected) ...[
                      const SizedBox(width: 12),
                      svg(Img.check, width: 16, height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

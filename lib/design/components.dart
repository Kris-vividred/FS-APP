import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'tokens.dart';

Widget svg(String asset, {double? width, double? height, Color? tint}) => SvgPicture.asset(
      asset,
      width: width,
      height: height,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
    );

/// Figma `Badge` — Q / Good / Normal / Bad.
class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {super.key, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppSpace.radiusSm)),
      alignment: Alignment.center,
      child: Text(label, style: AppText.bold(10, color: AppColors.white)),
    );
  }
}

/// Figma `sortCombination` 의 sort 칩.
class SortChip extends StatelessWidget {
  const SortChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
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
          border: selected ? null : Border.all(color: AppColors.borderPrimary, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: AppText.regular(14,
                    lh: 20, color: selected ? AppColors.white : AppColors.contentsSecondary)),
            const SizedBox(width: 4),
            svg(Img.arrowDown12, width: 12, height: 12, tint: selected ? AppColors.white : null),
          ],
        ),
      ),
    );
  }
}

/// 세로 구분선 — Figma에서는 가로 라인 SVG를 90° 회전해 사용.
class VDivider extends StatelessWidget {
  const VDivider.h24({super.key}) : asset = Img.dividerV24, length = 24;
  const VDivider.h9({super.key}) : asset = Img.dividerV9, length = 9;

  final String asset;
  final double length;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 1,
        height: length,
        child: OverflowBox(
          maxWidth: length,
          child: RotatedBox(quarterTurns: 1, child: svg(asset, width: length)),
        ),
      );
}

/// Figma `Report/analysisItem`.
class AnalysisItem extends StatelessWidget {
  const AnalysisItem({
    super.key,
    required this.name,
    required this.value,
    required this.unit,
    this.badge,
    this.onTap,
  });

  final String name;
  final String value;
  final String unit;
  final (String, Color)? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Row(children: [
              Text(name, style: AppText.medium(14, color: AppColors.contentsSecondary)),
              if (badge != null) ...[const SizedBox(width: 6), AppBadge(badge!.$1, color: badge!.$2)],
            ]),
          ),
          Text(value, style: AppText.bold(16, lh: 24)),
          Text(unit, style: AppText.regular(16)),
          SizedBox(width: 16, height: 16, child: Center(child: svg(Img.arrowRight, width: 6, height: 10))),
        ],
      ),
    );
  }
}

/// Figma `bottomsheet/Header` + contents 구조의 공통 바텀시트.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required String title,
  required Widget Function(BuildContext) contentBuilder,
  bool showBar = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: false,
    barrierColor: AppColors.dim,
    backgroundColor: AppColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpace.radiusXl)),
    ),
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Column(children: [
            if (showBar) svg(Img.sheetBar, width: 54, height: 4),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(children: [
                Expanded(child: Text(title, style: AppText.bold(18, lh: 26))),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: svg(Img.close, width: 24, height: 24),
                ),
              ]),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          child: contentBuilder(ctx),
        ),
      ],
    ),
  );
}

/// Figma `Common/check` 목록으로 된 선택 시트.
Future<String?> showChoiceSheet(
  BuildContext context, {
  required String title,
  required List<String> options,
  required String selected,
}) {
  return showAppSheet<String>(
    context,
    title: title,
    contentBuilder: (ctx) => Column(
      children: [
        for (final (i, o) in options.indexed) ...[
          if (i > 0) const SizedBox(height: 10),
          InkWell(
            onTap: () => Navigator.of(ctx).pop(o),
            child: SizedBox(
              height: 48,
              child: Row(children: [
                Text(o, style: AppText.regular(16)),
                if (o == selected) ...[const SizedBox(width: 12), svg(Img.check, width: 16, height: 16)],
              ]),
            ),
          ),
        ],
      ],
    ),
  );
}

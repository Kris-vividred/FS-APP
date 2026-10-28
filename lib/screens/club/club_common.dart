import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';

/// Figma `tabCombination` — Header(168) 안의 기록 / 클럽별 통계 탭.
class ClubHeaderTabs extends StatelessWidget {
  const ClubHeaderTabs({
    super.key,
    required this.index,
    required this.onChanged,
  });

  final int index;
  final ValueChanged<int> onChanged;

  static const _labels = ['기록', '클럽별 통계'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (i, label) in _labels.indexed)
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: i == index
                        ? const BorderSide(
                            color: AppColors.contentsPrimary,
                            width: 2,
                          )
                        : const BorderSide(color: AppColors.borderPrimary),
                  ),
                ),
                child: Text(
                  label,
                  style: i == index
                      ? AppText.bold(16, lh: 24)
                      : AppText.regular(16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Figma `InfoText` — 빈 상태 안내 문구.
class ClubInfoText extends StatelessWidget {
  const ClubInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '클럽 측정을 하면\n자세한 샷 정보를 확인할 수 있어요.',
          style: AppText.bold(18, lh: 26),
        ),
        const SizedBox(height: 10),
        Text(
          '아래 데이터는 가상 스코어입니다.',
          style: AppText.medium(14, color: AppColors.contentsTertiary),
        ),
      ],
    );
  }
}

/// Figma `bottomsheetHandle` — 제목 없이 20px 핸들 영역 + `Common/check` 목록.
Future<String?> showClubHandleSheet(
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
    builder: (ctx) => SingleChildScrollView(
      child: Padding(
        // 핸들 20 + contents 상단 패딩 20
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
    ),
  );
}

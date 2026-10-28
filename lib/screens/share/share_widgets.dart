import 'dart:async';

import 'package:flutter/material.dart';

import '../../design/tokens.dart';
import 'share_img.dart';

/// Figma `toggleTextSquare` — 기본형 / 편집형.
class ShareToggle extends StatelessWidget {
  const ShareToggle({super.key, required this.edit, required this.onChanged});

  /// true면 '편집형'이 선택된 상태.
  final bool edit;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, bool selected, bool value) => Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: selected ? null : () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            border: Border.all(
              color: selected ? AppColors.contentsBrand : Colors.transparent,
            ),
          ),
          child: Text(
            label,
            style: AppText.bold(
              16,
              lh: 24,
              color: selected
                  ? AppColors.contentsBrand
                  : AppColors.contentsTertiary,
            ),
          ),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: ShareColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppSpace.radiusMd),
      ),
      child: Row(
        children: [cell('기본형', !edit, false), cell('편집형', edit, true)],
      ),
    );
  }
}

/// Figma `buttonCombinationDefault` — 이미지 저장 / 공유하기.
class ShareBottomButtons extends StatelessWidget {
  const ShareBottomButtons({
    super.key,
    required this.onSave,
    required this.onShare,
  });

  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    Widget button(String label, Color bg, Color fg, VoidCallback onTap) =>
        Expanded(
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: 54,
                padding: const EdgeInsets.only(top: 2, left: 24, right: 24),
                alignment: Alignment.center,
                child: Text(label, style: AppText.bold(16, lh: 24, color: fg)),
              ),
            ),
          ),
        );

    return Container(
      height: 66,
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          button(
            '이미지 저장',
            ShareColors.surfaceSecondary,
            AppColors.contentsSecondary,
            onSave,
          ),
          const SizedBox(width: 8),
          button('공유하기', AppColors.actionPrimary, AppColors.white, onShare),
        ],
      ),
    );
  }
}

/// Figma `tabCombination` (배경 / 레이아웃).
class ShareTabs extends StatelessWidget {
  const ShareTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.borderPrimary)),
      ),
      child: Row(
        children: [
          for (final (i, l) in labels.indexed) ...[
            if (i > 0) const SizedBox(width: 30),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: Container(
                height: 48,
                constraints: const BoxConstraints(minWidth: 32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: i == index
                          ? AppColors.contentsPrimary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  l,
                  style: i == index
                      ? AppText.bold(16, lh: 24)
                      : AppText.regular(16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Figma `Toast` — 나타났다가 약 2초 뒤 사라진다.
mixin ShareToastMixin<T extends StatefulWidget> on State<T> {
  String? _toastText;
  bool _toastVisible = false;
  Timer? _toastTimer;

  void showToast(String text) {
    _toastTimer?.cancel();
    setState(() {
      _toastText = text;
      _toastVisible = true;
    });
    _toastTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _toastVisible = false);
    });
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  /// Stack 안에 넣는다. 화면 하단에서 40 위, 폭 339.
  Widget buildToast() => Positioned(
    left: 0,
    right: 0,
    bottom: 40,
    child: IgnorePointer(
      child: AnimatedOpacity(
        opacity: _toastVisible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        child: Center(
          child: Container(
            width: 339,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: ShareColors.toast,
              borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            ),
            alignment: Alignment.center,
            child: Text(
              _toastText ?? '',
              style: AppText.bold(14, lh: 20, color: AppColors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

const shareSaveToast = '이미지 저장이 완료되었습니다.';

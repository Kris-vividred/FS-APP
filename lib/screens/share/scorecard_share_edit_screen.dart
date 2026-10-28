import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'share_cards.dart';
import 'share_img.dart';
import 'share_widgets.dart';

/// Figma Scorecard_share_edit_background (1738:10889) /
/// _edit_layout (1738:11491) / _edit_layout_team (2389:53404).
class ScorecardShareEditScreen extends StatefulWidget {
  const ScorecardShareEditScreen({
    super.key,
    required this.team,
    this.initialTab = 0,
    this.initialLayout,
  });

  final bool team;

  /// 0 = 배경, 1 = 레이아웃.
  final int initialTab;
  final ShareLayout? initialLayout;

  @override
  State<ScorecardShareEditScreen> createState() =>
      _ScorecardShareEditScreenState();
}

class _ScorecardShareEditScreenState extends State<ScorecardShareEditScreen>
    with ShareToastMixin {
  late int _tab = widget.initialTab;
  late ShareLayout _layout =
      widget.initialLayout ??
      // 개인 레이아웃 탭 프레임은 B가 선택된 상태로 그려져 있다.
      (widget.initialTab == 1 && !widget.team ? ShareLayout.b : ShareLayout.a);
  ShareBackground _bg = ShareBackground.character;

  List<ShareLayout> get _layouts =>
      widget.team ? ShareLayout.teamSet : ShareLayout.personalSet;

  void _pickBackground(ShareBackground bg) {
    switch (bg) {
      case ShareBackground.camera:
        showNotReady(context, '카메라');
      case ShareBackground.album:
        showNotReady(context, '앨범');
      default:
        setState(() => _bg = bg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              const SubHeader(title: '스코어카드 공유하기'),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          AppSpace.global,
                        ).copyWith(top: 20, bottom: 20),
                        child: Column(
                          children: [
                            ShareToggle(
                              edit: true,
                              onChanged: (_) =>
                                  Navigator.of(context).maybePop(),
                            ),
                            const SizedBox(height: 20),
                            _Preview(
                              layout: _layout,
                              background: _bg,
                              team: widget.team,
                            ),
                          ],
                        ),
                      ),
                      ShareTabs(
                        labels: const ['배경', '레이아웃'],
                        index: _tab,
                        onChanged: (i) => setState(() => _tab = i),
                      ),
                      const SizedBox(height: 30),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: _tab == 0
                            ? _BackgroundOptions(
                                key: const ValueKey('bg'),
                                selected: _bg,
                                onSelect: _pickBackground,
                              )
                            : _LayoutOptions(
                                key: const ValueKey('layout'),
                                layouts: _layouts,
                                selected: _layout,
                                onSelect: (l) => setState(() => _layout = l),
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              ShareBottomButtons(
                onSave: () => showToast(shareSaveToast),
                onShare: () => showToast(shareSaveToast),
              ),
            ],
          ),
          buildToast(),
        ],
      ),
    );
  }
}

/// 상단 339×339 미리보기 (360 기준 카드를 축소, radius 16).
class _Preview extends StatelessWidget {
  const _Preview({
    required this.layout,
    required this.background,
    required this.team,
  });

  final ShareLayout layout;
  final ShareBackground background;
  final bool team;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpace.radiusXl),
        child: FittedBox(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: ShareCard(
              key: ValueKey((layout, background)),
              layout: layout,
              background: background,
              team: team,
            ),
          ),
        ),
      ),
    );
  }
}

/// 배경 탭 — 캐릭터 / 코스 / 카메라 / 앨범.
class _BackgroundOptions extends StatelessWidget {
  const _BackgroundOptions({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final ShareBackground selected;
  final ValueChanged<ShareBackground> onSelect;

  @override
  Widget build(BuildContext context) {
    Widget option(ShareBackground bg, String label, Widget icon) {
      final on = bg == selected;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelect(bg),
        child: SizedBox(
          width: 60,
          child: Column(
            children: [
              SizedBox.square(
                dimension: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(child: icon),
                    if (on)
                      Positioned(
                        left: -1,
                        top: -1,
                        right: -1,
                        bottom: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.contentsBrand,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppText.medium(
                  12,
                  lh: 18,
                  color: AppColors.contentsSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          option(
            ShareBackground.character,
            '캐릭터',
            Container(
              decoration: const BoxDecoration(
                color: ShareColors.surfaceSecondary,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.fromLTRB(19.2, 20.55, 19.2, 20.55),
              child: svg(ShareImg.iconCharacter, width: 21.6, height: 18.9),
            ),
          ),
          option(
            ShareBackground.course,
            '코스',
            svg(ShareImg.optCourse, width: 60, height: 60),
          ),
          option(
            ShareBackground.camera,
            '카메라',
            svg(ShareImg.optCamera, width: 60, height: 60),
          ),
          option(
            ShareBackground.album,
            '앨범',
            svg(ShareImg.optAlbum, width: 60, height: 60),
          ),
        ],
      ),
    );
  }
}

/// 레이아웃 탭 — 90×90 썸네일 가로 스크롤.
class _LayoutOptions extends StatelessWidget {
  const _LayoutOptions({
    super.key,
    required this.layouts,
    required this.selected,
    required this.onSelect,
  });

  final List<ShareLayout> layouts;
  final ShareLayout selected;
  final ValueChanged<ShareLayout> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
        itemCount: layouts.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final l = layouts[i];
          final on = l == selected;
          return GestureDetector(
            onTap: () => onSelect(l),
            child: SizedBox.square(
              dimension: 90,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpace.radiusSm),
                    child: Image.asset(l.thumb, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: on ? AppColors.white.withValues(alpha: 0.6) : null,
                      borderRadius: BorderRadius.circular(AppSpace.radiusSm),
                      border: on
                          ? Border.all(color: AppColors.contentsBrand, width: 2)
                          : Border.all(
                              color: AppColors.borderPrimary,
                              width: 0.5,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import 'analysis_data.dart';
import 'analysis_img.dart';
import 'analysis_sections.dart';
import 'analysis_widgets.dart';

/// Figma 02.0.CategoryHome_Report_Analysis_* (1177:45836, 1654:40444,
/// 1654:40911, 1654:41392, 1654:41752, 1654:42071) + 제품/횟수 선택 시트
/// (2122:13177, 2122:13384).
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key, this.initialTab = AnalysisTab.score});

  final AnalysisTab initialTab;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  static const _products = ['프렌즈 스크린 Q', '프렌즈 스크린 T2'];
  static const _counts = ['최근 5회', '최근 10회', '최근 20회'];

  late AnalysisTab _tab = widget.initialTab;
  late String _count = defaultCountFor(widget.initialTab);
  String _product = _products[0];

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

  void _select(AnalysisTab t) {
    if (t == _tab) return;
    setState(() => _tab = t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SubHeader(
            title: '기록 분석',
            actions: [
              GestureDetector(
                onTap: () => showNotReady(context, '기록 분석 공유'),
                child: svg(AnalysisImg.share, width: 24, height: 24),
              ),
            ],
            bottom: _FilterBar(
              product: _product,
              count: _count,
              onProduct: _pickProduct,
              onCount: _pickCount,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _CardGrid(selected: _tab, onSelect: _select),
                  const SizedBox(height: 30),
                  // 탭/횟수가 바뀌면 그래프 진입 애니메이션을 다시 재생
                  KeyedSubtree(
                    key: ValueKey('${_tab.name}/$_count/$_product'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpace.global,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AverageTitle(averageHeaders[_tab]!),
                              const SizedBox(height: 40),
                              TrendGraph(points: graphPointsFor(_count)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(height: 0.5, color: AppColors.borderPrimary),
                        const SizedBox(height: 30),
                        AnalysisDetailSection(tab: _tab),
                      ],
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

/// Figma `tab` 프레임(높이 72) — 제품/횟수 sort 칩. 가로 스크롤.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.product,
    required this.count,
    required this.onProduct,
    required this.onCount,
  });

  final String product;
  final String count;
  final VoidCallback onProduct;
  final VoidCallback onCount;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 72,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpace.global,
        vertical: 20,
      ),
      child: Row(
        children: [
          SortChip(label: product, selected: true, onTap: onProduct),
          const SizedBox(width: 10),
          SortChip(label: count, selected: true, onTap: onCount),
        ],
      ),
    ),
  );
}

/// 3×2 `Report/statisticsCard` 그리드 — 카드가 곧 탭이다.
class _CardGrid extends StatelessWidget {
  const _CardGrid({required this.selected, required this.onSelect});

  final AnalysisTab selected;
  final ValueChanged<AnalysisTab> onSelect;

  @override
  Widget build(BuildContext context) {
    const tabs = AnalysisTab.values;
    Widget row(int from) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = from; i < from + 3; i++) ...[
          if (i > from) const SizedBox(width: 10),
          Expanded(
            child: StatisticsCard(
              card: statCards[tabs[i]]!,
              selected: tabs[i] == selected,
              onTap: () => onSelect(tabs[i]),
            ),
          ),
        ],
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.global),
      child: Column(children: [row(0), const SizedBox(height: 10), row(3)]),
    );
  }
}

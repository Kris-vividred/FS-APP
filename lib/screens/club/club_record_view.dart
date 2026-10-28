import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'club_assets.dart';
import 'club_common.dart';

/// Figma 1177:42279 Club_record / 1690:43536 Club_record_empty 의 본문(Con).
class ClubRecordView extends StatelessWidget {
  const ClubRecordView({super.key, required this.empty});

  final bool empty;

  static const _driver = _Record(
    '12월 10일',
    '5구 평균',
    '드라이버',
    'driver',
    '175.5m',
    'S',
  );
  static const _groups = [
    _Month('2023년 12월', '3', [
      _Record('12월 10일', '5구 평균', '7번 아이언', 'iron7', '110.9m', 'B'),
      _Record('12월 10일', '6구 평균', '9번 아이언', 'iron9', '95.5m', 'S'),
      _driver,
    ]),
    _Month('2023년 10월', '3', [_driver, _driver]),
    _Month('2023년 9월', '3', [_driver, _driver]),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.global,
        20,
        AppSpace.global,
        40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (empty) ...[const ClubInfoText(), const SizedBox(height: 20)],
          for (final (i, g) in _groups.indexed) ...[
            if (i > 0) const SizedBox(height: 20),
            Opacity(
              opacity: empty ? 0.5 : 1,
              child: IgnorePointer(ignoring: empty, child: _MonthGroup(g)),
            ),
          ],
        ],
      ),
    );
  }
}

class _Month {
  const _Month(this.label, this.count, this.records);
  final String label;
  final String count;
  final List<_Record> records;
}

class _Record {
  const _Record(
    this.date,
    this.average,
    this.club,
    this.key,
    this.carry,
    this.grade,
  );
  final String date;
  final String average;
  final String club;
  final String key; // Routes.clubDetail 의 club 인자
  final String carry;
  final String grade; // S / B
}

/// Figma `LabelDate` + `scorecard`(Report/trainingList 목록).
class _MonthGroup extends StatelessWidget {
  const _MonthGroup(this.month);

  final _Month month;

  @override
  Widget build(BuildContext context) {
    final label = AppText.bold(14, lh: 20, color: AppColors.contentsSecondary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(month.label, style: label)),
            Text('${month.count}회', style: label),
          ],
        ),
        const SizedBox(height: 12),
        for (final (i, r) in month.records.indexed) ...[
          if (i > 0) const SizedBox(height: 10),
          _TrainingCard(r),
        ],
      ],
    );
  }
}

/// Figma `Report/trainingList`.
class _TrainingCard extends StatelessWidget {
  const _TrainingCard(this.r);

  final _Record r;

  @override
  Widget build(BuildContext context) {
    final sub = AppText.medium(14, color: AppColors.contentsSecondary);
    return Material(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(AppSpace.radiusMd),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          Routes.clubDetail,
          arguments: {'club': r.key},
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 88),
          padding: const EdgeInsets.fromLTRB(
            AppSpace.global,
            16,
            AppSpace.global,
            14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: Text(r.date, style: sub)),
                  const SizedBox(width: 10),
                  Text(r.average, style: sub),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(r.club, style: AppText.bold(16, lh: 24)),
                  ),
                  const SizedBox(width: 10),
                  Text(r.carry, style: AppText.bold(24, lh: 24 * 1.3)),
                  const SizedBox(width: 10),
                  Padding(
                    // Value Container 는 items-center: 31.2 높이 텍스트와 30 아이콘 중앙 정렬
                    padding: const EdgeInsets.only(bottom: 0.6),
                    child: svg(
                      r.grade == 'B' ? ClubImg.gradeB : ClubImg.gradeS,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

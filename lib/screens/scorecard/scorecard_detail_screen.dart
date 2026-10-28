import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../design/components.dart';
import '../../design/tokens.dart';
import '../../routes.dart';
import 'scorecard_img.dart';
import 'scorecard_table.dart';
import 'scorecard_widgets.dart';

/// Figma 02.0.CategoryHome_Report_Scorecard_Detail
/// - stroke_18H 1177:56462 (type=18h, 기본) / stroke_9H 1177:56882 (type=9h)
/// - team 1177:56713 (type=team)
class ScorecardDetailScreen extends StatefulWidget {
  const ScorecardDetailScreen({super.key, this.type = '18h'});

  final String type;

  @override
  State<ScorecardDetailScreen> createState() => _ScorecardDetailScreenState();
}

class _ScorecardDetailScreenState extends State<ScorecardDetailScreen> {
  late final bool _team = widget.type == 'team';
  late final bool _nine = widget.type == '9h';

  /// 플레이어(팀)별 스코어 펼침 상태 — Figma 기본값: 1·2 펼침, 3 접힘.
  final List<bool> _open = [true, true, false];

  void _share() => Navigator.pushNamed(
    context,
    Routes.scorecardShare,
    arguments: {'type': _team ? 'team' : 'default'},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SubHeader(
            title: '스코어카드 상세',
            actions: [
              GestureDetector(
                onTap: _share,
                child: svg(ScorecardImg.appbarShare, width: 24, height: 24),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Top(team: _team, holes: _nine ? '9H' : '18H'),
                  SizedBox(
                    height: 12,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: svg(ScorecardImg.spacer, width: 375, height: 12),
                    ),
                  ),
                  ..._scorecards(),
                  const SizedBox(height: 24),
                  ScoreLegend(team: _team),
                  if (!_team) const _RankingBoard(),
                  const _SwingVideos(),
                  _team ? const _RoundAnalysisEmpty() : const _RoundAnalysis(),
                  const _HoleRecord(),
                  _ShotRecord(team: _team),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _scorecards() {
    final players = _team ? _teams : _players;
    return [
      for (final (i, p) in players.indexed) ...[
        if (i > 0) const SizedBox(height: 24),
        _ScorecardBlock(
          player: p,
          team: _team,
          nine: _nine,
          open: _open[i],
          onToggle: () => setState(() => _open[i] = !_open[i]),
        ),
      ],
    ];
  }
}

// ───────────────────────────── Top ─────────────────────────────

class _Top extends StatelessWidget {
  const _Top({required this.team, required this.holes});

  final bool team;
  final String holes;

  @override
  Widget build(BuildContext context) {
    final secondary = AppText.medium(14, color: AppColors.contentsSecondary);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpace.global,
        0,
        AppSpace.global,
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 48,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.borderPrimary),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '프렌즈 스크린 판교 파미어스몰',
                    style: AppText.bold(
                      14,
                      lh: 20,
                      color: AppColors.contentsSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('2023.9.17', style: secondary),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('롯데스카이힐부여', style: AppText.bold(18, lh: 26)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('계백장군', style: secondary),
              const SizedBox(width: 4),
              Text(
                '|',
                style: AppText.regular(10, color: AppColors.contentsSecondary),
              ),
              const SizedBox(width: 4),
              Text('의자왕', style: secondary),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              SlotIcon(
                team ? ScorecardImg.modeFoursome : ScorecardImg.modeStroke,
              ),
              const SizedBox(width: 8),
              Text(team ? '포썸스트로크' : '스트로크', style: secondary),
              const Spacer(),
              MetaTexts(['Q', '마스터', '4명', holes]),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Scorecard ───────────────────────────

class _Player {
  const _Player(this.name, this.avatar, {this.me = false, this.score});
  final String name;
  final Widget avatar;
  final bool me;
  final String? score; // 팀: 9DN
}

final _players = [
  const _Player(
    '라이언',
    _PhotoAvatar(ScorecardImg.profileRyan, l: -18.6, w: 75.0, h: 116.4),
    me: true,
  ),
  const _Player(
    '내이름은차은우',
    _PhotoAvatar(ScorecardImg.profileCha, l: -9, w: 54, h: 36.6),
  ),
  const _Player(
    '뉴곰아지',
    _PhotoAvatar(ScorecardImg.profileRyan, l: -18.6, w: 75.0, h: 116.4),
  ),
];

final _teams = [
  const _Player(
    'Team ACE',
    _TeamAvatar(ScorecardImg.teamAceLogo, 17.62, 18),
    me: true,
    score: '9DN',
  ),
  const _Player(
    'Team EPIC',
    _TeamAvatar(ScorecardImg.teamEpicLogo, 15.265, 20),
    score: '9DN',
  ),
  const _Player(
    'Team BEST',
    _TeamAvatar(ScorecardImg.teamBestLogo, 15.915, 16, dx: -0.44),
    score: '9DN',
  ),
];

/// 36px 원형 프로필 사진 — Figma의 이미지 크롭 오프셋을 그대로 적용.
class _PhotoAvatar extends StatelessWidget {
  const _PhotoAvatar(
    this.asset, {
    required this.l,
    required this.w,
    required this.h,
  });

  final String asset;
  final double l;
  final double w;
  final double h;

  @override
  Widget build(BuildContext context) => ClipOval(
    child: SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: l,
            top: 0,
            width: w,
            height: h,
            child: Image.asset(asset, fit: BoxFit.cover),
          ),
        ],
      ),
    ),
  );
}

/// 팀 로고 — #101214 원 가운데 로고.
class _TeamAvatar extends StatelessWidget {
  const _TeamAvatar(this.asset, this.w, this.h, {this.dx = 0});

  final String asset;
  final double w;
  final double h;
  final double dx;

  @override
  Widget build(BuildContext context) => Container(
    width: 36,
    height: 36,
    decoration: const BoxDecoration(
      color: AppColors.contentsPrimary,
      shape: BoxShape.circle,
    ),
    alignment: Alignment.center,
    child: Transform.translate(
      offset: Offset(dx, 0),
      child: svg(asset, width: w, height: h),
    ),
  );
}

class _ScorecardBlock extends StatelessWidget {
  const _ScorecardBlock({
    required this.player,
    required this.team,
    required this.nine,
    required this.open,
    required this.onToggle,
  });

  final _Player player;
  final bool team;
  final bool nine;
  final bool open;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final halves = nine ? [false] : [false, true];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileRow(player: player, team: team, open: open, onTap: onToggle),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: open
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final isIn in halves) ...[
                      const HLine(color: ScColors.borderSecondary),
                      HoleLabelRow(isIn: isIn),
                      const HLine(),
                      const ParRow(),
                      const HLine(),
                      team ? const MatchRow() : const StrokeScoreRow(),
                      if (!team) ...[const HLine(), const PuttRow()],
                    ],
                  ],
                )
              : const HLine(color: ScColors.borderSecondary),
        ),
      ],
    );
  }
}

/// Figma Report/scorecardProfile.
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.player,
    required this.team,
    required this.open,
    required this.onTap,
  });

  final _Player player;
  final bool team;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          10,
          AppSpace.global,
          6,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 44,
              child: Stack(
                children: [
                  Positioned(left: 0, top: 4, child: player.avatar),
                  if (player.me)
                    Positioned(
                      left: 22,
                      bottom: 0,
                      child: svg(ScorecardImg.profileMe, width: 18, height: 18),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      player.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bold(16, lh: 24),
                    ),
                  ),
                  if (team) ...[const SizedBox(width: 6), const _MemberChip()],
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (player.score != null)
              Text(player.score!, style: AppText.bold(16, lh: 24))
            else ...[
              Text('121', style: AppText.bold(16, lh: 24)),
              const SizedBox(width: 4),
              Text('(+7)', style: AppText.regular(16)),
            ],
            const SizedBox(width: 6),
            SizedBox(
              width: 24,
              height: 24,
              child: Center(
                child: AnimatedRotation(
                  turns: open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: svg(ScorecardImg.arrowDownScorecard),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma chip/player — 탭하면 팀원 목록(team member) 팝오버를 띄운다.
class _MemberChip extends StatefulWidget {
  const _MemberChip();

  @override
  State<_MemberChip> createState() => _MemberChipState();
}

class _MemberChipState extends State<_MemberChip> {
  final _link = LayerLink();
  final _ctrl = OverlayPortalController();

  static const _members = ['김프로24', '아테나예빈kim', '파소리', '정체불명사나이', '통통이', '고담'];

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _ctrl,
      overlayChildBuilder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _ctrl.hide,
            ),
          ),
          CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomLeft,
            offset: const Offset(-4, 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 160),
                builder: (_, t, child) => Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, -6 * (1 - t)),
                    child: child,
                  ),
                ),
                child: const _MemberPopup(_members),
              ),
            ),
          ),
        ],
      ),
      child: CompositedTransformTarget(
        link: _link,
        child: GestureDetector(
          onTap: _ctrl.toggle,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.borderPrimary),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_members.length}명',
                  style: AppText.medium(
                    12,
                    lh: 18,
                    color: AppColors.contentsSecondary,
                  ),
                ),
                const SizedBox(width: 2),
                svg(ScorecardImg.arrow12Filled, width: 12, height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberPopup extends StatelessWidget {
  const _MemberPopup(this.members);

  final List<String> members;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 20, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.borderPrimary),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 7,
            color: Color(0x0F000000),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, m) in members.indexed) ...[
            if (i > 0) const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                svg(ScorecardImg.userIcon, width: 12, height: 12),
                const SizedBox(width: 6),
                Text(
                  m,
                  style: AppText.medium(12, lh: 18, color: ScColors.gray800),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────── 랭킹보드 ───────────────────────────

class _RankingBoard extends StatefulWidget {
  const _RankingBoard();

  @override
  State<_RankingBoard> createState() => _RankingBoardState();
}

class _RankingBoardState extends State<_RankingBoard> {
  double _turns = 0;

  static const _people = [
    ('1', '지나태윤', '68타'),
    ('2', '쏭크리스탈', '68타'),
    ('3', '다다제이', '70타'),
    ('4', '밤토리엄늬', '73타'),
    ('5', '청라동버디땅콩', '74타'),
    ('6', '버디땅콩', '76타'),
    ('7', '버디땅콩2', '76타'),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: const SectionLabel('랭킹보드'),
      trailing: GestureDetector(
        onTap: () => setState(() => _turns += 1),
        child: AnimatedRotation(
          turns: _turns,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          child: const _RefreshIcon(),
        ),
      ),
      child: Container(
        height: 360,
        padding: const EdgeInsets.fromLTRB(
          AppSpace.global,
          20,
          AppSpace.global,
          0,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: ScColors.borderSecondary, width: 0.5),
          borderRadius: BorderRadius.circular(AppSpace.radiusMd),
        ),
        child: Column(
          children: [
            const _RankRow('99', '김프로24', '112타', me: true),
            const SizedBox(height: 20),
            Container(height: 0.5, color: AppColors.borderPrimary),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: _people.length,
                separatorBuilder: (_, _) => const SizedBox(height: 20),
                itemBuilder: (_, i) =>
                    _RankRow(_people[i].$1, _people[i].$2, _people[i].$3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Figma title/24, refresh — 두 개의 화살표 그룹(하나는 180° 회전)으로 구성.
class _RefreshIcon extends StatelessWidget {
  const _RefreshIcon();

  @override
  Widget build(BuildContext context) {
    Widget part(String a) => OverflowBox(
      maxWidth: 20,
      maxHeight: 20,
      child: svg(a, width: 17.3001, height: 12.8792),
    );
    return SizedBox(
      width: 24,
      height: 24,
      child: Stack(
        children: [
          Positioned(
            left: 7.5,
            top: 3.45,
            width: 15.5,
            height: 11.08,
            child: part(ScorecardImg.refreshPartA),
          ),
          Positioned(
            left: 1.5,
            top: 9.45,
            width: 15.5,
            height: 11.08,
            child: Transform.rotate(
              angle: math.pi,
              child: part(ScorecardImg.refreshPartB),
            ),
          ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow(this.rank, this.name, this.record, {this.me = false});

  final String rank;
  final String name;
  final String record;
  final bool me;

  @override
  Widget build(BuildContext context) {
    final c = me ? AppColors.contentsBrand : AppColors.contentsPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              rank,
              textAlign: TextAlign.center,
              style: AppText.regular(16, color: c),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.bold(16, lh: 24, color: c),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(record, style: AppText.regular(14, lh: 20, color: c)),
        ],
      ),
    );
  }
}

// ─────────────────────────── 스윙영상 ───────────────────────────

class _SwingVideos extends StatelessWidget {
  const _SwingVideos();

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      title: const SectionLabel('스윙영상'),
      bleedRight: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: AppSpace.global),
        child: Row(
          children: [
            for (var i = 0; i < 3; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Pressable(
                onTap: () => showNotReady(context, '스윙영상'),
                child: const _Thumbnail(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail();

  @override
  Widget build(BuildContext context) {
    const shadow = [
      Shadow(
        offset: Offset(0, 3.19),
        blurRadius: 3.19,
        color: Color(0x4D000000),
      ),
    ];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 126,
        height: 126,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: AppColors.backgroundSecondary,
                child: Center(
                  child: svg(
                    ScorecardImg.thumbPlaceholder,
                    width: 72,
                    height: 72,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: ScColors.thumbDim,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '어프로치',
                      style: AppText.medium(
                        14,
                        color: AppColors.white,
                      ).copyWith(shadows: shadow),
                    ),
                    Text(
                      '20.1m',
                      style: AppText.bold(
                        14,
                        lh: 20,
                        color: AppColors.white,
                      ).copyWith(shadows: shadow),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────── 라운드분석 ───────────────────────────

class _RoundAnalysis extends StatelessWidget {
  const _RoundAnalysis();

  static const _rows = [
    ('최대 비거리', '255.2', 'm', '250.9', ScorecardImg.gradeS),
    ('평균 비거리', '120.2', 'm', '120.2', ScorecardImg.gradeB),
    ('페어웨이 안착률', '56.3', '%', null, null),
    ('그린 적중률', '120.2', '%', '120.2', ScorecardImg.gradeS),
    ('파 세이브율', '120.2', '%', '120.2', ScorecardImg.gradeA),
    ('샌드 세이브율', '18.4', '%', '18.4', ScorecardImg.gradeC),
    ('평균 퍼트수', '1.2', '타', '1.2', ScorecardImg.gradeS),
  ];

  @override
  Widget build(BuildContext context) {
    final head = AppText.medium(12, lh: 18, color: AppColors.contentsSecondary);
    return SectionContainer(
      title: const SectionLabel('라운드분석'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 94),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('나', textAlign: TextAlign.center, style: head),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('등급평균', textAlign: TextAlign.center, style: head),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 50,
                  child: Text('평가', textAlign: TextAlign.center, style: head),
                ),
              ],
            ),
          ),
          const HLine(),
          for (final r in _rows) ...[
            Container(
              height: 46,
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 94,
                    child: Text(
                      r.$1,
                      style: AppText.medium(
                        14,
                        color: AppColors.contentsSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Center(child: ValueText(r.$2, r.$3))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Center(
                      child: r.$4 == null
                          ? Text(
                              '집계중',
                              style: AppText.medium(
                                14,
                                color: AppColors.contentsSecondary,
                              ),
                            )
                          : ValueText(r.$4!, r.$3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 50,
                    height: 24,
                    child: r.$5 == null
                        ? null
                        : Center(child: svg(r.$5!, width: 22, height: 22)),
                  ),
                ],
              ),
            ),
            const HLine(),
          ],
        ],
      ),
    );
  }
}

class _RoundAnalysisEmpty extends StatelessWidget {
  const _RoundAnalysisEmpty();

  @override
  Widget build(BuildContext context) => SectionContainer(
    title: const SectionLabel('라운드분석'),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text(
        '18홀 라운드를 완료하지 않은 경우\n라운드 분석을 지원하지 않아요.',
        textAlign: TextAlign.center,
        style: AppText.regular(16, color: AppColors.contentsTertiary),
      ),
    ),
  );
}

// ─────────────────────────── 홀 공략 기록 ───────────────────────────

class _HoleRecord extends StatefulWidget {
  const _HoleRecord();

  @override
  State<_HoleRecord> createState() => _HoleRecordState();
}

class _HoleRecordState extends State<_HoleRecord> {
  static const _pars = [4, 4, 3, 4, 5, 4, 3, 4, 5, 4, 5, 3, 4, 4, 5, 4, 3, 4];
  static const _results = ['3온 2퍼팅', '2온 2퍼팅', '1온 3퍼팅', '4온 1퍼팅'];

  int _hole = 0; // 0‥17

  bool get _inSide => _hole >= 9;
  int get _first => _inSide ? 9 : 0;
  int get _last => _first + 8;

  String _distance(int par) => switch (par) {
    3 => '152.0m',
    5 => '468.5m',
    _ => '310.0m',
  };

  void _go(int h) => setState(() => _hole = h);

  @override
  Widget build(BuildContext context) {
    final par = _pars[_hole];
    final canPrev = _hole > _first;
    final canNext = _hole < _last;
    return SectionContainer(
      title: const SectionLabel('홀 공략 기록'),
      trailing: _OutInToggle(inSide: _inSide, onChanged: (v) => _go(v ? 9 : 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 248,
            decoration: BoxDecoration(
              color: ScColors.primaryDisabled,
              border: Border.all(color: AppColors.actionPrimary),
              borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(AppSpace.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: canPrev ? () => _go(_hole - 1) : null,
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: Center(
                      child: Transform.rotate(
                        angle: math.pi,
                        child: svg(
                          ScorecardImg.holePrev,
                          width: 6,
                          height: 10,
                          tint: canPrev ? AppColors.contentsPrimary : null,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Row(
                    key: ValueKey(_hole),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_hole + 1}H', style: AppText.bold(16, lh: 24)),
                      const SizedBox(width: 8),
                      Text('Par $par', style: AppText.regular(16)),
                      const SizedBox(width: 8),
                      Text(_distance(par), style: AppText.bold(16, lh: 24)),
                    ],
                  ),
                ),
                Text(
                  _results[_hole % _results.length],
                  style: AppText.bold(
                    16,
                    lh: 24,
                    color: AppColors.contentsBrand,
                  ),
                ),
                GestureDetector(
                  onTap: canNext ? () => _go(_hole + 1) : null,
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: Center(
                      child: svg(
                        ScorecardImg.holeNext,
                        width: 6,
                        height: 10,
                        tint: canNext ? null : AppColors.contentsTertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Figma ToggleTextRound (120 × 36).
class _OutInToggle extends StatelessWidget {
  const _OutInToggle({required this.inSide, required this.onChanged});

  final bool inSide;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: inSide ? Alignment.centerRight : Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.actionPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          Row(
            children: [
              for (final (i, label) in ['OUT', 'IN'].indexed)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onChanged(i == 1),
                    child: Center(
                      child: Text(
                        label,
                        style: AppText.medium(
                          14,
                          color: (i == 1) == inSide
                              ? AppColors.white
                              : AppColors.contentsTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── 샷 기록 ───────────────────────────

class _Shot {
  const _Shot(
    this.order,
    this.club,
    this.shape,
    this.distance,
    this.landing,
    this.player, {
    this.warn = false,
  });
  final String order;
  final String club;
  final String shape;
  final String? distance;
  final String landing;
  final String player;
  final bool warn;
}

const _shots = [
  _Shot('1st', 'DR', 'Straight', '250.9', 'Fairway', 'Kris'),
  _Shot('2nd', 'I4', 'Push Hook', '120.2', 'O.B', 'Nick', warn: true),
  _Shot('3rd', '-', '-', null, 'Penalty', 'Nick', warn: true),
  _Shot('4th', 'I4', 'Pull Slice', '120.2', 'Heavy\nRough', 'Nick'),
  _Shot('5th', 'I7', 'Push', '120.2', 'Green\nFairway', 'Nick'),
  _Shot('6th', 'PT', '-', '18.4', 'Green', 'Nick'),
  _Shot('7th', 'PT', '-', '18.4', 'Hole Cup', 'Kris'),
];

class _ShotRecord extends StatefulWidget {
  const _ShotRecord({required this.team});

  final bool team;

  @override
  State<_ShotRecord> createState() => _ShotRecordState();
}

class _ShotRecordState extends State<_ShotRecord> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final team = widget.team;
    final shots = team ? _shots.sublist(0, 6) : _shots;
    final head = AppText.medium(12, lh: 18, color: AppColors.contentsSecondary);
    final cell = AppText.medium(14);

    Widget row({required List<Widget> children}) =>
        SizedBox(height: 46, child: Row(children: _gap8(children)));

    Widget shape(Widget w) =>
        team ? SizedBox(width: 100, child: w) : Expanded(child: w);

    final table = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HLine(color: AppColors.borderTertiary),
        row(
          children: [
            SizedBox(
              width: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Text('클럽', textAlign: TextAlign.center, style: head),
              ),
            ),
            shape(Text('구질', textAlign: TextAlign.center, style: head)),
            SizedBox(
              width: 70,
              child: Text('비거리', textAlign: TextAlign.center, style: head),
            ),
            SizedBox(
              width: 70,
              child: Text('안착지점', textAlign: TextAlign.center, style: head),
            ),
            if (team)
              SizedBox(
                width: 100,
                child: Text('플레이어', textAlign: TextAlign.center, style: head),
              ),
          ],
        ),
        const HLine(),
        for (final s in shots) ...[
          row(
            children: [
              SizedBox(
                width: 60,
                child: Row(
                  children: [
                    SizedBox(
                      width: 26,
                      child: Text(
                        s.order,
                        style: AppText.medium(
                          12,
                          lh: 18,
                          color: AppColors.contentsSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.club,
                        textAlign: TextAlign.center,
                        style: cell,
                      ),
                    ),
                  ],
                ),
              ),
              shape(Text(s.shape, textAlign: TextAlign.center, style: cell)),
              SizedBox(
                width: 70,
                child: Center(
                  child: s.distance == null
                      ? Text('-', style: AppText.bold(14, lh: 20))
                      : ValueText(s.distance!, 'yd'),
                ),
              ),
              SizedBox(
                width: 70,
                child: Text(
                  s.landing,
                  textAlign: TextAlign.center,
                  style: AppText.medium(
                    14,
                    color: s.warn
                        ? ScColors.functionalS1
                        : AppColors.contentsPrimary,
                  ),
                ),
              ),
              if (team)
                SizedBox(
                  width: 100,
                  child: Text(
                    s.player,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: cell,
                  ),
                ),
            ],
          ),
          const HLine(),
        ],
      ],
    );

    return SectionContainer(
      title: const SectionLabel('샷 기록'),
      bottomPadding: 40,
      divider: false,
      bleedRight: team,
      child: team
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SingleChildScrollView(
                  controller: _scroll,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(right: AppSpace.global),
                  child: SizedBox(width: 432, child: table),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: AppSpace.global),
                  child: _HScrollBar(controller: _scroll),
                ),
              ],
            )
          : table,
    );
  }

  List<Widget> _gap8(List<Widget> ws) => [
    for (final (i, w) in ws.indexed) ...[
      if (i > 0) const SizedBox(width: 8),
      w,
    ],
  ];
}

/// Figma Scroll_Horizon — 4px 트랙 + 스크롤 위치를 따라가는 thumb.
class _HScrollBar extends StatelessWidget {
  const _HScrollBar({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: LayoutBuilder(
        builder: (context, c) => AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            var ratio = 0.4321; // Figma 초기 thumb 비율(100% - 56.79%)
            var progress = 0.0;
            if (controller.hasClients &&
                controller.position.hasContentDimensions) {
              final p = controller.position;
              final total = p.maxScrollExtent + p.viewportDimension;
              ratio = (p.viewportDimension / total).clamp(0.1, 1.0);
              progress = p.maxScrollExtent == 0
                  ? 0
                  : (p.pixels / p.maxScrollExtent).clamp(0.0, 1.0);
            }
            final w = c.maxWidth * ratio;
            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.borderPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  left: (c.maxWidth - w) * progress,
                  top: 0,
                  bottom: 0,
                  width: w,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.contentsPrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

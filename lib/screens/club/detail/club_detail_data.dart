import 'package:flutter/widgets.dart';

/// 클럽 상세 화면에서 쓰는 에셋 경로.
abstract final class ClubDetailImg {
  static const _p = 'assets/images/club/';
  static const shotBg = '${_p}detail_shot_bg.svg';
  static const gradeS = '${_p}detail_grade_s.svg';
  static const gradeA = '${_p}detail_grade_a.svg';
  static const gradeB = '${_p}detail_grade_b.svg';
  static const gradeC = '${_p}detail_grade_c.svg';
  static const clubDriver = '${_p}detail_club_driver.png';
  static const clubHybrid = '${_p}detail_club_hybrid.png';
  static const clubIron8 = '${_p}detail_club_iron8.png';
  static const shadowDriver = '${_p}detail_shadow_driver.png';
  static const shadowHybrid = '${_p}detail_shadow_hybrid.png';
  static const shadowIron = '${_p}detail_shadow_iron.png';
}

enum DetailTab { shot, target }

/// Figma img/Club_Img(110×100) 안의 클럽 사진 + 반사 그림자 배치.
class ClubPhoto {
  const ClubPhoto({
    required this.image,
    required this.imageRect,
    required this.shadow,
    required this.shadowRect,
    required this.shadowOpacity,
  });

  final String image;
  final Rect imageRect;
  final String shadow;
  final Rect shadowRect;
  final double shadowOpacity;

  static const driver = ClubPhoto(
    image: ClubDetailImg.clubDriver,
    imageRect: Rect.fromLTWH(0, 1, 107, 78),
    shadow: ClubDetailImg.shadowDriver,
    shadowRect: Rect.fromLTWH(0, 73, 104, 26),
    shadowOpacity: 0.06,
  );
  static const hybrid = ClubPhoto(
    image: ClubDetailImg.clubHybrid,
    imageRect: Rect.fromLTWH(10, -5, 110, 83.646),
    shadow: ClubDetailImg.shadowHybrid,
    shadowRect: Rect.fromLTWH(10, 72.92, 85.196, 32.083),
    shadowOpacity: 0.4,
  );
  static const iron = ClubPhoto(
    image: ClubDetailImg.clubIron8,
    imageRect: Rect.fromLTWH(12, 3, 109.908, 75.535),
    shadow: ClubDetailImg.shadowIron,
    shadowRect: Rect.fromLTWH(12, 73.12, 87.995, 29.877),
    shadowOpacity: 0.4,
  );
}

/// clubDataCard 하나. value == null 이면 "데이터 준비중".
typedef ClubStat = (String label, String? value);

/// 샷분포도 — ball 프레임(95.45×82.95) 안의 타원과 점 좌표.
class ShotSpread {
  const ShotSpread({
    required this.frontBack,
    required this.leftRight,
    required this.dots,
  });

  final String frontBack;
  final String leftRight;
  final List<Offset> dots;
}

enum TargetShape { lane, ring }

/// 목표적중률 그래픽 — 목표 / 안쪽 / 바깥 링 / 이탈 비율(%).
class TargetHit {
  const TargetHit({required this.shape, required this.percents});

  final TargetShape shape;
  final List<int> percents;
}

class ClubDetailData {
  const ClubDetailData({
    required this.key,
    required this.name,
    required this.distance,
    required this.grades,
    required this.photo,
  });

  final String key;
  final String name;
  final String distance;

  /// 탭별 등급(Figma 프레임마다 다른 값이면 탭별로 둔다).
  final Map<DetailTab, String> grades;
  final ClubPhoto photo;

  String gradeAsset(DetailTab tab) => switch (grades[tab]) {
    'S' => ClubDetailImg.gradeS,
    'B' => ClubDetailImg.gradeB,
    'C' => ClubDetailImg.gradeC,
    _ => ClubDetailImg.gradeA,
  };
}

// ── 클럽 목록 (Figma 6개 프레임) ───────────────────────────────────────────

const clubOrder = ['driver', 'wood', 'hybrid', 'hybrid4', 'iron8'];

const clubs = <String, ClubDetailData>{
  'driver': ClubDetailData(
    key: 'driver',
    name: '드라이버',
    distance: '275.5m',
    grades: {DetailTab.shot: 'S', DetailTab.target: 'S'},
    photo: ClubPhoto.driver,
  ),
  'wood': ClubDetailData(
    key: 'wood',
    name: '우드',
    distance: '275.5m',
    grades: {DetailTab.shot: 'B', DetailTab.target: 'B'},
    photo: ClubPhoto.driver,
  ),
  'hybrid': ClubDetailData(
    key: 'hybrid',
    name: '하이브리드',
    distance: '275.5m',
    grades: {DetailTab.shot: 'A', DetailTab.target: 'A'},
    photo: ClubPhoto.hybrid,
  ),
  'hybrid4': ClubDetailData(
    key: 'hybrid4',
    name: '하이브리드 4',
    distance: '275.5m',
    grades: {DetailTab.shot: 'C', DetailTab.target: 'C'},
    photo: ClubPhoto.hybrid,
  ),
  'iron8': ClubDetailData(
    key: 'iron8',
    name: '아이언 8',
    distance: '275.5m',
    grades: {DetailTab.shot: 'S', DetailTab.target: 'A'},
    photo: ClubPhoto.iron,
  ),
};

/// 외부에서 들어온 club 값을 가장 가까운 키로 정규화. 기본값 driver.
String normalizeClub(String? raw) {
  final v = (raw ?? '').toLowerCase().replaceAll(RegExp(r'[\s_-]'), '');
  if (clubs.containsKey(v)) return v;
  if (v.contains('driver')) return 'driver';
  if (v.contains('wood')) return 'wood';
  if (v.contains('hybrid') || v.contains('utility')) {
    return v.contains('4') ? 'hybrid4' : 'hybrid';
  }
  if (v.contains('iron') || v.contains('wedge')) return 'iron8';
  return 'driver';
}

// ── 탭별 디자인 데이터 (프레임이 없는 클럽은 가장 가까운 클럽 데이터 사용) ──

const _shotFrameOf = {
  'driver': 'wood', // 드라이버 샷 프레임 없음 → 우드
  'wood': 'wood',
  'hybrid': 'hybrid',
  'hybrid4': 'hybrid',
  'iron8': 'iron8',
};

const _targetFrameOf = {
  'driver': 'driver',
  'wood': 'driver',
  'hybrid': 'hybrid4',
  'hybrid4': 'hybrid4',
  'iron8': 'iron8',
};

String frameKey(String club, DetailTab tab) =>
    (tab == DetailTab.shot ? _shotFrameOf : _targetFrameOf)[club] ?? club;

const _dots = <Offset>[
  Offset(52.2727, 5.6819),
  Offset(40.9094, 28.4094),
  Offset(73.8636, 32.9546),
  Offset(73.8636, 45.4546),
  Offset(36.3636, 65.9092),
  Offset(17.0452, 65.9092),
  Offset(21.5909, 50.0001),
  Offset(54.5452, 50.0001),
  Offset(86.3636, 53.4092),
  Offset(65.9094, 73.8637),
];

const shotSpreads = <String, ShotSpread>{
  'wood': ShotSpread(frontBack: '5.8m', leftRight: '17.8m', dots: _dots),
  'hybrid': ShotSpread(frontBack: '5.8m', leftRight: '17.8m', dots: _dots),
  'iron8': ShotSpread(frontBack: '5.8m', leftRight: '17.8m', dots: _dots),
};

const targetHits = <String, TargetHit>{
  'driver': TargetHit(shape: TargetShape.lane, percents: [80, 5, 5, 10]),
  'hybrid4': TargetHit(shape: TargetShape.lane, percents: [80, 5, 5, 10]),
  'iron8': TargetHit(shape: TargetShape.ring, percents: [80, 5, 5, 10]),
};

const _statsPartial = <ClubStat>[
  ('구질', '71.2m'),
  ('비거리', '215.8m'),
  ('캐리', '71.2m'),
  ('볼스피드', '29.5m/s'),
  ('발사각', '25.4°'),
  ('백스핀', '2331rpm'),
  ('최고 높이', null),
  ('방향각', null),
  ('사이드 스핀', null),
];

const _statsFull = <ClubStat>[
  ('구질', '71.2m'),
  ('비거리', '215.8m'),
  ('캐리', '71.2m'),
  ('볼스피드', '29.5m/s'),
  ('발사각', '25.4°'),
  ('백스핀', '2331rpm'),
  ('최고 높이', '13.2m'),
  ('방향각', '5.4°'),
  ('사이드 스핀', '1231rpm'),
];

/// "나의 샷 데이터" 9칸 — 프레임 키 기준.
List<ClubStat> statsFor(String club, DetailTab tab) {
  final f = frameKey(club, tab);
  if (tab == DetailTab.shot && (f == 'wood' || f == 'hybrid')) {
    return _statsPartial;
  }
  return _statsFull;
}

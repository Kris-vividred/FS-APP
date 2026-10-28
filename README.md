# FS-APP · 리포트 화면 프로토타입 (Flutter Web)

피그마 `APP Interaction R&D` › `2026080x - 테스트 화면 외 리포트 화면` 페이지의
**02.0.CategoryHome_Report_Screen** 을 Flutter로 구현한 웹 프로토타입입니다.

## 실행

```bash
flutter pub get
flutter run -d chrome
```

배포용 빌드:

```bash
flutter build web --release --no-web-resources-cdn
```

`build/web` 폴더를 아무 정적 서버에 올리면 됩니다. 데스크톱 브라우저에서는 375×812 폰 프레임 안에, 모바일 브라우저에서는 전체 화면으로 표시됩니다.

## 구성

| 경로 | 내용 |
|---|---|
| `lib/design/tokens.dart` | 피그마 변수(색상·간격·텍스트 스타일)와 에셋 경로 |
| `lib/design/components.dart` | 배지, 정렬 칩, 지표 행, 공통 바텀시트 |
| `lib/screens/report_screen.dart` | 리포트 메인 화면 |
| `assets/images/` | 피그마에서 내려받은 원본 에셋 |
| `assets/fonts/` | Spoqa Han Sans Neo (Regular/Medium/Bold) |

## 인터랙션

- 상단 탭(스크린/트레이닝) 전환과 밑줄 슬라이드
- 바텀시트: 제품 선택, 횟수 선택, 데이터 집계 (피그마 디자인 기준)
- 디자인에 없는 추가 효과: 핸디 숫자 카운트업, 레이더 그래프 등장, 카드·QR 버튼 눌림 축소
- 아직 없는 화면(하단 다른 탭, 지표 상세 등)은 안내 스낵바로 처리

화면에 들어간 숫자는 디자인의 예시 값을 쓴 고정 데이터입니다.

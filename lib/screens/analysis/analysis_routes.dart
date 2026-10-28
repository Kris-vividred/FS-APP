import '../../routes.dart';
import 'analysis_data.dart';
import 'analysis_screen.dart';

/// 기록 분석 상세. `tab`: score | driverDistance | fairway | gir | parSave | putting
final Map<String, RouteBuilder> analysisRoutes = {
  Routes.analysis: (q) => AnalysisScreen(initialTab: analysisTabFrom(q['tab'])),
};

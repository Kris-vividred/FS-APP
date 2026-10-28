import '../../../routes.dart';
import 'club_detail_screen.dart';

/// `Routes.clubDetail?club=driver|wood|hybrid|hybrid4|iron8&tab=shot|target`
final Map<String, RouteBuilder> clubDetailRoutes = {
  Routes.clubDetail: (q) => ClubDetailScreen(club: q['club'], tab: q['tab']),
};

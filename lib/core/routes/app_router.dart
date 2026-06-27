import 'package:go_router/go_router.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/tour/domain/entities/tour_entity.dart';
import '../../features/tour/presentation/pages/tour_detail_page.dart';
import '../../features/tour/presentation/pages/tour_form_page.dart';
import '../../features/tour/presentation/pages/all_tour_page.dart';
import '../../features/tour/presentation/pages/search_tour_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainPage()),
    GoRoute(
      path: '/tour-detail',
      builder: (context, state) {
        final tour = state.extra as TourEntity;
        return TourDetailPage(tour: tour);
      },
    ),
    GoRoute(
      path: '/tour-form',
      builder: (context, state) {
        final tour = state.extra as TourEntity?;
        return TourFormPage(tour: tour);
      },
    ),

    GoRoute(
      path: '/all-tour',
      builder: (context, state) => const AllTourPage(),
    ),
    GoRoute(
      path: '/search-tour',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'] ?? '';
        return SearchTourPage(query: query);
      },
    ),
  ],
);

import 'package:sesan_travel/features/tour/domain/entities/tour_entity.dart';
import 'package:sesan_travel/features/tour/domain/repositories/tour_repository.dart';

class SearchToursUseCase {
  final TourRepository repository;

  SearchToursUseCase({required this.repository});

  Future<List<TourEntity>> call(String query) async {
    return repository.searchTours(query);
  }
}

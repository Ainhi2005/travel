import '../entities/tour_entity.dart';
import '../entities/tour_request_entity.dart';
import '../repositories/tour_repository.dart';

class UpdateTourUseCase {
  final TourRepository repository;

  UpdateTourUseCase(this.repository);

  Future<TourEntity> call(String id, TourRequestEntity request) {
    return repository.updateTour(id, request);
  }
}

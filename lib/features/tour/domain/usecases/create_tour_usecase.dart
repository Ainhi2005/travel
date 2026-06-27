import '../entities/tour_entity.dart';
import '../entities/tour_request_entity.dart';
import '../repositories/tour_repository.dart';

class CreateTourUseCase {
  final TourRepository repository;

  CreateTourUseCase(this.repository);

  Future<TourEntity> call(TourRequestEntity request) {
    return repository.createTour(request);
  }
}

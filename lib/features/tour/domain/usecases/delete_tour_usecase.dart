import '../repositories/tour_repository.dart';

class DeleteTourUseCase {
  final TourRepository repository;

  DeleteTourUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteTour(id);
  }
}

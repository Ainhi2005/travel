import '../../domain/entities/tour_entity.dart';
import '../../domain/repositories/tour_repository.dart';
import '../datasources/tour_remote_datasource.dart';

class TourRepositoryImpl implements TourRepository {
  final TourRemoteDataSource remoteDataSource;

  TourRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TourEntity>> getTours(TourType type, {int page = 1, int limit = 3}) async {
    try {
      final models = await remoteDataSource.fetchTours(type, page: page, limit: limit);
      return models;
    } catch (e) {
       rethrow;
    }
  }
}

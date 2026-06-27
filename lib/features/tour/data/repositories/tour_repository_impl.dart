import '../../domain/entities/tour_entity.dart';
import '../../domain/entities/tour_filter_entity.dart';
import '../../domain/entities/tour_request_entity.dart';
import '../../domain/repositories/tour_repository.dart';
import '../datasources/tour_remote_datasource.dart';
import '../models/tour_request_model.dart';

class TourRepositoryImpl implements TourRepository {
  final TourRemoteDataSource remoteDataSource;

  TourRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<TourEntity>> getTours({
    TourFilterEntity? filter,
    String? sort,
    int page = 1,
    int limit = 3,
  }) async {
    try {
      final models = await remoteDataSource.getTours(
        filter: filter,
        sort: sort,
        page: page,
        limit: limit,
      );
      return models;
    } catch (e) {
       rethrow;
    }
  }

  @override
  Future<List<TourEntity>> searchTours(String query) async {
    try {
      final models = await remoteDataSource.searchTours(query);
      return models;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TourEntity>> getFeaturedTours() async {
    try {
      final models = await remoteDataSource.getFeaturedTours();
      return models;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TourEntity> createTour(TourRequestEntity request) async {
    try{
      final requestModel=TourRequestModel.fromEntity(request);
      final result=await remoteDataSource.createTour(requestModel);
      return result;      
    } catch (e){
      throw Exception(e.toString());
    }
  }

  @override
  Future<TourEntity> updateTour(String id, TourRequestEntity request) async {
    try {
      final requestModel = TourRequestModel.fromEntity(request);
      final result= await remoteDataSource.updateTour(id, requestModel);
      // Dummy return
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTour(String id) async {
    try {
      await remoteDataSource.deleteTour(id);
    } catch (e) {
      rethrow;
    }
  }
}

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/tour_response_model.dart';
import '../models/tour_request_model.dart';
import '../../domain/entities/tour_filter_entity.dart';

abstract class TourRemoteDataSource {
  Future<List<TourResponseModel>> getTours({
    TourFilterEntity? filter,
    String? sort,
    int page = 1,
    int limit = 10,
  });
  Future<List<TourResponseModel>> searchTours(String query);
  Future<List<TourResponseModel>> getFeaturedTours();
  Future<TourResponseModel> createTour(TourRequestModel request);
  Future<TourResponseModel> updateTour(String id, TourRequestModel request);
  Future<void> deleteTour(String id);
}

class TourRemoteDataSourceImpl implements TourRemoteDataSource {
  final ApiClient apiClient;
  TourRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TourResponseModel>> getTours({
    TourFilterEntity? filter, 
    String? sort, 
    int page = 1, 
    int limit = 3
  }) async {
    // Sử dụng chung 1 API /filter cho cả lọc và lấy tất cả để đồng nhất kết quả
    final String endpoint = ApiConstants.filterTours;
    
    final Map<String, dynamic> queryParams = {
      "page": page,
      "limit": limit,
      if (sort != null) "sort": sort,
    };
    
    if (filter != null) {
      if (filter.categoryId != null) queryParams["category_id"] = filter.categoryId;
      if (filter.minPrice != null) queryParams["minPrice"] = filter.minPrice;
      if (filter.maxPrice != null) queryParams["maxPrice"] = filter.maxPrice;
      if (filter.location != null && filter.location!.isNotEmpty) queryParams["location"] = filter.location;
      if (filter.duration != null && filter.duration!.isNotEmpty) queryParams["duration"] = filter.duration;
    }

    final response = await apiClient.get(endpoint, queryParameters: queryParams);
    
    final json = response['data'] as List<dynamic>;
    return json.map((e) => TourResponseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TourResponseModel>> searchTours(String query) async {
    final response = await apiClient.get(
      ApiConstants.searchTours,
      queryParameters: {"q": query},
    );
    final json = response['data'] as List<dynamic>;
    return json.map((e) => TourResponseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<TourResponseModel>> getFeaturedTours() async {
    final response = await apiClient.get(ApiConstants.featuredTours);
    final json = response['data'] as List<dynamic>;
    return json.map((e) => TourResponseModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<TourResponseModel> createTour(TourRequestModel request) async {
    final response = await apiClient.post(ApiConstants.tours, data: request.toJson());
    return TourResponseModel.fromJson(response['data']);
  }

  @override
  Future<TourResponseModel> updateTour(String id, TourRequestModel request) async {
    final response = await apiClient.put('${ApiConstants.tours}/$id', data: request.toJson());
    return TourResponseModel.fromJson(response['data']);
  }

  @override
  Future<void> deleteTour(String id) async {
    await apiClient.delete('${ApiConstants.tours}/$id');
  }
}

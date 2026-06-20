import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/repositories/tour_repository.dart';
import '../models/tour_model.dart';

abstract class TourRemoteDataSource {
  Future<List<TourModel>> fetchTours(TourType type, {int page = 1, int limit = 3});
}

class TourRemoteDataSourceImpl implements TourRemoteDataSource {
  final ApiClient apiClient;

  TourRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<TourModel>> fetchTours(TourType type, {int page = 1, int limit = 3}) async {
    String endpoint = '';
    
    switch (type) {
      case TourType.daily:
        endpoint = ApiConstants.dailyTours;
        break;
      case TourType.package:
        endpoint = ApiConstants.packageTours;
        break;
      case TourType.private:
        endpoint = ApiConstants.privateTours;
        break;
      case TourType.all:
        endpoint = ApiConstants.getAll;
        break;
    }

    final responseData = await apiClient.get(endpoint);    
    // Xử lý linh hoạt: Đôi khi API trả về trực tiếp một mảng List [...], 
    // đôi khi lại trả về một Object dạng Map { "data": [...] }
    dynamic data = responseData;
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        data = data['data'];
      } else {
        // Nếu API bọc list ở một key khác, ta thử tìm key chứa list
        final listValues = data.values.whereType<List>();
        if (listValues.isNotEmpty) {
          data = listValues.first;
        } else {
          // Trả về mảng rỗng nếu không có dữ liệu để tránh crash
          data = [];
        }
      }
    }

    if (data is List) {
      return data.map((e) => TourModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Dữ liệu trả về không hợp lệ (Không phải là danh sách)');
    }
  }
  
}

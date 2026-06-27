import 'package:sesan_travel/core/constants/api_constants.dart';
import 'package:sesan_travel/core/network/api_client.dart';
import '../models/category_response_model.dart';

abstract class CategoryDatasource {
  Future<List<CategoryResponseModel>> getCategories();
}

class CategoryDatasourceImpl implements CategoryDatasource {
  final ApiClient dio;
  CategoryDatasourceImpl(this.dio);
  @override
  Future<List<CategoryResponseModel>> getCategories() async {
    final response =  await dio.get(ApiConstants.categories);
    final json = response as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;
    return data.map((e)=> CategoryResponseModel.fromJson(e as Map<String,dynamic>)).toList();
  }
}

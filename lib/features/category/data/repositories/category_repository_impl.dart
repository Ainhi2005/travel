import 'package:sesan_travel/features/category/data/datasources/category_datasource.dart';
import 'package:sesan_travel/features/category/domain/entities/category_entity.dart';
import 'package:sesan_travel/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource categoryDatasource;
  CategoryRepositoryImpl(this.categoryDatasource);
  @override
  Future<List<CategoryEntity>> getCategory() async {
    try {
      return await categoryDatasource.getCategories();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

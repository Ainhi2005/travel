import 'package:sesan_travel/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategory();
}

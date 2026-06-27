import 'package:sesan_travel/features/category/domain/entities/category_entity.dart';
import 'package:sesan_travel/features/category/domain/repositories/category_repository.dart';

class GetCategorysUsecase {
  final CategoryRepository categoryRepository;
  GetCategorysUsecase(this.categoryRepository);
  Future<List<CategoryEntity>> call() async{
    return categoryRepository.getCategory();
  }
}

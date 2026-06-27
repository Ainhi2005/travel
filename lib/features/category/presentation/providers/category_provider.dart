import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/features/category/data/datasources/category_datasource.dart';
import '../../../../core/providers/dio_Provider.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/usecases/get_categorys_usecase.dart';

final categoryDatasourceProvider = Provider<CategoryDatasourceImpl>((ref) {
  final a = ref.watch(apiClientProvider);
  return CategoryDatasourceImpl(a);
});

final categoryRepositoryProvider = Provider<CategoryRepositoryImpl>((ref) {
  final a = ref.watch(categoryDatasourceProvider);
  return CategoryRepositoryImpl(a);
});

final getCategorysUsecaseProvider = Provider<GetCategorysUsecase>((ref) {
  final a = ref.watch(categoryRepositoryProvider);
  return GetCategorysUsecase(a);
});

final categoryProvider = FutureProvider((ref) async {
  final a = ref.watch(getCategorysUsecaseProvider);
  return await a.call();
});


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/providers/dio_Provider.dart';
import '../../data/datasources/tour_remote_datasource.dart';
import '../../data/repositories/tour_repository_impl.dart';
import '../../domain/entities/tour_entity.dart';
import '../../domain/entities/tour_filter_entity.dart';
import '../../domain/repositories/tour_repository.dart';
export 'tours_notifier.dart';
import '../../domain/usecases/get_tours_usecase.dart';
import '../../domain/usecases/create_tour_usecase.dart';
import '../../domain/usecases/update_tour_usecase.dart';
import '../../domain/usecases/delete_tour_usecase.dart';
import '../../domain/usecases/search_tours_usecase.dart';

// datasource
final tourRemoteDataSourceProvider = Provider<TourRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TourRemoteDataSourceImpl(apiClient: apiClient);
});
// repository
final tourRepositoryProvider = Provider<TourRepository>((ref) {
  final remoteDataSource = ref.watch(tourRemoteDataSourceProvider);
  return TourRepositoryImpl(remoteDataSource: remoteDataSource);
});
// usecase
final getToursUseCaseProvider = Provider<GetToursUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return GetToursUseCase(repository);
});

final createTourUseCaseProvider = Provider<CreateTourUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return CreateTourUseCase(repository);
});

final updateTourUseCaseProvider = Provider<UpdateTourUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return UpdateTourUseCase(repository);
});

final deleteTourUseCaseProvider = Provider<DeleteTourUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return DeleteTourUseCase(repository);
});
//tour nổi bật
final featuredToursProvider = FutureProvider<List<TourEntity>>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return repository.getFeaturedTours();
});

final searchToursUseCaseProvider = Provider<SearchToursUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return SearchToursUseCase(repository: repository);
});

final searchToursProvider = FutureProvider.family<List<TourEntity>, String>((ref, query) {
  final useCase = ref.watch(searchToursUseCaseProvider);
  return useCase.call(query);
});

// --- State Providers ---
final tourFilterProvider = StateProvider<TourFilterEntity>((ref) => const TourFilterEntity());
final selectedTourCategoryProvider = StateProvider<String?>((ref) => null);



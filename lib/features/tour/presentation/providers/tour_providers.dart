import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/tour_remote_datasource.dart';
import '../../data/repositories/tour_repository_impl.dart';
import '../../domain/repositories/tour_repository.dart';
import '../../domain/usecases/get_tours_usecase.dart';
import '../../domain/entities/tour_entity.dart';

//Core Network Providers
final dioClientProvider = Provider((ref) => DioClient());

final apiClientProvider = Provider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiClient(dioClient: dioClient);
});

//  Tour  Providers 
final tourRemoteDataSourceProvider = Provider<TourRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TourRemoteDataSourceImpl(apiClient: apiClient);
});

final tourRepositoryProvider = Provider<TourRepository>((ref) {
  final remoteDataSource = ref.watch(tourRemoteDataSourceProvider);
  return TourRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getToursUseCaseProvider = Provider<GetToursUseCase>((ref) {
  final repository = ref.watch(tourRepositoryProvider);
  return GetToursUseCase(repository);
});

// --- State Providers ---
// State lưu trữ loại Tour đang chọn 
class SelectedTourTypeNotifier extends Notifier<TourType> {
  @override
  TourType build() => TourType.all;

  void updateType(TourType type) {
    state = type;
  }
}

final selectedTourTypeProvider = NotifierProvider<SelectedTourTypeNotifier, TourType>(SelectedTourTypeNotifier.new);

// Provider gọi API dựa trên loại Tour đang chọn
final toursProvider = FutureProvider<List<TourEntity>>((ref) async {
  final useCase = ref.watch(getToursUseCaseProvider);
  final type = ref.watch(selectedTourTypeProvider);
  return useCase.call(type);
});

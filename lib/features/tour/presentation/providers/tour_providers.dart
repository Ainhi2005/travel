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

class ToursNotifier extends AsyncNotifier<List<TourEntity>> {
  int _page = 1;
  final int _limit = 3;
  bool _hasMore = true;
  bool _isFetchingNext = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNext => _isFetchingNext;

  @override
  Future<List<TourEntity>> build() async {
    // Khi loại Tour thay đổi (VD: All -> Daily), hàm build() sẽ tự chạy lại
    // Ta cần reset biến state về ban đầu
    _page = 1;
    _hasMore = true;
    _isFetchingNext = false;
    
    return _fetchTours(page: _page);
  }

  Future<List<TourEntity>> _fetchTours({required int page}) async {
    final useCase = ref.read(getToursUseCaseProvider);
    final type = ref.watch(selectedTourTypeProvider);
    
    return useCase.call(type, page: page, limit: _limit);
  }

  // Hàm gọi tải thêm trang
  Future<void> fetchNextPage() async {
    // Nếu đang tải thêm, hoặc đã hết dữ liệu, hoặc danh sách đang load lần đầu -> Bỏ qua
    if (_isFetchingNext || !_hasMore || !state.hasValue || state.isLoading) return;

    _isFetchingNext = true;
    
    try {
      _page++;
      final newTours = await _fetchTours(page: _page);

      if (newTours.isEmpty || newTours.length < _limit) {
        _hasMore = false; // Đánh dấu đã hết dữ liệu
      }

      if (newTours.isNotEmpty) {
        // Nối dữ liệu mới vào mảng cũ
        final currentList = state.value ?? [];
        state = AsyncData([...currentList, ...newTours]);
      }
    } catch (e, st) {
      // Báo lỗi bằng cách đưa lỗi vào state hoặc chỉ print ra
      print('Lỗi khi tải trang $_page: $e');
    } finally {
      _isFetchingNext = false;
    }
  }

  // Hàm để kéo làm mới (Pull to refresh)
  Future<void> refresh() async {
    state = const AsyncLoading(); 
    state = await AsyncValue.guard(() => build());
  }
}

// Khai báo provider mới
final toursProvider = AsyncNotifierProvider<ToursNotifier, List<TourEntity>>(
  ToursNotifier.new,
);


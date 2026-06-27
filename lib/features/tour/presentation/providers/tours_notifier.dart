import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/tour_entity.dart';
import '../../domain/entities/tour_filter_entity.dart';
import '../../domain/entities/tour_request_entity.dart';
import 'tour_providers.dart';

class ToursNotifier extends AsyncNotifier<List<TourEntity>> {
  int _page = 1;
  final int _limit = 3;
  bool _hasMore = true;
  bool _isFetchingNext = false;

  bool get hasMore => _hasMore;
  bool get isFetchingNext => _isFetchingNext;

  @override
  Future<List<TourEntity>> build() async {
    // Theo dõi bộ lọc ở hàm build() để Notifier tự rebuild khi filter thay đổi
    final filter = ref.watch(tourFilterProvider);
    
    _page = 1;
    _hasMore = true;
    _isFetchingNext = false;
    
    return _fetchTours(page: _page, filter: filter);
  }

  Future<List<TourEntity>> _fetchTours({required int page, required TourFilterEntity filter}) async {
    final useCase = ref.read(getToursUseCaseProvider);
    
    return useCase.call(filter: filter, page: page, limit: _limit);
  }

  // Hàm gọi tải thêm trang
  Future<void> fetchNextPage() async {
    // Nếu đang tải thêm, hoặc đã hết dữ liệu, hoặc danh sách đang load lần đầu -> Bỏ qua
    if (_isFetchingNext || !_hasMore || !state.hasValue || state.isLoading) return;

    _isFetchingNext = true;
    
    try {
      _page++;
      final filter = ref.read(tourFilterProvider); // Chỉ read khi tải thêm
      final newTours = await _fetchTours(page: _page, filter: filter);

      if (newTours.isEmpty || newTours.length < _limit) {
        _hasMore = false; // Đánh dấu đã hết dữ liệu
      }

      if (newTours.isNotEmpty) {
        // Nối dữ liệu mới vào mảng cũ
        final currentList = state.value ?? [];
        state = AsyncData([...currentList, ...newTours]);
      }
    } catch (e) {
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

  Future<void> createTour(TourRequestEntity request) async {
    final useCase = ref.read(createTourUseCaseProvider);
    final newTour = await useCase.call(request);
    
    if (state.hasValue) {
      // Cập nhật state nội bộ: chèn tour mới lên đầu
      state = AsyncData([newTour, ...state.value!]);
    }
  }

  Future<void> updateTour(String id, TourRequestEntity request) async {
    final useCase = ref.read(updateTourUseCaseProvider);
    final updatedTour = await useCase.call(id, request);
    
    if (state.hasValue) {
      final currentList = state.value!;
      final index = currentList.indexWhere((t) => t.id == id);
      if (index != -1) {
        final newList = [...currentList];
        newList[index] = updatedTour;
        state = AsyncData(newList);
      }
    }
  }

  Future<void> deleteTour(String id) async {
    final useCase = ref.read(deleteTourUseCaseProvider);
    await useCase.call(id);
    
    if (state.hasValue) {
      final currentList = state.value!;
      state = AsyncData(currentList.where((t) => t.id != id).toList());
    }
  }
}

// Khai báo provider mới
final toursProvider = AsyncNotifierProvider<ToursNotifier, List<TourEntity>>(
  ToursNotifier.new,
);

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/badge_tag.dart';
import '../../../../core/widgets/custom_network_image.dart';
import '../../../tour/domain/entities/tour_entity.dart';

class HomeSliderWidget extends ConsumerStatefulWidget {
  const HomeSliderWidget({super.key});

  @override
  ConsumerState<HomeSliderWidget> createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends ConsumerState<HomeSliderWidget> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _nextPage());
  }

  void _nextPage() {
    if (!_pageController.hasClients) return;
    final tour = ref.read(featuredToursProvider).value;
    //Đọc dữ liệu hiện tại của featuredToursProvider và lấy giá trị (value) bên trong AsyncValue.
    if (tour == null || tour.isEmpty) return;
    // quay về 0 nếu ở trang cuối
    _currentPage = (_currentPage + 1) % tour.length;
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    ); // hiệu ứng chuyển đôngk
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featureTours = ref.watch(featuredToursProvider);
    return featureTours.when(
      error: (_, __) => const SizedBox(
        height: 200,
        child: Center(child: Text("Không thể tải slider")),
      ),
      loading: () => const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      data: (tours) {
        if (tours.isEmpty) return SizedBox.shrink();
        return _buildSlider(tours);
      },
    );
  }

  Widget _buildSlider(List<TourEntity> tours) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: tours.length,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return CustomNetworkImage(
                imageUrl: tours[index].image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              );
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              // Cho phép bấm xuyên qua lớp này vào hình ảnh phía dưới
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.neutral.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          _buildContent(), // nội dung
          _builIndicator(tours.length), // dấu chấm trang
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 16,
      top: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BadgeTag(text: "KHUYẾN MÃI", backgroundColor: AppColors.error),
          const SizedBox(height: 8),
          const Text(
            "CHÀO HÈ 2026",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Khuyến mãi sốc 20% cho mỗi chuyến đi",
            style: TextStyle(color: AppColors.white, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Nút ĐẶT NGAY bằng Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ĐẶT NGAY",
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // chuyển động
  Widget _builIndicator(int length) {
  // Positioned là một widget trong Flutter
  // Dùng để định vị chính xác vị trí của một widget con bên trong một Stack.
  return Positioned(
    // Đẩy widget lên cách mép dưới (bottom) của Stack là 10 logic pixel
    bottom: 10,
    
    // Căn lề trái và phải bằng 0 kết hợp với Row (chứa mainAxisAlignment.center)
    // Giúp thanh indicator căn đều vào chính giữa màn hình theo chiều ngang
    left: 0,
    right: 0,
    
    // Dùng Row để xếp các dấu chấm indicator nằm hàng ngang
    child: Row(
      // Căn các con của Row vào chính giữa
      mainAxisAlignment: MainAxisAlignment.center,
      
      // List.generate: Vòng lặp tự động tạo ra một danh sách các widget
      // dựa trên số lượng phần tử (length) truyền vào
      children: List.generate(
        length,
        // 'index' là vị trí của dấu chấm hiện tại trong vòng lặp (bắt đầu từ 0)
        (index) => AnimatedContainer(
          // Thời gian diễn ra hiệu ứng chuyển đổi mượt mà khi thay đổi kích thước/màu sắc
          // LƯU Ý: Ở đây bạn đang để 200 giây (Duration(seconds: 200)), hãy sửa thành milliseconds: 200 nhé!
          duration: const Duration(milliseconds: 200),
          
          // Tạo khoảng cách giữa các dấu chấm (trái và phải mỗi bên 4 pixel)
          margin: const EdgeInsets.symmetric(horizontal: 4),
          
          // Toán tử ba ngôi toán học: Nếu dấu chấm này trùng với trang hiện tại (_currentPage) 
          // thì nó sẽ dài ra (width = 20), ngược lại các dấu chấm khác sẽ ngắn (width = 8)
          width: _currentPage == index ? 20 : 8,
          
          // Chiều cao cố định của các dấu chấm là 8 pixel
          height: 8,
          
          // Trang trí hình dáng cho dấu chấm
          decoration: BoxDecoration(
            // Nếu là trang hiện tại thì đổi sang màu chủ đạo (AppColors.primary)
            // Nếu là trang khác thì đổi sang màu chữ phụ/màu nhạt (AppColors.textSecondary)
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.textSecondary,
                
            // Bo tròn góc cho dấu chấm (bán kính 4 pixel) biến nó từ hình chữ nhật thành hình kẹo/hình tròn
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
  );
}
}

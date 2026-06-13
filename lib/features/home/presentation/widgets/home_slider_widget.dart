import 'package:flutter/material.dart';

class HomeSliderWidget extends StatefulWidget {
  const HomeSliderWidget({super.key});

  @override
  State<HomeSliderWidget> createState() => _HomeSliderWidgetState();
}

class _HomeSliderWidgetState extends State<HomeSliderWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> imageUrls = [
    'https://sesantravel.com/thumbs/1366x576x1/upload/photo/golden-hands-bridge-da-nang-vietnam-19040.webp',
    'https://sesantravel.com/thumbs/1366x576x1/upload/photo/cruise-the-mekong-river-32640.webp',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 3), _nextPage);
  }

  void _nextPage() {
    if (!mounted) return;
    
    if (_currentPage < imageUrls.length - 1) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }
    
    _pageController.animateToPage(
      _currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    _startAutoPlay(); // Gọi lại để tiếp tục
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: imageUrls.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Không thể tải ảnh'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
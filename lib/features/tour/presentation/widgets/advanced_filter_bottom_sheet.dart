import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tour_providers.dart';

class AdvancedFilterBottomSheet extends ConsumerStatefulWidget {
  const AdvancedFilterBottomSheet({super.key});

  @override
  ConsumerState<AdvancedFilterBottomSheet> createState() =>
      _AdvancedFilterBottomSheetState();
}

class _AdvancedFilterBottomSheetState
    extends ConsumerState<AdvancedFilterBottomSheet> {
  late double _minPrice;
  late double _maxPrice;

  final _locationController = TextEditingController();
  final _durationController = TextEditingController();

  final double _min = 0;
  final double _max = 50000000;

  @override
  void initState() {
    super.initState();

    final filter = ref.read(tourFilterProvider);

    _minPrice = filter.minPrice ?? _min;
    _maxPrice = filter.maxPrice ?? _max;

    _locationController.text = filter.location ?? '';
    _durationController.text = filter.duration ?? '';
  }

  @override
  void dispose() {
    _locationController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final filter = ref.read(tourFilterProvider);

    ref.read(tourFilterProvider.notifier).state = filter.copyWith(
      minPrice: _minPrice > _min ? _minPrice : null,
      maxPrice: _maxPrice < _max ? _maxPrice : null,
      location: _locationController.text.trim(),
      duration: _durationController.text.trim(),
      clearMinPrice: _minPrice <= _min,
      clearMaxPrice: _maxPrice >= _max,
      clearLocation: _locationController.text.trim().isEmpty,
      clearDuration: _durationController.text.trim().isEmpty,
    );

    Navigator.pop(context);
  }

  void _resetFilter() {
    setState(() {
      _minPrice = _min;
      _maxPrice = _max;

      _locationController.clear();
      _durationController.clear();
    });
  }

  String formatPrice(double price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)} Tr';
    }
    return '${(price / 1000).toStringAsFixed(0)} K';
  }

  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
        return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc nâng cao',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Khoảng giá
            const Text(
              'Khoảng giá (VND)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatPrice(_minPrice),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatPrice(_maxPrice),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            RangeSlider(
              values: RangeValues(
                _minPrice,
                _maxPrice,
              ),
              min: _min,
              max: _max,
              divisions: 100,
              activeColor: AppColors.primary,
              inactiveColor: Colors.grey.shade300,
              labels: RangeLabels(
                formatPrice(_minPrice),
                formatPrice(_maxPrice),
              ),
              onChanged: (value) {
                setState(() {
                  _minPrice = value.start;
                  _maxPrice = value.end;
                });
              },
            ),

            const SizedBox(height: 24),

            /// Địa điểm
            const Text(
              'Địa điểm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _locationController,
              decoration: inputDecoration(
                hint: 'VD: Đà Lạt, Phú Quốc...',
                icon: Icons.location_on_outlined,
              ),
            ),

            const SizedBox(height: 24),

            /// Thời gian
            const Text(
              'Thời gian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _durationController,
              decoration: inputDecoration(
                hint: 'VD: 3N2Đ, 4 Ngày...',
                icon: Icons.access_time,
              ),
            ),

            const SizedBox(height: 32),

            /// Button
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilter,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      side: const BorderSide(
                        color: AppColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xóa',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _applyFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
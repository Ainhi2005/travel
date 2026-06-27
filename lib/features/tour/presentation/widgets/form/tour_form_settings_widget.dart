import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/category/presentation/providers/category_provider.dart';

class TourFormSettingsWidget extends ConsumerWidget {
  final TextEditingController maxPeopleController;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;
  final String status;
  final ValueChanged<String?> onStatusChanged;
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const TourFormSettingsWidget({
    super.key,
    required this.maxPeopleController,
    required this.selectedCategoryId,
    required this.onCategoryChanged,
    required this.status,
    required this.onStatusChanged,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final categories = categoriesAsync.value ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cài đặt & Phân loại',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          
          // Danh mục
          DropdownButtonFormField<String>(
            value: selectedCategoryId,
            items: categories.map((cat) {
              return DropdownMenuItem(
                value: cat.id,
                child: Text(cat.name),
              );
            }).toList(),
            onChanged: onCategoryChanged,
            decoration: InputDecoration(
              labelText: 'Danh mục *',
              prefixIcon: const Icon(Icons.category_outlined, color: AppColors.neutral),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) => value == null ? 'Vui lòng chọn danh mục' : null,
          ),
          const SizedBox(height: 16),

          // Số người tối đa
          TextFormField(
            controller: maxPeopleController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Số người tối đa *',
              prefixIcon: const Icon(Icons.group_outlined, color: AppColors.neutral),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) => value == null || value.isEmpty ? 'Nhập số người tối đa' : null,
          ),
          const SizedBox(height: 16),

          // Trạng thái
          DropdownButtonFormField<String>(
            value: status,
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Kích hoạt (Active)')),
              DropdownMenuItem(value: 'inactive', child: Text('Ẩn (Inactive)')),
            ],
            onChanged: onStatusChanged,
            decoration: InputDecoration(
              labelText: 'Trạng thái hiển thị',
              prefixIcon: const Icon(Icons.visibility_outlined, color: AppColors.neutral),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 16),

          // Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đánh giá mặc định: ${rating.toStringAsFixed(1)} sao',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Slider(
                value: rating,
                min: 1.0,
                max: 5.0,
                divisions: 8, // 1.0, 1.5, 2.0, ... 5.0
                activeColor: Colors.orange,
                label: rating.toStringAsFixed(1),//có chức năng chuyển một số thực (double) 
                                                //thành chuỗi (String) với đúng số chữ số thập phân được chỉ định.
                onChanged: onRatingChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

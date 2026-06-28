import 'package:flutter/material.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

/// Form section for tour description and image URL.
///
/// Shows a character counter for the description field and a live
/// preview thumbnail when a valid image URL is entered.
class TourFormDescriptionWidget extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController imageController;

  const TourFormDescriptionWidget({
    super.key,
    required this.descriptionController,
    required this.imageController,
  });

  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: alignLabelWithHint,
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      prefixIcon: icon != null
          ? Icon(
              icon,
              color: AppColors.primary.withValues(alpha: 0.7),
              size: 20,
            )
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Mô tả & Hình ảnh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Description with character counter
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
            maxLength: 1000,
            decoration: _inputDecoration(
              label: 'Mô tả chuyến đi',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 10),

          // Image URL field
          TextFormField(
            controller: imageController,
            decoration: _inputDecoration(
              label: 'Link hình ảnh (URL) *',
              icon: Icons.image_outlined,
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Vui lòng nhập link ảnh'
                : null,
          ),
          const SizedBox(height: 10),

          // Image preview
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: imageController,
            builder: (context, value, _) {
              final url = value.text.trim();
              if (url.isEmpty || !Uri.tryParse(url)!.hasAbsolutePath) {
                return const SizedBox.shrink();
              }
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey.shade400,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Không thể tải ảnh',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

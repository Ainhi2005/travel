import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/features/category/domain/entities/category_entity.dart';
import 'package:sesan_travel/features/category/presentation/providers/category_provider.dart';

/// Form section for tour settings: category, max people, status, and rating.
///
/// Uses [DropdownSearch] for category selection with filtering,
/// a [Switch] for status toggle, and interactive star rating.
class TourFormSettingsWidget extends ConsumerWidget {
  final TextEditingController maxPeopleController;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategoryChanged;
  final String status;
  final ValueChanged<String> onStatusChanged;
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

  bool get _isActive => status == 'active';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);
    final categories = categoriesAsync.value ?? [];

    // Resolve the currently selected category object from the id.
    final selectedCategory = selectedCategoryId != null
        ? categories
            .where((c) => c.id == selectedCategoryId)
            .firstOrNull
        : null;

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
                  Icons.settings_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Cài đặt & Phân loại',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Category dropdown with search
          DropdownSearch<CategoryEntity>(
            selectedItem: selectedCategory,
            items: (filter, loadProps) => categories,
            compareFn: (a, b) => a.id == b.id,
            itemAsString: (cat) => cat.name,
            filterFn: (cat, filter) =>
                cat.name.toLowerCase().contains(filter.toLowerCase()),
            onChanged: (cat) => onCategoryChanged(cat?.id),
            validator: (value) =>
                value == null ? 'Vui lòng chọn danh mục' : null,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm danh mục...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
              menuProps: MenuProps(
                borderRadius: BorderRadius.circular(12),
                elevation: 6,
                shadowColor: Colors.black.withValues(alpha: 0.08),
              ),
              itemBuilder: (context, item, isDisabled, isSelected) {
                return ListTile(
                  title: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.neutral,
                    ),
                  ),
                  leading: Icon(
                    Icons.category_rounded,
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade400,
                    size: 18,
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle,
                          color: AppColors.primary, size: 18)
                      : null,
                  dense: true,
                );
              },
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                labelText: 'Danh mục *',
                labelStyle: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                prefixIcon: Icon(Icons.category_outlined,
                    color: AppColors.primary.withValues(alpha: 0.7), size: 20),
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
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.error, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.error, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Max people with stepper
          _MaxPeopleField(controller: maxPeopleController),
          const SizedBox(height: 12),

          // Divider
          Divider(color: Colors.grey.shade100, height: 1),
          const SizedBox(height: 12),

          // Status switch
          _StatusSwitch(
            isActive: _isActive,
            onChanged: (val) => onStatusChanged(val ? 'active' : 'inactive'),
          ),
          const SizedBox(height: 20),

          // Star rating
          _StarRating(
            rating: rating,
            onChanged: onRatingChanged,
          ),
        ],
      ),
    );
  }
}

/// Max people field with inline +/- stepper buttons.
class _MaxPeopleField extends StatelessWidget {
  final TextEditingController controller;

  const _MaxPeopleField({required this.controller});

  void _increment() {
    final current = int.tryParse(controller.text) ?? 0;
    controller.text = (current + 1).toString();
  }

  void _decrement() {
    final current = int.tryParse(controller.text) ?? 0;
    if (current > 1) controller.text = (current - 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: 'Số người tối đa *',
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        prefixIcon: Icon(Icons.group_outlined,
            color: AppColors.primary.withValues(alpha: 0.7), size: 20),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperIconButton(
              icon: Icons.remove_rounded,
              onTap: _decrement,
            ),
            const SizedBox(width: 4),
            _StepperIconButton(
              icon: Icons.add_rounded,
              onTap: _increment,
            ),
            const SizedBox(width: 8),
          ],
        ),
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
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số người tối đa';
        }
        final count = int.tryParse(value);
        if (count == null || count <= 0) {
          return 'Số người phải lớn hơn 0';
        }
        return null;
      },
    );
  }
}

/// Circular +/- button for the max people stepper.
class _StepperIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

/// Animated toggle switch for active / inactive status.
class _StatusSwitch extends StatelessWidget {
  final bool isActive;
  final ValueChanged<bool> onChanged;

  const _StatusSwitch({required this.isActive, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.06)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.success.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              isActive ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              key: ValueKey(isActive),
              color: isActive ? AppColors.success : Colors.grey.shade500,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trạng thái hiển thị',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isActive ? AppColors.neutral : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  isActive ? 'Tour đang hiển thị công khai' : 'Tour đang bị ẩn',
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive
                        ? AppColors.success
                        : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            onChanged: onChanged,
            activeThumbColor: AppColors.success,
            activeTrackColor: AppColors.success.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}

/// Interactive star rating widget supporting half-star increments.
class _StarRating extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _StarRating({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Đánh giá mặc định',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${rating.toStringAsFixed(1)} / 5.0',
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starValue = index + 1.0;
            final isFullStar = rating >= starValue;
            final isHalfStar =
                rating >= starValue - 0.5 && rating < starValue;

            return GestureDetector(
              onTap: () {
                // Tap toggles between full star and half star
                if (rating == starValue) {
                  onChanged(starValue - 0.5);
                } else {
                  onChanged(starValue);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: isFullStar || isHalfStar ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFullStar
                        ? Icons.star_rounded
                        : isHalfStar
                            ? Icons.star_half_rounded
                            : Icons.star_outline_rounded,
                    color: isFullStar || isHalfStar
                        ? Colors.orange
                        : Colors.grey.shade300,
                    size: 30,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

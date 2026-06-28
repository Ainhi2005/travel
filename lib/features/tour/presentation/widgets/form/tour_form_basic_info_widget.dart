import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/core/utils/currency_input_formatter.dart';

/// Form section for basic tour info: name, destination, price, and duration.
///
/// Duration uses day/night spinners instead of free-text entry to prevent
/// formatting errors. Price auto-formats with VND thousand separators.
class TourFormBasicInfoWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController destinationController;
  final TextEditingController priceController;
  final int days;
  final int nights;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<int> onNightsChanged;

  const TourFormBasicInfoWidget({
    super.key,
    required this.nameController,
    required this.destinationController,
    required this.priceController,
    required this.days,
    required this.nights,
    required this.onDaysChanged,
    required this.onNightsChanged,
  });

  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
    String? suffixText,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: AppColors.primary.withValues(alpha: 0.7), size: 20)
          : null,
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      suffix: suffix,
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

  Widget _buildSpinnerField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    required IconData icon,
    int min = 0,
    int max = 30,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary.withValues(alpha: 0.7), size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SpinnerButton(
                  icon: Icons.keyboard_arrow_up_rounded,
                  onTap: value < max ? () => onChanged(value + 1) : null,
                ),
                const SizedBox(height: 1),
                _SpinnerButton(
                  icon: Icons.keyboard_arrow_down_rounded,
                  onTap: value > min ? () => onChanged(value - 1) : null,
                ),
              ],
            ),
          ],
        ),
      ),
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
          // Section header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tour name
          TextFormField(
            controller: nameController,
            decoration: _inputDecoration(
              label: 'Tên chuyến đi *',
              icon: Icons.tour_outlined,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên tour' : null,
          ),
          const SizedBox(height: 10),

          // Destination
          TextFormField(
            controller: destinationController,
            decoration: _inputDecoration(
              label: 'Điểm đến *',
              icon: Icons.location_on_outlined,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập điểm đến' : null,
          ),
          const SizedBox(height: 10),

          // Price with VND formatter
          TextFormField(
            controller: priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyInputFormatter(),
            ],
            decoration: _inputDecoration(
              label: 'Giá tour *',
              icon: Icons.payments_outlined,
              suffixText: 'VND',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập giá tour';
              }
              // Strip dot formatting
              final cleanVal = value.replaceAll('.', '');
              final price = double.tryParse(cleanVal);
              if (price == null || price <= 0) {
                return 'Giá tour phải lớn hơn 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),

          // Duration: day/night spinners
          Row(
            children: [
              _buildSpinnerField(
                label: 'Số ngày',
                value: days,
                onChanged: onDaysChanged,
                icon: Icons.wb_sunny_outlined,
                min: 1,
              ),
              const SizedBox(width: 12),
              _buildSpinnerField(
                label: 'Số đêm',
                value: nights,
                onChanged: onNightsChanged,
                icon: Icons.nights_stay_outlined,
                min: 0,
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Duration preview chip
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${days}N${nights}Đ',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small arrow button used in the day/night spinner controls.
class _SpinnerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _SpinnerButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isEnabled ? AppColors.primary : Colors.grey.shade400,
        ),
      ),
    );
  }
}

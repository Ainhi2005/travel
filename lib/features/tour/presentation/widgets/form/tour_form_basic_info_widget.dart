import 'package:flutter/material.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';

class TourFormBasicInfoWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController destinationController;
  final TextEditingController priceController;
  final TextEditingController durationController;

  const TourFormBasicInfoWidget({
    super.key,
    required this.nameController,
    required this.destinationController,
    required this.priceController,
    required this.durationController,
  });

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.neutral),
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
            'Thông tin cơ bản',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: nameController,
            label: 'Tên chuyến đi *',
            icon: Icons.tour_outlined,
            validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên tour' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: destinationController,
            label: 'Điểm đến *',
            icon: Icons.location_on_outlined,
            validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập điểm đến' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: priceController,
                  label: 'Giá (VND) *',
                  icon: Icons.payments_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null || value.isEmpty ? 'Nhập giá' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: durationController,
                  label: 'Thời gian *',
                  icon: Icons.access_time,
                  validator: (value) => value == null || value.isEmpty ? 'VD: 3N2Đ' : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

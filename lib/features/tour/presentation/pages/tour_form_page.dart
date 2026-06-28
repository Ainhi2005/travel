import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
import 'package:sesan_travel/core/utils/currency_input_formatter.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_entity.dart';
import 'package:sesan_travel/features/tour/domain/entities/tour_request_entity.dart';
import 'package:sesan_travel/features/tour/presentation/providers/tours_notifier.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/form/tour_form_basic_info_widget.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/form/tour_form_description_widget.dart';
import 'package:sesan_travel/features/tour/presentation/widgets/form/tour_form_settings_widget.dart';

class TourFormPage extends ConsumerStatefulWidget {
  final TourEntity? tour;

  const TourFormPage({super.key, this.tour});

  @override
  ConsumerState<TourFormPage> createState() => _TourFormPageState();
}

class _TourFormPageState extends ConsumerState<TourFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho Thông tin cơ bản
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _priceController = TextEditingController();

  // Controllers cho Mô tả & Hình ảnh
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  // Controllers/State cho Settings
  final _maxPeopleController = TextEditingController();
  String? _selectedCategoryId;
  String _status = 'active';
  double _rating = 5.0;

  // Duration as day/night count instead of free-text
  int _days = 3;
  int _nights = 2;

  bool _isLoading = false;
  bool get isEditMode => widget.tour != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final t = widget.tour!;
      _nameController.text = t.title;
      _destinationController.text = t.location;

      // Format price with VND separators for display
      _priceController.text = _formatPrice(t.price.toDouble());

      // Parse duration string like "3N2Đ" → days=3, nights=2
      _parseDuration(t.duration);

      _descriptionController.text = t.description;
      _imageController.text = t.image;
      _maxPeopleController.text = t.maxPeople.toString();
      _selectedCategoryId = t.categoryId;
      _status = t.status;
      _rating = t.rating.toDouble();
    } else {
      _maxPeopleController.text = '10';
    }
  }

  /// Formats a numeric price into dot-separated VND display string.
  String _formatPrice(double price) {
    final intPrice = price.toInt();
    if (intPrice == 0) return '';
    final str = intPrice.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  /// Parses a duration string like "3N2Đ" into day and night counts.
  void _parseDuration(String duration) {
    final match = RegExp(r'(\d+)N(\d+)Đ').firstMatch(duration);
    if (match != null) {
      _days = int.tryParse(match.group(1)!) ?? 3;
      _nights = int.tryParse(match.group(2)!) ?? 2;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    _maxPeopleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Kiểm tra category
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn danh mục cho tour!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Strip VND formatting dots to get raw numeric value
      final rawPrice = CurrencyInputFormatter.getUnformattedValue(
        _priceController.text.trim(),
      );

      final request = TourRequestEntity(
        categoryId: _selectedCategoryId!,
        title: _nameController.text.trim(),
        location: _destinationController.text.trim(),
        price: double.tryParse(rawPrice) ?? 0,
        duration: '${_days}N$_nightsĐ',
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        maxPeople: int.tryParse(_maxPeopleController.text.trim()) ?? 10,
        status: _status,
        rating: _rating,
      );

      if (isEditMode) {
        await ref
            .read(toursProvider.notifier)
            .updateTour(widget.tour!.id, request);
      } else {
        await ref.read(toursProvider.notifier).createTour(request);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditMode
                  ? 'Cập nhật tour thành công!'
                  : 'Thêm tour thành công!',
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.neutral,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditMode ? 'Chỉnh sửa Tour' : 'Thêm Tour mới',
          style: const TextStyle(
            color: AppColors.neutral,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    isEditMode ? 'Đang cập nhật...' : 'Đang tạo tour...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12.0,
                ),
                children: [
                  // Section 1: Basic Info
                  TourFormBasicInfoWidget(
                    nameController: _nameController,
                    destinationController: _destinationController,
                    priceController: _priceController,
                    days: _days,
                    nights: _nights,
                    onDaysChanged: (val) => setState(() => _days = val),
                    onNightsChanged: (val) => setState(() => _nights = val),
                  ),
                  const SizedBox(height: 12),

                  // Section 2: Description & Image
                  TourFormDescriptionWidget(
                    descriptionController: _descriptionController,
                    imageController: _imageController,
                  ),
                  const SizedBox(height: 12),

                  // Section 3: Settings & Category
                  TourFormSettingsWidget(
                    maxPeopleController: _maxPeopleController,
                    selectedCategoryId: _selectedCategoryId,
                    onCategoryChanged: (val) =>
                        setState(() => _selectedCategoryId = val),
                    status: _status,
                    onStatusChanged: (val) => setState(() => _status = val),
                    rating: _rating,
                    onRatingChanged: (val) => setState(() => _rating = val),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFFF9F43)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _submit,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isEditMode
                                ? Icons.save_rounded
                                : Icons.add_circle_outline_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            isEditMode
                                ? 'Cập nhật chuyến đi'
                                : 'Tạo chuyến đi mới',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

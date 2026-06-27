import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sesan_travel/core/theme/app_colors.dart';
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
  final _durationController = TextEditingController();
  
  // Controllers cho Mô tả & Hình ảnh
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  // Controllers/State cho Settings
  final _maxPeopleController = TextEditingController();
  String? _selectedCategoryId;
  String _status = 'active';
  double _rating = 5.0;

  bool _isLoading = false;
  bool get isEditMode => widget.tour != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final t = widget.tour!;
      _nameController.text = t.title;
      _destinationController.text = t.location;
      _priceController.text = t.price.toString();
      _durationController.text = t.duration;
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

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _priceController.dispose();
    _durationController.dispose();
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
      final request = TourRequestEntity(
        categoryId: _selectedCategoryId!,
        title: _nameController.text.trim(),
        location: _destinationController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        duration: _durationController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _imageController.text.trim(),
        maxPeople: int.tryParse(_maxPeopleController.text.trim()) ?? 10,
        status: _status,
        rating: _rating,
      );

      if (isEditMode) {
        await ref.read(toursProvider.notifier).updateTour(widget.tour!.id, request);
      } else {
        await ref.read(toursProvider.notifier).createTour(request);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode ? 'Cập nhật tour thành công!' : 'Thêm tour thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
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
      backgroundColor: Colors.grey.shade100, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.neutral),
          onPressed: () => context.pop(),
        ),
        title: Text(
          isEditMode ? 'Chỉnh sửa Tour' : 'Thêm Tour mới',
          style: const TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 1: Basic Info
                    TourFormBasicInfoWidget(
                      nameController: _nameController,
                      destinationController: _destinationController,
                      priceController: _priceController,
                      durationController: _durationController,
                    ),
                    const SizedBox(height: 24),

                    // Section 2: Description & Image
                    TourFormDescriptionWidget(
                      descriptionController: _descriptionController,
                      imageController: _imageController,
                    ),
                    const SizedBox(height: 24),

                    // Section 3: Settings & Category
                    TourFormSettingsWidget(
                      maxPeopleController: _maxPeopleController,
                      selectedCategoryId: _selectedCategoryId,
                      onCategoryChanged: (val) => setState(() => _selectedCategoryId = val),
                      status: _status,
                      onStatusChanged: (val) => setState(() => _status = val ?? 'active'),
                      rating: _rating,
                      onRatingChanged: (val) => setState(() => _rating = val),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Nút Lưu
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _submit,
                      child: Text(
                        isEditMode ? 'Cập nhật chuyến đi' : 'Tạo chuyến đi mới',
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

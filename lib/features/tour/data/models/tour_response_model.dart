import '../../../category/data/models/category_response_model.dart';
import '../../domain/entities/tour_entity.dart';

class TourResponseModel extends TourEntity {
  TourResponseModel({
    required super.id,
    required super.categoryId,
    required super.title,
    required super.slug,
    required super.description,
    required super.price,
    required super.duration,
    required super.location,
    required super.image,
    required super.maxPeople,
    required super.status,
    required super.rating,
    super.createdAt,
    super.updatedAt,
    super.category,
  });

  factory TourResponseModel.fromJson(Map<String, dynamic> json) {
    return TourResponseModel(
      id: json['id'] as String? ?? '',
      categoryId: json['category_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as num? ?? 0,
      duration: json['duration'] as String? ?? '',
      location: json['location'] as String? ?? '',
      image: json['image'] as String? ?? '',
      maxPeople: json['max_people'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      rating: json['rating'] as num? ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      category: json['category'] != null ? CategoryResponseModel.fromJson(json['category']) : null,
    );
  }
}

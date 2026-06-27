import '../../../category/domain/entities/category_entity.dart';

class TourEntity {
  final String id;
  final String categoryId;
  final String title;
  final String slug;
  final String description;
  final num price;
  final String duration;
  final String location;
  final String image;
  final int maxPeople;
  final String status;
  final num rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final CategoryEntity? category;

  TourEntity({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.slug,
    required this.description,
    required this.price,
    required this.duration,
    required this.location,
    required this.image,
    required this.maxPeople,
    required this.status,
    required this.rating,
    this.createdAt,
    this.updatedAt,
    this.category,
  });
}

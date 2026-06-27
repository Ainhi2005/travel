import '../../domain/entities/category_entity.dart';

class CategoryResponseModel extends CategoryEntity {
  CategoryResponseModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.image,
    required super.status,
    required super.sortOrder,
  });
  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
       id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

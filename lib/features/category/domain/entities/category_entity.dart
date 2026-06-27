class CategoryEntity {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final String status;
  final int sortOrder;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.status,
    required this.sortOrder,
  });
}
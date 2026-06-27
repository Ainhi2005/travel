class CategoryRequestModel {
  final String name;
  final String description;
  final String imageUrl;
  final String status;
  final int sortOrder;
  CategoryRequestModel({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.status,
    required this.sortOrder,
  });
  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'imageUrl': imageUrl,
    'status': status,
    'sortOrder': sortOrder,
  };
}

class TourRequestEntity {
  final String categoryId;
  final String title;
  final String description;
  final double price;
  final String duration;
  final String location;
  final String image;
  final int maxPeople;
  final String status;
  final double rating;

  TourRequestEntity({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    required this.location,
    required this.image,
    required this.maxPeople,
    required this.status,
    required this.rating,
  });
}

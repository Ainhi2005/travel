import '../../domain/entities/tour_request_entity.dart';

class TourRequestModel extends TourRequestEntity {

  TourRequestModel({
    required super.categoryId,
    required super.title,
    required super.description,
    required super.price,
    required super.duration,
    required super.location,
    required super.image,
    required super.maxPeople,
    required super.status,
    required super.rating,
  });

  factory TourRequestModel.fromEntity(TourRequestEntity entity) {
    return TourRequestModel(
      categoryId: entity.categoryId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      duration: entity.duration,
      location: entity.location,
      image: entity.image,
      maxPeople: entity.maxPeople,
      status: entity.status,
      rating: entity.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'location': location,
      'image': image,
      'max_people': maxPeople,
      'status': status,
      'rating': rating,
    };
  }
}

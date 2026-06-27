class TourFilterEntity {
  final String? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final String? duration;

  const TourFilterEntity({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.duration,
  });

  TourFilterEntity copyWith({
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? location,
    String? duration,
    bool clearCategory = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearLocation = false,
    bool clearDuration = false,
  }) {
    return TourFilterEntity(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      location: clearLocation ? null : (location ?? this.location),
      duration: clearDuration ? null : (duration ?? this.duration),
    );
  }

  bool get isEmpty =>
      categoryId == null &&
      minPrice == null &&
      maxPrice == null &&
      (location == null || location!.isEmpty) &&
      (duration == null || duration!.isEmpty);
}

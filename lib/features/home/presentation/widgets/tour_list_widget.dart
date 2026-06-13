import 'package:flutter/material.dart';

class TourListWidget extends StatelessWidget {
  const TourListWidget({super.key});

  final List<TourItem> tours = const [
    TourItem(
      imageUrl: 'https://sesantravel.com/thumbs/1366x576x1/upload/photo/golden-hands-bridge-da-nang-vietnam-19040.webp',
      priceFrom: 48,
      priceVnd: 1133000,
      title: 'Private Mui Ne - Phan Thiet Beach 1 Day',
      description: 'Mui Ne - Phan Thiet is a wonderfully beautiful sea in Vietnam, with sunshine and white sand stretching.',
    ),
    TourItem(
      imageUrl: 'https://sesantravel.com/thumbs/1366x576x1/upload/photo/cruise-the-mekong-river-32640.webp',
      priceFrom: 35,
      priceVnd: 825000,
      title: 'Mekong Delta Discovery Tour',
      description: 'Explore the vibrant floating markets, lush orchards, and traditional villages of the Mekong Delta.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        return _buildTourItem(tours[index]);
      },
    );
  }

  Widget _buildTourItem(TourItem tour) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              tour.imageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 40),
              ),
            ),
          ),
          // Nội dung
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Giá
                  Row(
                    children: [
                      Text(
                        'Price from ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '\$${tour.priceFrom} USD',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        ' / ${_formatPrice(tour.priceVnd)} VND',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    tour.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    tour.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }
}

class TourItem {
  final String imageUrl;
  final int priceFrom;
  final int priceVnd;
  final String title;
  final String description;

  const TourItem({
    required this.imageUrl,
    required this.priceFrom,
    required this.priceVnd,
    required this.title,
    required this.description,
  });
}
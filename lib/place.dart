import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String name;
  final String location;
  final double? latitude;
  final double? longitude;
  final double rating;
  final String imageUrl;
  final String description;
  final String mapUrl;
  final List<Map<String, dynamic>> reviews;

  Place({
    required this.id,
    required this.name,
    required this.location,
    this.latitude,
    this.longitude,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.mapUrl,
    required this.reviews,
  });

  factory Place.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // Process reviews to handle timestamp conversion
    List<Map<String, dynamic>> reviews = [];
    if (data['reviews'] != null) {
      reviews = List<Map<String, dynamic>>.from(data['reviews'].map((review) {
        // Convert timestamp if it exists
        if (review['timestamp'] != null) {
          if (review['timestamp'] is Timestamp) {
            review['timestamp'] = (review['timestamp'] as Timestamp).toDate();
          } else if (review['timestamp'] is String) {
            review['timestamp'] = DateTime.tryParse(review['timestamp']);
          }
        }
        return Map<String, dynamic>.from(review);
      }));
    }

    // Add URL validation
    String imageUrl = data['imageUrl'] ?? '';
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = 'https://$imageUrl';
    }

    return Place(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      latitude: data['latitude']?.toDouble(),
      longitude: data['longitude']?.toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: imageUrl,
      description: data['description'] ?? '',
      mapUrl: data['mapUrl'] ?? 'https://www.google.com/maps',
      reviews: reviews,
    );
  }
}
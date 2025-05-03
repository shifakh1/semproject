import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String location;
  final double? latitude;
  final double? longitude;
  final double rating;
  final String imageUrl;
  final String description;
  final String mapUrl;
  final List<Map<String, dynamic>> reviews;
  final String cuisineType;
  final String priceRange;

  Restaurant({
    required this.id,
    required this.name,
    required this.location,
    required this.address,
    this.latitude,
    this.longitude,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.mapUrl,
    required this.reviews,
    required this.cuisineType,
    required this.priceRange,
  });

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    debugPrint('Raw Firestore data for ${doc.id}: $data');

    // Process reviews
    List<Map<String, dynamic>> reviews = [];
    if (data['reviews'] != null) {
      reviews = List<Map<String, dynamic>>.from(data['reviews'].map((review) {
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

    String imageUrl = data['imageUrl']?.toString().trim() ?? '';
    if (imageUrl.isNotEmpty) {
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'https://$imageUrl';
      }
      imageUrl = imageUrl
          .replaceAll(r'\', '')
          .replaceAll(' ', '%20')
          .replaceAll('"', '');
    }

    String mapUrl = data['mapUrl']?.toString().trim() ?? 'https://www.google.com/maps';
    if (mapUrl.isNotEmpty && !mapUrl.startsWith('http')) {
      mapUrl = 'https://$mapUrl';
    }

    // Fix rating conversion
    double ratingValue;
    if (data['rating'] == null) {
      ratingValue = 0.0;
    } else if (data['rating'] is num) {
      ratingValue = data['rating'].toDouble();
    } else if (data['rating'] is String) {
      ratingValue = double.tryParse(data['rating']) ?? 0.0;
    } else {
      ratingValue = 0.0;
    }

    return Restaurant(
      id: doc.id,
      name: data['name']?.toString().trim() ?? 'Unknown Restaurant',
      location: data['location']?.toString().trim() ?? 'Lahore',
      address: data['address']?.toString().trim() ?? 'Unknown Address',
      latitude: data['lat']?.toDouble() ?? data['latitude']?.toDouble(),
      longitude: data['lng']?.toDouble() ?? data['longitude']?.toDouble(),
      rating: ratingValue,  // Use the properly converted value
      imageUrl: imageUrl,
      description: data['description']?.toString().trim() ?? '',
      mapUrl: mapUrl,
      reviews: reviews,
      cuisineType: data['cuisineType']?.toString().trim() ?? 'Various',
      priceRange: data['priceRange']?.toString().trim() ?? '\$\$',
    );
  }
}
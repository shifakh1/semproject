import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Hotel {
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
  final String priceRange;
  final List<String> amenities;

  Hotel({
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
    required this.priceRange,
    required this.amenities,
  });

  factory Hotel.fromFirestore(DocumentSnapshot doc) {
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

    // Process image URL
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

    // Process map URL
    String mapUrl = data['mapUrl']?.toString().trim() ?? 'https://www.google.com/maps';
    if (mapUrl.isNotEmpty && !mapUrl.startsWith('http')) {
      mapUrl = 'https://$mapUrl';
    }

    // Process amenities
    List<String> amenities = [];
    if (data['amenities'] != null) {
      amenities = List<String>.from(data['amenities'].map((a) => a.toString()));
    }

    // Process name with common corrections
    String name = data['name']?.toString().trim() ?? 'Unknown Hotel';
    name = name
        .replaceAll(' - ', '-')
        .replaceAll('  ', ' ')
        .trim();

    return Hotel(
      id: doc.id,
      name: name,
      location: data['location']?.toString().trim() ?? 'Lahore',
      address: data['address']?.toString().trim() ?? 'Unknown Address',
      latitude: data['lat']?.toDouble() ?? data['latitude']?.toDouble(),
      longitude: data['lng']?.toDouble() ?? data['longitude']?.toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: imageUrl,
      description: data['description']?.toString().trim() ?? '',
      mapUrl: mapUrl,
      reviews: reviews,
      priceRange: data['priceRange']?.toString().trim() ?? '\$',
      amenities: amenities,
    );
  }
}
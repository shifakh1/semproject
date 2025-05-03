import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Place {
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

  Place({
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
  });

  factory Place.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;

    // Debug print to see raw data
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

    String mapUrl = data['mapUrl']?.toString().trim() ??
        'https://www.google.com/maps';
    if (mapUrl.isNotEmpty && !mapUrl.startsWith('http')) {
      mapUrl = 'https://$mapUrl';
    }

    // Get the name - check multiple possible fields
    String name = data['name']?.toString().trim() ??
        data['title']?.toString().trim() ??
        'Unknown Place';

    // Get the address - check multiple possible fields
    String address = data['address']?.toString().trim() ??
        data['location']?.toString().trim() ??
        'Unknown Address';

    // Get the description - check multiple possible fields
    String description = data['description']?.toString().trim() ??
        data['desc']?.toString().trim() ??
        data['details']?.toString().trim() ??
        '';

    // Get coordinates
    double? latitude;
    double? longitude;
    if (data['coordinates'] != null) {
      final coords = data['coordinates'] as Map<String, dynamic>;
      latitude = coords['lat']?.toDouble();
      longitude = coords['lng']?.toDouble();
    }


    // SPECIAL HANDLING FOR BADSHAHI MOSQUE


    if (name.toLowerCase().contains('badshahi')) {
      // Force specific values for Badshahi Mosque
      address = 'Walled City of Lahore, Lahore';
      description = 'The Badshahi Mosque is a Mughal era mosque in Lahore, '
          'capital of the Pakistani province of Punjab, Pakistan. '
          'The mosque is located west of Lahore Fort along the '
          'outskirts of the Walled City of Lahore, and is widely '
          'considered to be one of Lahore\'s most iconic landmarks.';
    } else {
      // Normal handling for other places
      address = data['address']?.toString().trim() ??
          data['location']?.toString().trim() ??
          'Unknown Address';

      description = data['description']?.toString().trim() ??
          data['desc']?.toString().trim() ??
          '';
    }

    return Place(
      id: doc.id,
      name: name,
      location: data['city']?.toString().trim() ?? 'Lahore',
      // Default to Lahore if city not specified
      address: address,
      latitude: latitude ?? data['latitude']?.toDouble(),
      longitude: longitude ?? data['longitude']?.toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: imageUrl,
      description: description,
      mapUrl: mapUrl,
      reviews: reviews,
    );
  }
}
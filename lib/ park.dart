import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Park {
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

  Park({
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

  factory Park.fromFirestore(DocumentSnapshot doc) {
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

    // Process name - handle various possible formats
    String name = data['name']?.toString().trim() ??
        data['Name']?.toString().trim() ??
        'Unknown Park';

    // Fix common typos in name
    name = name
        .replaceAll('Guishan', 'Gulshan')
        .replaceAll('Idbal', 'Iqbal')
        .replaceAll(' - ', '-')
        .replaceAll('e- ', 'e-');

    // Process description
    String description = data['description']?.toString().trim() ??
        data['Description']?.toString().trim() ??
        '';


    // Handle the specific case for Gulshan-e-Iqbal Park with corrected field names
    return Park(
      id: doc.id,
      name: name,
      description: description,
      location: data['location']?.toString().trim() ?? 'Lahore',
      address: data['address']?.toString().trim() ??
          (data['Address']?.toString().trim() ?? 'Unknown Address'), // Check for 'Address' with capital A
      latitude: data['lat']?.toDouble() ??
          data['latitude']?.toDouble() ??
          data['Lat']?.toDouble(), // Check for 'Lat' with capital L
      longitude: data['lng']?.toDouble() ??
          data['longitude']?.toDouble() ??
          data['Lng']?.toDouble(), // Check for 'Lng' with capital L
      rating: (data['rating'] ?? 0).toDouble(),
      imageUrl: imageUrl,
      mapUrl: mapUrl,
      reviews: reviews,
    );
  }
}
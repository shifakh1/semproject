import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'place_detail_page.dart';
import 'place.dart';

class PlacesPage extends StatelessWidget {
  const PlacesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA6B8),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow and search icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Icon(Icons.search, color: Colors.white, size: 28),
                ],
              ),
            ),

            // Page title
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PLACES",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Places list from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('places').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading places'));
                  }

                  final places = snapshot.data!.docs.map((doc) {
                    final place = Place.fromFirestore(doc);
                    debugPrint('Loading place: ${place.name} | Image URL: ${place.imageUrl}');
                    return place;
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(place: place),
                            ),
                          );
                        },
                        child: _buildPlaceCard(place: place, index: index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard({required Place place, required int index}) {
    final cardColors = [
      Colors.white,
      Colors.pink.shade100,
      Colors.red.shade300,
      Colors.blue.shade100,
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        decoration: BoxDecoration(
          color: cardColors[index % cardColors.length],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image container
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: _buildPlaceImage(place.imageUrl),
                ),
              ),
              const SizedBox(width: 12),

              // Details on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Star ratings
                        ...List.generate(5, (index) {
                          return Icon(
                            index < place.rating.floor()
                                ? Icons.star
                                : index < place.rating
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceImage(String imageUrl) {

    debugPrint('Original image URL: $imageUrl');
    debugPrint('Cleaned image URL: ${imageUrl.replaceAll(r'\', '')
        .replaceAll(' ', '%20')
        .replaceAll('"', '')
        .trim()}');
    // Clean and validate the URL first
    if (imageUrl.isNotEmpty) {
      imageUrl = imageUrl
          .replaceAll(r'\', '')
          .replaceAll(' ', '%20')
          .replaceAll('"', '')
          .trim();

      // Ensure URL starts with http/https
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'https://$imageUrl';
      }
    }

    debugPrint('Processing image URL: $imageUrl');

    if (imageUrl.isEmpty) {
      return Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      cacheManager: CacheManager(
        Config(
          'customCacheKey',
          stalePeriod: const Duration(days: 7),
        ),
      ),
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
        ),
      ),
      errorWidget: (context, url, error) {
        debugPrint('Image load error: $error for URL: $url');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
              SizedBox(height: 8),
              Text(
                'Could not load image',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }
}
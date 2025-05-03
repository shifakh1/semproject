import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'restaurant_detail_page.dart';
import 'restaurant.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFA6B8),
      body: SafeArea(
        child: Column(
          children: [
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
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "RESTAURANTS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading restaurants'));
                  }

                  final restaurants = snapshot.data!.docs.map((doc) {
                    final restaurant = Restaurant.fromFirestore(doc);
                    debugPrint('Loading restaurant: ${restaurant.name} | Image URL: ${restaurant.imageUrl}');
                    return restaurant;
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                            ),
                          );
                        },
                        child: _buildRestaurantCard(restaurant: restaurant, index: index),
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

  Widget _buildRestaurantCard({required Restaurant restaurant, required int index}) {
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
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: _buildRestaurantImage(restaurant.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < restaurant.rating.floor()
                                ? Icons.star
                                : index < restaurant.rating
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.cuisineType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.address,
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

  Widget _buildRestaurantImage(String imageUrl) {
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
          'restaurantsCacheKey',
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
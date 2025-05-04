import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'restaurant.dart';

class RestaurantDetailPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailPage({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  late Restaurant restaurant;

  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: restaurant.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: restaurant.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: Center(child: Icon(Icons.broken_image)),
                ),
              )
                  : Container(color: Colors.grey[300]),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.cuisineType,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.address,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.priceRange,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "DESCRIPTION",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(restaurant.description),
                  const SizedBox(height: 24),
                  const Text(
                    "REVIEWS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (restaurant.reviews.isEmpty)
                    const Text("No reviews yet", style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: restaurant.reviews
                          .map((review) => _buildReviewCard(
                        review['text'] ?? '',
                        review['author'] ?? 'Guest',
                        (review['rating'] ?? 0).toDouble(),
                        _parseTimestamp(review['timestamp']),
                      ))
                          .toList(),
                    ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _openMap,
                        icon: const Icon(Icons.map),
                        label: const Text("MAP"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA6B8),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _addReview,
                        icon: const Icon(Icons.edit),
                        label: const Text("ADD REVIEW"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA6B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String review, String author, double rating, DateTime? timestamp) {
    final clampedRating = rating.clamp(0.0, 5.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  author,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (timestamp != null)
                  Text(
                    '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            RatingBarIndicator(
              rating: clampedRating,
              itemBuilder: (context, index) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20.0,
            ),
            const SizedBox(height: 8),
            Text(review),
          ],
        ),
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.tryParse(timestamp);
    return null;
  }

  void _openMap() async {
    try {
      if (restaurant.latitude != null && restaurant.longitude != null) {
        final url = 'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
          return;
        }
      }

      final searchUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(restaurant.name)}';
      if (await canLaunchUrl(Uri.parse(searchUrl))) {
        await launchUrl(Uri.parse(searchUrl));
        return;
      }

      throw 'Could not open maps';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open maps: $e'),
        ),
      );
    }
  }

  void _addReview() {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final reviewController = TextEditingController();
    double rating = 3.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Review'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Your Name'),
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: reviewController,
                    decoration: const InputDecoration(labelText: 'Your Review'),
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  const Text('Rating'),
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    itemCount: 5,
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (value) {
                      rating = value;
                      setDialogState(() {});
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      setDialogState(() {}); // Show loading

                      final doc = await FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.id)
                          .get();

                      List<dynamic> reviews = List.from(doc.data()?['reviews'] ?? []);
                      reviews.add({
                        'author': nameController.text,
                        'text': reviewController.text,
                        'rating': rating,
                        'timestamp': DateTime.now().toIso8601String(),
                      });

                      await FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.id)
                          .update({'reviews': reviews});

                      final updatedDoc = await FirebaseFirestore.instance
                          .collection('restaurants')
                          .doc(restaurant.id)
                          .get();

                      if (mounted) {
                        setState(() {
                          restaurant = Restaurant.fromFirestore(updatedDoc);
                        });
                      }

                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review added successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Close loading
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
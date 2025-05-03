import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'place.dart';

class PlaceDetailPage extends StatefulWidget {
  final Place place;

  const PlaceDetailPage({Key? key, required this.place}) : super(key: key);

  @override
  _PlaceDetailPageState createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  late Place place;

  @override
  void initState() {
    super.initState();
    place = widget.place;
    debugPrint('Loading place: ${place.name} | Image URL: ${place.imageUrl}');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Loading place: ${place.name} | Image URL: ${place.imageUrl}');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: place.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: place.imageUrl,
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
                        place.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toStringAsFixed(1),
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
                    place.address,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "DESCRIPTION",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "REVIEWS",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (place.reviews.isEmpty)
                    const Text("No reviews yet", style: TextStyle(color: Colors.grey))
                  else
                    Column(
                      children: place.reviews
                          .map((review) => _buildReviewCard(
                        review['text'] ?? '',
                        review['author'] ?? 'Visitor',
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
                        onPressed: () => _openMap(context),
                        icon: const Icon(Icons.map, color: Colors.white),
                        label: const Text("MAP"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA6B8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _addReview(context),
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text("ADD REVIEW"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA6B8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.tryParse(timestamp);
    return null;
  }

  Widget _buildReviewCard(String review, String author, double rating, DateTime? timestamp) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFFFA6B8),
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
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
                          fontSize: 16,
                        ),
                      ),
                      if (timestamp != null)
                        Text(
                          '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMap(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      if (place.latitude != null && place.longitude != null) {
        final url = 'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
          Navigator.pop(context);
          return;
        }
      }

      final searchUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent('${place.name}, ${place.location}')}';
      if (await canLaunchUrl(Uri.parse(searchUrl))) {
        await launchUrl(Uri.parse(searchUrl));
        Navigator.pop(context);
        return;
      }

      throw 'Could not open maps application';
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open maps: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _addReview(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController reviewController = TextEditingController();
    double rating = 3.0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Review'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: reviewController,
                decoration: InputDecoration(labelText: 'Your Review'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Rating'),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(child: CircularProgressIndicator()),
                );

                try {
                  // First get the current document
                  final doc = await FirebaseFirestore.instance
                      .collection('places')
                      .doc(place.id)
                      .get();

                  // Get existing reviews or empty list if none
                  List<dynamic> currentReviews = doc.data()?['reviews'] ?? [];

                  // Add the new review with client-side timestamp
                  currentReviews.add({
                    'author': nameController.text,
                    'text': reviewController.text,
                    'rating': rating,
                    'timestamp': DateTime.now().toIso8601String(),
                  });

                  // Update the document with the new reviews array
                  await FirebaseFirestore.instance
                      .collection('places')
                      .doc(place.id)
                      .update({
                    'reviews': currentReviews,
                  });

                  // Refresh the data
                  final updatedDoc = await FirebaseFirestore.instance
                      .collection('places')
                      .doc(place.id)
                      .get();

                  setState(() {
                    place = Place.fromFirestore(updatedDoc);
                  });

                  Navigator.pop(context); // Close loading
                  Navigator.pop(context); // Close dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Review added successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close loading
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add review: $e'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
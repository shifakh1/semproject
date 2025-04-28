import 'package:flutter/material.dart';
import 'GulshanEIqbalParkPage.dart';
import 'RaceCourseJilaniParkPage.dart';
import 'JalloParkPage.dart';
import 'JoylandPage.dart';

class ParksPage extends StatelessWidget {
  const ParksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA6B8),
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
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Icon(Icons.search, color: Colors.white, size: 28),
                ],
              ),
            ),

            // Page title
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PARKS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Parks list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => GulshanEIqbalParkPage())),
                    child: _buildParkCard(
                      image: 'assets/gulshaneiqbalpark.jpeg',
                      title: "GUISHAN-E-IOBAL PARK",
                      rating: 4.5,
                      description: "Fazai e Has Rd Lahore, Punjab",
                      cardColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RaceCourseJilaniParkPage())),
                    child: _buildParkCard(
                      image: 'assets/racecoursepark.jpeg',
                      title: "RACE COURSE (JILANI PARK)",
                      rating: 4.6,
                      description: "Race Course Rd, Lahore, Punjab",
                      cardColor: Colors.pink.shade100,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => JalloParkPage())),
                    child: _buildParkCard(
                      image: 'assets/jallo_park.jpg',
                      title: "JALLO PARK AKA BOTANICAL PARK",
                      rating: 4.5,
                      description: "Phagwaranwala, Jallo Rd, Lahore",
                      cardColor: Colors.red.shade300,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => JoylandPage())),
                    child: _buildParkCard(
                      image: 'assets/joyland (1).png',
                      title: "JOYLAND",
                      rating: 4.3,
                      description: "Main Boulevard Gulberg, Lahore",
                      cardColor: Colors.white,
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

  Widget _buildParkCard({
    required String image,
    required String title,
    required double rating,
    required String description,
    required Color cardColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image on the left
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              // Details on the right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        // Star ratings (4.5 shows 4 full stars and 1 half star)
                        ...List.generate(rating.floor(), (_) =>
                            Icon(Icons.star, color: Colors.amber, size: 16)),
                        if (rating % 1 >= 0.5)
                          Icon(Icons.star_half, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
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
}
import 'package:flutter/material.dart';

class HotelsPage extends StatelessWidget {
  const HotelsPage({Key? key}) : super(key: key);

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
                  "HOTELS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Hotels list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildHotelCard(
                    image: 'assets/holidayinn.jpeg',
                    title: "HOLIDAY INN SUITES",
                    rating: 4.3,
                    description: "Sector D Sector C DHA Phase 6, Lahore",
                    cardColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/marcopolo.jpeg',
                    title: "HOTEL MARCOPOLO LAHORE",
                    rating: 4.1,
                    description: "13 Alison Road, near Lakhmi Chowk, Gari Shahu",
                    cardColor: Colors.pink.shade100,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/avari_express.jpeg',
                    title: "AVARI XPRESS",
                    rating: 4.4,
                    description: "11-K Mall Boulevard Gulberg II, Lahore",
                    cardColor: Colors.red.shade300,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/Pearl-Continental-Lahore.jpg',
                    title: "PEARL CONTINENTAL HOTEL LAHORE",
                    rating: 4.7,
                    description: "Shahrah-e-Quaid-e-Azam, Lahore",
                    cardColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/falettis.jpg',
                    title: "FALETTIS HOTEL LAHORE",
                    rating: 4.2,
                    description: "Egerton Road, Garhi Shahu, Lahore",
                    cardColor: Colors.pink.shade100,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/park_lane.jpeg',
                    title: "PARK LANE HOTEL",
                    rating: 4.0,
                    description: "115-CCA, Phase 1, DHA, Lahore",
                    cardColor: Colors.red.shade300,
                  ),
                  SizedBox(height: 16),
                  _buildHotelCard(
                    image: 'assets/nishat.jpg',
                    title: "THE NISHAT HOTEL JOHAR TOWN",
                    rating: 4.5,
                    description: "Main Boulevard, Johar Town, Lahore",
                    cardColor: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard({
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
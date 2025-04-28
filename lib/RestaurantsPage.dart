import 'package:flutter/material.dart';
import ' Maribellepage.dart';
import 'HaveliRestaurantPage.dart';
import 'MandarinKitchenPage.dart';
import 'HowdyRooftopPage.dart';
import 'YumChinesePage.dart';
import 'PfChangsPage.dart';
import 'TheWokPage.dart';
import 'CafeAylantoPage.dart';

class RestaurantsPage extends StatelessWidget {
  const RestaurantsPage({Key? key}) : super(key: key);

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
                    onPressed: () => Navigator.pop(context),
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
                  "RESTAURANTS",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Restaurants list
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MaribelleRestaurantPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/maribelle.jpg',
                      title: "MARIBELLE RESTAURANT",
                      rating: 4.8,
                      description: "123 Gourmet Street, Food District, Lahore",
                      cardColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HaveliRestaurantPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/mosque.png',
                      title: "HAVELI RESTAURANT",
                      rating: 4.3,
                      description: "2170-A Food St Fort Rd, Shahi Mohallah Walled City of Lahore, Lahore, Punjab",
                      cardColor: Colors.pink.shade100,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MandarinKitchenPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/mandarin_kitchen.jpeg',
                      title: "MANDARIN KITCHEN",
                      rating: 5.0,
                      description: "57 L Block I, Gulberg 2, Lahore, Punjab",
                      cardColor: Colors.red.shade300,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HowdyRooftopPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/howdy_rooftop.jpeg',
                      title: "HOWDY ROOFTOP MM ALAM",
                      rating: 4.4,
                      description: "Rooftop, 9c Building, MM Alam Rd, Lahore, 54000",
                      cardColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => YumChinesePage())),
                    child: _buildRestaurantCard(
                      image: 'assets/yumchinese.png',
                      title: "YUM CHINESE & THAI",
                      rating: 3.5,
                      description: "DHA Lahore Branch - 72 Z, Phase III, DHA",
                      cardColor: Colors.pink.shade100,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PfChangsPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/pf_changs.jpeg',
                      title: "P.F. CHANG'S, LAHORE",
                      rating: 3.5,
                      description: "17 - C1 MM Alam Rd, Block C1 Block C 1 Gulberg III, Lahore",
                      cardColor: Colors.red.shade300,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TheWokPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/the_wok.jpeg',
                      title: "THE WOK PAKISTAN",
                      rating: 3.7,
                      description: "Main Blvd Gulberg, opposite to Mall One, Block D1 Block D 1 Gulberg III, Lahore, Punjab",
                      cardColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CafeAylantoPage())),
                    child: _buildRestaurantCard(
                      image: 'assets/cafe_aylanto.jpeg',
                      title: "CAFE AYLANTO",
                      rating: 5.0,
                      description: "12 C1 MM Alam Rd, Gulberg III, Lahore, Punjab",
                      cardColor: Colors.pink.shade100,
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

  Widget _buildRestaurantCard({
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
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
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
                        ...List.generate(rating.floor(), (_) =>
                            Icon(Icons.star, color: Colors.amber, size: 16)),
                        if (rating % 1 >= 0.5)
                          Icon(Icons.star_half, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
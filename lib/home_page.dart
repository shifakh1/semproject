import 'package:flutter/material.dart';
import 'PlacesPage.dart';
import 'all_categories_page.dart';
import 'ParksPage.dart';
import 'HotelsPage.dart';
import 'RestaurantsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You Signed In Successfully"),
          duration: Duration(seconds: 2),
        ),
      );
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFFFA6B8),
      drawer: buildDrawer(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top image with icons
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: double.infinity,
                            child: Image.asset(
                              "assets/ac_logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 35,
                            left: 16,
                            child: IconButton(
                              icon: Icon(Icons.menu, color: Colors.white, size: 28),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          ),
                          Positioned(
                            top: 35,
                            right: 16,
                            child: Icon(Icons.add, color: Colors.white, size: 28),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            "LAHORE LAHORE AYE!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search...",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),

                      // Categories Icons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PlacesPage()),
                                  );
                                },
                                child: categoryBox(Icons.apartment, "Places", Colors.red.shade300),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                  );
                                },
                                child: categoryBox(Icons.restaurant, "Restaurants", Colors.pink.shade100),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HotelsPage()),
                                  );
                                },
                                child: categoryBox(Icons.hotel, "Hotels", Colors.red.shade300),
                              ),
                              SizedBox(width: 16),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ParksPage()),
                                  );
                                },
                                child: categoryBox(Icons.park, "Parks", Colors.white),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Featured Section
                      Container(
                        color: Colors.pink.shade100.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // All Featured Locations
                                Container(
                                  width: 150,
                                  height: 335,
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "ALL\nFEATURED\nLOCATIONS",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          height: 1.3,
                                        ),
                                      ),
                                      SizedBox(height: 14),
                                      Text(
                                        "All the locations that are featured and have the top demand in Lahore!",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),

                                // Horizontal scrolling cards
                                Expanded(
                                  child: Container(
                                    height: 335,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                            );
                                          },
                                          child: featuredLocationCard(
                                            "assets/mosque.png",
                                            "Haveli",
                                            "Restaurant",
                                            "Haveli Restaurant is located in the historic Haveli Khalil Khan.",
                                            4.5,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                            );
                                          },
                                          child: featuredLocationCard(
                                            "assets/pfchangs.jpg",
                                            "P.F.Chang's",
                                            "Restaurant",
                                            "P.F.Chang's offers a casual dining atmosphere to experience authentic Chinese food & Asian cuisine.",
                                            4.0,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PlacesPage()),
                                            );
                                          },
                                          child: featuredLocationCard(
                                            "assets/lahorefort.png",
                                            "Lahore Fort",
                                            "Historical Place",
                                            "The Lahore Fort is located in the city of Lahore. The fort is located at the northern end of Lahore.",
                                            4.8,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PlacesPage()),
                                            );
                                          },
                                          child: featuredLocationCard(
                                            "assets/wazirkhanmosque.jpg",
                                            "Wazir Khan Mosque",
                                            "Historical Place",
                                            "Vazir Khan Mosque is renowned for its intricate tile work known as kashi-kari.",
                                            4.7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Most Viewed Section with horizontal scrolling
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MOST VIEWED",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 240,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ParksPage()),
                                      );
                                    },
                                    child: mostViewedCard(
                                      "assets/joyland (1).png",
                                      "Joyland Lahore",
                                      "Amusement Park",
                                      "The oldest and most modern amusement park",
                                      3.5,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                      );
                                    },
                                    child: mostViewedCard(
                                      "assets/maribelle.jpg",
                                      "Maribelle",
                                      "Restaurant",
                                      "Luxurious, modern European restaurant",
                                      4.0,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                      );
                                    },
                                    child: mostViewedCard(
                                      "assets/cafeaylanto.jpeg",
                                      "Café Aylanto",
                                      "Restaurant",
                                      "High quality cuisine and refined sophistication.",
                                      5.0,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PlacesPage()),
                                      );
                                    },
                                    child: mostViewedCard(
                                      "assets/minar_e_pak.jpg",
                                      "Minar-e-Pakistan",
                                      "Monument",
                                      "National monument built between 1960 and 1968.",
                                      4.0,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                      );
                                    },
                                    child: mostViewedCard(
                                      "assets/mosque.png",
                                      "Haveli Restaurant",
                                      "Restaurant",
                                      "Historic restaurant in Haveli Khalil Khan.",
                                      4.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      // Categories Section with horizontal scrolling
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "CATEGORIES",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AllCategoriesPage()),
                                    );
                                  },
                                  child: Text(
                                    "View all",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 120,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => RestaurantsPage()),
                                      );
                                    },
                                    child: categoryCard(
                                      "assets/restaurant.png.png",
                                      "RESTAURANTS",
                                      Color(0xFFF5E4E7),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ParksPage()),
                                      );
                                    },
                                    child: categoryCard(
                                      "assets/park_icon.jpg",
                                      "PARKS",
                                      Color(0xFFF5E4E7),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HotelsPage()),
                                      );
                                    },
                                    child: categoryCard(
                                      "assets/hotel.jpg",
                                      "HOTELS",
                                      Color(0xFFF5E4E7),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => PlacesPage()),
                                      );
                                    },
                                    child: categoryCard(
                                      "assets/place.png",
                                      "PLACES",
                                      Color(0xFFF5E4E7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    final menuItems = [
      {'icon': Icons.home, 'title': 'HOME'},
      {'icon': Icons.search, 'title': 'SEARCH'},
      {'icon': Icons.category, 'title': 'ALL CATEGORIES'},
      {'icon': Icons.add_location, 'title': 'ADD NEW PLACE'},
      {'icon': Icons.logout, 'title': 'LOGOUT'},
      {'icon': Icons.person, 'title': 'PROFILE'},
      {'icon': Icons.share, 'title': 'SHARE'},
      {'icon': Icons.star, 'title': 'RATE US'},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 180,
            color: Colors.black,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/ac_logo.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'LAHORE LAHORE AYE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'WE KNOW OUR WAY AROUND',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(menuItems.length, (index) {
            final item = menuItems[index];
            return MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = -1),
              child: Container(
                color: _hoveredIndex == index ? Colors.black : Colors.transparent,
                child: ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: _hoveredIndex == index ? Colors.red : Colors.black,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: _hoveredIndex == index ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    if (index == 2) { // ALL CATEGORIES
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllCategoriesPage()),
                      );
                    }
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget categoryBox(IconData icon, String title, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.black87, size: 34),
        ),
        SizedBox(height: 6),
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget featuredLocationCard(String imagePath, String title, String subtitle, String description, double rating) {
    return Container(
      width: 200,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                imagePath,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        ...List.generate(rating.floor(), (_) => Icon(Icons.star, color: Colors.green, size: 16)),
                        if (rating % 1 > 0) Icon(Icons.star_half, color: Colors.green, size: 16),
                      ],
                    ),
                    SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mostViewedCard(String imagePath, String title, String subtitle, String description, double rating) {
    return Container(
      width: 180,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                imagePath,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(rating.floor(), (_) => Icon(Icons.star, color: Colors.green, size: 14)),
                      if (rating % 1 > 0) Icon(Icons.star_half, color: Colors.green, size: 14),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryCard(String imagePath, String title, Color bgColor) {
    return Container(
      width: 120,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 50,
                width: 50,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
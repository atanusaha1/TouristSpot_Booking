import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:new_flutter_project/reviews.dart';
import 'package:new_flutter_project/welcomeScreen.dart';
import 'Details.dart';
import 'Profile.dart';
import 'globals.dart' as globals;

// Booking model class
class Booking {
  final String id;
  final String userId;
  final String ticketId;
  final String name;
  final String spotName;
  final double total;
  final String date;
  final String status;

  Booking({
    required this.id,
    required this.userId,
    required this.ticketId,
    required this.name,
    required this.spotName,
    required this.total,
    required this.date,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      userId: json['userId'],
      ticketId: json['ticketId'],
      name: json['name'],
      spotName: json['spot_name'],
      total: json['total'].toDouble(),
      date: json['date'],
      status: json['status'],
    );
  }
}

class myHome extends StatefulWidget {
  const myHome({Key? key}) : super(key: key);

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  List<dynamic>? listOfSpots = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTouristSpot();
    searchController.addListener(searchSpots);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await showExitConfirmation(context);
        return exitApp;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            title: isSearching ? buildSearchField() : buildTitle(),
            actions: [
              IconButton(
                icon: Icon(isSearching ? Icons.clear : Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    if (!isSearching) {
                      searchController.clear();
                      getTouristSpot();
                    }
                  });
                },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage('assets/T2.jpg'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome Tourists',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person,
                    size: 30, color: Colors.lightGreen),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              // Other ListTile items for menu options
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, size: 30, color: Colors.red),
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()));
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: getTouristSpot,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(0.8, 1),
                            colors: <Color>[
                              Color(0xff1f005c),
                              Color(0xff5b0060),
                              Color(0xff870160),
                              Color(0xffac255e),
                              Color(0xffca485c),
                              Color(0xffe16b5c),
                              Color(0xfff39060),
                              Color(0xffffb56b),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                        ),
                        padding: const EdgeInsets.all(12.0),
                        child: const Text(
                          'Welcome Tourist',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Please Select\nYour Favourite Destination.....',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: listOfSpots!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyDetail(
                              spot: listOfSpots![index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 290),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: Image.network(
                                      listOfSpots![index]['images'][0]
                                              ['link'] ??
                                          '',
                                      height: 168,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(6.0),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        listOfSpots![index]['category'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listOfSpots![index]['name'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.redAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            listOfSpots![index]['location'] ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.category,
                                          color: Colors.blueAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          listOfSpots![index]['category'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        const Icon(
                                          Icons.location_city,
                                          color: Colors.orangeAccent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          listOfSpots![index]['district'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 70,
          padding: const EdgeInsets.only(top: 5),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const myHome()),
                  );
                },
                icon:
                    const Icon(Icons.home, size: 30, color: Colors.lightGreen),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reviews()),
                  );
                },
                icon: const Icon(Icons.reviews,
                    size: 30, color: Colors.lightGreen),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                icon: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.lightGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getTouristSpot() async {
    String url = "http://10.10.10.136/web/spots";
    Dio dio = Dio();

    listOfSpots = [];
    try {
      var response = await dio.get(url);
      Map<String, dynamic> map = response.data;
      if (map['status']) {
        setState(() {
          listOfSpots = List.from(map['result']);
        });
      } else {
        log('[e] Tourist Spot not found');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> searchSpots() async {
    String searchText = searchController.text;
    if (searchText.isEmpty) {
      getTouristSpot();
      return;
    }

    String url = "http://10.10.10.136/web/search?search=$searchText";
    Dio dio = Dio();

    listOfSpots = [];
    try {
      var response = await dio.get(url);
      Map<String, dynamic> map = response.data;
      if (map['status']) {
        setState(() {
          listOfSpots = List.from(map['result']);
        });
      } else {
        log('[e] No spots found');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.black),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
              left: 8.0, right: 8.0), // Shifts the icon to the left
          child: Icon(Icons.search, color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget buildTitle() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Color(0xFFF65959)),
        SizedBox(width: 13),
        Text.rich(
          TextSpan(
            style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w800,
                fontFamily: 'Cursive'), // Applying cursive font
            children: [
              TextSpan(text: 'E', style: TextStyle(color: Colors.green)),
              TextSpan(text: 'x', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'p', style: TextStyle(color: Colors.purple)),
              TextSpan(text: 'l', style: TextStyle(color: Colors.pink)),
              TextSpan(text: 'o', style: TextStyle(color: Colors.red)),
              TextSpan(text: 'r', style: TextStyle(color: Colors.orange)),
              TextSpan(text: 'e', style: TextStyle(color: Colors.orangeAccent)),
              TextSpan(
                  text: ' ',
                  style: TextStyle(color: Colors.black)), // Space between words
              TextSpan(text: 'T', style: TextStyle(color: Colors.purple)),
              TextSpan(text: 'r', style: TextStyle(color: Colors.pink)),
              TextSpan(text: 'i', style: TextStyle(color: Colors.red)),
              TextSpan(text: 'p', style: TextStyle(color: Colors.orange)),
              TextSpan(text: 'u', style: TextStyle(color: Colors.pink)),
              TextSpan(text: 'r', style: TextStyle(color: Colors.purple)),
              TextSpan(text: 'a', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> showExitConfirmation(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}

class UpcomingBookingsPage extends StatefulWidget {
  const UpcomingBookingsPage({Key? key}) : super(key: key);

  @override
  _UpcomingBookingsPageState createState() => _UpcomingBookingsPageState();
}

class _UpcomingBookingsPageState extends State<UpcomingBookingsPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchUpcomingBookings();
  }

  Future<void> fetchUpcomingBookings() async {
    String url = "http://10.10.10.136/web/booking?upcoming=true";
    Dio dio = Dio();

    try {
      var response = await dio.get(url);
      List<dynamic> data = response.data['result'];
      setState(() {
        bookings = data.map((json) => Booking.fromJson(json)).toList();
      });
    } catch (e) {
      log('[e] Error fetching upcoming bookings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Bookings'),
      ),
      body: bookings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Booking booking = bookings[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(booking.spotName),
                    subtitle: Text(
                        'Date: ${booking.date}\nStatus: ${booking.status}\nTotal: ${booking.total}'),
                  ),
                );
              },
            ),
    );
  }
}

// class MyLogin extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//       ),
//       body: const Center(
//         child: Text('Login Page'),
//       ),
//     );
//   }
// }

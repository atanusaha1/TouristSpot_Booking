import 'dart:developer';
import 'package:new_flutter_project/Details.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:new_flutter_project/reviews.dart';
import 'Profile.dart';
import 'home_app_bar.dart';
import 'globals.dart' as globals;

class myHome extends StatefulWidget {
  const myHome({super.key});

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  List? listOfSpots = [];

  @override
  void initState() {
    super.initState();
    getTouristSpot();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = await showExitConfirmation(context);
        return exitApp;
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: HomeAppBar(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  getTouristSpot();
                },
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
                        constraints: BoxConstraints(maxHeight: 290),
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
          padding: EdgeInsets.only(top: 5),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => myHome()));
                  },
                  icon: const Icon(Icons.home,
                      size: 30, color: Colors.lightGreen)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Reviews()));
                  },
                  icon: const Icon(Icons.reviews,
                      size: 30, color: Colors.lightGreen)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()));
                  },
                  icon: const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.lightGreen,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  getTouristSpot() async {
    String url = "http://10.10.10.136/web/spots";
    Dio dio = Dio();

    listOfSpots = [];
    try {
      var response = await dio.get(url);
      Map map = response.data;
      // log('[i] TOURIST SPOT list $map');
      if (map['status']) {
        for (var spots in map['result']) {
          // log('[i]$spots');
          listOfSpots!.add(spots);
        }
        setState(() {});
      } else {
        log('[e] Tourist Spot not found');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> showExitConfirmation(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
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
        ) ??
        false;
  }
}

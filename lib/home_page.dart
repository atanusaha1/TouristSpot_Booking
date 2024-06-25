import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:new_flutter_project/Details.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'Profile.dart';
import 'home_app_bar.dart';

class myHome extends StatefulWidget {
  const myHome({super.key});

  @override
  State<myHome> createState() => _myHomeState();
}

class _myHomeState extends State<myHome> {
  // List<Map<String, dynamic>> listOfSpots = [];

  List? listOfSpots = [];

  @override
  void initState() {
    super.initState();
    getTouristSpot();
  }
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: (){
                getTouristSpot();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
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
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Welcome Tourist',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Ensuring text is readable on gradient
                    ),
                  ),
                ),
              ),

            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: listOfSpots!.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyDetail(spot: listOfSpots![index]),
                        ),
                      );
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 290
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.network(
                                listOfSpots![index]['images'][0]['link'] ?? '',
                                height: 168,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
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
                                          listOfSpots![index]['location'] ?? '',
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
                icon: const Icon(Icons.home, size: 30, color: Colors.lightGreen)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite,
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

    );
  }

  getTouristSpot() async {
    String url = "http://10.10.10.114/web/spots";
    Dio dio = Dio();

    listOfSpots = [];
    try {
      var response = await dio.get(url);
      Map map = response.data;
      log('[i] TOURIST SPOT list $map');
      if (map['status']) {
        for (var spots in map['result']){
        log('[i]$spots');
          listOfSpots!.add(spots);
        }
        setState(() {});
      }else{
        log('[e] Tourist Spot not found');
      }
    } catch (e) {
      print(e);
    }
  }
}













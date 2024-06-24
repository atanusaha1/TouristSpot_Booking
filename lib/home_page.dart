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

  // void _showSpotDetails(Map<String, dynamic> spot) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Container(
  //           padding: const EdgeInsets.all(16.0),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 if (spot['images'] != null)
  //                   ClipRRect(
  //                     borderRadius: const BorderRadius.only(
  //                       topRight: Radius.circular(25),
  //                       topLeft: Radius.circular(25),
  //                     ),
  //                     child: Image.asset(
  //                       spot['images'],
  //                       width: double.infinity,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(16.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         spot['name'] ?? '',
  //                         style: const TextStyle(
  //                           fontSize: 25,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Row(
  //                         children: [
  //                           const Icon(
  //                             Icons.location_on,
  //                             color: Colors.redAccent,
  //                             size: 18,
  //                           ),
  //                           const SizedBox(width: 4),
  //                           Text(
  //                             spot['location'] ?? '',
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               color: Colors.grey[500],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         spot['description'] ?? '',
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           color: Colors.grey[800],
  //                         ),
  //                       ),
  //                       const SizedBox(height: 20),
  //                       SizedBox(
  //                         height: 150,
  //                         child: ListView.builder(
  //                           scrollDirection: Axis.horizontal,
  //                           itemCount: spot['imageUrl']?.length ?? 0,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             return Padding(
  //                               padding: const EdgeInsets.only(right: 8.0),
  //                               child: Image.network(
  //                                 spot['imageUrl'][index],
  //                                 width: 120,
  //                                 fit: BoxFit.cover,
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text(
  //                         'Close',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           color: Colors.blue,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                         _showBookingDialog(spot);
  //                       },
  //                       child: const Text(
  //                         'Book Now',
  //                         style: TextStyle(color: Colors.orangeAccent),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 15),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 16),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // void _showBookingDialog(Map<String, dynamic> spot) {
  //   final _formKey = GlobalKey<FormState>();
  //   DateTime selectedDate = DateTime.now();
  //   int numAdults = 1;
  //   int numChildren = 0;
  //   int adultPrice = 200; // Example price per adult
  //   int childPrice = 100;  // Example price per child
  //   int totalPrice = 0;
  //
  //   totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Form(
  //             key: _formKey,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text(
  //                   'Book Ticket',
  //                   style: TextStyle(
  //                     fontSize: 24,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     labelText: 'Date',
  //                     suffixIcon: Icon(Icons.calendar_today),
  //                   ),
  //                   readOnly: true,
  //                   onTap: () async {
  //                     DateTime? pickedDate = await showDatePicker(
  //                       context: context,
  //                       initialDate: selectedDate,
  //                       firstDate: DateTime.now(),
  //                       lastDate: DateTime(2101),
  //                     );
  //                     if (pickedDate != null && pickedDate != selectedDate) {
  //                       setState(() {
  //                         selectedDate = pickedDate;
  //                       });
  //                     }
  //                   },
  //                   controller: TextEditingController(
  //                     text: "${selectedDate.toLocal()}".split(' ')[0],
  //                   ),
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return 'Please select a date';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     labelText: 'Number of Adults',
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                   initialValue: numAdults.toString(),
  //                   onChanged: (value) {
  //                     numAdults = int.parse(value);
  //                     totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
  //                     setState(() {});
  //                   },
  //                   validator: (value) {
  //                     if (value!.isEmpty || int.tryParse(value) == null) {
  //                       return 'Please enter a valid number';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   decoration: InputDecoration(
  //                     labelText: 'Number of Children',
  //                   ),
  //                   keyboardType: TextInputType.number,
  //                   initialValue: numChildren.toString(),
  //                   onChanged: (value) {
  //                     numChildren = int.parse(value);
  //                     totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
  //                     setState(() {});
  //                   },
  //                   validator: (value) {
  //                     if (value!.isEmpty || int.tryParse(value) == null) {
  //                       return 'Please enter a valid number';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 SizedBox(height: 16),
  //                 Text(
  //                   'Total Price: \$${totalPrice.toStringAsFixed(2)}',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 16),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     if (_formKey.currentState!.validate()) {
  //                       // Implement your booking functionality here
  //                       Navigator.of(context).pop();
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         SnackBar(
  //                           content: Text('Booking confirmed for \$${totalPrice.toStringAsFixed(2)}'),
  //                         ),
  //                       );
  //                     }
  //                   },
  //                   child: Text('Confirm Booking'),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                icon: const Icon(Icons.home, size: 20, color: Colors.black)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite,
                    size: 20, color: Colors.black)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                icon: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.black,
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













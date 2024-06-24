import 'dart:developer';
import 'package:flutter/material.dart';

class MyDetail extends StatefulWidget {
  Map spot;

  MyDetail({super.key, required this.spot});

  @override
  State<MyDetail> createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {
  // List<Map<String, dynamic>> listOfAllSpots = [
  //   {
  //     "name": 'Chabimura',
  //     "location": 'Amarpur',
  //     "images": '',
  //     "district": "",
  //     "category": "",
  //     "imageUrl": [],
  //     "description": "",
  //     "rating": ""
  //   },
  //   {
  //     "name": 'Bash Gram',
  //     "location": 'katlamara',
  //     "images": 'http://10.10.10.114/uploads/290c1f54-2b87-416b-8614-1e37c9dd8f9b.j',
  //     "district": "",
  //     "category": "",
  //     "imageUrl": [],
  //     "description": "",
  //     "rating": ""
  //   },
  //   {
  //     "name": 'Dumboor Lake',
  //     "location": '',
  //     "images": 'http://10.10.10.114/uploads/c2a59251-e31b-40dd-9af2-24823d27c9b5.jpg',
  //     "district": "",
  //     "category": "",
  //     "imageUrl": [],
  //     "description": "",
  //     "rating": ""
  //   },
  //   {
  //     "name": 'Chowda Devta Mandir',
  //     "location": '',
  //     "images": 'http://10.10.10.114/uploads/4b22b198-ecbc-4903-bdb9-ab3782426c52.jpg',
  //     "district": "",
  //     "category": "",
  //     "imageUrl": [],
  //     "description": "",
  //     "rating": ""
  //   },
  //   {
  //     "name": 'Jampui Hills',
  //     "location": '',
  //     "images": 'http://10.10.10.114/uploads/2b908425-fb73-46c0-be3f-22f8bdafc5e4.jpg',
  //     "district": "",
  //     "category": "",
  //     "imageUrl": [],
  //     "description": "",
  //     "rating": ""
  //   },
  // ];
  List? listOfAllSpots = [];
  @override
  void initState() {
    super.initState();
    log('${widget.spot}');
    listOfAllSpots = widget.spot['images'];
    log("$listOfAllSpots");
    // getAllTouristSpot();
  }
  //add more pictures here
  void _showSpotDetails(Map spot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (spot['images'] != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      child: Image.asset(
                        spot['images'][0],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.spot['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.spot['location'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          spot['description'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: spot['images']?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.network(
                                  listOfAllSpots! [index]['images'][0]['link'] ?? '',
                                height : 300,
                                fit : BoxFit.cover,
                                ),
                              //   spot['imageUrl'][index],
                                //   width: 120,
                                //   fit: BoxFit.cover,
                                // ),
                                // child: Image.network(
                                //   listOfSpots![index]['images'][0]['link'] ?? '',
                                //   height: 168,
                                //   width: double.infinity,
                                //   fit: BoxFit.cover,
                                // ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showBookingDialog(widget.spot);
                        },
                        child: const Text(
                          'Book Now',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBookingDialog(Map spot) {
    final _formKey = GlobalKey<FormState>();
    DateTime selectedDate = DateTime.now();
    int numAdults = 1;
    int numChildren = 0;
    int adultPrice = 200; // Example price per adult
    int childPrice = 100; // Example price per child

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            int totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);

            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Book Ticket for ${spot['name']}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null && pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        controller: TextEditingController(
                          text: "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Adults: $numAdults'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (numAdults > 1) {
                                    setState(() {
                                      numAdults--;
                                      totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    numAdults++;
                                    totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Children: $numChildren'),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  if (numChildren > 0) {
                                    setState(() {
                                      numChildren--;
                                      totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    numChildren++;
                                    totalPrice = (numAdults * adultPrice) + (numChildren * childPrice);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text('Total Price: $totalPrice INR'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle the booking logic here
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('Confirm Booking'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist Spots'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(widget.spot['name']),
            Text(widget.spot['location']),
            Image.network(widget.spot['images'][3]['link']),    /////////////////////////////////
            // Expanded(child: ListView.builder(
            //   itemCount: listOfAllSpots!.length,
            //   itemBuilder: (context, index) {
            //     final spot = listOfAllSpots![index];
            //     return Card(
            //       child: ListTile(
            //         leading: Image.asset(widget.spot['images'][index]['link']),
            //         onTap: () => _showSpotDetails(widget.spot),
            //       ),
            //     );
            //   },
            // ),)
          ],
        ),
      )
    );
  }
}
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Tourist Spot Booking',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: myHome(), // Replace with your initial home page widget
//     );
//   }
// }

// getAllTouristSpot() async {
//   String url = "http://10.10.10.114/web/spots";
//   Dio dio = Dio();
//
//   listOfAllSpots = [];
//   try {
//     var response = await dio.get(url);
//     Map map = response.data;
//     log('[i] TOURIST SPOT list $map');
//     if (map['status']) {
//       for (var spots in map['result']){
//         log('[i]$spots');
//         listOfSpots!.add(spots);
//       }
//       setState(() {});
//     }else{
//       log('[e] Tourist Spot not found');
//     }
//   } catch (e) {
//     print(e);
//   }
// }



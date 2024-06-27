import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Profile.dart';
import 'home_page.dart';
import 'access_tokens.dart';
import 'reviews.dart';

class MyDetail extends StatefulWidget {
  final Map spot;

  MyDetail({Key? key, required this.spot}) : super(key: key);

  @override
  State<MyDetail> createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {
  List? listOfAllSpots = [];
  DateTime selectedDate = DateTime.now();
  int numAdults = 1;
  int numChildren = 0;
  int adultPrice = 200;
  int childPrice = 100;
  Map<String, double>? entryFee = {};
  Map<String, String>? visitingHours = {};
  double? spotRating; // Rating for the spot, null if not rated yet
  TextEditingController _feedbackController = TextEditingController();
  String? spotId; // Variable to hold the spotId

  int getTotalPrice() {
    return (numAdults * adultPrice) + (numChildren * childPrice);
  }

  @override
  void initState() {
    super.initState();
    log('${widget.spot}');
    listOfAllSpots = widget.spot['images'];
    entryFee = Map<String, double>.from(widget.spot['entry_fee']);
    visitingHours = Map<String, String>.from(widget.spot['visiting_hours']);
    log("$listOfAllSpots");

    // Save _id to spotId in local storage (shared_preferences)
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        spotId = widget.spot['_id'];
        prefs.setString('spotId', spotId!); // Save spotId to local storage
      });
    });

    // Load initial rating if available (example)
    // For simplicity, let's assume spot data contains a rating.
    spotRating = widget.spot['rating']?.toDouble();
  }

  void showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Book Your Ticket',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Adults: $numAdults'),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (numAdults > 1) {
                                  setState(() {
                                    numAdults--;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  numAdults++;
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
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (numChildren > 0) {
                                  setState(() {
                                    numChildren--;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  numChildren++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Total Price: ${getTotalPrice()} INR'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booking confirmed!')),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Confirm Booking'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showImageInFullScreen(String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double? newRating = spotRating ?? 0.0;
        return AlertDialog(
          title: const Text('Rate this spot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Current Rating: ${spotRating ?? "Not rated yet"}'),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: newRating,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  newRating = rating;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Feedback',
                  hintText: 'Enter your feedback here...',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Call API to submit rating and feedback
                ratingService(newRating.toString(), _feedbackController.text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void ratingService(String rating, String feedback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? spotId = prefs.getString('spotId');

    String url = "http://10.10.10.132/web/review";
    var body = {
      'spotId': spotId,
      'rating': rating,
      'feedback': feedback,
    };

    Dio dio = Dio();
    try {
      var response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Authorization": "Bearer ${AccessTokens.authToken}",
            "Content-Type": "application/json",
          },
        ),
      );
      log("[i] svdjjsdv ${AccessTokens.authToken}");
      log("[i] raw Rating response  ${response.data}");
      if (response.data['status']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rating service failed: ${response.data['message']}')),
        );
      }
    } catch (e) {
      log("[e] $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Tourist Spots', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _showRatingDialog,
            icon: const Icon(Icons.star,color: Colors.green,),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.spot['name'] ?? '',
              style: const TextStyle(
                fontSize: 40,
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
                Expanded(
                  child: Text(
                    widget.spot['location'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.category,
                  color: Colors.blueAccent,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.spot['category'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_city,
                  color: Colors.orangeAccent,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.spot['district'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.spot['description'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            if (listOfAllSpots != null && listOfAllSpots!.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listOfAllSpots!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _showImageInFullScreen(listOfAllSpots![index]['link'] ?? '');
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            listOfAllSpots![index]['link'] ?? '',
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (entryFee != null && entryFee!.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entry Fee',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Adult: ${entryFee!['adult']} INR',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Child: ${entryFee!['child']} INR',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (visitingHours != null && visitingHours!.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Visiting Hours:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: visitingHours!.entries.map((entry) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.lightGreen[50],
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(color: Colors.lightGreen, width: 1.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key.capitalize(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lightGreen,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => myHome()));
              },
              icon: const Icon(Icons.home, size: 30, color: Colors.lightGreen),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Reviews()));
              },
              icon: const Icon(Icons.reviews, size: 30, color: Colors.lightGreen),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showBookingSheet(context);
        },
        label: const Text('Book Ticket'),
        icon: const Icon(Icons.book),
        backgroundColor: Colors.lightGreen,
        elevation: 2.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
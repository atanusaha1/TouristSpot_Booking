import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:dio/dio.dart';
import 'Profile.dart';
import 'home_page.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';

class Reviews extends StatefulWidget {
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final List<Review> reviews = [];
  final _formKey = GlobalKey<FormState>();
  final _spotController = TextEditingController();
  final _reviewController = TextEditingController();
  final _spotIdController = TextEditingController();
  double _rating = 0.0;

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      ratingService(_spotController.text, _rating.toString(), _reviewController.text, _spotIdController.toString());
    }
  }

  void ratingService(String spot, String rating,String spotId, String feedback) async {
    String url = "http://10.10.10.132/web/review";
    var body = {
      'spotId' : spotId,
      'spot': spot,
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
            "Content-Type": "application/json",
          },
        ),
      );
      log("[i] raw Rating response  ${response.data}");
      if (response.data['status']) {
        setState(() {
          reviews.add(
            Review(
              spot: _spotController.text,
              feedback: _reviewController.text,
              rating: _rating,
              date: DateTime.now(),
            ),
          );
        });
        _spotController.clear();
        _reviewController.clear();
        _rating = 0.0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Review submitted!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Reviews()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Rating service failed: ${response.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      log("[e] $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void getReviews() async {
    String url = "http://10.10.10.132/web/review?spotId=66746025dfa4f309c1a12a38";
    Dio dio = Dio();
    try {
      var response = await dio.get(url);
      Map map = response.data;
      if (map['status']) {
        List<dynamic> results = map['result'];
        setState(() {
          reviews.addAll(results.map((review) => Review(
            spot: review['spot'],
            feedback: review['feedback'],
            rating: double.parse(review['rating']),
            date: DateTime.parse(review['date']),
          )).toList());
        });
      } else {
        log('[e] Reviews not found');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Reviews', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submit Your Review',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _spotController,
                    decoration: InputDecoration(labelText: 'Spot'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the spot name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _reviewController,
                    decoration: InputDecoration(labelText: 'Feedback'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Rating:'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RatingBar.builder(
                          initialRating: _rating,
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
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Reviews',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              review.spot,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: review.rating,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          direction: Axis.horizontal,
                        ),
                        const SizedBox(height: 8),
                        Text(review.feedback),
                        const SizedBox(height: 8),
                        Text(
                          '${review.date.toLocal()}'.split(' ')[0],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => myHome()));
                },
                icon: const Icon(Icons.home, size: 30, color: Colors.lightGreen)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Reviews()));
                },
                icon: const Icon(Icons.reviews, size: 30, color: Colors.lightGreen)),
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
}

class Review {
  final String spot;
  final String feedback;
  final double rating;
  final DateTime date;

  Review({
    required this.spot,
    required this.feedback,
    required this.rating,
    required this.date,
  });
}

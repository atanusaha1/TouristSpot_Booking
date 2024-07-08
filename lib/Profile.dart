import 'dart:convert';
import 'dart:developer';
import 'package:TouristSpot_Booking_System/welcomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'access_tokens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainPage(),
    );
  }
}

class BookingDetails {
  final String name;
  final String spotName;
  final String ticketId;
  final double total;
  final DateTime date;
  final String status;

  BookingDetails({
    required this.name,
    required this.spotName,
    required this.ticketId,
    required this.total,
    required this.date,
    required this.status,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      name: json['name'] ?? '',
      spotName: json['spot_name'] ?? '',
      ticketId: json['ticketId'] ?? '',
      total:
          json['total'] != null ? double.parse(json['total'].toString()) : 0.0,
      date: DateTime.tryParse(json['date']) ?? DateTime.now(),
      status: json['status'] ?? '',
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Profile(),
    FAQScreen(),
    HelpScreen(),
    ContactUsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Main Page', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer_outlined),
            label: 'FAQ & Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Terms and Conditions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail_outlined),
            label: 'Contact Us',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightGreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/T2.jpg'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Welcome Tourists',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem('Update Personal Information', Icons.person_outline,
              () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const DialogBox();
              },
            );
          }),
          _buildDrawerItem('FAQ & Help', Icons.question_answer_outlined, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQScreen()),
            );
          }),
          _buildDrawerItem('Terms and Conditions', Icons.help_outline, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HelpScreen()),
            );
          }),
          _buildDrawerItem('Contact Us', Icons.contact_mail_outlined, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem('Booking Status', Icons.book_online_outlined, () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BookingStatusScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem('Log Out', Icons.logout, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }, textColor: Colors.red),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title, IconData icon, VoidCallback onTap,
      {Color textColor = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            const Text('Profile', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/T2.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome Tourists',
                style: TextStyle(color: Colors.green, fontSize: 24),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Tourist Details',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('Account Settings'),
            _buildListTile(
              title: 'Update Personal Information',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const DialogBox();
                  },
                );
              },
            ),
            _buildDivider(),
            _buildSectionTitle('Help & Support'),
            _buildListTile(
              title: 'FAQ & Help',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQScreen()),
                );
              },
            ),
            _buildListTile(
              title: 'Terms and Conditions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
            ),
            _buildListTile(
              title: 'Contact Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsScreen()),
                );
              },
            ),
            _buildDivider(),
            _buildListTile(
              title: 'Booking Status',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BookingStatusScreen()),
                );
              },
            ),
            _buildDivider(),
            _buildListTile(
              title: 'Log Out',
              textColor: Colors.red,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    Color textColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward, size: 20, color: textColor),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}

class DialogBox extends StatefulWidget {
  const DialogBox({Key? key}) : super(key: key);

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Update Personal Information',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTextField(
              controller: nameController,
              labelText: 'Name',
            ),
            _buildTextField(
              controller: emailController,
              labelText: 'Email address',
            ),
            _buildTextField(
              controller: mobileController,
              labelText: 'Mobile',
            ),
            _buildTextField(
              controller: addressController,
              labelText: 'Address',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                String name = nameController.text;
                String email = emailController.text;
                String mobile = mobileController.text;
                String address = addressController.text;
                Navigator.of(context).pop();
                // Navigate back to Profile screen
                // Handle updating logic here
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('FAQ & Help',
            style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: const Text(
          'FAQs and Help Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: EdgeInsets.all(50),
        child: ListView(
          children: [
            Text(
              '1.  Introduction',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Welcome to xlayer_Tourist Spot Booking By using our application, you agree to comply with and be bound by the following terms and conditions. Please review them carefully.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '2.  Booking and Payment',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'BOOKING PROCESS: To book a tourist spot, you must provide accurate and complete information as requested.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'PAYMENT: All payments must be made through the payment methods provided in the application. Payments are non-refundable except as outlined in our cancellation policy.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '3.  Cancellation and Refunds',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'CANCELLATION POLICY: Cancellations must be made 24 hours before the booking date to be eligible for a refund.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'REFUNDS: Refunds will be processed within 7-10 business days after the cancellation request is approved.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '4.  User Conduct',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'COMPLIANCE: Users must comply with all applicable laws and regulations when using the application.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'PROHIBITED ACTIONS: Users must not engage in any behavior that could harm or disrupt the application, other users, or the tourist spots.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '5.  Privacy',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'DATA COLLECTION: We collect and use personal information as described in our Privacy Policy.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'DATA SRCURITY: We implement reasonable measures to protect your data but cannot guarantee absolute security.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '6.  Liability',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'NO WARRANTIES: The application is provided "as is" without any warranties of any kind.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'LIMITATION OF LIABILITY: We are not liable for any damages arising from your use of the application or any bookings made through it.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '7.  Changes to Terms',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'MODIFICATIONS: We may update these terms and conditions from time to time. Changes will be effective immediately upon posting.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '8.  Governing Law',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'JURISDICTION: These terms and conditions are governed by the laws of India/Agartala Any disputes will be resolved in the courts of India/Agartala.',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 15),
            Text(
              '9.  Contact Us',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'SUPPORT: If you have any questions or concerns about these terms and conditions, please contact us at \njagritipal19@gmail.com / 8787338323 .',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Contact Us',
            style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: const Text(
          'Contact Us Content',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class BookingStatusScreen extends StatefulWidget {
  const BookingStatusScreen({Key? key}) : super(key: key);

  @override
  _BookingStatusScreenState createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  late Future<List<BookingDetails>> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings =
        fetchBookings('bookingId', 'userId'); // Replace with actual ids
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Booking Status',
            style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<BookingDetails>>(
        future: _futureBookings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<BookingDetails> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(context, bookings[index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingDetails booking) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket header with subtle background color
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Ticket Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ),
            SizedBox(height: 12),
            // Row to display the name and spot name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name: ${booking.name}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Spot Name: ${booking.spotName}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Divider line
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            // Row to display the ticket ID and total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ticket ID: ${booking.ticketId}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Total: ${booking.total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, color: Colors.green[700]),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Divider line
            Divider(color: Colors.grey[300]),
            SizedBox(height: 8),
            // Display the date and status with icons
            Row(
              children: [
                Icon(Icons.date_range, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Text(
                  'Date: ${DateFormat('MM/dd/yyyy').format(booking.date)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.info, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Text(
                  'Status: ${booking.status}',
                  style: TextStyle(fontSize: 16, color: Colors.orange[500]),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Download and Cancel buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(Icons.download, color: Colors.black),
                  label: Text('Download'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Downloading ticket for ${booking.name}'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                SizedBox(width: 160),
                TextButton.icon(
                  icon: Icon(Icons.cancel, color: Colors.red[500]),
                  label: Text('Cancel'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cancelling ticket for ${booking.name}'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingBookingScreen extends StatelessWidget {
  final List<BookingDetails> bookings;

  const UpcomingBookingScreen({Key? key, required this.bookings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Upcoming Bookings',
            style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${booking.name}'),
                  Text('Spot Name: ${booking.spotName}'),
                  Text('Ticket ID: ${booking.ticketId}'),
                  Text('Total: ${booking.total.toStringAsFixed(2)}'),
                  Text(
                      'Date: ${DateFormat('MM/dd/yyyy').format(booking.date)}'),
                  Text('Status: ${booking.status}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Function to fetch bookings from API
Future<List<BookingDetails>> fetchBookings(
    String bookingId, String userId) async {
  String url =
      'http://10.10.10.136/web/upcoming?bookingId=$bookingId&userId=$userId';

  try {
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${AccessTokens.authToken}",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['result'];
      List<BookingDetails> bookings =
          jsonData.map((item) => BookingDetails.fromJson(item)).toList();
      return bookings;
    } else {
      throw Exception('Failed to load bookings');
    }
  } catch (e) {
    log('Error fetching bookings: $e');
    throw Exception('Failed to load bookings');
  }
}

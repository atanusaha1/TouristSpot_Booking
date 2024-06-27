import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tourist App',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MainPage(),
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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Main Page', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Add more BottomNavigationBarItems for other pages
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
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
                Text(
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
          ListTile(
            title: const Text('Update Personal Information'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogBox();
                },
              );
            },
          ),
          ListTile(
            title: const Text('FAQ & Help'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => FAQScreen());
            },
          ),
          ListTile(
            title: const Text('Help'),
            onTap: () {
              Navigator.pop(context);
              // Implement Help screen navigation
            },
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              // Implement Contact Us screen navigation
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Booking Status'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingStatusScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyLogin()),
              );
            },
          ),
        ],
      ),
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
        title: const Text('Profile', style: TextStyle(color: Colors.lightGreen)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black54,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage('assets/T2.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Welcome Tourists',
                style: TextStyle(color: Colors.lightGreen, fontSize: 24),
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
                    return DialogBox();
                  },
                );
              },
            ),
            _buildDivider(),
            _buildSectionTitle('Help & Support'),
            _buildListTile(
              title: 'FAQ & Help',
              onTap: () {
                Get.to(() => FAQScreen());
              },
            ),
            _buildListTile(
              title: 'Help',
              onTap: () {
                // Implement Help screen navigation
              },
            ),
            _buildListTile(
              title: 'Contact Us',
              onTap: () {
                // Implement Contact Us screen navigation
              },
            ),
            _buildDivider(),
            _buildListTile(
              title: 'Booking Status',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingStatusScreen()),
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
                  MaterialPageRoute(builder: (context) => MyLogin()),
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
        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
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
              onPressed: (){
                String name = nameController.text;
                String email = emailController.text;
                String mobile = mobileController.text;
                String address = addressController.text;
                Get.back();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
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
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
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
        title: const Text('FAQ & Help'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            const Text(
              'FAQ & Help',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text(
                '',//////////////////////ques
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              children: [
                ListTile(
                  title: const Text(
                    '', //////////////////ans
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                '',/////////////////////ques
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              children: [
                ListTile(
                  title: const Text(
                    '',/////////////////////ans
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
            // Add more FAQ questions and answers here
          ],
        ),
      ),
    );
  }
}

class BookingStatusScreen extends StatelessWidget {
  const BookingStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Status'),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, size: 100, color: Colors.lightGreen),
            SizedBox(height: 20),
            Text(
              'Your Booking Status',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Confirmed',
              style: TextStyle(fontSize: 18, color: Colors.lightGreen),
            ),
          ],
        ),
      ),
    );
  }
}

class MyLogin extends StatelessWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement login functionality
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
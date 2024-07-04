import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'Profile.dart';
import 'globals.dart' as globals;

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final StreamController<List<Map<String, String>>> _streamController =
      StreamController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchItems);
    _searchItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _streamController.close();
    super.dispose();
  }

  Future<void> _searchItems() async {
    final searchText = _searchController.text;
    if (searchText.isEmpty) {
      _streamController.add([]);
    } else {
      final url = "http://10.10.10.136/web/search?search=$searchText";
      Dio dio = Dio();
      try {
        var response = await dio.get(url);
        log("[i] search ${response.data}");
        print(globals.globalName);
        Map map = response.data;
        if (map['status']) {
          final Map results = map['result'][0];
          globals.globalName = results['name'].toString();
          log(globals.globalName);
          setState(() {});
          // final List<Map<String, String>> items = results.map((item) {
          //   return {
          //     'name': item['name'].toString(),
          //     'location': item['location'].toString(),
          //   };
          // }).toList();
          // _streamController.add(items);
        } else {
          _streamController.add([]);
        }
      } catch (e) {
        print(e);
        _streamController.add([]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white70,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset('assets/T2.jpg', width: 30, height: 30),
                ),
              ),
              const Spacer(),
              _isSearching ? _buildSearchField() : _buildLocationInfo(),
              const Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.search, size: 28),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Map<String, String>>>(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No results found.'));
              } else {
                final items = snapshot.data!;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item['name']!),
                      subtitle: Text(item['location']!),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 23, bottom: 10, right: 10, top: 12),
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _searchItems();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, color: Color(0xFFF65959)),
        SizedBox(width: 8),
        Text(
          "Agartala Tripura, INDIA",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

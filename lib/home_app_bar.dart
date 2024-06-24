import 'package:flutter/material.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Sample list of items with name and location
  final List<Map<String, String>> _items = [
    {"name": "Unakoti", "location": "Kailasahar District"},
    {"name": "Tripura State Museum", "location": "Agartala,West Tripura"},
    {"name": "Tripura Sundari Temple", "location": "Udaipur,Gomati District"},
    {"name": "Pilak - in Jolaibari, South Tripura", "location": "shantirbazar,South Tripura"},
    {"name": "Neermahal", "location": "melaghar"},
    {"name": "Sepahijala", "location": "bishalgar"},
    {"name": "Dumboor Lake", "location": "Gandachera sub division"},
    {"name": "Trishna Wild Life Sanctuary", "location": "Belonia,south tripura district"},
    {"name": "Jampui Hills", "location": "north tripura District"},
    {"name": "Silcherra budhha waterfall", "location": "Pecharthal Waterfall"},
    {"name": "Tuisoi Waterfal", "location": "Saikar Bazar"},
  ];

  List<Map<String, String>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_items); // Initialize filtered items with all items
  }

  void _searchItems() {
    setState(() {
      if (_searchText.isEmpty) {
        _filteredItems = List.from(_items);
      } else {
        _filteredItems = _items.where((item) {
          final nameLower = item['name']!.toLowerCase();
          final locationLower = item['location']!.toLowerCase();
          final searchLower = _searchText.toLowerCase();

          return nameLower.contains(searchLower) || locationLower.contains(searchLower);
        }).toList();
      }
    });
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                    )
                  ],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Image.asset(
                  'assets/T2.jpg', // Replace with your logo path
                  width: 30,
                  height: 30,
                ),
              ),
              const Spacer(), // Spacer to push location info to the center
              _isSearching ? _buildSearchField() : _buildLocationInfo(),
              const Spacer(), // Spacer to maintain equal spacing
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
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.search, size: 28),
                ),
              )
            ],
          ),
        ),
        // Display the filtered list of items
        Expanded(
          child: ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return ListTile(
                title: Text(item['name']!),
                subtitle: Text(item['location']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Adjust the width as needed
      // padding: const EdgeInsets.only(left: 12,),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchText = value;
          });
          _searchItems(); // Call search function here
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 35,
          bottom: 10,right: 10,top: 12),
          hintText: 'Search...',
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchText = '';
              });
              _searchItems(); // Call clear function or search function with empty text here
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return const Row(
      mainAxisSize: MainAxisSize.min, // To make sure the Row takes minimum space
      children: [
        Icon(Icons.location_on, color: Color(0xFFF65959)),
        SizedBox(width: 8),
        Text(
          "Agartala Tripura, INDIA",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

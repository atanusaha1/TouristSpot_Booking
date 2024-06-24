// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyTokens extends StatefulWidget {
//   const MyTokens({super.key});
//
//   @override
//   State<MyTokens> createState() => _MyTokensState();
// }
//
// class _MyTokensState extends State<MyTokens> {
//   String? token;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadToken();
//   }
//
//   Future<void> _loadToken() async {
//     token = await getToken();
//     setState(() {});
//   }
//
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }
//
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Tokens'),
//       ),
//       body: Center(
//         child: token == null
//             ? const CircularProgressIndicator()
//             : Text('Saved Token: $token'),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(const MaterialApp(
//     home: MyTokens(),
//   ));
// }

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_flutter_project/access_tokens.dart';
import 'package:new_flutter_project/register.dart';
import 'package:dio/dio.dart';
import 'home_page.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  bool _passwordVisible = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/12345.jpeg'), fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 270, top: 30),
                  child: const Text('Welcome Tourists',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 320, top: 52),
                  child: const Text('PLEASE LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.4,
                      right: 35,
                      left: 35,
                    ),
                    child: Column(
                      children: [
                        const Text('LOGIN',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        TextField(
                          controller: emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              fillColor: Colors.black,
                              filled: true,
                              hintText: 'library_id',
                              label: const Text(
                                'library_id',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextField(
                          obscureText: _passwordVisible,
                          controller: passController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              fillColor: Colors.black,
                              filled: true,
                              hintText: 'Password',
                              label: const Text(
                                'Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              hintStyle: const TextStyle(color: Colors.white),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon(!_passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const myHome()));
                                return;
                                logIn(emailController.text.trim(),
                                    passController.text.trim());

                              },
                              child: const Text('Sign in',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const myRegister()));
                              },
                              child: const Text('sign up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text('Forget Password',
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  logIn(String library_id, String password) async {
    String url = "http://10.10.10.100/web/authentication/signin";
    var body = {
      'library_id': library_id,
      'password': password,
    };
    Dio dio = Dio();
    // try {
      var response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
    log("[i] raw login response  ${response.data}") ;
      Map map = jsonDecode(response.data);
    log("[i] login response  ${map}") ;
    log("[i] login response  ${response.statusCode}") ;
    try {
      if (map['status']) {
        Fluttertoast.showToast(
          msg: "Sign in successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        // AccessTokens.authToken = '';
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const myHome()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "login failed. Please try again.",
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
}

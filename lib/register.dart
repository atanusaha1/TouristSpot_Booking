import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Login.dart';
import 'package:dio/dio.dart';

class myRegister extends StatefulWidget {
  const myRegister({super.key});

  @override
  State<myRegister> createState() => _myRegisterState();
}

class _myRegisterState extends State<myRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool _passwordVisible = true;

  void registerUser(String name, String email, String mobile, String address,
      String password) async {
    String url = "http://10.10.10.100/web/authentication/signup";
    var body = {
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
      'password': password,
    };

    Dio dio = Dio();
    // try {
        var response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      Map map = response.data;
      print(map);
      try {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Registration successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyLogin()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Registration failed. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/2024.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 270, top: 5),
                child: const Text('Welcome Tourists',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              Container(
                padding: const EdgeInsets.only(left: 300, top: 27),
                child: const Text('PLEASE REGISTER',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
              Container(
                padding: EdgeInsets.only(left: 35, top: 170),
                child: Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Mobile",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Mobile',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: addressController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Address",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: passController,
                        style: TextStyle(color: Colors.white),
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
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
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: confirmPassController,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          hintText: "Confirm Password",
                          hintStyle: TextStyle(color: Colors.white),
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyLogin(),
                                ),
                              );
                            },
                            child: const Text('sign in',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 20,
                                    decoration: TextDecoration.underline)),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: () {
                              // Validate input fields
                              if (_validateFields()) {
                                registerUser(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  mobileController.text.trim(),
                                  addressController.text.trim(),
                                  passController.text.trim(),
                                );
                              }
                            },
                            child: const Text('Save',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateFields() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        addressController.text.isEmpty ||
        passController.text.isEmpty ||
        confirmPassController.text.isEmpty)
    {
      Fluttertoast.showToast(
        msg: "Please fill all fields.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    } else if (passController.text != confirmPassController.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
    return true;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:new_flutter_project/register.dart';
import 'home_page.dart';
import 'Login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
        child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const SizedBox(height: 20,),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black54,
                      child: CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage('assets/T2.jpg')),
                    ),
                  ),
                  const Spacer(),
                  Center(child: Text('Welcome Tourists',style: TextStyle(color: Colors.black,fontSize: 20),)),
                  Center(child: Text('Tourist Details',style: TextStyle(color: Colors.black,))),

                  const SizedBox(height: 100,),
                  Text('Account Settings',style: TextStyle(color: Colors.black,fontSize: 20)),
                  ListTile(
                   onTap: (){
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return DialogBox();
                      //   }
                      //
                      Get.to(()); },
                    title: const Text('Personal Information',style: TextStyle(color: Colors.black,fontSize: 16),),
                    trailing: const Icon(Icons.arrow_forward,
                        size: 20,
                        color: Colors.black),
                  ),
                  const Text('Help & Support',style: TextStyle(color: Colors.black,fontSize: 20)),
                  ListTile(
                    onTap: (){},
                    title: const Text('FAQ & Help',style: TextStyle(color: Colors.black,fontSize: 16),),
                    trailing: const Icon(Icons.arrow_forward,
                        size: 20,
                        color: Colors.black),
                  ),
                  ListTile(
                    onTap: (){
                      // Get.to(()=> myRegister());
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyLogin()));
                     },
                    title: const Text('Log Out',style: TextStyle(color: Colors.red,fontSize: 18),),
                    // trailing: Text('>',style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                ],
              )),
        ));

  }
}
// Widget DialogBox(){
//   return AlertDialog(
//     title: const Text('Sign in',textAlign: TextAlign.center,),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         const Text('Please sign in to continue'),
//         const SizedBox(height: 16),
//         TextField(
//           decoration: const InputDecoration(
//             hintText: 'Email address',
//           ),
//         ),
//         const SizedBox(height: 16),
//         TextField(
//           obscureText: true,
//           decoration: const InputDecoration(
//             hintText: 'Password',
//           ),
//         ),
//         const SizedBox(height: 24),
//         ElevatedButton(
//           onPressed: () {
//             Get.to(()=>(HomePage()));
//           },
//           child: const Text('Sign in'),
//         ),
//         const SizedBox(height: 16),
//         const Text('or'),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () {
//             // Handle Google sign in
//           },
//           child: const Text('Google'),
//         ),
//
//       ],
//     ),
//     actions: <Widget>[
//
//     ],
//   );
Widget DialogBox(BuildContext context){
  return AlertDialog(
    title: const Text('Personal Information',textAlign: TextAlign.center,),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        const Text('Name :',textAlign: TextAlign.start,style: TextStyle(fontSize: 16,),),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Email address',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Password',
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Profile()));
          },
          child: const Text('Sign in'),
        ),
        const SizedBox(height: 16),
        const Text('or'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle Google sign in
          },
          child: const Text('Google'),
        ),

      ],
    ),
    actions: <Widget>[

    ],
  );
}
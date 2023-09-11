// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// // import 'HomePage.dart';
//
// class Login extends StatefulWidget {
//   const Login({super.key});
//
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//   final _auth = FirebaseAuth.instance;
//   late String email;
//   late String password;
//   bool showSpinner = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return ModalProgressHUD(
//       inAsyncCall: showSpinner,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         // appBar: AppBar(
//         //   title: Text("Login Page"),
//         // ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.only(top: 60.0),
//                 child: Center(
//                   child: Container(
//                       width: 200,
//                       height: 150,
//                       /*decoration: BoxDecoration(
//                           color: Colors.red,
//                           borderRadius: BorderRadius.circular(50.0)),*/
//                       child: Image.asset("assets/images/mainLogo.PNG")),
//                 ),
//               ),
//               const Padding(
//                 //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: TextField(
//                   decoration: InputDecoration(
//                       fillColor: Colors.black12,
//                       filled: true,
//                       border: OutlineInputBorder(),
//                       labelText: 'Email',
//                       labelStyle: TextStyle(color: Colors.black),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                           borderSide: BorderSide(color: Colors.black))
//                       // hintText: 'Enter valid email id as abc@gmail.com',
//                       ),
//                   onChanged: (value) {
//                     email = value;
//                   },
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(
//                     left: 15.0, right: 15.0, top: 15, bottom: 0),
//                 //padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                       fillColor: Colors.black12,
//                       filled: true,
//                       border: OutlineInputBorder(),
//                       labelText: 'Password',
//                       labelStyle: TextStyle(color: Colors.black),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                           borderSide: BorderSide(color: Colors.black))
//                       // hintText: 'Enter secure password',
//                       ),
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, 'forgotpassword');
//                 },
//                 child: const Text(
//                   'Forgot Password?',
//                   style: TextStyle(color: Colors.red, fontSize: 15),
//                 ),
//               ),
//               Container(
//                 height: 50,
//                 width: 250,
//                 decoration: BoxDecoration(
//                     color: Colors.blueGrey[900],
//                     borderRadius: BorderRadius.circular(20)),
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.pushNamed(context, 'login');
//                   },
//                   child: const Text(
//                     'Login',
//                     style: TextStyle(color: Colors.white, fontSize: 25),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 130),
//               // const Text('New User? Create Account')
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'New User?',
//                     style: TextStyle(fontSize: 15),
//                   ),
//                   TextButton(
//                       onPressed: () {},
//                       child: const Text(
//                         'Create Account',
//                         style: TextStyle(
//                           fontSize: 15,
//                           color: Colors.blueGrey,
//                         ),
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mainBackground.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                child: const Text(
                  'LETS SHARE THE RIDE WITH\nBudget-Ride!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.51,
                      right: 40,
                      left: 40),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontFamily: 'Orbitron',
                          ),
                          fillColor: Colors.grey,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontFamily: 'Orbitron',
                          ),
                          fillColor: Colors.grey,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 29,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 26,
                            child: IconButton(
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  email = "";
                                  password = "";
                                  if (user != null) {
                                    Navigator.pushNamed(context, 'modeselect');
                                  }
                                } catch (e) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 2), () {
                                        Navigator.of(context).pop(true);
                                      });
                                      return const AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                          'Invalid Login Credentials!',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  );
                                  print(e);
                                }
                                setState(() {
                                  showSpinner = false;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.black,
                                size: 27,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'signup');
                            },
                            style: TextButton.styleFrom(
                              side: const BorderSide(
                                width: 1.5,
                                style: BorderStyle.solid,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text(
                              'SignUp',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'forgotpassword');
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ),
                        ],
                      )
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
}

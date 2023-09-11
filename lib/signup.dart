import 'package:flutter/material.dart';
import 'input_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController cellnoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String? selectedGender = null;
  List<String> genderList = ['Male', 'Female'];

  Future registerUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((signedInUser) => FirebaseFirestore.instance
                  .collection("Users")
                  .doc(signedInUser.user?.uid)
                  .set({
                'userId': signedInUser.user?.uid,
                'name': nameController.text,
                'email': emailController.text,
                'cnic': cnicController.text,
                'callno': cellnoController.text,
                'gender': selectedGender,
              }).then((signedInUser) => {
                        print("Success"),
                      }));
    } catch (e) {
      print(e);
    }
  }

  late String name;
  late String email;
  late String cnic;
  late String cellNo;
  late String password;
  late String gender;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mainBackground.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              child: const Text(
                'WELCOME!\nTime to Go',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Orbitron',
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InputTextField(
                                controller: nameController,
                                hintText: "Full Name",
                                obscureText: false,
                                textFieldWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                              const SizedBox(width: 10),
                              InputTextField(
                                controller: emailController,
                                hintText: "Email",
                                obscureText: false,
                                textFieldWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              InputTextField(
                                controller: cnicController,
                                hintText: "CNIC",
                                obscureText: false,
                                textFieldWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                              const SizedBox(width: 10),
                              InputTextField(
                                controller: cellnoController,
                                hintText: "Cell No.",
                                obscureText: false,
                                textFieldWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              InputTextField(
                                controller: passwordController,
                                hintText: "Password",
                                obscureText: true,
                                textFieldWidth:
                                    MediaQuery.of(context).size.width * 0.4,
                              ),
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(left: 10),
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.grey,
                                  value: selectedGender,
                                  hint: selectedGender == null
                                      ? const Text('Select Gender')
                                      : null,
                                  style: const TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value!;
                                    });
                                  },
                                  items: genderList.map((gender) {
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Text(gender),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                  fontSize: 29,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Orbitron',
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 28,
                                child: IconButton(
                                  onPressed: () {
                                    registerUser();
                                    Navigator.pushNamed(context, 'modeselect');
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'login');
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
                                  'SignIn',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Orbitron',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

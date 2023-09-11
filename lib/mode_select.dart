import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ModeSelect extends StatefulWidget {
  const ModeSelect({Key? key}) : super(key: key);

  @override
  State<ModeSelect> createState() => _ModeSelectState();
}

class _ModeSelectState extends State<ModeSelect> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String currentUserId = "";
  String currentUserName = "";

  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
    final currentUserData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .get();
    setState(() {
      currentUserName = currentUserData.data()!['name'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/getStarted.jpg"),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text('Hello $currentUserName!',
                          style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[700]),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, 'login');
                      },
                      child: const Text('Logout',
                          style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                Image(
                  image: const AssetImage("assets/images/logo.PNG"),
                  width: MediaQuery.of(context).size.width * 0.48,
                  height: MediaQuery.of(context).size.height * 0.33,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'postride');
                    },
                    child: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'POST RIDE',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'postride');
                            },
                            icon: const Icon(Icons.post_add),
                            color: Colors.black54,
                            iconSize: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'bookride');
                    },
                    child: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'BOOK RIDE',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'bookride');
                            },
                            icon: const Icon(Icons.book),
                            color: Colors.black54,
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.5,
                  indent: 40,
                  endIndent: 40,
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'myposts');
                    },
                    child: Container(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'My Posts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'myposts');
                            },
                            icon: const Icon(Icons.list_alt_outlined),
                            color: Colors.black54,
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'mybookedrides');
                    },
                    child: Container(
                      color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'My Booked Rides',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'mybookedrides');
                            },
                            icon: const Icon(Icons.car_rental_outlined),
                            color: Colors.black54,
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                const Divider(
                  color: Colors.grey,
                  thickness: 1.5,
                  indent: 40,
                  endIndent: 40,
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'addfriend');
                    },
                    child: Container(
                      color: Colors.blueGrey[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'Add Friend',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'addfriend');
                            },
                            icon: const Icon(Icons.add_box),
                            color: Colors.black54,
                            iconSize: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'friendlist');
                    },
                    child: Container(
                      color: Colors.blueGrey[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          const Text(
                            'Friend-List',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Orbitron',
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'friendlist');
                            },
                            icon: const Icon(Icons.featured_play_list_sharp),
                            color: Colors.black54,
                            iconSize: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 7),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

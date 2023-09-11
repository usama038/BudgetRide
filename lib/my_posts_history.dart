import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPostsHistory extends StatefulWidget {
  const MyPostsHistory({Key? key}) : super(key: key);

  @override
  State<MyPostsHistory> createState() => _MyPostsHistoryState();
}

class _MyPostsHistoryState extends State<MyPostsHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  late String currentUserId;
  Future<void> getCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts History'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection('Users')
                  .doc(currentUserId)
                  .collection('Posts')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final posts = snapshot.data!.docs;
                if (posts.isEmpty) {
                  return const Center(
                      child: Text('You haven\'t made any posts yet.'));
                }
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // final post = posts[index].data();
                      DocumentSnapshot post = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Card(
                          elevation: 5,
                          child: ListTile(
                            title: Text(
                              '${post['from']} TO ${post['where']}',
                              style: const TextStyle(fontWeight: FontWeight.w600
                                  // fontFamily: 'Orbitron',
                                  ),
                            ),
                            subtitle: Text(
                              '${post['vehName']} | ${post['vehRegNo']}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // post['bookedSeats'] == "1"
                                //     ? Text('${post['bookedSeats']} Seat')
                                //     : Text('${post['bookedSeats']} Seats'),
                                Text('Time: ${post['time']}'),
                                Text('Date: ${post['date']}'),
                                Text(
                                    'Seats Booked: ${post['bookedSeats']}/${post['bookedSeats'] + int.parse(post['seats'])}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width * 0.6,
          //   child: TextButton(
          //     onPressed: () async {},
          //     style: TextButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8)),
          //       backgroundColor: Colors.black,
          //     ),
          //     child: const Text(
          //       'CLEAR',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 25,
          //         fontWeight: FontWeight.bold,
          //         fontFamily: 'Orbitron',
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

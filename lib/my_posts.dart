import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
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
        title: const Text('My Posts'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, 'mypostshistory');
            },
          )
        ],
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance
            .collection('Posts')
            .where('authorID', isEqualTo: currentUserId)
            // .orderBy('createdAt', descending: true)
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        '${post['bookedSeats']} of ${post['bookedSeats'] + int.parse(post['seats'])} seats booked!',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            // delete the post
                            final postRef = posts[index].reference;
                            await postRef.delete();

                            // delete the bookedUsers subcollection
                            final bookedUsersRef =
                                postRef.collection('bookedUsers');
                            final bookedUsersSnapshot =
                                await bookedUsersRef.get();
                            for (final bookedUserDoc
                                in bookedUsersSnapshot.docs) {
                              await bookedUserDoc.reference.delete();
                            }
                            // final bookedUsersRef1 = firestoreInstance
                            //     .collection('Users')
                            //     .doc(currentUserId)
                            //     .collection('Posts')
                            //     .doc(postRef.id)
                            //     .collection('bookedUsers');
                            // final bookedUsersSnapshot1 =
                            //     await bookedUsersRef1.get();
                            // for (final bookedUserDoc
                            //     in bookedUsersSnapshot1.docs) {
                            //   await bookedUserDoc.reference.delete();
                            // }
                            //
                            // await firestoreInstance
                            //     .collection('Users')
                            //     .doc(currentUserId)
                            //     .collection('Posts')
                            //     .doc(postRef.id)
                            //     .delete();

                            // delete the post from bookedRides collection in all user documents
                            final userSnapshot = await FirebaseFirestore
                                .instance
                                .collection('Users')
                                .get();
                            for (final userDoc in userSnapshot.docs) {
                              final userId = userDoc.id;
                              final bookedRidesRef = FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(userId)
                                  .collection('bookedRides');
                              final bookedRidesSnapshot =
                                  await bookedRidesRef.get();
                              for (final rideDoc in bookedRidesSnapshot.docs) {
                                if (rideDoc.id == postRef.id) {
                                  final rideRef =
                                      bookedRidesRef.doc(rideDoc.id);
                                  await rideRef.delete();
                                }
                              }
                            }
                          } catch (e) {
                            print('Error deleting post: $e');
                          }
                        },
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

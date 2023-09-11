import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'postList.dart';

class BookRide extends StatefulWidget {
  const BookRide({Key? key}) : super(key: key);

  @override
  State<BookRide> createState() => _BookRideState();
}

class _BookRideState extends State<BookRide> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  late String currentUserName;
  late String currentUserCnic;
  late String currentUserCallno;
  late String currentUserEmail;
  late String currentUserPassword;
  String currentUserGender = "";

  late Future<List<String>> _friendIdsFuture;

  Future<List<String>> _getFriendIds() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('Friends')
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

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
      currentUserEmail = currentUserData.data()!['email'];
      currentUserCnic = currentUserData.data()!['cnic'];
      currentUserCallno = currentUserData.data()!['callno'];
      currentUserGender = currentUserData.data()!['gender'];
      // currentUserPassword = currentUserData.data()!['password'];
    });
  }

  void _showSeatSelectionSheet(DocumentSnapshot post) {
    int availableSeats = int.parse(post['seats']);
    int selectedSeats = 1; // default selected seats

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 200.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Select Number of Seats',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (selectedSeats > 1) {
                            setState(() {
                              selectedSeats--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$selectedSeats',
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          if (selectedSeats < availableSeats) {
                            setState(() {
                              selectedSeats++;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (availableSeats > 0 &&
                          selectedSeats <= availableSeats) {
                        _bookRide(post, selectedSeats, availableSeats);
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Not enough seats available'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text('Book $selectedSeats Seats'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _bookRide(
      DocumentSnapshot post, int seatsToBook, int availableSeats) async {
    try {
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(currentUserId);
      DocumentSnapshot userSnapshot =
          await userRef.collection('bookedRides').doc(post.id).get();
      String bookedSeats;
      String totalBookedSeats;
      if (userSnapshot.exists &&
          userSnapshot.data() != null &&
          (userSnapshot.data() as Map<String, dynamic>)
              .containsKey('bookedSeats')) {
        bookedSeats = userSnapshot.get('bookedSeats').toString();
        totalBookedSeats = (int.parse(bookedSeats) + seatsToBook).toString();
      } else {
        totalBookedSeats = seatsToBook.toString();
      }

      // Users -> CurrentUser -> bookedRides -> postDOC
      // Add selected post to the "bookedRides" collection with same ID
      await userRef.collection('bookedRides').doc(post.id).set({
        'authorID': post['authorID'],
        'name': post['name'],
        'from': post['from'],
        'where': post['where'],
        'date': post['date'],
        'time': post['time'],
        'vehName': post['vehName'],
        'vehRegNo': post['vehRegNo'],
        'licNo': post['licNo'],
        'fare': post['fare'],
        'genderAllowed': post['genderAllowed'],
        'bookedSeats': totalBookedSeats,
      });

      final selectedPostRef =
          FirebaseFirestore.instance.collection('Posts').doc(post.id);

      // Posts -> postId -> bookedUsers -> CurrentUserDOC
      // Add the user's document data to the "bookedUsers" subcollection inside the selected post's document
      await selectedPostRef.collection('bookedUsers').doc(currentUserId).set({
        'userId': currentUserId,
        'name': currentUserName,
        'gender': currentUserGender,
        'email': currentUserEmail,
        'callno': currentUserCallno,
        'cnic': currentUserCnic,
        'bookedSeats': totalBookedSeats,
      });
      final selectedPostRef1 =
          FirebaseFirestore.instance.collection('Users').doc(post['authorID']);

      // Users -> authorID -> Posts -> postID -> bookedUsers -> CurrentUserDOC
      await selectedPostRef1
          .collection('Posts')
          .doc(post.id)
          .collection('bookedUsers')
          .doc(currentUserId)
          .set({
        'userId': currentUserId,
        'name': currentUserName,
        'gender': currentUserGender,
        'email': currentUserEmail,
        'callno': currentUserCallno,
        'cnic': currentUserCnic,
        'bookedSeats': totalBookedSeats,
      });
      await selectedPostRef.update({
        'seats': (availableSeats - seatsToBook).toString(),
        'bookedSeats': FieldValue.increment(seatsToBook)
      });
      await selectedPostRef1.collection('Posts').doc(post.id).update({
        'seats': (availableSeats - seatsToBook).toString(),
        'bookedSeats': FieldValue.increment(seatsToBook)
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride booked successfully!')));
    } catch (e) {
      print('Error booking ride: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to book ride.'),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _friendIdsFuture = _getFriendIds();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[700],
        appBar: AppBar(
          title: const Text('Available Rides by Friends'),
          backgroundColor: Colors.grey[800],
        ),
        body: FutureBuilder<List<String>>(
          future: _friendIdsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text('No data'),
              );
            }
            final friendIds = snapshot.data ?? [];
            if (friendIds.isEmpty) {
              return const Center(
                child: Text('You have no friends yet.'),
              );
            }
            print('Friend IDs: $friendIds');
            print(snapshot.data);
            print(currentUserGender);

            return StreamBuilder<QuerySnapshot>(
              stream: currentUserGender == "Male"
                  ? FirebaseFirestore.instance
                      .collection('Posts')
                      .where('authorID', whereIn: friendIds)
                      .where('genderAllowed', isEqualTo: "All")
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Posts')
                      .where('authorID', whereIn: friendIds)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No data'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: PostList(
                        driverName: ds['name'],
                        from: ds['from'],
                        where: ds['where'],
                        date: ds['date'],
                        time: ds['time'],
                        vehName: ds['vehName'],
                        vehRegNo: ds['vehRegNo'],
                        licNo: ds['licNo'],
                        seats: ds['seats'],
                        fare: ds['fare'],
                        ds: ds,
                        onBookRide: () => _showSeatSelectionSheet(ds),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

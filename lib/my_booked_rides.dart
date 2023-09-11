import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyBookedRides extends StatefulWidget {
  const MyBookedRides({super.key});

  @override
  State<MyBookedRides> createState() => _MyBookedRidesState();
}

class _MyBookedRidesState extends State<MyBookedRides> {
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
    final bookedRidesRef = firestoreInstance
        .collection('Users')
        .doc(currentUserId)
        .collection('bookedRides');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Booked Rides'),
        backgroundColor: Colors.grey[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookedRidesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final bookedRides = snapshot.data!.docs;

          if (bookedRides.isEmpty) {
            return const Center(
              child: Text('You have no booked rides.'),
            );
          }

          return ListView.builder(
            itemCount: bookedRides.length,
            itemBuilder: (context, index) {
              final bookedRide =
                  bookedRides[index].data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      '${bookedRide['from']} TO ${bookedRide['where']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Ride by: ${bookedRide['name']}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    // trailing: Text('Date: ${bookedRide['date']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        bookedRide['bookedSeats'] == "1"
                            ? Text('${bookedRide['bookedSeats']} Seat')
                            : Text('${bookedRide['bookedSeats']} Seats'),
                        Text('Time: ${bookedRide['time']}'),
                        Text('Date: ${bookedRide['date']}')
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

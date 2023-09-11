import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  PostList({
    required this.driverName,
    required this.from,
    required this.where,
    required this.date,
    required this.time,
    required this.vehName,
    required this.vehRegNo,
    required this.licNo,
    required this.seats,
    required this.fare,
    required this.ds,
    required this.onBookRide,
  });

  final String driverName;
  final String from;
  final String where;
  final String date;
  final String time;
  final String vehName;
  final String vehRegNo;
  final String licNo;
  final String seats;
  final String fare;
  final DocumentSnapshot ds;
  final Function() onBookRide;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white54,
        boxShadow: [
          BoxShadow(
            color: Colors.white70,
            offset: Offset(2, 2.5), //(x,y)
            blurRadius: 6,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 10),
      //color: Colors.white54,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      driverName,
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                    Text(
                      '$vehName | $vehRegNo',
                      style: TextStyle(
                        fontSize: 12.3,
                        fontFamily: 'Orbitron',
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: onBookRide,
                  child: Text(
                    'SELECT',
                    style: TextStyle(fontFamily: 'Orbitron'),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800]),
                )
              ],
            ),
            //SizedBox(height: 10),
            Column(
              children: [
                Text(
                  from,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Orbitron',
                  ),
                ),
                Text(
                  'towards',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Orbitron',
                  ),
                ),
                Text(
                  where,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Orbitron',
                  ),
                ),
              ],
            ),
            //SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '$date at $time hrs',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    // fontFamily: 'Orbitron',
                  ),
                ),
                Text(
                  '$seats Seats\t\t\t$fare Rs/Seat',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    // fontFamily: 'Orbitron',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

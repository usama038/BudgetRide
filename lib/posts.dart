import 'package:flutter/material.dart';

class Posts {
  Posts({
    required this.driverName,
    required this.startingPoint,
    required this.endingPoint,
    required this.date,
    required this.time,
    required this.vehName,
    required this.vehRegNo,
    required this.licenseNo,
    required this.noOfSeats,
    required this.fare,
  });

  final String driverName;
  final String startingPoint;
  final String endingPoint;
  final String date;
  final String time;
  final String vehName;
  final String vehRegNo;
  final String licenseNo;
  final String noOfSeats;
  final String fare;
}

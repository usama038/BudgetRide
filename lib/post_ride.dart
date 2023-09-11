import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostRide extends StatefulWidget {
  const PostRide({Key? key}) : super(key: key);

  @override
  State<PostRide> createState() => _PostRideState();
}

class _PostRideState extends State<PostRide> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String currentUserId;
  late String currentUserName;
  String currentUserGender = "";
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
      currentUserGender = currentUserData.data()!['gender'];
    });
  }

  String formattedDate = "No date selected";
  String formattedTime = "No time selected";
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  void _showTimePicker(BuildContext context, TimeOfDay currentTime,
      DateTime selectedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: currentTime,
    );

    if (pickedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          pickedTime.hour,
          pickedTime.minute);
      final DateTime currentDateTime = DateTime(
          now.year, now.month, now.day, currentTime.hour, currentTime.minute);
      final Duration timeDifference =
          selectedDateTime.difference(currentDateTime);

      if (timeDifference.inMinutes < 30) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Time'),
              content:
                  const Text('Please select a time at least 30 minutes ahead.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTimePicker(context, currentTime, selectedDate);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          _dateController.text =
              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year} at ${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}";
          _timeController.text =
              '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
          formattedTime = _timeController.text;
        });
      }
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String from = "";
  String where = "";
  String vehName = "";
  String vehRegNo = "";
  String licNo = "";
  String seats = "";
  String fare = "";
  String genderAllowed = "All";
  bool _switchValue = false;

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
        decoration: const BoxDecoration(color: Colors.white
            // image: DecorationImage(
            //   image: AssetImage("assets/images/map_sample.jpeg"),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      indent: 20.0,
                      endIndent: 10.0,
                      thickness: 1.5,
                    ),
                  ),
                  Text(
                    "LOCATION",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10.0,
                      endIndent: 20.0,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  validator: _validateField,
                  decoration: InputDecoration(
                    hintText: 'From?',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Orbitron',
                    ),
                    fillColor: Colors.black.withOpacity(0.15),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    from = value;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  validator: _validateField,
                  decoration: InputDecoration(
                    hintText: 'Where?',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'Orbitron',
                    ),
                    fillColor: Colors.black.withOpacity(0.15),
                    filled: true,
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(15),
                    //   borderSide: BorderSide(color: Colors.blue, width: 2),
                    // ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    where = value;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      indent: 20.0,
                      endIndent: 10.0,
                      thickness: 1.5,
                    ),
                  ),
                  Text(
                    "SCHEDULE",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10.0,
                      endIndent: 20.0,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 25, right: 25),
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          hintText: 'Date',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Orbitron',
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dateController.text =
                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                  formattedDate = _dateController.text;
                                });
                                final TimeOfDay currentTime =
                                    TimeOfDay.fromDateTime(DateTime.now());
                                _showTimePicker(
                                    context, currentTime, pickedDate);
                              }
                            },
                            icon: Icon(
                              Icons.edit_calendar_outlined,
                              size: 26,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: Container(
                  //     height: 45,
                  //     margin: const EdgeInsets.only(left: 25, right: 25),
                  //     padding: const EdgeInsets.only(left: 10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.black.withOpacity(0.15),
                  //       border: Border.all(
                  //         color: Colors.black,
                  //         width: 2,
                  //       ),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: TextFormField(
                  //       controller: _timeController,
                  //       readOnly: true,
                  //       decoration: InputDecoration(
                  //         hintText: 'Time',
                  //         hintStyle: const TextStyle(
                  //           color: Colors.black,
                  //           fontSize: 18,
                  //           fontFamily: 'Orbitron',
                  //         ),
                  //         suffixIcon: IconButton(
                  //           onPressed: () {
                  //             final TimeOfDay currentTime =
                  //                 TimeOfDay.fromDateTime(DateTime.now());
                  //             _showTimePicker(context, currentTime);
                  //           },
                  //           icon: Icon(
                  //             Icons.more_time_outlined,
                  //             size: 26,
                  //             color: Colors.grey[600],
                  //           ),
                  //         ),
                  //       ),
                  //       validator: (value) {
                  //         if (value == null || value.isEmpty) {
                  //           return 'Please enter a time';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Expanded(
                    child: Divider(
                      indent: 20.0,
                      endIndent: 10.0,
                      thickness: 1.5,
                    ),
                  ),
                  Text(
                    "VEHICLE DETAILS",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  Expanded(
                    child: Divider(
                      indent: 10.0,
                      endIndent: 20.0,
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      validator: _validateField,
                      decoration: InputDecoration(
                        hintText: 'Veh. Name',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Orbitron',
                        ),
                        fillColor: Colors.black.withOpacity(0.15),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        vehName = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                      validator: _validateField,
                      decoration: InputDecoration(
                        hintText: 'Veh. RegNo',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Orbitron',
                        ),
                        fillColor: Colors.black.withOpacity(0.15),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        vehRegNo = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      validator: _validateField,
                      decoration: InputDecoration(
                        hintText: 'License No.',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Orbitron',
                        ),
                        fillColor: Colors.black.withOpacity(0.15),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        licNo = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                      validator: _validateField,
                      decoration: InputDecoration(
                        hintText: 'No. of Seats',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Orbitron',
                        ),
                        fillColor: Colors.black.withOpacity(0.15),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        seats = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                            ),
                            validator: _validateField,
                            decoration: InputDecoration(
                              hintText: 'Fare',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: 'Orbitron',
                              ),
                              fillColor: Colors.black.withOpacity(0.15),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              fare = value;
                            },
                          ),
                        ),
                        currentUserGender == 'Female'
                            ? Container(
                                padding: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Female Only',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Orbitron',
                                        fontSize: 15.5,
                                      ),
                                    ),
                                    Switch(
                                      inactiveTrackColor: Colors.lightBlue[300],
                                      activeTrackColor: Colors.red,
                                      activeColor: Colors.white,
                                      value: _switchValue,
                                      onChanged: (bool value) {
                                        setState(
                                          () {
                                            _switchValue = value;
                                            _switchValue
                                                ? genderAllowed = "Female Only"
                                                : genderAllowed = "All";
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const Text(''),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 45,
                      child: TextButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            final firestoreInstance =
                                FirebaseFirestore.instance;

                            // Create a new post containing user-entered data
                            final newPostRef =
                                firestoreInstance.collection('Posts').doc();
                            final newPostData = {
                              'authorID': currentUserId,
                              'name': currentUserName,
                              'from': from,
                              'where': where,
                              'date': formattedDate,
                              'time': formattedTime,
                              'vehName': vehName,
                              'vehRegNo': vehRegNo,
                              'licNo': licNo,
                              'seats': seats,
                              'bookedSeats': 0,
                              'fare': fare,
                              'genderAllowed': genderAllowed,
                              'createdAt': FieldValue.serverTimestamp(),
                            };

                            // Add the new post to the 'Posts' collection and update the user's 'Posts' subcollection
                            final batch = firestoreInstance.batch();
                            batch.set(newPostRef, newPostData);
                            batch.set(
                              firestoreInstance
                                  .collection('Users')
                                  .doc(currentUserId)
                                  .collection('Posts')
                                  .doc(newPostRef.id),
                              newPostData,
                            );
                            await batch.commit();

                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[800],
                                  child: Center(
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Text(
                                          'Ride Posted Succesfully!',
                                          style: TextStyle(
                                            fontFamily: 'Orbitron',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                          ),
                                          child: const Text(
                                            'Ok',
                                            style: TextStyle(
                                              fontFamily: 'Orbitron',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            print('Form validation failed');
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'POST RIDE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Orbitron',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

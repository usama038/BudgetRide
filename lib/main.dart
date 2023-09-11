import 'package:flutter/material.dart';
import 'get_started.dart';
import 'login.dart';
import 'signup.dart';
import 'forgot_password.dart';
import 'mode_select.dart';
import 'post_ride.dart';
import 'book_ride.dart';
import 'my_posts.dart';
import 'my_posts_history.dart';
import 'my_booked_rides.dart';
import 'add_friend.dart';
import 'friend_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BudgetRide());
}

class BudgetRide extends StatelessWidget {
  const BudgetRide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'getstarted',
      routes: {
        'getstarted': (context) => const GetStarted(),
        'login': (context) => const Login(),
        'signup': (context) => const SignUp(),
        'forgotpassword': (context) => const ForgotPasswordPage(),
        'modeselect': (context) => const ModeSelect(),
        'postride': (context) => const PostRide(),
        'bookride': (context) => const BookRide(),
        'myposts': (context) => const MyPosts(),
        'mypostshistory': (context) => const MyPostsHistory(),
        'mybookedrides': (context) => const MyBookedRides(),
        'addfriend': (context) => const AddFriend(),
        'friendlist': (context) => const FriendList(),
      },
    );
  }
}

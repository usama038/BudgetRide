import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/getStarted.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            const Image(
              image: AssetImage("assets/images/mainLogo.PNG"),
              width: 250,
              height: 250,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.47),
            SizedBox(
              width: 340,
              height: 55,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'signup');
                },
                style: TextButton.styleFrom(
                  side: const BorderSide(
                    width: 1.5,
                  ),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black38,
                ),
                child: Text(
                  'GET STARTED',
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 35,
                    fontFamily: 'Orbitron',
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.blueGrey[400],
                      fontSize: 17,
                      fontFamily: 'Orbitron',
                      decoration: TextDecoration.underline,
                    ),
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

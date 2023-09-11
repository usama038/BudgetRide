import 'package:flutter/material.dart';

class InputTextField extends StatefulWidget {
  InputTextField({
    required this.hintText,
    required this.obscureText,
    required this.textFieldWidth,
    required this.controller,
  });

  final String hintText;
  final bool obscureText;
  final double textFieldWidth;
  final TextEditingController controller;
  //final String? Function(String?)? validator;

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: widget.textFieldWidth,
      child: TextField(
        //validator: widget.validator,
        controller: widget.controller,
        style: TextStyle(color: Colors.white, fontFamily: 'Orbitron'),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.white),
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomeFormText extends StatelessWidget {
  final Icon icon;
  final bool isSecured;
  final String labeltxt;
  final TextEditingController controllers;
  final String? Function(String?) valid;
  const CustomeFormText(
      {super.key,
      required this.icon,
      required this.isSecured,
      required this.controllers,
      required this.valid,
      required this.labeltxt});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: valid,
      obscureText: isSecured,
      controller: controllers,
      decoration: InputDecoration(
          labelText: labeltxt,
          labelStyle: TextStyle(fontSize: 20),
          prefixIcon: icon,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );
  }
}

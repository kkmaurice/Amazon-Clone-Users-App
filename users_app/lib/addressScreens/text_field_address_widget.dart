import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TextFieldAddressWidget extends StatelessWidget {
  String hint;
  TextEditingController controller;
  TextFieldAddressWidget({
    Key? key,
    required this.hint,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white),
          // enabledBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          // focusedBorder: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
          // border: const UnderlineInputBorder(
          //   borderSide: BorderSide(color: Colors.white),
          // ),
        ),
        validator: (value) => value!.isEmpty ? "Please enter $hint" : null,
      ),
    );
  }
}

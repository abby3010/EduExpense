import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final IconData btnIcon;
  final String hintText;
  final TextEditingController controller;
  final String Function(String) validate;
  CustomTextField({this.btnIcon, this.hintText, this.controller, this.validate});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        children: <Widget>[
          Container(
              width: 60,
              child: Icon(
                widget.btnIcon,
                size: 20,
                color: Colors.grey.shade500,
              )),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                border: InputBorder.none,
                hintText: widget.hintText,
              ),
              validator: widget.validate,
            ),
          ),
        ],
      ),
    );
  }
}

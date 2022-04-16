
import 'package:flutter/material.dart';
import 'package:not_todo_list/calendar_page/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120.0,
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: primaryClr
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
    );
  }
}

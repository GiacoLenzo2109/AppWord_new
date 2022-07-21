import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        color: Colors.grey,
      ),
    );
  }
}

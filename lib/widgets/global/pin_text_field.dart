import 'dart:developer';

import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PinTextField extends StatefulWidget {
  final TextEditingController controller;
  const PinTextField({Key? key, required this.controller}) : super(key: key);

  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  var pin = ["", "", "", ""];
  var focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        for (int i = 0; i < focusNodes.length; i++)
          TextFieldWidget(
            padding: 15,
            textInputAction: TextInputAction.next,
            type: TextInputType.number,
            focusNode: focusNodes[i],
            text: pin[i],
            onChanged: (number) {
              setState(() {
                if (number.length > 1) {
                  number = number.substring(0, 1);
                }
                widget.controller.text = "";
                pin[i] = number;
                for (var n in pin) {
                  widget.controller.text += n;
                }
              });
              if (i + 1 < focusNodes.length) {
                FocusScope.of(context).requestFocus(focusNodes[i + 1]);
              } else {
                FocusScope.of(context).unfocus();
              }
            },
          ),
      ],
    );
  }
}

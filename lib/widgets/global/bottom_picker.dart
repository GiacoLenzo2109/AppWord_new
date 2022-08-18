import 'package:app_word/util/themes.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomPickerWidget extends StatefulWidget {
  List<String> items;
  Function(int) onSelect;
  int initialItem;

  BottomPickerWidget(
      {Key? key,
      required this.onSelect,
      required this.items,
      required this.initialItem})
      : super(key: key);

  @override
  State<BottomPickerWidget> createState() => _BottomPickerWidgetState();
}

class _BottomPickerWidgetState extends State<BottomPickerWidget> {
  bool onPressed = false;
  @override
  Widget build(BuildContext context) {
    List<Text> getItems() {
      List<Text> list = [];
      for (var item in widget.items) {
        list.add(
          Text(item),
        );
      }
      return list;
    }

    var iPicker = Container(
      height: 350,
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 6.0),
      child: CupertinoPicker(
        itemExtent: 30,
        scrollController:
            FixedExtentScrollController(initialItem: widget.initialItem),
        onSelectedItemChanged: widget.onSelect,
        children: getItems(),
      ),
    );

    var picker = BottomPicker(
      items: getItems(),
      title: 'Scegli la tipologia',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      pickerTextStyle: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: ThemesUtil.getTextColor(context),
      ),
      onChange: (index) => widget.onSelect(index),
      onClose: () => Navigator.of(context).pop(),
      onSubmit: (index) => Navigator.of(context).pop(),
      backgroundColor: Theme.of(context).backgroundColor,
      dismissable: false,
      displayButtonIcon: false,
      displaySubmitButton: false,
      itemExtent: 30,
      closeIconColor: Theme.of(context).primaryColorDark,
    );

    if (Theme.of(context).platform == TargetPlatform.android && !onPressed) {
      Future.delayed(const Duration(seconds: 0)).then((value) {
        setState(() {
          onPressed = true;
        });
        picker.show(context);
      });
    }
    return Theme.of(context).platform == TargetPlatform.iOS
        ? iPicker
        : Container();
  }
}

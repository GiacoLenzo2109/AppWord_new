import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WordItem extends StatefulWidget {
  final String word;

  const WordItem({Key? key, required this.word}) : super(key: key);

  @override
  State<WordItem> createState() => _WordItemState();
}

class _WordItemState extends State<WordItem> {
  bool edit = false;
  var checked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (edit)
            GestureDetector(
              child: Icon(
                checked
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.check_mark_circled,
                color: checked
                    ? Colors.greenAccent
                    : ThemesUtil.getTextColor(context).withOpacity(0.5),
              ),
            ),
          SizedBox(
            width: edit ? 10 : 0,
          ),
          Text(
            widget.word,
            style: const TextStyle(fontSize: 17),
          )
        ],
      ),
    );
  }
}

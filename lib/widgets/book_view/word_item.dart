import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/others/word_page.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class WordItem extends StatefulWidget {
  final String book;
  final Word word;

  const WordItem({Key? key, required this.word, required this.book})
      : super(key: key);

  @override
  State<WordItem> createState() => _WordItemState();
}

class _WordItemState extends State<WordItem> {
  bool edit = false;
  var checked = false;

  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<NavbarModel>(context);
    final bookProvider = Provider.of<BookModel>(context);

    setState(() {
      edit = navbarProvider.leading;
    });

    return GestureDetector(
      child: Container(
        height: 50,
        width: ScreenUtil.getSize(context).width - 50,
        color: Colors.transparent,
        child: Row(
          children: [
            if (edit)
              Icon(
                checked
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.check_mark_circled,
                color: checked
                    ? Colors.green
                    : ThemesUtil.getTextColor(context).withOpacity(0.5),
              ),
            SizedBox(
              width: edit ? 10 : 0,
            ),
            Text(
              widget.word.word,
              style: const TextStyle(fontSize: 17),
            )
          ],
        ),
      ),
      onTap: () => {
        if (edit)
          {
            bookProvider.addSelectedWord(widget.book, widget.word.word),
            setState(() {
              checked = !checked;
            })
          }
        else
          {
            // DialogUtil.openDialog(
            //   context: context,
            //   builder: (context) => WordPage(word: widget.word),
            // ),
            Navigator.of(context).push(
              Theme.of(context).platform == TargetPlatform.android
                  ? MaterialPageRoute(
                      builder: (context) => WordPage(word: widget.word),
                    )
                  : CupertinoPageRoute(
                      builder: (context) => CupertinoScaffold(
                        body: WordPage(word: widget.word),
                      ),
                    ),
            ),
          }
      },
    );
  }
}

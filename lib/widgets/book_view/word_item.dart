import 'package:app_word/models/word.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/others/word_page.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/screen_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
      child: Slidable(
        //key: const ValueKey(0),
        endActionPane: ActionPane(
          // A motion is a widget used to control how the pane animates.
          motion: const ScrollMotion(),

          // A pane can dismiss the Slidable.
          // dismissible: DismissiblePane(
          //   onDismissed: () => DialogUtil.openDialog(
          //     context: context,
          //     builder: (context) => DialogWidget(
          //       dType: DialogType.WARNING,
          //       msg:
          //           "Sei sicuro di voler rimuovere il vocabolo ${widget.word.word}?",
          //       onPressed: () => bookProvider.remove(
          //           bookProvider.selectedBook, widget.word.word),
          //     ),
          //   ),
          // ),

          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (context) => DialogUtil.openDialog(
                context: context,
                builder: (context) => DialogWidget(
                  dType: DialogType.WARNING,
                  title: "Attenzione!",
                  msg:
                      "Sei sicuro di voler rimuovere il vocabolo ${widget.word.word}?",
                  onPressed: () => bookProvider.remove(
                      bookProvider.selectedBook, widget.word.word),
                  doneText: "Elimina",
                  doneColorText: CupertinoColors.systemRed,
                ),
              ),
              backgroundColor: CupertinoColors.systemRed,
              foregroundColor: ThemesUtil.getBackgroundColor(context),
              icon: Icons.delete,
              label: 'Elimina',
              autoClose: true,
            ),
          ],
        ),
        child: Container(
          height: 50,
          width: ScreenUtil.getSize(context).width -
              (ThemesUtil.isAndroid(context) ? 50 : 0),
          color: Colors.transparent,
          child: Row(
            children: [
              if (edit)
                Icon(
                  checked
                      ? CupertinoIcons.check_mark_circled_solid
                      : CupertinoIcons.check_mark_circled,
                  color: checked
                      ? CupertinoColors.activeBlue
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

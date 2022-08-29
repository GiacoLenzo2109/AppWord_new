import 'package:app_word/database/repository/book_repository.dart';
import 'package:app_word/models/book.dart';
import 'package:app_word/providers/book_list_model.dart';
import 'package:app_word/providers/book_model.dart';
import 'package:app_word/providers/navbar_model.dart';
import 'package:app_word/screens/main/book/book.dart';
import 'package:app_word/service/navigation_service.dart';
import 'package:app_word/util/constants.dart';
import 'package:app_word/util/dialog_util.dart';
import 'package:app_word/util/navigator_util.dart';
import 'package:app_word/util/themes.dart';
import 'package:app_word/widgets/dialogs/dialog_widget.dart';
import 'package:app_word/widgets/global/button_widget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class BookItem extends StatefulWidget {
  final Book book;
  const BookItem({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    final bookListProvider = Provider.of<BookListProvider>(context);
    final bookProvider = Provider.of<BookModel>(context);

    return Slidable(
      //key: const ValueKey(0),
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
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
                    "Sei sicuro di voler abbandonare la rubrica ${bookProvider.name}?",
                onPressed: () async {
                  await BookRepository.leaveBook(
                      context: context, book: widget.book);

                  bookListProvider.removeBook(widget.book.id);
                },
                doneText: "Lascia",
                doneColorText: CupertinoColors.systemRed,
                doneIcon: Icons.logout,
              ),
            ),
            backgroundColor: CupertinoColors.systemRed,
            foregroundColor: Colors.white,
            icon: Icons.logout,
            label: 'Lascia',
            autoClose: true,
          ),
        ],
      ),
      child: ButtonWidget(
        text: widget.book.name,
        padding: 15,
        textColor: ThemesUtil.getTextColor(context),
        backgroundColor: ThemesUtil.isAndroid(context)
            ? Theme.of(context).backgroundColor
            : CupertinoThemes.backgroundColor(context),
        icon: Icon(
          widget.book.name == Constants.personalBook
              ? CupertinoIcons.person
              : CupertinoIcons.person_3,
          color: ThemesUtil.getContrastingColor(context),
        ),
        suffixIcon: const Icon(CupertinoIcons.arrow_right),
        onPressed: () => NavigatorUtil.navigateTo(
          context: NavigationService.navigatorKey.currentContext!,
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => NavbarModel(),
              ),
            ],
            builder: (context, _) => ChangeNotifierProvider<BookModel>.value(
              value: bookProvider,
              child: !ThemesUtil.isAndroid(context)
                  ? const CupertinoScaffold(
                      body: BookPage(),
                    )
                  : const BookPage(),
            ),
          ),
        ),
      ),
    );
  }
}

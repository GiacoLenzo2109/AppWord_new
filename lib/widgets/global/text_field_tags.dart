import 'package:app_word/util/screen_util.dart';
import 'package:app_word/widgets/global/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TextFieldTagsWidget extends StatefulWidget {
  final String? errorPhrase;
  final String? insertPhrase;
  final String? separator;
  final TextfieldTagsController controller;
  final IconData? icon;
  final List<String>? initialTags;

  const TextFieldTagsWidget({
    Key? key,
    this.errorPhrase,
    this.insertPhrase,
    this.separator,
    required this.controller,
    this.icon,
    this.initialTags,
  }) : super(key: key);

  @override
  State<TextFieldTagsWidget> createState() => _TextFieldTagsWidgetState();
}

class _TextFieldTagsWidgetState extends State<TextFieldTagsWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      initialTags: widget.initialTags ?? [],
      textfieldTagsController: widget.controller,
      textSeparators:
          widget.separator != null ? [widget.separator!] : [",", " "],
      letterCase: LetterCase.normal,
      validator: (String tag) {
        if (widget.controller.getTags!.contains(tag)) {
          return widget.errorPhrase;
        }
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return StaggeredGrid.count(
            crossAxisCount: 1,
            children: [
              TextFieldWidget(
                icon: widget.icon,
                controller: tec,
                focusNode: fn,
                placeholder: widget.insertPhrase,
                onChanged: onChanged,
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.done,
                text: null,
              ),
              SizedBox(
                width: ScreenUtil.getSize(context).width,
                child: tags.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    ScreenUtil.getSize(context).height / 5),
                            child: SingleChildScrollView(
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.end,
                                children: tags.map((String tag) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      CupertinoColors
                                                          .activeBlue)),
                                          child: Row(
                                            children: [
                                              Text(
                                                tag,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(width: 10),
                                              const Icon(
                                                CupertinoIcons.xmark_circle,
                                                color: CupertinoColors.white,
                                                size: 25,
                                              ),
                                            ],
                                          ),
                                          onPressed: () {
                                            onTagDelete(tag);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        ],
                      )
                    : null,
              ),
            ],
          );
        });
      },
    );
  }
}

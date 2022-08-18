import 'package:app_word/util/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchSliverTextField extends SliverPersistentHeaderDelegate {
  final Function(String) onChanged;
  final Function() onStop;

  const SearchSliverTextField(
      {Key? key, required this.onChanged, required this.onStop});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var controller = TextEditingController();
    var isTyping = false;
    var searchTextField = TextField(
      controller: controller,
      onChanged: (value) {
        onChanged(value);
        isTyping = true;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        filled: true,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: isTyping
            ? GestureDetector(
                onTap: () {
                  onStop();
                  isTyping = false;
                  controller.clear();
                },
                child: const Padding(
                    padding: EdgeInsets.all(15), child: Text("Annulla")),
              )
            : const SizedBox(),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "Cerca",
      ),
    );

    var iSearchTextField = Stack(
      fit: StackFit.expand,
      children: [
        CupertinoSearchTextField(
          placeholder: "Cerca",
          onChanged: onChanged,
          padding: const EdgeInsets.all(0),
        ),
      ],
    );

    return Theme.of(context).platform == TargetPlatform.android
        ? searchTextField
        : iSearchTextField;
  }

  @override
  double get maxExtent => 35;

  @override
  double get minExtent => 35;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

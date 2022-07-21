import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class NavbarModel extends ChangeNotifier {
  bool _leading = false;
  bool _trailing = false;

  bool get leading => _leading;
  bool get trailing => _trailing;

  void tapLeading() => _leading = !_leading;
  void tapTrailing() => _trailing = !_trailing;
}

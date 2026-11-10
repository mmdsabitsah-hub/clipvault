import 'package:flutter/foundation.dart';

class NavController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void go(int i) {
    if (i == _index) return;
    _index = i;
    notifyListeners();
  }

  static const home = 0, downloads = 1, editor = 2, library = 3, settings = 4;
}

import 'package:flutter/material.dart';

class PlaceSuggestProvider extends ChangeNotifier {
  final List<String> _place_list = [];

  void add(String item) {
    _place_list.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAll() {
    _place_list.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  List<String> getPlaces() {
    //notifyListeners();
    return _place_list;
  }
}

import 'package:flutter/material.dart';

class DayData extends ChangeNotifier{
  int _hour;
  bool _isExpand = false;

  DayData(this._hour);

  int get hour => _hour;

  bool get isExpand => _isExpand;

  set valueHour(int newValue) {
    if (_hour == newValue) return;
    _hour = newValue;
    notifyListeners();
  }

  set valueExpand(bool newValue) {
    if (_isExpand == newValue) return;
    _isExpand = newValue;
    notifyListeners();
  }

}
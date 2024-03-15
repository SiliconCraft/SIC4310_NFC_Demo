import 'package:flutter/material.dart';

/* ValueNotifier use with provider which has 1 param and fixed value. 
ValueNotifier can auto update to UI doesn't use notifylisten() */

/* ChangeNotifier use with more params fixed or no fixed value are OK. 
ChangeNotifier MUST use with notifylisten(), its cannot auto update to UI */
class ProviderStatus with ChangeNotifier {
  String _status = 'Please tap a tag.';
  String _img = 'assets/ic_nfc_blue.png';
  Color? _color = Colors.blue[600];

  // a param has getters and setters by itselfe doesn't create function and cannot be private param (_param).
  String page = '';

  // In provider file Must has only get param and dosomething function. doesn't good for set param.
  String get status => _status;

  String get image {
    return _img;
  }

  Color? get color => _color;

  void setStatusInitial() {
    _status = 'Please tap a tag.';
    _img = 'assets/ic_nfc_blue.png';
    _color = Colors.blue[600];
    notifyListeners();
  }

  void setStatusSuccess() {
    _status = 'Success.';
    _img = 'assets/ic_done_all_green.png';
    _color = Colors.green;
    notifyListeners();
  }

  void setStatusTap() {
    _status = 'Tag is detected.';
    _img = 'assets/ic_vibration_black.png';
    _color = Colors.black;
    notifyListeners();
  }

  void setStatusError(String setStatus) {
    _status = setStatus;
    _img = 'assets/ic_report_problem_yellow.png';
    _color = Colors.red[800];
    notifyListeners();
  }

  void clear() {
    _status = 'Please tap a tag.';
    _img = 'assets/ic_nfc_blue.png';
    _color = Colors.blue[600];
  }
}

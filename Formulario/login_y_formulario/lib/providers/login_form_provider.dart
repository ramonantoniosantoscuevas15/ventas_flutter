import 'package:flutter/material.dart';

class LoginformProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isloading = false;
  bool get isloading => _isloading;
  set isloading(bool value) {
    _isloading = true;
    notifyListeners();
  }

  String email = '';
  String password = '';
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}

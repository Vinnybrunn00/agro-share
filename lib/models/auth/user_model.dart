//  user_model.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'dart:io';

import 'package:flutter/material.dart';

enum Mode { isLogin, isSignup }

class UserModel with ChangeNotifier {
  String? name;
  String? email;
  String? cpf;
  String? password;
  File? image;
  bool? isCheck = false;
  Mode _mode = Mode.isLogin;

  bool get isLogin => _mode == Mode.isLogin;
  bool get isSignup => _mode == Mode.isSignup;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void changeMode() {
    _mode = isLogin ? Mode.isSignup : Mode.isLogin;
    notifyListeners();
  }

  void onChange(bool? value) {
    isCheck = value;
    notifyListeners();
  }

  Map<String, dynamic> get _map {
    return {
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'isCheck': isCheck,
      'photo': image?.path,
    };
  }

  @override
  String toString() {
    return _map.toString();
  }
}

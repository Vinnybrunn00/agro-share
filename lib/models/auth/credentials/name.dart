//  name.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/constants/regex.dart';

class Name {
  final String _name;

  Name({required this._name}) {
    _validate();
  }

  String get getValue => _name;

  void _validate() {
    if (_name.trim().isEmpty) {
      throw 'O nome completo não pode estar vazio';
    }

    if (hasNumbers.hasMatch(_name)) {
      throw 'O nome não pode conter números.';
    }

    final words = _name.trim().split(RegExp(r'\s+'));
    if (words.length < 2) {
      throw 'Informe seu nome completo (nome e sobrenome).';
    }
  }
}

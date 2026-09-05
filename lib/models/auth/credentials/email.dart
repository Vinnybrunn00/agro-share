//  email.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/constants/regex.dart';

class Email {
  final String? _email;

  Email({required this._email}) {
    _validate();
  }

  String? get getValue => _email;

  void _validate() {
    if (_email == null) {
      throw 'O email não pode estar vazio';
    }

    if (hasSpace.hasMatch(_email)) {
      throw 'O email não pode conter espaços.';
    }

    if (!isValidEmail.hasMatch(_email)) {
      throw 'Informe um endereço de email válido.';
    }
  }
}

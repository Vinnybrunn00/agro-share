//  password.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/constants/regex.dart';

class Password {
  final String? _password;

  Password({required this._password}) {
    _validate();
  }

  String? get getValue => _password;

  void _validate() {
    if (_password == null) {
      throw 'A senha não pode estar vazia';
    }

    if (_password.length <= 10) {
      throw 'Senha muito curta, tenta uma senha mais longa';
    }

    if (hasSpace.hasMatch(_password)) {
      throw 'A senha não pode conter espaços.';
    }

    final Map<bool, String> rules = {
      hasCharacter.hasMatch(_password):
          r'A senha deve conter pelo menos um caractere especial. [@#$%^&*]',
      hasLowerCase.hasMatch(_password):
          'A senha deve conter pelo menos uma letra minúscula',
      hasUpperCase.hasMatch(_password):
          'A senha deve conter pelo menos uma letra maiúscula',
      hasNumbers.hasMatch(_password): 'A senha deve conter números.',
    };

    for (final rule in rules.entries) {
      if (!rule.key) throw rule.value;
    }
  }
}

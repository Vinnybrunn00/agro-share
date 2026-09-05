//  cpf.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/constants/regex.dart';

class Cpf {
  final String _cpf;

  Cpf({required this._cpf}) {
    _validate();
  }

  String get getValue => _cpf;

  void _validate() {
    final String digits = _cpf.replaceAll(nonDigits, '');

    if (digits.isEmpty) {
      throw 'O CPF não pode estar vazio';
    }

    if (digits.length != 11) {
      throw 'O CPF deve conter 11 dígitos.';
    }

    if (allSameDigit.hasMatch(digits)) {
      throw 'CPF inválido.';
    }

    if (!_hasValidCheckDigits(digits)) {
      throw 'CPF inválido.';
    }
  }

  bool _hasValidCheckDigits(String digits) {
    final List<int> numbers = digits.split('').map(int.parse).toList();

    for (final int position in [9, 10]) {
      int sum = 0;
      for (int i = 0; i < position; i++) {
        sum += numbers[i] * (position + 1 - i);
      }

      int checkDigit = (sum * 10) % 11;
      if (checkDigit == 10) checkDigit = 0;

      if (checkDigit != numbers[position]) return false;
    }

    return true;
  }
}

//  auth_services.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/models/auth/credentials/cpf.dart';
import 'package:agroshare/models/auth/credentials/email.dart';
import 'package:agroshare/models/auth/credentials/name.dart';
import 'package:agroshare/models/auth/credentials/password.dart';
import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/navigator/navigator_app.dart';
import 'package:agroshare/services/picker/manager_picker.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ManagerPicker {
  final UserModel _userModel;

  AuthServices({required this._userModel});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw _ExceptionMessage.messages(error);
    }
  }

  Future<void> _signUp({
    required String name,
    required String cpf,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        /// OVERRIDE DE [ManagerPicker]
        final String? imageUrl = await uploadImagePicker(user.uid, _userModel);

        if (imageUrl == null) {
          throw 'Erro ao fazer upload da imagem, tente novamente';
        }

        await user.updateDisplayName(name);

        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': name,
          'cpf': cpf,
          'email': email,
          'create_in': DateTime.now().millisecondsSinceEpoch,
          'photo': imageUrl,
          'lat': null,
          'long': null,
        });
      }
    } on FirebaseAuthException catch (error) {
      throw _ExceptionMessage.messages(error);
    }
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      final NavigatorsApp navigatorsApp = NavigatorsApp();

      _userModel.setLoading = true;

      final Email email = Email(email: _userModel.email);
      final Password password = Password(password: _userModel.password);

      late final Name? name;
      late final Cpf? cpf;

      if (_userModel.isSignup) {
        name = Name(name: _userModel.name!);
        cpf = Cpf(cpf: _userModel.cpf!);

        await _signUp(
          name: name.getValue,
          cpf: cpf.getValue,
          email: email.getValue!,
          password: password.getValue!,
        );
      }

      if (_userModel.isLogin) {
        await _signIn(email: email.getValue!, password: password.getValue!);
      }

      if (!context.mounted) return;
      await navigatorsApp.pushAndRemoveUntil(context, HomePage());
    } catch (err) {
      if (!context.mounted) return;
      _showMessageError(context, message: err.toString());
    } finally {
      _userModel.setLoading = false;
    }
  }
}

void _showMessageError(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: MediaQuery.of(context).size.width * .95,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(231, 13, 17, 23),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(color: AppColors.whiteColor),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

abstract class _ExceptionMessage {
  static String messages(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Este e-mail já está sendo utilizado por outra conta.';
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-credential':
        return 'E-mail ou senha inválidos.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro Desconhecido';
    }
  }
}

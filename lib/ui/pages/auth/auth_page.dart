//  auth_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/services/auth/auth_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/input/input.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel userModelProvider = Provider.of<UserModel>(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        alignment: .center,
        padding: .only(left: 15, right: 15),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              _CardAuth(
                userModelProvider: userModelProvider,
                children: [
                  Column(
                    spacing: 10,
                    children: [
                      // ICONE
                      _BoxIcon(),

                      // TEXT - ENTRAR OU CADASTRAR NO AGROSHARE
                      _AuthText(userModelProvider: userModelProvider),
                    ],
                  ),

                  // INPUTS
                  Column(
                    spacing: 12,
                    children: [
                      // NOME COMPLETO - apenas em modo cadastro
                      _TransitionInputs(
                        userModelProvider: userModelProvider,
                        child: InputText(
                          prefixIcon: BoxIcons.bx_user,
                          hintText: 'Nome Completo',
                          keyboardType: .text,
                          onChanged: (name) => userModelProvider.name = name,
                        ),
                      ),

                      _TransitionInputs(
                        userModelProvider: userModelProvider,
                        child: InputText(
                          prefixIcon: BoxIcons.bx_credit_card,
                          hintText: 'CPF',
                          keyboardType: .number,
                          onChanged: (cpf) => userModelProvider.cpf = cpf,
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '###.###.###-##',
                              filter: {"#": RegExp(r'[0-9]')},
                            ),
                          ],
                        ),
                      ),

                      // EMAIL
                      InputText(
                        prefixIcon: EvaIcons.email_outline,
                        hintText: 'Email',
                        keyboardType: .emailAddress,
                        onChanged: (email) => userModelProvider.email = email,
                      ),

                      // SENHA
                      InputText(
                        prefixIcon: Icons.key,
                        hintText: userModelProvider.isLogin
                            ? 'Senha'
                            : 'Crie uma senha',
                        keyboardType: .text,
                        onChanged: (password) =>
                            userModelProvider.password = password,
                      ),
                    ],
                  ),

                  // ESQUECEU A SENHA
                  if (userModelProvider.isLogin)
                    _ForgetPassword(userModelProvider: userModelProvider),

                  if (userModelProvider.isSignup)
                    Row(
                      children: [
                        Checkbox(
                          splashRadius: 10,
                          activeColor: AppColors.mainColor,
                          value: userModelProvider.isCheck,
                          onChanged: userModelProvider.onChange,
                        ),
                        Expanded(
                          child: Text(
                            'Aceito os termos de uso e a política de privacidade',
                            overflow: .fade,
                          ),
                        ),
                      ],
                    ),

                  // BOTÃO DE ENTRAR E CADASTRAR
                  _EventButton(
                    onTap: () async {
                      final AuthServices authServices = AuthServices(
                        userModel: userModelProvider,
                      );

                      await authServices.onSubmit(context);
                    },
                    userModelProvider: userModelProvider,
                  ),

                  Row(
                    spacing: 4,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        userModelProvider.isLogin
                            ? 'Não tem conta?'
                            : 'Já possui uma conta?',
                      ),
                      GestureDetector(
                        onTap: userModelProvider.isLoading
                            ? null
                            : () => userModelProvider.changeMode(),
                        child: Text(
                          userModelProvider.isLogin
                              ? 'Cadastre-se'
                              : 'Voltar ao login',
                          style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransitionInputs extends StatelessWidget {
  final UserModel _userModelProvider;
  final Widget? _child;
  const new({required this._userModelProvider, required this._child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 450),
      constraints: BoxConstraints(
        minHeight: _userModelProvider.isLogin ? 0 : 43,
        maxHeight: _userModelProvider.isLogin ? 0 : 43,
      ),
      curve: Curves.linear,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 450),
        opacity: _userModelProvider.isSignup ? 1 : 0,
        child: _child,
      ),
    );
  }
}

class _CardAuth extends StatelessWidget {
  final UserModel _userModelProvider;
  final List<Widget> _children;

  const new({required this._children, required this._userModelProvider});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return AnimatedContainer(
      alignment: .center,
      duration: Duration(milliseconds: 450),
      padding: .only(left: 15, right: 15),
      height: _sizeCard(size),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: _userModelProvider.isLogin ? .end : .start,
        mainAxisAlignment: .center,
        children: _children,
      ),
    );
  }

  double _sizeCard(Size size) =>
      _userModelProvider.isLogin ? (size.height * .55) : (size.height * .75);
}

// esta classe serve para mostrar o icone do aplicativo
// na tela de login
class _BoxIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 85,
        width: 85,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(42.5 / 2),
        ),
        child: Center(child: Image.asset('assets/icons/icon.png', width: 65)),
      ),
    );
  }
}

// botão de entrar e criar conta
class _EventButton extends StatelessWidget {
  final UserModel _userModelProvider;
  final void Function()? _onTap;

  const _EventButton({required this._userModelProvider, required this._onTap});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _userModelProvider.isLoading
            ? null
            : (_checkTermos ? _onTap : null),
        child: Ink(
          height: 50,
          width: size.width,
          decoration: BoxDecoration(
            color: _checkTermosForColor(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _userModelProvider.isLoading
                ? CircularProgressIndicator(
                    color: AppColors.whiteColor,
                    strokeWidth: 3,
                  )
                : Text(
                    _userModelProvider.isLogin ? 'Entrar' : 'Criar Conta',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
          ),
        ),
      ),
    );
  }

  bool get _checkTermos {
    if (_userModelProvider.isSignup) {
      return _userModelProvider.isCheck!;
    }
    return true;
  }

  Color? _checkTermosForColor() {
    if (_userModelProvider.isSignup) {
      return _userModelProvider.isCheck!
          ? AppColors.mainColor
          : AppColors.mainColor.withAlpha(150);
    }
    return AppColors.mainColor;
  }
}

class _ForgetPassword extends StatelessWidget {
  final UserModel _userModelProvider;

  const _ForgetPassword({required this._userModelProvider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _userModelProvider.isLoading ? null : () {},
      child: Text(
        'Esqueceu a senha?',
        style: TextStyle(color: AppColors.mainColor),
      ),
    );
  }
}

class _AuthText extends StatelessWidget {
  final UserModel userModelProvider;

  const new({required this.userModelProvider});

  @override
  Widget build(BuildContext context) {
    return Text(
      userModelProvider.isLogin
          ? 'Entrar no AgroShare'
          : 'Cadastrar no AgroShare',
      style: TextStyle(
        fontSize: 18,
        color: AppColors.textColor,
        fontWeight: .w600,
      ),
    );
  }
}

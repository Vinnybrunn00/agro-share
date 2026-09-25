//  add_photo_page.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 06/09/2026
//

import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/services/auth/auth_services.dart';
import 'package:agroshare/core/providers/picker/picker_profile.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class AddPhotoPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: .only(left: 15, right: 15),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 11, 41, 25),
              Color(0xFF2F6B4A),
              AppColors.mainColor,
            ],
            stops: [0.0, 1, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // VOLTAR
              Align(alignment: .center, child: _BackButton()),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      _CardPhoto(
                        children: [
                          Column(
                            spacing: 8,
                            children: [
                              // TITULO
                              Text(
                                'Adicione uma foto de perfil',
                                textAlign: .center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textColor,
                                  fontWeight: .w600,
                                ),
                              ),

                              // SUBTITULO
                              Text(
                                'Ajude outros produtores a te reconhecer no AgroShare',
                                textAlign: .center,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.blackColorAlpha120,
                                ),
                              ),
                            ],
                          ),

                          // AVATAR
                          _AvatarPicker(),

                          // CONTINUAR
                          _CreateAccount(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(),
      child: InkWell(
        onTap: () => Navigator.maybePop(context),
        customBorder: CircleBorder(),
        child: Padding(
          padding: .all(12),
          child: Icon(
            Iconsax.arrow_left_outline,
            color: AppColors.whiteColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _CardPhoto extends StatelessWidget {
  final List<Widget> _children;

  const new({required this._children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: .symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 20,
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: _children,
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PickerProfile>(
      builder: (_, picker, _) {
        return InkWell(
          onTap: () async => await picker.handlePicker(),
          child: Ink(
            height: 140,
            width: 140,
            child: Stack(
              clipBehavior: .none,
              children: [
                // CIRCULO PLACEHOLDER
                CircleAvatar(
                  maxRadius: 140,
                  backgroundColor: AppColors.backgroundColorWhite,
                  backgroundImage: picker.image != null
                      ? FileImage(picker.image!)
                      : null,
                  child: picker.image != null
                      ? null
                      : Icon(
                          Iconsax.user_outline,
                          size: 62,
                          color: AppColors.mainColor,
                        ),
                ),

                // BADGE DA CAMERA
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppColors.mainColor,
                      border: Border.all(color: AppColors.whiteColor, width: 3),
                    ),
                    child: Icon(
                      Iconsax.camera_outline,
                      size: 17,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CreateAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer3<PickerProfile, UserModel, AuthServices>(
      builder: (_, picker, userModelProvider, authService, _) {
        return Material(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: picker.image != null
                ? () async {
                    userModelProvider.image = picker.image;

                    await authService.signUp(userModel: userModelProvider);
                  }
                : null,
            child: Ink(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.mainColor.withAlpha(
                  picker.image != null ? 255 : 200,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: userModelProvider.isLoading
                    ? CircularProgressIndicator(
                        color: AppColors.whiteColor,
                        strokeWidth: 1.8,
                      )
                    : Text(
                        'Criar a conta',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: .w600,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

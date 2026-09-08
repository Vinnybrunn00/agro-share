import 'dart:developer';

import 'package:agroshare/core/streams/user_stream.dart';
import 'package:agroshare/services/location/location_services.dart';
import 'package:agroshare/ui/colors/app_colors.dart';
import 'package:agroshare/ui/components/shimmer_loading_app.dart';
import 'package:agroshare/ui/screens/chat_screen.dart';
import 'package:agroshare/ui/screens/equipamentos_screen.dart';
import 'package:agroshare/ui/screens/home_screen.dart';
import 'package:agroshare/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  new({super.key});

  final LocationServices _locationServices = LocationServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _locationServices.locationServiceStatusStream,
      builder: (_, snapshot) {
        final bool? status = snapshot.data;

        return (status != null && status) ? MainPage() : ErrorLocation();
      },
    );
  }
}

class MainPage extends StatelessWidget {
  new({super.key});

  final UserStream _userStream = UserStream();

  @override
  Widget build(BuildContext context) {
    final NavigatorProvider navigator = Provider.of<NavigatorProvider>(context);
    return Scaffold(
      appBar: navigator.index != 0
          ? null
          : AppBar(
              backgroundColor: AppColors.backgroundColor,
              title: StreamBuilder(
                stream: _userStream.snapshot(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SimmerLoading(width: 130);
                  }

                  final Map<String, dynamic>? data = snapshot.data?.data();

                  return Text(
                    'Olá, ${data!['name'].toString()}',
                    style: TextStyle(fontSize: 18),
                  );
                },
              ),
            ),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: _NavigatorButtons(),
      body: SafeArea(child: navigator.screens[navigator.index]['screen']),
    );
  }
}

class ErrorLocation extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: .symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              // ICONE
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  shape: .circle,
                  color: AppColors.backgroundColorWhite,
                ),
                child: Icon(
                  Iconsax.location_outline,
                  size: 44,
                  color: AppColors.mainColor,
                ),
              ),

              const SizedBox(height: 24),

              // TITULO
              Text(
                'Localização desativada',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.textColor,
                  fontWeight: .w600,
                ),
              ),

              const SizedBox(height: 8),

              // SUBTITULO
              Text(
                'Precisamos da sua localização para mostrar equipamentos e serviços perto de você.',
                textAlign: .center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.blackColorAlpha120,
                ),
              ),

              const SizedBox(height: 32),

              // BOTAO
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    LocationServices locationServices = LocationServices();

                    try {
                      await locationServices.determinePosition();
                    } catch (err) {
                      log(err.toString());
                    }
                  },
                  child: Ink(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Permitir localização',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
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

class _NavigatorButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        margin: .only(left: 12, right: 12, bottom: 18),
        duration: Duration(milliseconds: 450),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),

        child: Consumer<NavigatorProvider>(
          builder: (_, navigator, _) {
            return Row(
              mainAxisAlignment: .spaceEvenly,
              children: navigator.screens.asMap().entries.map((entry) {
                final Map<String, dynamic> value = entry.value;
                final int index = entry.key;

                final bool selected = navigator.index == index;

                final bool isAdd = value['screen'] == null;

                return _NavigatorApp(
                  iconColor: selected ? AppColors.mainColor : null,
                  icon: selected ? value['SelectIcon'] : value['icon'],
                  title: value['title'],
                  onTap: isAdd
                      ? () {
                          log('add');
                        }
                      : (selected ? null : () => navigator.changePage(index)),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _NavigatorApp extends StatelessWidget {
  final IconData? _icon;
  final String _title;
  final void Function()? _onTap;
  final Color? _iconColor;

  const _NavigatorApp({
    required this._onTap,
    required this._icon,
    required this._title,
    required this._iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: .only(top: 5, bottom: 5),
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(25),
          child: Ink(
            width: size.width * .18,
            child: Column(
              spacing: 3,
              mainAxisAlignment: .center,
              children: [
                Icon(_icon, color: _iconColor ?? Color(0xCD5B6058), size: 19),
                Text(
                  _title,
                  style: TextStyle(
                    color: _iconColor ?? Color(0xCD5B6058),
                    fontSize: 12,
                    fontWeight: _iconColor != null ? .w600 : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigatorProvider with ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void changePage(int index) {
    _index = index;
    notifyListeners();
  }

  int get length => screens.length;

  List<Map<String, dynamic>> screens = [
    {
      'SelectIcon': Iconsax.home_2_bold,
      'icon': Iconsax.home_2_outline,
      'title': 'Início',
      'screen': HomeScreen(),
    },

    {
      'SelectIcon': Iconsax.message_2_bold,
      'icon': Iconsax.message_2_outline,
      'title': 'Chat',
      'screen': ChatScreen(),
    },

    {
      'SelectIcon': FontAwesome.tractor_solid,
      'icon': FontAwesome.tractor_solid,
      'title': 'Ações',
      'screen': EquipamentosScreen(),
    },

    {
      'SelectIcon': Iconsax.user_bold,
      'icon': Iconsax.user_outline,
      'title': 'Conta',
      'screen': ProfileScreen(),
    },

    {'icon': Iconsax.add_outline, 'title': 'Criar'},
  ];
}

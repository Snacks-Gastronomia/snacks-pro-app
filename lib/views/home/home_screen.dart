import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/home_finance.dart';
import 'package:snacks_pro_app/views/home/home_widget.dart';
import 'package:snacks_pro_app/views/home/orders_screen.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/profile_modal.dart';
import 'package:snacks_pro_app/views/recharge_card/recharge_card_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class Content {
  final Widget? screen;
  final GButton button;
  Content({
    required this.screen,
    required this.button,
  });
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final storage = AppStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, snapshot) {
      var contents = getButtons();

      return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuilder<List<Content>>(
              future: contents,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child:
                        (snapshot.data ?? []).elementAt(_selectedIndex).screen,
                  );
                }
                return const SizedBox();
              }),
          extendBody: true,
          bottomNavigationBar: Container(
            // margin: const EdgeInsets.fromLTRB(20, 0, 15, 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: FutureBuilder<List<Content>>(
                  future: contents,
                  builder: (context, snapshot) {
                    var _contents = snapshot.data ?? [];
                    if (snapshot.hasData) {
                      return GNav(
                        backgroundColor: Colors.transparent,
                        curve: Curves.easeInOut,
                        rippleColor: Colors.grey[300]!,
                        hoverColor: Colors.grey[100]!,
                        gap: 8,
                        activeColor: Colors.black,
                        iconSize: 24,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        duration: const Duration(milliseconds: 400),
                        tabBackgroundColor: Colors.grey[100]!,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        color: Colors.black,
                        tabs: _contents.map((e) => e.button).toList(),
                        selectedIndex: _selectedIndex,
                        onTabChange: (index) async {
                          setState(() {
                            if (index < _contents.length - 1) {
                              _selectedIndex = index;
                            }
                          });
                        },
                      );
                    }
                    return const SizedBox();
                  }),
            ),
          ),
        ),
      );
    });
  }

  Future<List<Content>> getButtons() async {
    var _storage = await storage.getDataStorage("user");
    var access = _storage["access_level"];
    List<Content> items = [];

    if (access == AppPermission.cashier.name) {
      items.addAll([
        Content(
          screen: const RechargeCardScreen(),
          button: const GButton(
            icon: Icons.credit_card,
            text: 'Recarregar',
          ),
        )
      ]);
    }
    if (access == AppPermission.radm.name ||
        access == AppPermission.employee.name) {
      items.addAll([
        Content(
            screen: const HomeScreenWidget(),
            button: const GButton(
              icon: Icons.home_rounded,
              text: 'Home',
            )),
      ]);
    }
    items.addAll([
      Content(
          screen: OrdersScreen(),
          button: const GButton(
            icon: Icons.receipt_rounded,
            text: 'Pedidos',
          )),
    ]);
    if (access == AppPermission.sadm.name ||
        access == AppPermission.radm.name) {
      items.add(Content(
          screen: FinanceScreen(),
          button: const GButton(
            icon: Icons.business,
            text: 'Négocio',
          )));
    }

    items.add(Content(
      screen: null,
      button: GButton(
          icon: Icons.account_circle_rounded,
          text: 'Conta',
          onPressed: () => AppModal().showModalBottomSheet(
                withPadding: false,
                context: context,
                content: Builder(builder: (context) {
                  var data = _storage;

                  return ProfileModal(
                      name: data["name"] ?? "",
                      phone: data["phone"] ?? "",
                      ocupation: data["ocupation"] ?? "");
                }),
              )),
    ));
    return items;
  }
}

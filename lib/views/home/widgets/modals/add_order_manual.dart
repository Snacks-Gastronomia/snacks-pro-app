import 'dart:convert';
import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import '../../../../core/app.text.dart';
import '../../../../models/item_model.dart';
import '../../state/item_screen/item_screen_cubit.dart';
import '../order_item.dart';
import 'add_order_total.dart';

class AddOrderManual extends StatefulWidget {
  const AddOrderManual({super.key});

  @override
  State<AddOrderManual> createState() => _AddOrderManualState();
}

class _AddOrderManualState extends State<AddOrderManual> {
  List<Item> suggestions = [];
  List<Item> restaurantMenu = [];
  List<Item> order = [];

  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerItems = TextEditingController();

  String searchText = '';

  @override
  void initState() {
    super.initState();
    suggestions = restaurantMenu;
  }

  void updateFilteredSuggestions(String text) {
    setState(() {
      suggestions = restaurantMenu
          .where(
              (item) => item.title.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return StreamBuilder<QuerySnapshot>(
          stream: state.menu,
          builder: (context, snapshot) {
            final List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
            for (int i = 0; i < docs.length; i++) {
              var itemData = docs[i].data();
              var item = Item.fromJson(jsonEncode(itemData));
              restaurantMenu.add(item);
            }
            return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Adicionar pedidos manual',
                            style: AppTextStyles.bold(20),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.black12,
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Hora do pedido",
                        style: AppTextStyles.medium(14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 1.5,
                        dashPattern: const [7, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: TextFormField(
                          controller: _controllerData,
                          maxLines: 1,
                          maxLength: 30,
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            hintText: "Ex.: 22:03",
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Selecione os items",
                        style: AppTextStyles.medium(14),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          DottedBorder(
                            color: Colors.grey,
                            strokeWidth: 1.5,
                            dashPattern: const [7, 4],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFormField(
                              controller: _controllerItems,
                              onChanged: (text) {
                                updateFilteredSuggestions(text);
                              },
                              decoration: InputDecoration(
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  hintText: "Pesquise o nome do item"),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_controllerItems.text.isNotEmpty)
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 5),
                                        blurRadius: 7.0,
                                        spreadRadius: 0.0,
                                        blurStyle: BlurStyle.normal)
                                  ]),
                              child: ListView.builder(
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  String price = suggestions[index]
                                      .value
                                      .toStringAsFixed(2)
                                      .replaceAll('.', ',');
                                  return ListTile(
                                    title: Text(
                                      suggestions[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text("R\$$price"),
                                    onTap: () {
                                      console.log(
                                          'Selected: ${suggestions[index].title}');
                                      _controllerItems.clear();
                                      setState(() {
                                        order.add(suggestions[index]);
                                      });
                                    },
                                  );
                                },
                              ),
                            )
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: BlocBuilder<ItemScreenCubit, ItemScreenState>(
                            builder: (context, state) {
                          return Center(
                            child: ListView.builder(
                              itemCount: order.length,
                              itemBuilder: (context, index) {
                                return OrderItemWidget(
                                  order: order[index],
                                  onDelete: (() {}),
                                  onIncrement: context
                                      .read<ItemScreenCubit>()
                                      .incrementAmount,
                                  onDecrement: context
                                      .read<ItemScreenCubit>()
                                      .decrementAmount,
                                );
                              },
                            ),
                          );
                        }),
                      ),
                      AddOrderTotal(
                        subtotal: 0,
                        delivery: 0,
                        total: 0,
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }
}

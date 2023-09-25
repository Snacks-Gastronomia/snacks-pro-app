import 'dart:convert';
import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import '../../../../core/app.text.dart';
import '../../../../models/item_model.dart';
import '../../../../models/order_model.dart';
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
  OrderModel order = OrderModel(
      item: Item(
          title: '',
          value: 0,
          num_served: 0,
          time: 0,
          restaurant_id: '',
          restaurant_name: '',
          active: true),
      option_selected: '',
      observations: '');
  List<OrderModel> orders = [];
  double subtotal = 0;
  double delivery = 7;
  double total = 0;

  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerItems = TextEditingController();

  String searchText = '';

  void _handleCheckboxValue(bool value) {
    setState(() {
      value ? delivery = 7 : delivery = 0;
      updateTotal();
    });
  }

  void updateTotal() {
    total = subtotal + delivery;
  }

  @override
  void initState() {
    super.initState();
    suggestions = restaurantMenu;
    updateTotal();
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
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hora do pedido",
                          style: AppTextStyles.medium(14),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1.5,
                          dashPattern: const [7, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          // padding: const EdgeInsets.all(10),
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
                          height: 10,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1.5,
                          dashPattern: const [7, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12),
                          // padding: const EdgeInsets.all(10),
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
                        Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 250,
                              child:
                                  BlocBuilder<ItemScreenCubit, ItemScreenState>(
                                      builder: (context, state) {
                                return Center(
                                  child: ListView.builder(
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      return OrderItemWidget(
                                        order: orders[index],
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
                                    console.log(suggestions[index].title);
                                    console.log(suggestions.length.toString());
                                    OrderModel orderGet = OrderModel(
                                        item: suggestions[index],
                                        option_selected: '',
                                        observations: '');
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
                                          order = orderGet;
                                          orders.add(order);
                                          subtotal += order.item.value;
                                          updateTotal();
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AddOrderTotal(
                          checkBoxValue: _handleCheckboxValue,
                          subtotal: subtotal,
                          delivery: delivery,
                          total: total,
                        ),
                        CustomSubmitButton(
                            onPressedAction: () {}, label: "Adicionar Pedido"),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}

import 'dart:convert';
import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/views/home/state/add_order_state/add_order_state.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';

import '../../../../core/app.text.dart';
import '../../../../models/item_model.dart';
import '../../../../models/order_model.dart';
import '../../state/add_order_state/add_order_cubit.dart';
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
      amount: 1,
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

  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerItems = TextEditingController();

  void updateFilteredSuggestions(String text) {
    List<Item> teste = [];
    setState(() {
      if (suggestions.contains(teste[0].title)) {
        suggestions.clear();
        suggestions = restaurantMenu
            .where(
                (item) => item.title.toLowerCase().contains(text.toLowerCase()))
            .toList();
        teste = suggestions;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    suggestions = restaurantMenu;
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AddOrderCubit>();
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
                              child: BlocBuilder<AddOrderCubit, AddOrderState>(
                                  bloc: cubit,
                                  builder: (context, state) {
                                    return Center(
                                      child: ListView.builder(
                                        itemCount: orders.length,
                                        itemBuilder: (context, index) {
                                          int amount =
                                              orders[index].amount ?? 1;
                                          return OrderItemWidget(
                                              amount: amount,
                                              order: orders[index],
                                              onDelete: () {
                                                setState(() {
                                                  cubit.removeItem(
                                                      index, orders);
                                                });
                                              },
                                              onIncrement: () {
                                                setState(() {
                                                  cubit.incrementAmount(
                                                      index, orders);
                                                });
                                              },
                                              onDecrement: () {
                                                setState(() {
                                                  cubit.decrementAmount(
                                                      index, orders);
                                                });
                                              });
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
                                child:
                                    BlocBuilder<AddOrderCubit, AddOrderState>(
                                        bloc: cubit,
                                        builder: (context, state) {
                                          return ListView.builder(
                                            itemCount: suggestions.length,
                                            itemBuilder: (context, index) {
                                              OrderModel orderGet = OrderModel(
                                                  amount: 1,
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                trailing: Text("R\$$price"),
                                                onTap: () {
                                                  console.log(
                                                      'Selected: ${suggestions[index].title}');
                                                  _controllerItems.clear();
                                                  setState(() {
                                                    order = orderGet;
                                                    orders.add(order);
                                                    cubit.subtotal +=
                                                        order.item.value;
                                                    cubit.updateTotal();
                                                  });
                                                },
                                              );
                                            },
                                          );
                                        }),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        AddOrderTotal(
                          checkBoxValue: (value) {
                            setState(() {
                              cubit.handleCheckboxValue(value);
                            });
                          },
                          subtotal: cubit.subtotal,
                          delivery: cubit.delivery,
                          total: cubit.total,
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

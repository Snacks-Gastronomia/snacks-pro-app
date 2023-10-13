import 'dart:developer' as console;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.routes.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/state/add_order_state/add_order_state.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';

import '../../../../core/app.text.dart';

import '../../state/add_order_state/add_order_cubit.dart';

import '../order_item.dart';
import 'add_order_total.dart';

class AddOrderManual extends StatefulWidget {
  const AddOrderManual({super.key});

  @override
  State<AddOrderManual> createState() => _AddOrderManualState();
}

class _AddOrderManualState extends State<AddOrderManual> {
  final storage = AppStorage();

  List<ItemDetails> suggestions = [];
  List<ItemDetails> restaurantMenu = [];

  List<OrderResponse> orders = [];
  List<ItemResponse> listItemResponse = [];

  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerItems = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final timeFormat = DateFormat('HH:mm');

  late DateTime dateTime;

  void updateFilteredSuggestions(String text) {
    setState(() {
      suggestions = restaurantMenu
          .where((item) =>
              item.title.toLowerCase().contains(text.toLowerCase()) &&
              item.title.toLowerCase() != "suggestions")
          .toList();
      restaurantMenu.clear();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AddOrderCubit>();
    cubit.getDeliveryValue();

    return FutureBuilder(
        future: storage.getDataStorage("user"),
        builder: (context, future) {
          dateTime = DateTime.now();
          if (future.hasData) {
            var user = future.data ?? {};
            String restaurantName = '';
            String restaurantId = '';

            restaurantId = user["restaurant"]["id"];
            restaurantName = user["restaurant"]["name"];

            ItemResponse itemResponse = ItemResponse(
                amount: 1,
                item: ItemDetails(
                    imageUrl: '',
                    restaurantId: restaurantId,
                    active: false,
                    id: '',
                    time: 0,
                    title: '',
                    value: 0,
                    restaurantName: restaurantName),
                observations: '',
                optionSelected: OptionSelected(id: '', title: '', value: 0));

            OrderResponse orderResponse = OrderResponse(
                address: "",
                code: 'PM0000-#PM0000',
                customerName: "Pedido Manual",
                needChange: false,
                restaurant: restaurantId,
                created_at: dateTime,
                restaurantName: restaurantName,
                isDelivery: false,
                waiterPayment: 'Pedido Manual',
                id: 'Pedido Manual',
                waiterDelivery: 'Pedido Manual',
                receive_order: "address",
                part_code: 'PM0000',
                deliveryValue: 0,
                items: [],
                value: 0,
                paymentMethod: 'Pedido Manual',
                status: 'delivered',
                userUid: 'Pedido Manual');

            return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              return StreamBuilder<QuerySnapshot>(
                  stream: state.menu,
                  builder: (context, snapshot) {
                    orders.isEmpty ? orders.add(orderResponse) : null;
                    final List<QueryDocumentSnapshot> docs =
                        snapshot.data?.docs ?? [];
                    for (int i = 0; i < docs.length; i++) {
                      var itemData = docs[i].data() as Map<String, dynamic>;
                      final item = ItemDetails.fromMap(itemData);
                      item.restaurantId == restaurantId
                          ? restaurantMenu.add(item)
                          : null;
                    }
                    return Scaffold(
                      resizeToAvoidBottomInset: false,
                      body: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                Text(
                                  'Adicionar pedido manual',
                                  style: AppTextStyles.bold(20),
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      cubit.total = 0;
                                      cubit.subtotal = 0;
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor: Colors.black38,
                                        fixedSize: const Size.square(20),
                                        elevation: 0),
                                    child: const Icon(Icons.close,
                                        size: 20, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Form(
                              key: formKey,
                              child: Column(
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
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        hintText: "Ex.: 22:03",
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Digite a hora do pedido';
                                        }
                                        try {
                                          timeFormat.parseStrict(value);
                                        } catch (e) {
                                          return 'Digite uma hora válida';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {
                                        setState(() {
                                          dateTime =
                                              timeFormat.parseStrict(value!);
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selecione os items",
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
                                    controller: _controllerItems,
                                    onChanged: (text) {
                                      updateFilteredSuggestions(text);
                                    },
                                    decoration: InputDecoration(
                                        counterText: "",
                                        suffixIcon: const Icon(Icons.search),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        hintText: "Pesquise o nome do item"),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: BlocBuilder<AddOrderCubit,
                                              AddOrderState>(
                                          bloc: cubit,
                                          builder: (context, state) {
                                            return Center(
                                              child: ListView.builder(
                                                  itemCount:
                                                      listItemResponse.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (orders[0]
                                                        .items
                                                        .isNotEmpty) {
                                                      int amount = orders[0]
                                                          .items[index]
                                                          .amount;
                                                      return OrderItemWidget(
                                                          amount: amount,
                                                          order:
                                                              listItemResponse[
                                                                      index]
                                                                  .item,
                                                          onDelete: () {
                                                            setState(() {
                                                              cubit.removeItem(
                                                                  orders[0]
                                                                      .items,
                                                                  index,
                                                                  amount);
                                                            });
                                                          },
                                                          onIncrement: () {
                                                            setState(() {
                                                              cubit.incrementAmount(
                                                                  orders[0]
                                                                          .items[
                                                                      index],
                                                                  amount);
                                                            });
                                                          },
                                                          onDecrement: () {
                                                            setState(() {
                                                              cubit.decrementAmount(
                                                                  orders[0]
                                                                          .items[
                                                                      index],
                                                                  amount);
                                                            });
                                                          });
                                                    } else {
                                                      return Container();
                                                    }
                                                  }),
                                            );
                                          }),
                                    ),
                                    if (_controllerItems.text.isNotEmpty)
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxHeight: 200),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                          shrinkWrap: true,
                                          itemCount: suggestions.length,
                                          itemBuilder: (context, index) {
                                            ItemResponse itemResponseGet =
                                                ItemResponse(
                                                    amount: 1,
                                                    item: suggestions[index],
                                                    optionSelected:
                                                        OptionSelected(
                                                            id:
                                                                suggestions[
                                                                        index]
                                                                    .id,
                                                            title: suggestions[
                                                                    index]
                                                                .title,
                                                            value: suggestions[
                                                                    index]
                                                                .value),
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
                                                  itemResponse =
                                                      itemResponseGet;
                                                  listItemResponse
                                                      .add(itemResponse);
                                                  orderResponse.items =
                                                      listItemResponse;
                                                  orders[0] = orderResponse;
                                                  cubit.subtotal +=
                                                      itemResponse.item.value;
                                                  cubit.updateTotal();
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
                                    onPressedAction: () {
                                      var navigator = Navigator.of(context);
                                      if (formKey.currentState!.validate()) {
                                        DateTime currentDate = dateTime;

                                        TimeOfDay selectedTime =
                                            TimeOfDay.fromDateTime(
                                          timeFormat.parseStrict(
                                              _controllerData.text),
                                        );

                                        dateTime = DateTime(
                                          currentDate.year,
                                          currentDate.month,
                                          currentDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );

                                        orders[0].value = cubit.total;
                                        orders[0].created_at = dateTime;

                                        cubit.makeOrder(orders);

                                        cubit.total = 0;
                                        cubit.subtotal = 0;
                                        navigator.pop();
                                        navigator.pushNamed(AppRoutes.home);
                                        cubit.showToastSucess(context);
                                      }
                                    },
                                    label: "Adicionar Pedido"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
          } else {
            return Container();
          }
        });
  }
}

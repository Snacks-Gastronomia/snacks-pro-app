import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/home/state/cart_state/cart_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/tabbar.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Row(
              children: [
                Text(
                  'Pedidos',
                  style: AppTextStyles.medium(20),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          child:
              // Builder(
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: BlocProvider.of<HomeCubit>(context).fetchOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var orders = snapshot.data!.docs;
                      List<dynamic> orders_delivery = [];
                      List<dynamic> orders_local = [];
                      orders.map((e) {
                        Map<String, dynamic> data = e.data();
                        data["id"] = e.id;
                        if (e.get("isDelivery") == true) {
                          orders_delivery.add(data);
                        } else {
                          orders_local.add(data);
                        }
                      }).toList();
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TabarBar(
                              new_items_page1: orders_local.isNotEmpty
                                  ? orders_local
                                      .map((element) => element["status"] ==
                                              OrderStatus.ready_to_start.name
                                          ? 1
                                          : 0)
                                      .reduce(
                                          (value, element) => value + element)
                                  : 0,
                              new_items_page2: orders_delivery.isNotEmpty
                                  ? orders_delivery
                                      .map((element) => element["status"] ==
                                              OrderStatus.ready_to_start.name
                                          ? 1
                                          : 0)
                                      .reduce(
                                          (value, element) => value + element)
                                  : 0,
                              page1: Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: orders_local.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) {
                                            var item = orders_local[index];
                                            Timestamp date = item["created_at"];
                                            // time.toDate();
                                            String time = DateFormat("HH:mm")
                                                .format(date.toDate());
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: CardOrderWidget(
                                                  doubleTap: () => context
                                                      .read<CartCubit>()
                                                      .changeStatusFoward(
                                                          item["id"],
                                                          item["items"],
                                                          item[
                                                              "payment_method"],
                                                          item["status"],
                                                          item["created_at"]),
                                                  onLonPress: () =>
                                                      print("printer"),
                                                  leading: item["isDelivery"]
                                                      ? null
                                                      : item["table"],
                                                  address: item["isDelivery"]
                                                      ? item["address"]
                                                      : "",
                                                  status: item["status"],
                                                  isDelivery:
                                                      item["isDelivery"],
                                                  time: time,
                                                  total: item["value"],
                                                  method:
                                                      item["payment_method"],
                                                  items: item["items"] ?? []),
                                            );
                                          })),
                                ],
                              ),
                              page2: Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: orders_delivery.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) {
                                            var item = orders_delivery[index];
                                            Timestamp date = item["created_at"];
                                            // time.toDate();
                                            String time = DateFormat("HH:mm")
                                                .format(date.toDate());
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child:
                                                  // Dismissible(
                                                  //   key: UniqueKey(),
                                                  //   dismissThresholds: const {
                                                  //     DismissDirection.startToEnd:
                                                  //         0.1,
                                                  //     DismissDirection.endToStart:
                                                  //         0.1
                                                  //   },
                                                  //   onDismissed: (direction) {
                                                  //     print(direction);
                                                  //   },
                                                  //   child:
                                                  CardOrderWidget(
                                                      doubleTap: () => print(
                                                          "change status"),
                                                      onLonPress: () =>
                                                          print("printer"),
                                                      leading:
                                                          item["isDelivery"]
                                                              ? null
                                                              : item["table"],
                                                      address:
                                                          item["isDelivery"]
                                                              ? item["address"]
                                                              : "",
                                                      status: item["status"],
                                                      isDelivery:
                                                          item["isDelivery"],
                                                      time: time,
                                                      total: item["value"],
                                                      method: item[
                                                          "payment_method"],
                                                      items: item["orders"]),
                                            );
                                            // );
                                          })),
                                ],
                              ),
                              onChange: (p0) {},
                            )
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: SizedBox(
                          height: 60,
                          width: 60,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            backgroundColor: Colors.black12,
                          )),
                    );
                  }),
        ));
  }
}

class CardOrderWidget extends StatelessWidget {
  final bool isDelivery;
  final String? leading;
  final String status;
  final String address;
  final double total;
  final String method;
  final String time;
  final List items;
  final VoidCallback doubleTap;
  final VoidCallback onLonPress;

  const CardOrderWidget({
    Key? key,
    this.isDelivery = false,
    required this.leading,
    required this.status,
    required this.address,
    required this.total,
    required this.method,
    required this.time,
    required this.items,
    required this.doubleTap,
    required this.onLonPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // SwipeTo(
        //   onLeftSwipe: () => print("left"),
        //   onRightSwipe: () => print("right"),
        //   iconOnLeftSwipe: Icons.keyboard_double_arrow_right_rounded,
        //   iconOnRightSwipe: Icons.keyboard_double_arrow_left_rounded,
        //   child:
        GestureDetector(
      onDoubleTap: doubleTap,
      onLongPress: () => onLonPress,
      child: ExpandableNotifier(
          initialExpanded: true,
          child: Stack(children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: const Color(0xffF6F6F6),
              // color: Color(0xffF6F6F6),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          leading == null
                              ? SvgPicture.asset(
                                  AppImages.snacks_logo,
                                  width: 50,
                                  color:
                                      const Color(0xff263238).withOpacity(0.7),
                                )
                              : Text(
                                  '#$leading',
                                  style: AppTextStyles.bold(52,
                                      color: const Color(0xff263238)),
                                ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                method,
                                style: AppTextStyles.regular(16,
                                    color: const Color(0xff979797)),
                              ),
                              Text(
                                NumberFormat.currency(
                                        locale: "pt", symbol: r"R$ ")
                                    .format(total),
                                style: AppTextStyles.semiBold(16,
                                    color: const Color(0xff979797)),
                              ),
                            ],
                          )
                        ]),
                        Text(
                          time,
                          style: AppTextStyles.light(14,
                              color: const Color(0xff979797)),
                        ),
                      ],
                    ),
                  ),
                  if (isDelivery)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.all(15),
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade200),
                        child: Text(address),
                      ),
                    ),
                  ScrollOnExpand(
                    scrollOnExpand: true,
                    scrollOnCollapse: false,
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: true,
                        tapBodyToExpand: false,
                        hasIcon: false,
                      ),
                      header: Column(
                        children: [
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Ver detalhes",
                                style: AppTextStyles.regular(12,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          )
                        ],
                      ),
                      collapsed: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemCount: items.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var order = Order.fromMap(items[index]);

                                if (order.item.restaurant_id ==
                                    context
                                        .read<HomeCubit>()
                                        .state
                                        .storage["restaurant"]["id"]) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 18,
                                              height: 23,
                                              // padding: EdgeInsets.symmetric(
                                              //     horizontal: 7, vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.black),
                                              child: Center(
                                                child: Text(
                                                  order.amount.toString(),
                                                  style: AppTextStyles.regular(
                                                      14,
                                                      color: Colors.white),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.item.title,
                                                style:
                                                    AppTextStyles.regular(14),
                                              ),
                                              if (order.observations.isNotEmpty)
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    order.observations,
                                                    style:
                                                        AppTextStyles.regular(
                                                            12,
                                                            color: Colors.grey),
                                                  ),
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                                locale: "pt", symbol: r"R$ ")
                                            .format(order.item.value),
                                        style: AppTextStyles.regular(14,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      expanded: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[],
                      ),
                      builder: (_, collapsed, expanded) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Expandable(
                            collapsed: collapsed,
                            expanded: expanded,
                            theme: const ExpandableThemeData(
                                crossFadePoint: 0, hasIcon: false, iconSize: 0),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: OrderStatus.values.byName(status).getColor,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Center(
                      child: Text(
                        OrderStatus.values.byName(status).name,
                        style: AppTextStyles.regular(14, color: Colors.white54),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black),
                child: Text(
                  items.length.toString(),
                  style: AppTextStyles.regular(16, color: Colors.white),
                ))
          ])),
    );
    // );
  }
}

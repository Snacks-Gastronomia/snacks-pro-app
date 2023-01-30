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
    final access_level = context
        .read<HomeCubit>()
        .state
        .storage["access_level"]
        .toString()
        .stringToEnum;

    getCountByStatus(List data, OrderStatus status) {
      return data.isNotEmpty
          ? data
              .map((element) => element["status"] == status.name ? 1 : 0)
              .reduce((value, element) => value + element)
          : 0;
    }

    getCountBadgeTab(orders_page1, orders_page2) {
      var count1 = 0;
      var count2 = 0;
      if (access_level == AppPermission.employee.name) {
        count1 = getCountByStatus(orders_page1, OrderStatus.ready_to_start);
        count2 = getCountByStatus(orders_page2, OrderStatus.order_in_progress);
      } else {
        count1 = getCountByStatus(orders_page1, OrderStatus.waiting_payment);
        count2 = getCountByStatus(orders_page2, OrderStatus.done);
      }

      return [count1, count2];
    }

    getTextTab() {
      if (access_level == AppPermission.employee.name) {
        return ["Pronto para Começar", "Em andamento"];
      } else if (access_level == AppPermission.waiter.name) {
        return ["À pagar", "Prontos"];
      } else {
        return ["Local", "Entrega"];
      }
    }

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
                      List<dynamic> orders_page2 = [];
                      List<dynamic> orders_page1 = [];
                      orders.map((e) {
                        Map<String, dynamic> data = e.data();
                        data["id"] = e.id;

                        if (access_level == AppPermission.waiter.name) {
                          if (data["status"] ==
                              OrderStatus.waiting_payment.name) {
                            orders_page1.add(data);
                          } else {
                            orders_page2.add(data);
                          }
                        } else if (access_level ==
                            AppPermission.employee.name) {
                          if (data["status"] ==
                              OrderStatus.ready_to_start.name) {
                            orders_page1.add(data);
                          } else {
                            orders_page2.add(data);
                          }
                        } else {
                          if (data["isDelivery"] == true) {
                            orders_page2.add(data);
                          } else {
                            orders_page1.add(data);
                          }
                        }
                      }).toList();

                      List<String> tabs = getTextTab();
                      List<int> counts =
                          getCountBadgeTab(orders_page1, orders_page2);
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TabarBar(
                              tab1_text: tabs[0],
                              tab2_text: tabs[1],
                              new_items_page1: counts[0],
                              new_items_page2: counts[1],
                              page1: Column(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: orders_page1.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) {
                                            var item = orders_page1[index];
                                            Timestamp date = item["created_at"];
                                            // time.toDate();
                                            String time = DateFormat("HH:mm")
                                                .format(date.toDate());

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: CardOrderWidget(
                                                  permission: access_level,
                                                  doubleTap: () => context
                                                      .read<CartCubit>()
                                                      .changeStatus(
                                                          context,
                                                          item["isDelivery"]
                                                              ? null
                                                              : item["table"],
                                                          item["id"],
                                                          item["items"],
                                                          item[
                                                              "payment_method"],
                                                          item["status"],
                                                          item["created_at"],
                                                          item["isDelivery"]),
                                                  onLongPress: () async =>
                                                      context
                                                          .read<HomeCubit>()
                                                          .printerOrder(
                                                              item, context),
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
                                          itemCount: orders_page2.length,
                                          shrinkWrap: true,
                                          itemBuilder: (_, index) {
                                            var item = orders_page2[index];
                                            Timestamp date = item["created_at"];

                                            String time = DateFormat("HH:mm")
                                                .format(date.toDate());

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: CardOrderWidget(
                                                  permission: access_level,
                                                  doubleTap: () => context
                                                      .read<CartCubit>()
                                                      .changeStatus(
                                                        context,
                                                        item["isDelivery"]
                                                            ? null
                                                            : item["table"],
                                                        item["id"],
                                                        item["items"],
                                                        item["payment_method"],
                                                        item["status"],
                                                        item["created_at"],
                                                        item["isDelivery"],
                                                      ),
                                                  onLongPress: () {},
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
  final AppPermission permission;
  final double total;
  final String method;
  final String time;
  final List items;
  final VoidCallback doubleTap;
  final VoidCallback onLongPress;

  const CardOrderWidget({
    Key? key,
    this.isDelivery = false,
    required this.leading,
    required this.permission,
    required this.status,
    required this.address,
    required this.total,
    required this.method,
    required this.time,
    required this.items,
    required this.doubleTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: doubleTap,
      onLongPress: onLongPress,
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
                              SizedBox(
                                width: 160,
                                child: Text(
                                  method,
                                  style: AppTextStyles.regular(16,
                                      color: const Color(0xff979797)),
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                var order = OrderModel.fromMap(items[index]);

                                if (order.item.restaurant_id ==
                                        context
                                            .read<HomeCubit>()
                                            .state
                                            .storage["restaurant"]["id"] ||
                                    permission == AppPermission.waiter) {
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
                        children: [],
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
                        OrderStatus.values.byName(status).displayEnum,
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

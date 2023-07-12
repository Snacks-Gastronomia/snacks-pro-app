import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';

import 'package:snacks_pro_app/core/app.images.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_model.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/finance/state/orders/finance_orders_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/tabbar.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({Key? key}) : super(key: key);
  final storage = AppStorage();

  Future<AppPermission> getAccessLevel() async {
    var user = await storage.getDataStorage("user");
    String access = user["access_level"].toString();

    return access.stringToEnum;
  }

  @override
  Widget build(BuildContext context) {
    getCountByStatus(List data, OrderStatus status) {
      return data.isNotEmpty
          ? data
              .map((element) => element["status"] == status.name ? 1 : 0)
              .reduce((value, element) => value + element)
          : 0;
    }

    getCountBadgeTab(access_level, orders_page1, orders_page2) {
      var count1 = 0;
      var count2 = 0;
      if (access_level == AppPermission.employee) {
        count1 = getCountByStatus(orders_page1, OrderStatus.ready_to_start);
        count2 = getCountByStatus(orders_page2, OrderStatus.order_in_progress);
      } else {
        count1 = getCountByStatus(orders_page1, OrderStatus.waiting_payment);
        count2 = getCountByStatus(orders_page2, OrderStatus.done);
      }

      return [count1, count2];
    }

    getTextTab({required AppPermission access_level}) {
      if (access_level == AppPermission.employee) {
        return ["Em preparação", "Em andamento"];
      } else if (access_level == AppPermission.waiter) {
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
        body: FutureBuilder<AppPermission>(
            future: getAccessLevel(),
            builder: (context, snapshot) {
              var access_level = snapshot.data;

              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child:
                      // Builder(
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream:
                              BlocProvider.of<HomeCubit>(context).fetchOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var orders = snapshot.data!.docs;
                              List<dynamic> orders_page2 = [];
                              List<dynamic> orders_page1 = [];

                              orders.map((e) {
                                Map<String, dynamic> data = e.data();
                                data["id"] = e.id;

                                if (access_level == AppPermission.waiter) {
                                  if (data["status"] ==
                                      OrderStatus.waiting_payment.name) {
                                    orders_page1.add(data);
                                  } else {
                                    orders_page2.add(data);
                                  }
                                } else if (access_level ==
                                    AppPermission.employee) {
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

                              List<String> tabs =
                                  getTextTab(access_level: access_level!);
                              List<int> counts = getCountBadgeTab(
                                  access_level, orders_page1, orders_page2);
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
                                                  itemCount:
                                                      orders_page1.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (_, index) {
                                                    var item =
                                                        orders_page1[index];
                                                    Timestamp date =
                                                        item["created_at"];
                                                    // time.toDate();
                                                    String time =
                                                        DateFormat("HH:mm")
                                                            .format(date
                                                                .toDate()
                                                                .toLocal());
                                                    var waiter = item?[
                                                            "waiter_delivery"] ??
                                                        "";
                                                    var _change = (item[
                                                                "need_change"] ??
                                                            false)
                                                        ? (item["change_money"] ??
                                                            "")
                                                        : "";

                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: CardOrderWidget(
                                                          total: context.read<OrdersCubit>().getTotal(
                                                              item["items"]),
                                                          onCancelOrder: () => context
                                                              .read<
                                                                  OrdersCubit>()
                                                              .deleteOrder(
                                                                  item["id"]),
                                                          waiter: waiter,
                                                          restaurant: item[
                                                              "restaurant_name"],
                                                          change: _change,
                                                          permission:
                                                              access_level,
                                                          doubleTap: () => context
                                                              .read<
                                                                  OrdersCubit>()
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
                                                                  item["isDelivery"]),
                                                          onLongPress: () async => context.read<HomeCubit>().printerOrder(item, context),
                                                          leading: item["isDelivery"] ? null : item["table"],
                                                          address: item["isDelivery"] ? item["address"] ?? 'Endereço não informado' : "",
                                                          status: item["status"],
                                                          isDelivery: item["isDelivery"],
                                                          time: time,
                                                          method: item["payment_method"],
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
                                                  itemCount:
                                                      orders_page2.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (_, index) {
                                                    var item =
                                                        orders_page2[index];
                                                    Timestamp date =
                                                        item["created_at"];

                                                    String time =
                                                        DateFormat("HH:mm")
                                                            .format(date
                                                                .toDate()
                                                                .toLocal());
                                                    var _change = (item[
                                                                "need_change"] ??
                                                            false)
                                                        ? (item["change_money"] ??
                                                            "")
                                                        : "";
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      child: CardOrderWidget(
                                                          onCancelOrder: () =>
                                                              context.read<OrdersCubit>().deleteOrder(
                                                                  item["id"]),
                                                          restaurant: item[
                                                              "restaurant_name"],
                                                          change: _change,
                                                          permission:
                                                              access_level,
                                                          doubleTap: () => context
                                                              .read<
                                                                  OrdersCubit>()
                                                              .changeStatus(
                                                                context,
                                                                item["isDelivery"]
                                                                    ? null
                                                                    : item[
                                                                        "table"],
                                                                item["id"],
                                                                item["items"],
                                                                item[
                                                                    "payment_method"],
                                                                item["status"],
                                                                item[
                                                                    "created_at"],
                                                                item[
                                                                    "isDelivery"],
                                                              ),
                                                          onLongPress: () async => context
                                                              .read<HomeCubit>()
                                                              .printerOrder(
                                                                  item, context),
                                                          leading: item["isDelivery"]
                                                              ? null
                                                              : item["table"],
                                                          address:
                                                              item["isDelivery"]
                                                                  ? item["address"] ??
                                                                      ""
                                                                  : "",
                                                          status:
                                                              item["status"],
                                                          isDelivery: item[
                                                              "isDelivery"],
                                                          time: time,
                                                          total: context
                                                              .read<OrdersCubit>()
                                                              .getTotal(item["items"]),
                                                          method: item["payment_method"],
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
                );
              }

              return const CustomCircularProgress();
            }));
  }
}

class CardOrderWidget extends StatelessWidget {
  final bool isDelivery;
  final String change;
  final String? leading;
  final String status;
  final String restaurant;
  final String address;
  final AppPermission permission;
  final double total;
  final String method;
  final String time;
  final String waiter;
  final List items;
  final VoidCallback doubleTap;
  final VoidCallback onLongPress;
  final VoidCallback onCancelOrder;

  const CardOrderWidget({
    Key? key,
    this.isDelivery = false,
    required this.leading,
    this.waiter = "",
    required this.permission,
    required this.status,
    required this.restaurant,
    this.change = "",
    required this.address,
    required this.total,
    required this.method,
    required this.time,
    required this.items,
    required this.doubleTap,
    required this.onLongPress,
    required this.onCancelOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.5,
        children: [
          CustomSlidableAction(
            onPressed: (context) {},
            autoClose: true,
            backgroundColor: Colors.transparent,
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onCancelOrder,
                  child: Text(
                    "Cancelar pedido",
                    style:
                        AppTextStyles.light(14, color: const Color(0xffE20808)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      child: GestureDetector(
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
                      child: Column(
                        children: [
                          Text(restaurant),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(children: [
                                leading == null
                                    ? SvgPicture.asset(
                                        AppImages.snacks_logo,
                                        width: 50,
                                        color: const Color(0xff263238)
                                            .withOpacity(0.7),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                            text: '#',
                                            style: AppTextStyles.bold(25,
                                                color: const Color(0xff263238)),
                                            children: [
                                              TextSpan(
                                                text: leading,
                                                style: AppTextStyles.bold(40,
                                                    color: const Color(
                                                        0xff263238)),
                                              ),
                                            ]),
                                      ),

                                // Text(
                                //     '#$leading',
                                //     style: AppTextStyles.bold(42,
                                //         color: const Color(0xff263238)),
                                //   ),

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
                          headerAlignment:
                              ExpandablePanelHeaderAlignment.center,
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

                                  // if (order.item.restaurant_id ==
                                  //         context
                                  //             .read<HomeCubit>()
                                  //             .state
                                  //             .storage["restaurant"]["id"] ||
                                  //     permission == AppPermission.waiter) {
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
                                              SizedBox(
                                                width: 200,
                                                child: Text(
                                                  '${order.item.title} - ${order.option_selected["title"]}',
                                                  style:
                                                      AppTextStyles.regular(14),
                                                ),
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
                                              if (order.extras.isNotEmpty)
                                                for (int i = 0;
                                                    i < order.extras.length;
                                                    i++)
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      '+${order.extras[i]["title"]}  (${NumberFormat.currency(locale: "pt", symbol: r"R$").format(double.parse(order.extras[i]["value"].toString()))})',
                                                      style:
                                                          AppTextStyles.regular(
                                                              12,
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Text(
                                        NumberFormat.currency(
                                                locale: "pt", symbol: r"R$ ")
                                            .format(double.parse(order
                                                .option_selected["value"]
                                                .toString())),
                                        style: AppTextStyles.regular(14,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  );
                                  // } else {
                                  //   return const SizedBox();
                                  // }
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
                                  crossFadePoint: 0,
                                  hasIcon: false,
                                  iconSize: 0),
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
                          "${OrderStatus.values.byName(status).displayEnum} ${waiter.isNotEmpty ? "- $waiter" : ""}",
                          style:
                              AppTextStyles.regular(14, color: Colors.white54),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.black),
                      child: Text(
                        items.length.toString(),
                        style: AppTextStyles.regular(16, color: Colors.white),
                      )),
                  if (change.isNotEmpty)
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: const Color(0xffFFCA44)),
                        child: Text(
                          "Troco: $change",
                          style: AppTextStyles.regular(16),
                        ))
                ],
              )
            ])),
      ),
    );
    // );
  }
}

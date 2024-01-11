import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/utils/storage.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import 'package:snacks_pro_app/views/home/state/orders_state/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/add_order_manual.dart';
import 'package:snacks_pro_app/views/home/widgets/modals/withdraw_content.dart';
import 'package:snacks_pro_app/views/home/widgets/order/card.dart';
import 'package:snacks_pro_app/views/home/widgets/search_orders.dart';
import 'package:snacks_pro_app/views/home/widgets/tabbar.dart';
import 'package:snacks_pro_app/views/splash/loading_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final storage = AppStorage();
  final modal = AppModal();
  TextEditingController controllerFilter1 = TextEditingController();
  TextEditingController controllerFilter2 = TextEditingController();

  Future<AppPermission> getAccessLevel() async {
    var user = await storage.getDataStorage("user");
    String access = user["access_level"].toString();

    return access.stringToEnum;
  }

  @override
  Widget build(BuildContext context) {
    getCountByStatus(List<OrderResponse> data, OrderStatus status) {
      return data.isNotEmpty
          ? data
              .map((element) => element.status == status.name ? 1 : 0)
              .reduce((value, element) => value + element)
          : 0;
    }

    getCountBadgeTab(accessLevel, ordersPage1, ordersPage2) {
      var count1 = 0;
      var count2 = 0;
      if (accessLevel == AppPermission.employee) {
        count1 = getCountByStatus(ordersPage1, OrderStatus.ready_to_start);
        count2 = getCountByStatus(ordersPage2, OrderStatus.order_in_progress);
      } else {
        count1 = getCountByStatus(ordersPage1, OrderStatus.waiting_payment);
        count2 = getCountByStatus(ordersPage2, OrderStatus.done);
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

    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      return LoadingPage(
        loading: state.status == AppStatus.loading,
        text: "Pedindo já estando sendo enviado...",
        backgroundPage: FutureBuilder<AppPermission>(
            future: getAccessLevel(),
            builder: (context, snapshot) {
              var accessLevel = snapshot.data;
              return Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            'Pedidos',
                            style: AppTextStyles.medium(20),
                          ),
                          const Spacer(),
                          if (accessLevel == AppPermission.cashier ||
                              accessLevel == AppPermission.radm)
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      modal.showIOSModalBottomSheet(
                                          context: context,
                                          content: WithdrawContent());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(Icons.attach_money),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      modal.showIOSModalBottomSheet(
                                          context: context,
                                          content: const AddOrderManual());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  body: Builder(builder: (context) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: BlocBuilder<OrdersCubit, OrdersState>(
                            builder: (context, state) {
                          return StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: context.read<OrdersCubit>().fetchOrders(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var docs = snapshot.data!.docs;

                                  var orders = docs.map(
                                      (e) => OrderResponse.fromFirebase(e));

                                  List<OrderResponse> ordersPage1 = [];
                                  List<OrderResponse> ordersPage2 = [];

                                  orders.map((element) {
                                    if (accessLevel == AppPermission.waiter) {
                                      if (element.status ==
                                          OrderStatus.waiting_payment.name) {
                                        ordersPage1.add(element);
                                      } else {
                                        ordersPage2.add(element);
                                      }
                                    } else if (accessLevel ==
                                        AppPermission.employee) {
                                      if (element.status ==
                                          OrderStatus.ready_to_start.name) {
                                        ordersPage1.add(element);
                                      } else {
                                        ordersPage2.add(element);
                                      }
                                    } else {
                                      if (element.isDelivery) {
                                        ordersPage2.add(element);
                                      } else if (accessLevel ==
                                              AppPermission.cashier &&
                                          element.status !=
                                              OrderStatus.delivered.name) {
                                        ordersPage1.add(element);
                                      } else {
                                        // ordersPage1.add(element);
                                      }
                                    }
                                  }).toList();

                                  List<String> tabs =
                                      getTextTab(access_level: accessLevel!);
                                  List<int> counts = getCountBadgeTab(
                                      accessLevel, ordersPage1, ordersPage2);

                                  var groupedOrders1 = OrderResponse
                                      .groupOrdersByCode(controllerFilter1
                                                  .text !=
                                              ''
                                          ? ordersPage1
                                              .where((element) =>
                                                  element.table!
                                                      .contains(state.filter) ||
                                                  element.code
                                                      .toLowerCase()
                                                      .contains(state.filter) ||
                                                  element.customerName!
                                                      .toLowerCase()
                                                      .contains(state.filter))
                                              .toList()
                                          : ordersPage1);

                                  var groupedOrders2 =
                                      OrderResponse.groupOrdersByCode(
                                          controllerFilter2.text != ''
                                              ? ordersPage2
                                                  .where((element) =>
                                                      element.code
                                                          .toLowerCase()
                                                          .contains(
                                                              state.filter) ||
                                                      element.customerName!
                                                          .toLowerCase()
                                                          .contains(
                                                              state.filter))
                                                  .toList()
                                              : ordersPage2);
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child:
                                        BlocBuilder<OrdersCubit, OrdersState>(
                                            builder: (context, state) {
                                      return Column(
                                        children: [
                                          TabarBar(
                                            tab1_text: tabs[0],
                                            tab2_text: tabs[1],
                                            new_items_page1: counts[0],
                                            new_items_page2: counts[1],
                                            page1: Column(
                                              children: [
                                                SearchOrders(
                                                  action: () => context
                                                      .read<OrdersCubit>()
                                                      .filterOrders(
                                                          controllerFilter1
                                                              .text),
                                                  controllerFilter:
                                                      controllerFilter1,
                                                ),
                                                Expanded(
                                                    child: ListView.builder(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemCount:
                                                      groupedOrders1.length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (_, index) {
                                                    var grouped =
                                                        groupedOrders1[index];

                                                    List<OrderResponse> orders =
                                                        grouped["orders"];

                                                    return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 10),
                                                        child: OrderCardWidget(
                                                          orders: orders,
                                                          onDoubleTap: () => context
                                                              .read<
                                                                  OrdersCubit>()
                                                              .changeStatus(
                                                                context:
                                                                    context,
                                                                items: orders,
                                                              ),
                                                          onLongPress:
                                                              () async => context
                                                                  .read<
                                                                      HomeCubit>()
                                                                  .printerOrder(
                                                                      orders[0],
                                                                      context),
                                                        ));
                                                  },
                                                )),
                                              ],
                                            ),
                                            page2: Column(
                                              children: [
                                                if (accessLevel ==
                                                    AppPermission.cashier)
                                                  SearchOrders(
                                                    action: () => context
                                                        .read<OrdersCubit>()
                                                        .filterOrders(
                                                            controllerFilter2
                                                                .text),
                                                    controllerFilter:
                                                        controllerFilter2,
                                                  ),
                                                Expanded(
                                                    child: ListView.builder(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemCount:
                                                            groupedOrders2
                                                                .length,
                                                        shrinkWrap: true,
                                                        itemBuilder:
                                                            (_, index) {
                                                          var order =
                                                              groupedOrders2[
                                                                  index];

                                                          List<OrderResponse>
                                                              orders0 =
                                                              order["orders"];

                                                          return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              child:
                                                                  OrderCardWidget(
                                                                orders: orders0,
                                                                onDoubleTap:
                                                                    () => context
                                                                        .read<
                                                                            OrdersCubit>()
                                                                        .changeStatus(
                                                                          context:
                                                                              context,
                                                                          items:
                                                                              orders0,
                                                                        ),
                                                                onLongPress: () async => context
                                                                    .read<
                                                                        HomeCubit>()
                                                                    .printerOrder(
                                                                        orders0[
                                                                            0],
                                                                        context),
                                                              ));
                                                          // );
                                                        })),
                                              ],
                                            ),
                                            onChange: (p0) {},
                                          )
                                        ],
                                      );
                                    }),
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
                              });
                        }),
                      );
                    }

                    return const CustomCircularProgress();
                  }));
            }),
      );
    });
  }
}

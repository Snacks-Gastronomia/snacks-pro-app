import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/state/orders/orders_cubit.dart';
import 'package:snacks_pro_app/views/home/state/home_state/home_cubit.dart';
import './day_order_report.dart';

class OrdersReportScreen extends StatelessWidget {
  OrdersReportScreen({Key? key}) : super(key: key);
  final modal = AppModal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FutureBuilder(
            future: BlocProvider.of<OrdersCubit>(context).fetchMonthly(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!.docs;
                return Column(
                  children: [
                    Text(
                      'Relatório de pedidos',
                      style: AppTextStyles.semiBold(22),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      toBeginningOfSentenceCase(
                              DateFormat.MMMM("pt_BR").format(DateTime.now()))
                          .toString(),
                      style: AppTextStyles.light(18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total de pedidos',
                              style: AppTextStyles.regular(16),
                            ),
                            Text(
                                BlocProvider.of<OrdersCubit>(context)
                                    .state
                                    .total_orders_monthly
                                    .toString(),
                                style: AppTextStyles.semiBold(32)),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.grey.shade400,
                          height: 50,
                          width: 1,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receita obtida',
                              style: AppTextStyles.regular(16),
                            ),
                            Text(
                                NumberFormat.currency(
                                        locale: "pt", symbol: r"R$ ")
                                    .format(
                                        BlocProvider.of<OrdersCubit>(context)
                                            .state
                                            .budget_monthly),
                                style: AppTextStyles.semiBold(32)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .60,
                      child: ListView.separated(
                        // shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          var item = data[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            clipBehavior: Clip.hardEdge,
                            child: ListTile(
                              onTap: () => modal.showIOSModalBottomSheet(
                                context: context,
                                content: DayOrdersReportScreen(
                                    day: item.id,
                                    amount: item.data()["length"],
                                    total: NumberFormat.currency(
                                            locale: "pt", symbol: r"R$ ")
                                        .format(item.data()["total"])),
                              ),
                              tileColor: Colors.black,
                              title: Text(
                                DateFormat.MMMMd('pt_BR').format(DateTime.parse(
                                    '${DateTime.now().year}-${DateFormat("MM").format(DateTime.now())}-${item.id}')),
                                style: AppTextStyles.semiBold(18,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                NumberFormat.currency(
                                        locale: "pt", symbol: r"R$ ")
                                    .format(item.data()["total"]),
                                style: AppTextStyles.light(14,
                                    color: Colors.white),
                              ),
                              trailing: Text(
                                '${item.data()["length"]}',
                                style: AppTextStyles.semiBold(18,
                                    color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
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
      ),
    );
  }
}

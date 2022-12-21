import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/views/finance/state/orders/orders_cubit.dart';

class DayOrdersReportScreen extends StatelessWidget {
  const DayOrdersReportScreen({
    Key? key,
    required this.day,
    required this.total,
    required this.amount,
  }) : super(key: key);

  final String day;
  final String total;
  final int amount;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: FutureBuilder(
            future: BlocProvider.of<OrdersCubit>(context).fetchDaily(day),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                print(snapshot.data!.docs.length);
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
                      DateFormat.MMMMd('pt_BR').format(DateTime.parse(
                          '${DateTime.now().year}-${DateTime.now().month}-$day')),
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
                            Text(amount.toString(),
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
                            Text(total, style: AppTextStyles.semiBold(32)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .6,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            Divider(color: Colors.grey.shade300),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var item = snapshot.data!.docs[index];
                          return Card(
                            elevation: 0,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              title: Text(
                                item.data()["payment"],
                                style: AppTextStyles.semiBold(16),
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                      itemCount: (item.data()["orders"] as List)
                                          .length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var order =
                                            item.data()["orders"][index];
                                        var text =
                                            '${order["amount"]} ${order["name"]}';
                                        return Text(
                                          text,
                                          style: AppTextStyles.light(14,
                                              color: const Color(0xffB3B3B3)),
                                        );
                                      })
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                            locale: "pt", symbol: r"R$ ")
                                        .format(item.data()["total"]),
                                    style: AppTextStyles.semiBold(18,
                                        color: const Color(0xff00B907)),
                                  ),
                                  Text(
                                    item.data()["time"],
                                    style: AppTextStyles.light(14),
                                  ),
                                ],
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

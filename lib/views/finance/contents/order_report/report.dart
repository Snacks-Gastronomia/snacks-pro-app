import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/views/finance/state/orders/finance_orders_cubit.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key, this.restaurant_id});

  final String? restaurant_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: BlocBuilder<FinanceOrdersCubit, FinanceOrdersState>(
        builder: (context, state) {
          return FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () async {
              var results = await showCalendarDatePicker2Dialog(
                context: context,
                config: CalendarDatePicker2WithActionButtonsConfig(
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now(),
                    calendarType: CalendarDatePicker2Type.range),
                dialogSize: const Size(325, 400),
                value: [state.interval_start, state.interval_end],
                borderRadius: BorderRadius.circular(15),
              );
              if (results?.length == 1) {
                // ignore: use_build_context_synchronously
                context
                    .read<FinanceOrdersCubit>()
                    .fetchReceipts(restaurant_id, results![0]!, results[0]!);
              } else {
                // ignore: use_build_context_synchronously
                context
                    .read<FinanceOrdersCubit>()
                    .fetchReceipts(restaurant_id, results![0]!, results[1]!);
              }
            },
            tooltip: 'Escolha uma data',
            child:
                const Icon(Icons.calendar_today_outlined, color: Colors.white),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: BlocBuilder<FinanceOrdersCubit, FinanceOrdersState>(
            buildWhen: (previous, current) => previous.orders != current.orders,
            builder: (context, state) {
              // if (state.orders.isNotEmpty) {
              // var item = orders;
              double value = state.orders.isEmpty
                  ? 0
                  : state.orders.map((e) => e.value).reduce((v, e) => v + e);
              if (state.status == AppStatus.loading) {
                return const CustomCircularProgress();
              }

              return Column(
                children: [
                  Text(
                    'Relatório de pedidos',
                    style: AppTextStyles.semiBold(22),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.MMMMd('pt_BR').format(state.interval_start),
                        style: AppTextStyles.light(18),
                      ),
                      if (state.interval_start != state.interval_end)
                        Row(
                          children: [
                            Container(
                              height: 1,
                              width: 30,
                              color: Colors.black12,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                            ),
                            Text(
                              DateFormat.MMMMd('pt_BR')
                                  .format(state.interval_end),
                              style: AppTextStyles.light(18),
                            ),
                          ],
                        )
                    ],
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
                          Text(state.orders.length.toString(),
                              style: AppTextStyles.semiBold(25)),
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
                                  .format(value),
                              style: AppTextStyles.semiBold(25)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  state.orders.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                Divider(color: Colors.grey.shade300),
                            itemCount: state.orders.length,
                            itemBuilder: (context, index) {
                              var item = state.orders[index];
                              return Card(
                                elevation: 0,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  title: Text(
                                    item.paymentMethod,
                                    style: AppTextStyles.semiBold(16),
                                  ),
                                  isThreeLine: true,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListView.builder(
                                          itemCount: item.items.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var order = item.items[index];
                                            List extras = order.extras ?? [];

                                            var extraDescription = "";

                                            for (var i = 0;
                                                i < extras.length;
                                                i++) {
                                              var element = extras[i];
                                              extraDescription += element[
                                                      "title"] +
                                                  '(${NumberFormat.currency(locale: "pt", symbol: r"R$").format(double.parse(element["value"].toString()))})';
                                            }

                                            var text =
                                                '${order.amount} ${order.item.title}';

                                            if (extraDescription.isNotEmpty) {
                                              text += ' + $extraDescription';
                                            }

                                            return Text(
                                              text,
                                              style: AppTextStyles.light(14,
                                                  color:
                                                      const Color(0xffB3B3B3)),
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
                                            .format(item.value),
                                        style: AppTextStyles.semiBold(18,
                                            color: const Color(0xff00B907)),
                                      ),
                                      Text(
                                        DateFormat.Hm('pt_BR')
                                            .format(item.created_at),
                                        style: AppTextStyles.light(14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child: Text("Sem dados para exibir"),
                        )
                ],
              );
              // }
            }),
      ),
    );
  }
}

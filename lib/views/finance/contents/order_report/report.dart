import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/models/order_response.dart';
import 'package:snacks_pro_app/utils/enums.dart';

import 'package:snacks_pro_app/utils/save_excel.dart';
import 'package:snacks_pro_app/utils/toast.dart';
import 'package:snacks_pro_app/views/finance/state/orders/finance_orders_cubit.dart';
import 'package:snacks_pro_app/views/home/widgets/dropdown_items.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.restaurant_id});
  final String? restaurant_id;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: BlocBuilder<FinanceOrdersCubit, FinanceOrdersState>(
        builder: (context, state) {
          return ExpandableFab(
            key: _key,
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(Icons.menu),
              fabSize: ExpandableFabSize.regular,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
            ),
            closeButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.regular,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
            ),
            distance: 80,
            type: ExpandableFabType.up,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton.small(
                  heroTag: null,

                  tooltip: 'Escolha uma data',
                  // backgroundColor: Colors.black,
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
                    if (results != null) {
                      if (results.length == 1) {
                        // ignore: use_build_context_synchronously
                        context.read<FinanceOrdersCubit>().fetchReceipts(
                            widget.restaurant_id, results[0]!, results[0]!);
                      } else {
                        // ignore: use_build_context_synchronously
                        context.read<FinanceOrdersCubit>().fetchReceipts(
                            widget.restaurant_id, results[0]!, results[1]!);
                      }
                    }
                    final stateButton = _key.currentState;
                    if (stateButton != null) {
                      debugPrint('isOpen:${stateButton.isOpen}');
                      stateButton.toggle();
                    }
                  },

                  child: const Icon(Icons.calendar_today_outlined,
                      color: Colors.white),
                ),
              ),
              if (state.orders.isNotEmpty)
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton.small(
                    heroTag: null,
                    tooltip: 'Gerar planilha',
                    backgroundColor: Colors.green[800],
                    child: const Icon(Icons.file_download_outlined,
                        color: Colors.white),
                    onPressed: () async {
                      final toast = AppToast();
                      toast.init(context: context);
                      var state = context.read<FinanceOrdersCubit>().state;
                      await FileStorage.generateExcel(
                          state.orders,
                          [state.interval_start, state.interval_end],
                          state.totalValue);

                      final stateButton = _key.currentState;
                      if (stateButton != null) {
                        stateButton.toggle();
                        // ignore: use_build_context_synchronously
                        toast.showToast(
                            context: context,
                            content: "Relatório salvo em Documentos!",
                            type: ToastType.info);
                        // SnackBar(
                        //   content: const Text('Relatorio salvo em documentos'),
                        //   action: SnackBarAction(
                        //       label: 'Ok', onPressed: () => print("close")),
                        // );
                      }
                    },
                  ),
                ),
            ],
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
                  DropdownItems(),
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
                            separatorBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            itemCount: state.orders.length,
                            itemBuilder: (context, index) {
                              OrderResponse item = state.orders[index];

                              return ReceiptCard(data: item);
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

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    Key? key,
    required this.data,
  }) : super(key: key);
  final OrderResponse data;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (data.isDelivery)
                    Icon(Icons.delivery_dining,
                        color: Colors.green.shade700, size: 14),
                  RichText(
                      text: TextSpan(
                          text: data.customerName,
                          style: AppTextStyles.semiBold(14),
                          children: [
                        TextSpan(
                          text: " #${data.part_code}",
                          style:
                              AppTextStyles.semiBold(14, color: Colors.black26),
                        )
                      ])),
                ],
              ),
              Text(
                DateFormat('HH:mm (dd/MM)').format(data.created_at),
                style: AppTextStyles.regular(10, color: Colors.black26),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.items.length,
            itemBuilder: (context, index) {
              var item = data.items[index];
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item.amount} ${item.item.title}",
                          style: AppTextStyles.light(12, color: Colors.black45),
                        ),
                        Text(
                          NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                              .format(item.item.value),
                          style: AppTextStyles.light(12, color: Colors.black54),
                        ),
                      ],
                    ),
                    if (item.extras?.isNotEmpty ?? false)
                      Text(
                        item.extras?.map((e) => e["title"]).join(",") ?? "",
                        style: AppTextStyles.light(12, color: Colors.black26),
                      ),
                  ]);
            },
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey.shade300),
            child: Column(
              children: [
                if (data.isDelivery)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Entrega",
                        style: AppTextStyles.medium(11, color: Colors.black),
                      ),
                      Text(
                        NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                            .format(data.deliveryValue),
                        style: AppTextStyles.light(11, color: Colors.black),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: AppTextStyles.medium(11, color: Colors.black),
                    ),
                    Text(
                      NumberFormat.currency(locale: "pt", symbol: r"R$ ")
                          .format(data.value),
                      style: AppTextStyles.light(11, color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Método de pagamento",
                      style: AppTextStyles.medium(11, color: Colors.black),
                    ),
                    Text(
                      data.paymentMethod,
                      style: AppTextStyles.light(11, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

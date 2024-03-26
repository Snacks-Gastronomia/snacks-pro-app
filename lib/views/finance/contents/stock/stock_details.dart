import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/utils/enums.dart';
import 'package:snacks_pro_app/utils/modal.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/charts/stock_pie_chart.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/add_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/history_losses.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/modals/history_stock.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';

class StockDetailsScreen extends StatelessWidget {
  StockDetailsScreen({super.key});

  final modal = AppModal();

  @override
  Widget build(BuildContext context) {
    String lastEntranceId = "";
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 30,
              bottom: 20,
              child: FloatingActionButton(
                heroTag: 'Excluir',
                onPressed: () => context
                    .read<StockCubit>()
                    .deleteStockItem()
                    .then((value) => Navigator.pop(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  size: 40,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 30,
              child: FloatingActionButton(
                onPressed: () => modal.showModalBottomSheet(
                    context: context,
                    content: AddDataToStock(
                      typeModal: StockModalOptions.increment,
                      lastEntrance: lastEntranceId,
                    )),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.black,
                child: const Icon(Icons.refresh_rounded),
              ),
            ),
            // Add more floating buttons if you want
            // There is no limit
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => modal.showModalBottomSheet(
        //       context: context,
        //       content: AddDataToStock(
        //         typeModal: StockModalOptions.increment,
        //         lastEntrance: lastEntranceId,
        //       )),
        //   shape:
        //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        //   backgroundColor: Colors.black,
        //   child: const Icon(Icons.refresh_rounded),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: FutureBuilder(
            future: context.read<StockCubit>().fetchScreenData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CustomCircularProgress();
              }

              if (snapshot.hasData) {
                var data = snapshot.data;

                var entrances = data["entrances"] as List;
                var losses = data["losses"] as List;
                var consume = data["consume"] as List;

                if (entrances.isNotEmpty) {
                  lastEntranceId = entrances.last.id ?? "";
                }

                var totalValue = data["totalValue"];
                var consumedValue =
                    double.parse((data["consumedValue"] ?? 0).toString());
                var lossValue =
                    double.parse((data["lossValue"] ?? 0).toString());

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back)),
                            const SizedBox(
                              width: 30,
                            ),
                            // Text(item.title, style: AppTextStyles.regular(22))
                          ],
                        ),
                        Text(
                          "Entradas",
                          style: AppTextStyles.bold(22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 15,
                            ),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: entrances.length,
                            itemBuilder: (context, index) {
                              QueryDocumentSnapshot<Map<String, dynamic>> item =
                                  entrances[index];

                              var entc = item.data();

                              var timestamp = item["created_at"] as Timestamp;
                              return CardEntrancesWidget(
                                doc: entc["document"],
                                unit: entc["unit"],
                                description: entc["description"],
                                created_at: timestamp.toDate().toString(),
                                volume: entc["volume"],
                                value: entc["value"] == ''
                                    ? 0
                                    : double.parse(entc["value"]),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        StockPieChart(
                          consume: consumedValue,
                          loss: lossValue,
                          total: totalValue,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Container(
                            width: double.maxFinite,
                            // height: 200,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                // color: Colors.green[50],
                                border: Border.fromBorderSide(BorderSide(
                                  color: Colors.purple.shade200,
                                )),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ultimos consumos",
                                  style: AppTextStyles.bold(
                                    18,
                                    color: Colors.purple.shade200,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ListView.separated(
                                  itemCount: consume.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // print();
                                    var item = consume[index].data();
                                    //  {order_code: CLA779-BMHJBV, volume: 2, amount: 1, unit: kg, ing_name: ggg, order: Tataki salmão }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["order"],
                                              style: AppTextStyles.regular(14),
                                            ),
                                            Text(
                                              "Quantidate: ${item["amount"]}",
                                              style: AppTextStyles.light(11),
                                            )
                                          ],
                                        ),
                                        Text(
                                          (item["volume"] * item["amount"])
                                                  .toString() +
                                              item["unit"],
                                          style: AppTextStyles.semiBold(14),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: TextButton(
                                    onPressed: () => modal.showModalBottomSheet(
                                        context: context,
                                        content: HistoryStock(
                                          consumed: consumedValue,
                                          unit: context
                                              .read<StockCubit>()
                                              .state
                                              .selected
                                              .unit,
                                        )),
                                    child: const Text(
                                      "Ver tudo",
                                    ),
                                  ),
                                ),
                              ],
                            )
                            // trailing: Text('$totalConsume ${item.measure}'),
                            ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.maxFinite,
                            // height: 200,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                // color: Colors.green[50],
                                border: Border.fromBorderSide(BorderSide(
                                  color: Colors.red.shade200,
                                )),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Ultimas percas",
                                      style: AppTextStyles.bold(
                                        18,
                                        color: Colors.red.shade200,
                                      ),
                                    ),
                                    Text(
                                      lossValue.toString() +
                                          context
                                              .read<StockCubit>()
                                              .state
                                              .selected
                                              .unit,
                                      style: AppTextStyles.medium(
                                        18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ListView.separated(
                                  itemCount: losses.length,
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var loss = losses[index].data();
                                    print(loss);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 250,
                                              child: Text(
                                                loss["description"],
                                                style:
                                                    AppTextStyles.regular(14),
                                              ),
                                            ),
                                            Text(
                                              "${DateFormat.yMMMMd().format(DateTime.parse(loss["date"]))} às ${loss["time"]}",
                                              style: AppTextStyles.light(11,
                                                  color: Colors.black38),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "${loss["volume"]}${loss["unit"]}",
                                          style: AppTextStyles.semiBold(14),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () =>
                                            modal.showModalBottomSheet(
                                                context: context,
                                                content: AddDataToStock(
                                                  typeModal:
                                                      StockModalOptions.loss,
                                                  unit: context
                                                      .read<StockCubit>()
                                                      .state
                                                      .selected
                                                      .unit,
                                                )),
                                        child: Text(
                                          "Nova perda",
                                          style: AppTextStyles.medium(14,
                                              color: Colors.red.shade200),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () =>
                                            modal.showModalBottomSheet(
                                                context: context,
                                                content: HistoryLosses(
                                                  losses: lossValue,
                                                  unit: context
                                                      .read<StockCubit>()
                                                      .state
                                                      .selected
                                                      .unit,
                                                )),
                                        child: const Text(
                                          "Ver tudo",
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
      ),
    );
  }
}

class CardEntrancesWidget extends StatelessWidget {
  const CardEntrancesWidget({
    Key? key,
    required this.doc,
    required this.unit,
    required this.description,
    required this.created_at,
    required this.volume,
    this.consumed,
    this.loss,
    required this.value,
  }) : super(key: key);

  final String doc;
  final String unit;
  final String description;
  final String created_at;
  final double volume;
  final double? consumed;
  final double? loss;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
          color: const Color(0xffD9D9D9).withOpacity(0.3),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quantidade",
                    style: AppTextStyles.semiBold(14),
                  ),
                  Text(
                    volume.toString() + unit,
                    style: AppTextStyles.light(12),
                  ),
                ],
              ),
              if (consumed != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Consumido",
                      style: AppTextStyles.semiBold(14),
                    ),
                    Text(
                      consumed.toString(),
                      style: AppTextStyles.light(12),
                    ),
                  ],
                ),
              if (loss != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Perdido",
                      style: AppTextStyles.semiBold(14),
                    ),
                    Text(
                      loss.toString(),
                      style: AppTextStyles.light(12),
                    ),
                  ],
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Documento",
                    style: AppTextStyles.semiBold(14),
                  ),
                  Text(
                    doc,
                    style: AppTextStyles.light(12),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Valor",
                    style: AppTextStyles.semiBold(14),
                  ),
                  Text(
                    value.toString(),
                    style: AppTextStyles.light(12),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descrição",
                    style: AppTextStyles.semiBold(14),
                  ),
                  Text(
                    doc,
                    style: AppTextStyles.light(12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                created_at,
                style: AppTextStyles.light(10, color: Colors.black26),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

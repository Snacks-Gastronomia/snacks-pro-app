import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/losses_stock.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';

class HistoryLosses extends StatelessWidget {
  const HistoryLosses({
    Key? key,
    required this.losses,
    required this.unit,
  }) : super(key: key);
  final double losses;
  final String unit;

  @override
  Widget build(BuildContext context) {
    String amount = '${losses.toInt()}$unit';

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              "Historico de perdas",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(Icons.calendar_month),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            trailing: Text(
              'Total: $amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
            child: FutureBuilder(
                future: context.read<StockCubit>().fetchStockAllLoss(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docs = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var loss = docs[index].data();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    loss["description"],
                                    style: AppTextStyles.regular(14),
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
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
          const SizedBox(
            height: 25,
          ),
          CustomSubmitButton(
              onPressedAction: () => Navigator.pop(context), label: 'OK')
        ],
      ),
    );
  }
}

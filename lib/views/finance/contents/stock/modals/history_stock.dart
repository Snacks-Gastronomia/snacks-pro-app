import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacks_pro_app/components/custom_circular_progress.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/core/app.text.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_consume.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/state/stock/stock_cubit.dart';

class HistoryStock extends StatelessWidget {
  const HistoryStock({
    Key? key,
    required this.consumed,
    required this.unit,
  }) : super(key: key);
  final double consumed;
  final String unit;

  @override
  Widget build(BuildContext context) {
    String amount = '${consumed.toInt()}$unit';

    return Padding(
      padding: const EdgeInsets.all(30),
      child: FutureBuilder(
        future: context.read<StockCubit>().fetchStockAllConsume(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomCircularProgress();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            var data = snapshot.data?.docs ?? [];

            return Column(
              children: [
                const ListTile(
                  title: Text(
                    'Histórico de pedidos',
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
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // print();
                    var item = data[index].data();
                    //  {order_code: CLA779-BMHJBV, volume: 2, amount: 1, unit: kg, ing_name: ggg, order: Tataki salmão }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                          (item["volume"] * item["amount"]).toString() +
                              item["unit"],
                          style: AppTextStyles.semiBold(14),
                        )
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomSubmitButton(
                  onPressedAction: () => Navigator.pop(context),
                  label: 'OK',
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

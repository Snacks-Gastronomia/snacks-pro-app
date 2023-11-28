import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snacks_pro_app/components/custom_submit_button.dart';
import 'package:snacks_pro_app/services/new_stock_service.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/item_stock.dart';
import 'package:snacks_pro_app/views/finance/contents/stock/models/losses_stock.dart';

class HistoryLosses extends StatelessWidget {
  const HistoryLosses({super.key, required this.item});
  final ItemStock item;

  @override
  Widget build(BuildContext context) {
    final stock = NewStockService();
    String amount = '${item.amount.toInt()}${item.measure}';

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          ListTile(
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
              amount,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
            child: FutureBuilder(
                future: stock.getItemLossesCollection(item: item.title),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docs = snapshot.data!;
                    List<LossesStock> losses =
                        docs.map((e) => LossesStock.fromMap(e.data())).toList();

                    var listLosses = losses.reversed.toList();

                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: losses.length,
                      itemBuilder: (context, index) {
                        var dateTime = DateFormat('dd/MM/yyyy')
                            .format(listLosses[index].dateTime);

                        var losse = listLosses[index].losses.toInt();
                        return ListTile(
                          title: Text(listLosses[index].title),
                          subtitle: Text(dateTime),
                          trailing: Text("$losse${item.measure}"),
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
